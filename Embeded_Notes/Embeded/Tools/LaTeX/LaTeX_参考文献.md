# 参考文献

## 使用

### thebibliography排版

```latex
\begin{thebibliography}{99}
\bibiten{article1}作者,\emph{书名}[J].计算机科学.2014(06)
\end{thebibliography}
```
使用 `\cite{article1}` 引用该文献\
这种方式每一个文献都需要单独进行定义，比较麻烦

###  使用 bib文件创建bib数据库

使用 [谷歌学术](https://scholar.google.com) 设置引用，如下

```bib
@book{mittelbach2004latex,
  title={The LATEX companion},
  author={Mittelbach, Frank and Goossens, Michel and Braams, Johannes and Carlisle, David and Rowley, Chris},
  year={2004},
  publisher={Addison-Wesley Professional}
}
```

使用 `bibliography{}` 导入 然后使用 `\cite` 进行引用