module LaguerreVoronoi
    using QHull
    using LinearAlgebra
    using RecipesBase
    using Polyhedra
    using Distances
    using PrecompileTools
    using Random

    include("util.jl")
    include("triangulation.jl")
    include("voronoi.jl")
    include("plotter.jl")

    @setup_workload begin
        for seed in 0:2
            rng = MersenneTwister(seed)
            S = 20 * rand(rng, 10, 2) # centers of 10 balls
            R = rand(rng, 1 : 5, 10) # radii of 10 balls
            @compile_workload begin
                tri_list, V = LaguerreVoronoi.power_triangulation(S, R)
                voronoi_dict = LaguerreVoronoi.compute_voronoi_cells(S, V, tri_list)
            end
        end
    end
end
