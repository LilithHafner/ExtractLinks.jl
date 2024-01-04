# ExtractLinks

<!--[![Stable](https://img.shields.io/badge/docs-stable-blue.svg)](https://LilithHafner.github.io/ExtractLinks.jl/stable/)
[![Dev](https://img.shields.io/badge/docs-dev-blue.svg)](https://LilithHafner.github.io/ExtractLinks.jl/dev/)-->
[![Build Status](https://github.com/LilithHafner/ExtractLinks.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/LilithHafner/ExtractLinks.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/LilithHafner/ExtractLinks.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/LilithHafner/ExtractLinks.jl)
[![PkgEval](https://JuliaCI.github.io/NanosoldierReports/pkgeval_badges/E/ExtractLinks.svg)](https://JuliaCI.github.io/NanosoldierReports/pkgeval_badges/E/ExtractLinks.html)
[![Aqua](https://raw.githubusercontent.com/JuliaTesting/Aqua.jl/master/badge.svg)](https://github.com/JuliaTesting/Aqua.jl)

Extract links from a web-page

```
julia> extract_links("https://julialang.org")
210-element Vector{String}:
 "https://julialang.org/libs/bootstrap/bootstrap.min.css"
 "https://julialang.org/css/app.css"
 "https://julialang.org/css/franklin.css"
 ⋮
 "https://julialang.org/libs/bootstrap/bootstrap.min.js"
 "https://www.youtube.com/iframe_api"
```

That's all.

Features
- Resolves relative links
- Heuristics to determine what is and is not a link
- Handles malformed web-pages gracefully
- Low compile and precompile times
- Option to avoid web query if you provide the body of the page as a keyword argument
