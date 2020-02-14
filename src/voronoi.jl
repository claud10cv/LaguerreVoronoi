using LinearAlgebra, QHull, Polyhedra

function compute_voronoi_cells(S, V, tri_list)
    vertices_set = Set([u for t in tri_list for u in t])
#    println("vertices_set = $vertices_set")
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
    nV = size(V, 1)
    Vmat = zeros(nV, 2)
    for (i, v) in enumerate(V)
        Vmat[i, 1] = v[1]
        Vmat[i, 2] = v[2]
    end
    vpol = polyhedron(vrep(Vmat), QHull.Library())
    for (i, tri) in enumerate(tri_list)
        a, b, c = tri
        for (u, v, w) in [(a, b, c), (b, c, a), (c, a, b)]
            edge = u < v ? (u, v) : (v, u)
            if length(edge_dict[edge]) == 2
                j, k = edge_dict[edge]
                if k == i
                    j, k = k, j
                end
                U = V[k] - V[j]
                push!(cell_dict[u], ((j, k), (V[j], U, 0, 1)))
            else
                j = edge_dict[edge][1]
                A, B, C, D = S[u, :], S[v, :], S[w, :], V[j]
                U = normalize(B - A)
                I = A + dot(D - A, U) * U
                W = normalize(I - D)
                if dot(W, I - C) < 0
                    W = -W
                end
                push!(cell_dict[u], ((j, nothing), (V[j], W, 0, nothing)))
                push!(cell_dict[v], ((nothing, j), (V[j], -W, nothing, 0)))
            end
        end
    end

    return cell_dict
end
