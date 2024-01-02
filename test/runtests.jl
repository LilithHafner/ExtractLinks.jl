using ExtractLinks
using Test
using Aqua

@testset "Correctness (manual)" begin
    links = extract_links(read(joinpath(@__DIR__, "pages", "www.julialang.org"), String), root="https://www.julialang.org")
    for str in [
        "https://www.julialang.org/#tab-viz",
        "https://www.linkedin.com/company/the-julia-language",
        "https://twitter.com/JuliaLanguage",
        "https://julialang.zulipchat.com/",
        "https://www.youtube.com/iframe_api",
        "https://julialang.us14.list-manage.com/subscribe/post?u=d78e03c1818e29eeda84ff234&amp;id=c17a203547",
        "https://github.com/search?q=is%3Aopen+is%3Aissue+language%3AJulia+label%3A%22good+first+issue%22",
        "https://fonts.googleapis.com/css?family=Roboto:400,400i,500,500i,700,700i",
    ]
        @test str ∈ links
    end
    for str in [
        "https://fonts.googleapis.com/css?family=Roboto",
        "https://julialang.us14.list-manage.com/subscribe/post?u=d78e03c1818e29eeda84ff234&amp",
        "https://github.com/search?q=is%3Aopen",
        "ie=edge",
        "https://julialang.org/ie=edge",
    ]
        @test str ∉ links
    end

    links = extract_links(read(joinpath(@__DIR__, "pages", "nano.org"), String), root="https://nano.org")
    @test "https://nano.org/en/blog/author/Aneena Ann.Alexander" ∈ links
    @test "https://nano.org/en/blog/author/Aneena%20Ann.Alexander" ∉ links

    links = extract_links(
        read(joinpath(@__DIR__, "pages", "www.w3.org%F2TR%F2REC-html40%F2index%2Fattributes.html"), String),
        root="https://www.w3.org/TR/REC-html40/index/attributes.html")

    @test "https://www.w3.org/TR/REC-html40/interact/forms.html#adef-accept" ∈ links
end

# This testset prevents accedental semantic changes. In the event of an intentional
# semantic change, run `include("contrib/update.jl")` to update expected link files.
@testset "Consistency" begin
    for file in readdir(joinpath(@__DIR__, "pages"))
        actual = extract_links(read(joinpath(@__DIR__, "pages", file), String), root="https://"*replace(file, "%2F" => "/"))
        expected = readlines(joinpath(@__DIR__, "expected", file))
        @test sort!(actual) == sort!(expected)
    end
end

@testset "Errors" begin
    @test_throws ArgumentError extract_links("body"; root="root")
end

@testset "Code quality (Aqua.jl)" begin
    Aqua.test_all(ExtractLinks, deps_compat=false)
    # Aqua.test_deps_compat(ExtractLinks, check_extras=false)
end
