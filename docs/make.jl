using ExtractLinks
using Documenter

DocMeta.setdocmeta!(ExtractLinks, :DocTestSetup, :(using ExtractLinks); recursive=true)

makedocs(;
    modules=[ExtractLinks],
    authors="Lilith Orion Hafner <lilithhafner@gmail.com> and contributors",
    repo="https://github.com/LilithHafner/ExtractLinks.jl/blob/{commit}{path}#{line}",
    sitename="ExtractLinks.jl",
    format=Documenter.HTML(;
        prettyurls=get(ENV, "CI", "false") == "true",
        canonical="https://LilithHafner.github.io/ExtractLinks.jl",
        edit_link="main",
        assets=String[],
    ),
    pages=[
        "Home" => "index.md",
    ],
)

deploydocs(;
    repo="github.com/LilithHafner/ExtractLinks.jl",
    devbranch="main",
)
