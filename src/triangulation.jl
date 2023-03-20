function power_triangulation(S, R)
    ncircles, sdim = size(S)
    S_lifted = zeros(ncircles, 3)
    for i in 1 : ncircles
        S_lifted[i, 1] = S[i, 1]
        S_lifted[i, 2] = S[i, 2]
        S_lifted[i, 3] = S[i, 1]^2 + S[i, 2]^2 - R[i]^2
    end
    if ncircles == 3
        if is_ccw_triangle(S[1, :], S[2, :], S[3, :])
            return [(1, 2, 3)], [get_power_circumcenter(S_lifted[1, :], S_lifted[2, :], S_lifted[3, :])]
        else
            return [(1, 3, 2)], [get_power_circumcenter(S_lifted[1, :], S_lifted[3, :], S_lifted[2, :])]
        end
    end
    hull = chull(S_lifted)
    tri_list = []
    nfacets, dimfacets = size(hull.facets)
    for i in 1 : nfacets
        facet = hull.facets[i, :]
        simplex = hull.simplices[i, :]
        if facet[3] <= 0
            a, b, c = simplex[1], simplex[2], simplex[3]
            if is_ccw_triangle(S[a, :], S[b, :], S[c, :])
                push!(tri_list, (a, b, c))
            else
                push!(tri_list, (a, c, b))
            end
        end
    end
    V = [get_power_circumcenter(S_lifted[x[1], :], S_lifted[x[2], :], S_lifted[x[3], :]) for x in tri_list]
    tri_list, V
end
