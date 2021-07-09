## STM32_I2C编程
### RCC初始化
RCC设置系统时钟函数
~~~c
static void SetSysClockTo72(void)
{
	__IO uint32_t StartUpCounter = 0, HSEStatus = 0;
	// 1 使能 HSE,并等待 HSE 稳定
	RCC->CR |= ((uint32_t)RCC_CR_HSEON);
	// 等待 HSE 启动稳定,并做超时处理
	do{
		HSEStatus = RCC->CR & RCC_CR_HSERDY;
		StartUpCounter++;
	}while((HSEStatus==0)&&(StartUpCounter!=HSE_STARTUP_TIMEOUT);
	if ((RCC->CR & RCC_CR_HSERDY) != RESET)
	{
		HSEStatus = (uint32_t)0x01;
	}
	else
	{
		HSEStatus = (uint32_t)0x00;
	}
	// HSE 启动成功,则继续往下处理
	if (HSEStatus == (uint32_t)0x01) {
	//-----------------------------------------------------------
	// 使能 FLASH 预存取缓冲区 */
	FLASH->ACR |= FLASH_ACR_PRFTBE;
	// SYSCLK 周期与闪存访问时间的比例设置,这里统一设置成 2
	// 设置成 2 的时候,SYSCLK 低于 48M 也可以工作,如果设置成 0 或者 1 的时候,
	// 如果配置的 SYSCLK 超出了范围的话,则会进入硬件错误,程序就死了
	// 0:0 < SYSCLK <= 24M
	// 1:24< SYSCLK <= 48M
	// 2:48< SYSCLK <= 72M */
	FLASH->ACR &= (uint32_t)((uint32_t)~FLASH_ACR_LATENCY);
	FLASH->ACR |= (uint32_t)FLASH_ACR_LATENCY_2;
	// 2 设置 AHB、APB2、APB1 预分频因子
	// HCLK = SYSCLK
	RCC->CFGR |= (uint32_t)RCC_CFGR_HPRE_DIV1;
	//PCLK2 = HCLK
	RCC->CFGR |= (uint32_t)RCC_CFGR_PPRE2_DIV1;
	//PCLK1 = HCLK/2
	RCC->CFGR |= (uint32_t)RCC_CFGR_PPRE1_DIV2;
	// 3 设置 PLL 时钟来源,设置 PLL 倍频因子,PLLCLK = HSE * 9 = 72 MHz
	RCC->CFGR &= (uint32_t)((uint32_t)~(RCC_CFGR_PLLSRC
								| RCC_CFGR_PLLXTPRE
								| RCC_CFGR_PLLMULL));
	RCC->CFGR |= (uint32_t)(RCC_CFGR_PLLSRC_HSE
								| RCC_CFGR_PLLMULL9);
	// 4 使能 PLL
	RCC->CR |= RCC_CR_PLLON;
	// 5 等待 PLL 稳定
	while ((RCC->CR & RCC_CR_PLLRDY) == 0){}
	// 6 选择 PLL 作为系统时钟来源
	RCC->CFGR &= (uint32_t)((uint32_t)~(RCC_CFGR_SW));
	RCC->CFGR |= (uint32_t)RCC_CFGR_SW_PLL;
	// 7 读取时钟切换状态位,确保 PLLCLK 被选为系统时钟
	while ((RCC->CFGR&(uint32_t)RCC_CFGR_SWS) != (uint32_t)0x08)
	{
	}
	else {// 如果 HSE 启动失败,用户可以在这里添加错误代码出来
	}
}
~~~
### HSE作为系统时钟
~~~c
void HSE_SetSysClock(uint32_t pllmul)
{
	__IO uint32_t StartUpCounter = 0, HSEStartUpStatus = 0;
	// 把 RCC 外设初始化成复位状态
	RCC_DeInit();
	//使能 HSE,开启外部晶振,野火 STM32F103 系列开发板用的是 8M
	RCC_HSEConfig(RCC_HSE_ON);
	// 等待 HSE 启动稳定
	HSEStartUpStatus = RCC_WaitForHSEStartUp();
	// 只有 HSE 稳定之后则继续往下执行
	if (HSEStartUpStatus == SUCCESS) 
	{
		//------------------------------------------------
		// 这两句是操作 FLASH 闪存用到的,如果不操作 FLASH,这两个注释掉也没影响
		// 使能 FLASH 预存取缓冲区
		FLASH_PrefetchBufferCmd(FLASH_PrefetchBuffer_Enable);
		// SYSCLK 周期与闪存访问时间的比例设置,这里统一设置成 2
		// 设置成 2 的时候,SYSCLK 低于 48M 也可以工作,如果设置成 0 或者 1 的时候,
		// 如果配置的 SYSCLK 超出了范围的话,则会进入硬件错误,程序就死了
		// 0:0 < SYSCLK <= 24M
		// 1:24< SYSCLK <= 48M
		// 2:48< SYSCLK <= 72M
		FLASH_SetLatency(FLASH_Latency_2);
		//-----------------------------------------------------------------//
		// AHB 预分频因子设置为 1 分频,HCLK = SYSCLK
		RCC_HCLKConfig(RCC_SYSCLK_Div1);
		// APB2 预分频因子设置为 1 分频,PCLK2 = HCLK
		RCC_PCLK2Config(RCC_HCLK_Div1);
		// APB1 预分频因子设置为 1 分频,PCLK1 = HCLK/2
		RCC_PCLK1Config(RCC_HCLK_Div2);
		//-----------------设置各种频率主要就是在这里设置-------------------//
		// 设置 PLL 时钟来源为 HSE,设置 PLL 倍频因子
		// PLLCLK = 8MHz * pllmul
		RCC_PLLConfig(RCC_PLLSource_HSE_Div1, pllmul);
		// 开启 PLL
		RCC_PLLCmd(ENABLE);
		// 等待 PLL 稳定
		while (RCC_GetFlagStatus(RCC_FLAG_PLLRDY) == RESET){}
		// 当 PLL 稳定之后,把 PLL 时钟切换为系统时钟 SYSCLK
		RCC_SYSCLKConfig(RCC_SYSCLKSource_PLLCLK);
		// 读取时钟切换状态位,确保 PLLCLK 被选为系统时钟
		while (RCC_GetSYSCLKSource() != 0x08) {}
		else {
		// 如果 HSE 开启失败,那么程序就会来到这里,用户可在这里添加出错的代码处理
		// 当 HSE 开启失败或者故障的时候,单片机会自动把 HSI 设置为系统时钟,
		// HSI 是内部的高速时钟,8MHZ
		while (1) {}
	}
}
~~~
### 设置HSI为系统时钟
~~~c
void HSI_SetSysClock(uint32_t pllmul)
{
	__IO uint32_t HSIStartUpStatus = 0;
	// 把 RCC 外设初始化成复位状态
	RCC_DeInit();
	//使能 HSI
	RCC_HSICmd(ENABLE);
	// 等待 HSI 就绪
	HSIStartUpStatus = RCC->CR & RCC_CR_HSIRDY;
	// 只有 HSI 就绪之后则继续往下执行
	if (HSIStartUpStatus == RCC_CR_HSIRDY) {
		// 这两句是操作 FLASH 闪存用到的,如果不操作 FLASH,这两个注释掉也没影响
		// 使能 FLASH 预存取缓冲区
		FLASH_PrefetchBufferCmd(FLASH_PrefetchBuffer_Enable);
		// SYSCLK 周期与闪存访问时间的比例设置,这里统一设置成 2
		// 设置成 2 的时候,SYSCLK 低于 48M 也可以工作,如果设置成 0 或者 1 的时候,
		// 如果配置的 SYSCLK 超出了范围的话,则会进入硬件错误,程序就死了
		// 0:0 < SYSCLK <= 24M
		// 1:24< SYSCLK <= 48M
		// 2:48< SYSCLK <= 72M
		FLASH_SetLatency(FLASH_Latency_2);
		// AHB 预分频因子设置为 1 分频,HCLK = SYSCLK
		RCC_HCLKConfig(RCC_SYSCLK_Div1);
		// APB2 预分频因子设置为 1 分频,PCLK2 = HCLK
		RCC_PCLK2Config(RCC_HCLK_Div1);
		// APB1 预分频因子设置为 1 分频,PCLK1 = HCLK/2
		RCC_PCLK1Config(RCC_HCLK_Div2);
		
		// 设置 PLL 时钟来源为 HSE,设置 PLL 倍频因子
		// PLLCLK = 4MHz * pllmul
		RCC_PLLConfig(RCC_PLLSource_HSI_Div2, pllmul);
		
		// 开启 PLL
		RCC_PLLCmd(ENABLE);
		// 等待 PLL 稳定
		while (RCC_GetFlagStatus(RCC_FLAG_PLLRDY) == RESET) {}
		// 当 PLL 稳定之后,把 PLL 时钟切换为系统时钟 SYSCLK
		RCC_SYSCLKConfig(RCC_SYSCLKSource_PLLCLK);
		// 读取时钟切换状态位,确保 PLLCLK 被选为系统时钟
		while (RCC_GetSYSCLKSource() != 0x08) {}
		else {
		// 如果 HSI 开启失败,那么程序就会来到这里,用户可在这里添加出错的代码处理
		// 当 HSE 开启失败或者故障的时候,单片机会自动把 HSI 设置为系统时钟,
		// HSI 是内部的高速时钟,8MHZ
		while (1){}
	}
}
~~~
### MCO输出
~~~c
void MCO_GPIO_Config(void)
{
	GPIO_InitTypeDef GPIO_InitStructure;
	// 开启 GPIOA 的时钟
	RCC_APB2PeriphClockCmd(RCC_APB2Periph_GPIOA, ENABLE);
	// 选择 GPIO8 引脚
	GPIO_InitStructure.GPIO_Pin = GPIO_Pin_8;
	//设置为复用功能推挽输出
	GPIO_InitStructure.GPIO_Mode = GPIO_Mode_AF_PP;
	//设置 IO 的翻转速率为 50M
	GPIO_InitStructure.GPIO_Speed = GPIO_Speed_50MHz;
	// 初始化 GPIOA8
	GPIO_Init(GPIOA, &GPIO_InitStructure);
}
	//RCC_MCOConfig(RCC_MCO_HSE);
	//RCC_MCOConfig(RCC_MCO_HSI);
	//RCC_MCOConfig(RCC_MCO_PLLCLK_Div2);
	RCC_MCOConfig(RCC_MCO_SYSCLK);
~~~