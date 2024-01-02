using ExtractLinks
using Test
using Aqua

@testset "ExtractLinks.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(ExtractLinks)
    end
    # Write your tests here.
end
