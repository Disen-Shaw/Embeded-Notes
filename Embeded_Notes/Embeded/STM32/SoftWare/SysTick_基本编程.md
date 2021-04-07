## SysTick编程
~~~C
/* bsp_systick.h */
#ifndef __BSP_SYSTICK_H
#define __BSP_SYSTICK_H
#include "core_cm3.h"
#include "stm32f10x.h"
void SysTick_Delay_us(uint32_t us);
void SysTick_Delay_ms(uint32_t ms);
#endif
~~~
~~~C
/* bsp_systick.c */
void SysTick_Delay_us(uint32_t us)
{
 	SysTick_Config(72);
    for(int i = 0 ; i < us ; i++ )
    {
        while(!((SysTick->CTRL)&(1<<16)));
    }
    SysTick->CTRL &= ~SysTick_CTRL_ENABLE_Msk;
}

void SysTick_Delay_ms(uint32_t us)
{
 	SysTick_Config(72000);
    for(int i = 0 ; i < us ; i++ )
    {
        while(!((SysTick->CTRL)&(1<<16)));
    }
    SysTick->CTRL &= ~SysTick_CTRL_ENABLE_Msk;
}
~~~