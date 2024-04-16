function circleShape(p, r)
    theta = LinRange(0, 2*pi, 1000)
    p[1] .+ r * sin.(theta), p[2] .+ r * cos.(theta)
end

function out_of_box(xmin, ymin, xmax, ymax, v)
    if v[1] < xmin return true
    elseif v[2] < ymin return true
    elseif v[1] > xmax return true
    elseif v[2] > ymax return true
    else return false
    end
end 

@recipe function plot_voronoi_diagram(S::Matrix{F}, R::Vector{T}, cell_dict::Dict{P, Vector{Q}}, tri_list::Vector{W}) where F <: Real where T <: Real where P <: Integer where Q where W 
    ncircles = size(R, 1)
    xmin = minimum(S[:, 1]) - maximum(R)
    xmax = maximum(S[:, 1]) + maximum(R)
    ymin = minimum(S[:, 2]) - maximum(R)
    ymax = maximum(S[:, 2]) + maximum(R)

    diag = euclidean([xmin, ymin], [xmax, ymax])
    
    # xmin := _xmin 
    # xmax := _xmax 
    # ymin := _ymin 
    # ymax := _ymax
    
    # xs = Float64[]
    # ys = Float64[]

    label := ""
    size := (800, 800)
    border := :none
    arrow := :none
    legend := :none
    
    for i in 1 : ncircles
        @series begin
            :seriestype := :shape
            :seriescolor := :blue
            fillcolor := :blue
            fillalpha := 0.2
            label := ""
            c := :blue
            linecolor := :match
            linealpha := 0.2
            # xr = Float64[]
            # yr = Float64[]
            # if !isempty(xr) push!(xr, NaN) end
            # if !isempty(yr) push!(yr, NaN) end
            cx, cy = circleShape(S[i, :], R[i])
            # for _x in cx
            #     push!(xr, _x)
            # end
            # for _y in cy
            #     push!(yr, _y)
            # end
            # xr, yr
            cx, cy
        end
    end

    for k in keys(cell_dict)
        for ((i, j), (A, U, tmin, tmax)) in cell_dict[k]
            @series begin
                seriestype := :line
                seriescolor := :red
                fillcolor := :red
                fillalpha := 1.0
                label := ""
                c := :red
                # xs = Float64[]
                # ys = Float64[]
                if isnothing(tmin) && isnothing(tmax)
                    println("found full segment at A = $A and U = $U")
                end
                dU = norm(U)
                if isnothing(tmin)
                    tmin = -diag / (dU)
                    while out_of_box(xmin, ymin, xmax, ymax, A + tmin * U)
                        tmin *= 0.95
                    end
                elseif isnothing(tmax)
                    tmax = diag / (dU)
                    while out_of_box(xmin, ymin, xmax, ymax, A + tmax * U)
                        tmax *= 0.95
                    end
                end
                # tmin = isnothing(tmin) ? -100 : tmin
                # tmax = isnothing(tmax) ? 100 : tmax
                xs = [A[1] + tmin * U[1], A[1] + tmax * U[1]]
                ys = [A[2] + tmin * U[2], A[2] + tmax * U[2]]
                # if !isempty(xs) push!(xs, NaN) end
                # if !isempty(ys) push!(ys, NaN) end

                # push!(xs, _x[1])
                # push!(xs, _x[2])
                # push!(ys, _y[1])
                # push!(ys, _y[2])
                xs, ys
            end
        end
    end

    # for (u, v, w) in tri_list
    #     @series begin
    #         seriestype := :line
    #         seriescolor := :blue
    #         fillcolor := :blue
    #         fillalpha := 1.0
    #         c := :blue
    #         label := ""
    #         xs = Float64[]
    #         ys = Float64[]
    #         if !isempty(xs) push!(xs, NaN) end
    #         if !isempty(ys) push!(ys, NaN) end
    #         push!(xs, S[u, 1])
    #         push!(xs, S[v, 1])
    #         push!(xs, NaN)
    #         push!(ys, S[u, 2])
    #         push!(ys, S[v, 2])
    #         push!(ys, NaN)
    #         push!(xs, S[v, 1])
    #         push!(xs, S[w, 1])
    #         push!(xs, NaN)
    #         push!(ys, S[v, 2])
    #         push!(ys, S[w, 2])
    #         push!(ys, NaN)
    #         push!(xs, S[w, 1])
    #         push!(xs, S[u, 1])
    #         push!(ys, S[w, 2])
    #         push!(ys, S[u, 2])
    #         xs, ys
    #     end
    # end
    x := []
    y := []
    ()
end



# function plot_voronoi_diagram(S, R, cell_dict, tri_list, V)
#     gr()
#     ncircles = size(R, 1)
#     function circleShape(p, r)
#         theta = LinRange(0, 2*pi, 1000)
#         p[1] .+ r * sin.(theta), p[2] .+ r * cos.(theta)
#     end

#     xmin = minimum(S[:, 1]) - maximum(R) - 1
#     xmax = maximum(S[:, 1]) + maximum(R) + 1
#     ymin = minimum(S[:, 2]) - maximum(R) - 1
#     ymax = maximum(S[:, 2]) + maximum(R) + 1
    
#     p = plot(xlims = (xmin, xmax),# xticks = -0.1 : 0.2 : 1.1,
#             ylims = (ymin, ymax),# yticks = -0.1 : 0.2 : 1.1,
#             aspect_ratio = 1,
#             showaxis = false)
#     for i in 1 : ncircles
#         plot!(p, circleShape(S[i, :], R[i]), label = "", seriestype = [:shape], seriescolor = :grey, fillcolor = :grey, fillalpha = 0.1, c = :grey)
#     end
#     for k in keys(cell_dict)
#         for ((i, j), (A, U, tmin, tmax)) in cell_dict[k]
#             if tmin == nothing && tmax == nothing
#                 println("found full segment at A = $A and U = $U")
#             end
#             tmin = isnothing(tmin) ? -3 : tmin
#             tmax = isnothing(tmax) ? 3 : tmax
#             x = [A[1] + tmin * U[1], A[1] + tmax * U[1]]
#             y = [A[2] + tmin * U[2], A[2] + tmax * U[2]]
#             plot!(p, x, y, label = "", seriestype = [:line], seriescolor = :red, fillcolor = :red, fillalpha = 1.0, c = :red)
#         end
#     end
#     for (u, v, w) in tri_list
#         x = [S[u, 1], S[v, 1]]
#         y = [S[u, 2], S[v, 2]]
#         plot!(p, x, y, label = "", seriestype = [:line], seriescolor = :blue, fillcolor = :blue, fillalpha = 1.0, c = :blue)
#         x = [S[v, 1], S[w, 1]]
#         y = [S[v, 2], S[w, 2]]
#         plot!(p, x, y, label = "", seriestype = [:line], seriescolor = :blue, fillcolor = :blue, fillalpha = 1.0, c = :blue)
#         x = [S[w, 1], S[u, 1]]
#         y = [S[w, 2], S[u, 2]]
#         plot!(p, x, y, label = "", seriestype = [:line], seriescolor = :blue, fillcolor = :blue, fillalpha = 1.0, c = :blue)
#     end
#     p
# end
