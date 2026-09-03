# Julia for Nova.app
**Julia for Nova** integrates basic LanguageServer.jl support in the Nova editor as well as providing syntax highlighting for the Julia language.

## Getting up and running
**Julia for Nova** requires your having `LanguageServer.jl` installed on your system. If you don't already have that installed, please install it. Their documentation is available here: [https://github.com/julia-vscode/LanguageServer.jl](https://github.com/julia-vscode/LanguageServer.jl).

To install LanguageServer.jl, open the Julia REPL and type
```julia
using Pkg
Pkg.add("LanguageServer")
```

Then, install this extension. You should be able to switch 


## Pull / Feature Requests
This Nova extension is under sporadic development. Time and effort are finite, and I have other things to work on. That said, I welcome pull requests at this project's GitHub repository. If you'd like to contribute, please do so!

## Issues
Let's face it: this extension has problems. Notice a specific one? Create an issue on the GitHub repository (Or better still: a fix. See **Pull / Feature Requests** above) 

## Thanks
Thank you to the:
- Julia Language Contributors for a great language (https://github.com/JuliaLang/julia)
- Tree Sitter project for an MIT-licensed Julia grammar, from which the `libtree-sitter-julia.dylib` was generated (a copy of the license for the grammar is in `Syntaxes/LICENSE`) (https://github.com/tree-sitter/tree-sitter-julia)
