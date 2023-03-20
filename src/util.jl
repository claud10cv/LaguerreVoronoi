function is_ccw_triangle(A, B, C)
    cross_z(A, B) + cross_z(B, C) + cross_z(C, A) > 0
end

function cross_z(A, B)
    A[1] * B[2] - A[2] * B[1]
end

function get_power_circumcenter(A, B, C)
    N = get_triangle_normal(A, B, C)
    return (-.5 / N[3]) * N[1 : 2]
end

function get_triangle_normal(A, B, C)
    normalize(cross(A, B) + cross(B, C) + cross(C, A))
end

function euc(X)
    sqrt(sum(x^2 for x in X))
end

function orthogonal(A)
    [A[2], -A[1]]
end

function order_segment_list!(segment_list)
    println("segment list = $segment_list")
	# Pick the first element
    newsl = []
    minelem = 1
    for (i, sl) in enumerate(segment_list)
        if sl[1][1] == nothing
            minelem = i
            break
        end
    end
    push!(newsl, segment_list[minelem])
    while length(newsl) < length(segment_list)
        println(newsl[end][1])
        last = newsl[end][1][2]
        for sl in segment_list
            if sl[1][1] == last
                push!(newsl, sl)
                break
            end
        end
    end
    for i in 1 : length(newsl)
        segment_list[i] = newsl[i]
    end
	segment_list
end

function normalize(X)
    X / euc(X)
end

function intersect(S, T)
    A = zeros(2, 2)
    A[1, 1] = S[2][1]
    A[1, 2] = -T[2][1]
    A[2, 1] = S[2][2]
    A[2, 2] = -T[2][2]
    b = [T[1][1] - S[1][1], T[1][2] - S[1][2]]
    x = A \ b
    return x[1] >= 0 && x[1] <= S[3] && x[2] >= 0 && x[2] <= T[3]
end

function plot_voronoi_diagram(S, R, cell_dict, tri_list, V)
    gr()
    ncircles = size(R, 1)
    function circleShape(p, r)
        theta = LinRange(0, 2*pi, 1000)
        p[1] .+ r * sin.(theta), p[2] .+ r * cos.(theta)
    end
    p = plot(xlims = (-0.5, 1.5),# xticks = -0.1 : 0.2 : 1.1,
            ylims = (-0.5, 1.5),# yticks = -0.1 : 0.2 : 1.1,
            aspect_ratio = 1,
            showaxis = false)
    for i in 1 : ncircles
        plot!(p, circleShape(S[i, :], R[i]), label = "", seriestype = [:shape], seriescolor = :grey, fillcolor = :grey, fillalpha = 0.1, c = :grey)
    end
    for k in keys(cell_dict)
        for ((i, j), (A, U, tmin, tmax)) in cell_dict[k]
            if tmin == nothing && tmax == nothing
                println("found full segment at A = $A and U = $U")
            end
            tmin = isnothing(tmin) ? -3 : tmin
            tmax = isnothing(tmax) ? 3 : tmax
            x = [A[1] + tmin * U[1], A[1] + tmax * U[1]]
            y = [A[2] + tmin * U[2], A[2] + tmax * U[2]]
            plot!(p, x, y, label = "", seriestype = [:line], seriescolor = :red, fillcolor = :red, fillalpha = 1.0, c = :red)
        end
    end
    for (u, v, w) in tri_list
        x = [S[u, 1], S[v, 1]]
        y = [S[u, 2], S[v, 2]]
        plot!(p, x, y, label = "", seriestype = [:line], seriescolor = :blue, fillcolor = :blue, fillalpha = 1.0, c = :blue)
        x = [S[v, 1], S[w, 1]]
        y = [S[v, 2], S[w, 2]]
        plot!(p, x, y, label = "", seriestype = [:line], seriescolor = :blue, fillcolor = :blue, fillalpha = 1.0, c = :blue)
        x = [S[w, 1], S[u, 1]]
        y = [S[w, 2], S[u, 2]]
        plot!(p, x, y, label = "", seriestype = [:line], seriescolor = :blue, fillcolor = :blue, fillalpha = 1.0, c = :blue)
    end
    p
end
