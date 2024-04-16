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

    println("xmin = $xmin, ymin = $ymin, xmax = $xmax, ymax = $ymax")
    diag = euclidean([xmin, ymin], [xmax, ymax])

    label := ""
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
            cx, cy = circleShape(S[i, :], R[i])
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
                if isnothing(tmin) && isnothing(tmax)
                    println("found full segment at A = $A and U = $U")
                end
                dU = norm(U)
                if isnothing(tmin)
                    tmin = -diag / dU
                    while abs(tmin) > 1e-2 && out_of_box(xmin, ymin, xmax, ymax, A + tmin * U)
                        tmin *= 0.99
                    end
                elseif isnothing(tmax)
                    tmax = diag / dU
                    while abs(tmax) > 1e-2 && out_of_box(xmin, ymin, xmax, ymax, A + tmax * U)
                        tmax *= 0.99
                    end
                end
                xs = [A[1] + tmin * U[1], A[1] + tmax * U[1]]
                ys = [A[2] + tmin * U[2], A[2] + tmax * U[2]]

                xmax = max(xmax, maximum(xs))
                xmin = min(xmin, minimum(xs))
                ymax = max(ymax, maximum(ys))
                ymin = min(ymin, minimum(ys))
                xs, ys
            end
        end
    end

    width = xmax - xmin
    length = ymax - ymin
    size := (800, 800 * length / width)
    x := []
    y := []
    ()
end