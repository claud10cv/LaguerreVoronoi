using LinearAlgebra

function is_ccw_triangle(A, B, C)
    cross_z(A, B) + cross_z(B, C) + cross_z(C, A) >= 0
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
