using Test
using Random
using LaguerreVoronoi

function test_algorithm(S, R)
    tri_list, V = LaguerreVoronoi.power_triangulation(S, R)
    voronoi_dict = LaguerreVoronoi.compute_voronoi_cells(S, V, tri_list)
    return true
end

@testset "Random Test" begin
    for seed in 0:9
        rng = MersenneTwister(seed)
        S = 10 * rand(rng, 10, 2) # centers of 10 balls
        R = rand(rng, 1 : 5, 10) # radii of 10 balls
        @test test_algorithm(S, R)
    end
end