using LinearAlgebra

function compute_voronoi_cells(S, V, tri_list)
    vertices_set = Set([u for t in tri_list for u in t])
    println("vertices_set = $vertices_set")
    edge_dict = Dict{Tuple{Int64, Int64}, Array{Int64, 1}}()
    for (i, tri) in enumerate(tri_list)
        for edge in [(tri[1], tri[2]), (tri[1], tri[3]), (tri[2], tri[3])]
            (u, v) = edge[1] < edge[2] ? (edge[1], edge[2]) : (edge[2], edge[1])
            if haskey(edge_dict, (u, v))
                push!(edge_dict[(u, v)], i)
            else
                edge_dict[(u, v)] = [i]
            end
        end
    end
    cell_dict = Dict(i => [] for i in vertices_set)
    for e in keys(edge_dict)
        u, v = e
        if length(edge_dict[e]) == 2 # finite Voronoi edge
            k, j = edge_dict[e][1], edge_dict[e][2]
            edge_kj = ((k, j), (V[k], (V[j] - V[k]) / euc(V[j] - V[k]), 0, euc(V[j] - V[k])))
            edge_jk = ((j, k), (V[j], (V[k] - V[j]) / euc(V[k] - V[j]), 0, euc(V[k] - V[j])))
            if is_ccw_triangle(V[k], V[j], S[u, :])
                push!(cell_dict[u], edge_kj)
                push!(cell_dict[v], edge_jk)
            else
                push!(cell_dict[u], edge_jk)
                push!(cell_dict[v], edge_kj)
            end
        else # infinite Voronoi edge
            i = edge_dict[e][1]
            A = V[i]
            B = S[v, :] - S[u, :]
            if abs(B[1]) > 1e-7
                U = [-B[2] / B[1], 1]
            else
                U = [1, -B[1] / B[2]]
            end
            U = normalize(U)
            X = hcat(B, - U) \ (A - S[u, :])
            # println("printing inverse")
            # println("det = $(det(hcat(B, - U)))")
            # println("B = $B")
            # println("U = $U")
            # println(inv(hcat(B, - U)))
            # println("done")
            # X = inv(hcat(B, - U)) * (A - S[u, :])
            if X[2] <= 0
                U = -U
            end
            if is_ccw_triangle(A, A + U, S[u, :])
                push!(cell_dict[u], ((i, nothing), (A, U, 0, nothing)))
                push!(cell_dict[v], ((nothing, i), (A, -U, nothing, 0)))
            else
                push!(cell_dict[u], ((nothing, i), (A, -U, nothing, 0)))
                push!(cell_dict[v], ((i, nothing), (A, U, 0, nothing)))
            end
        end
    end

    # println("cell dict = $cell_dict")
    return cell_dict
end
