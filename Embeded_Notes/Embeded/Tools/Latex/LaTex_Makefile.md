# Latex Makefile 的编写

## 说明

> 编译器使用 `xelatex` 可以编译中文，否则会编译错误

## 示例

```makefile
CC = xelatex

SRC_DIR = src

SOURCE = $(foreach dir,$(SRC_DIR),$(wildcard $(dir)/*.tex))
SOURCE_NAME = $(patsubst %.tex,%,$(notdir $(SOURCE)))

all:
	$(CC) $(SOURCE)

clean:
	@rm -rf $(SOURCE_NAME).*
	@echo already cleaned project

run:
	xdg-open main.pdf
```

## 目录结构

```log
.
├── main.aux
├── main.log
├── main.pdf
├── Makefile
└── src
    └── main.tex

1 directory, 5 files
```
