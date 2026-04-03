angle = Float64[   60,   180,   300]
dist  = Float64[10e-3, 10e-3, 10e-3]

struct P{T}
    x::T
    y::T
    z::T
end

Plist = Vector{P}(undef, length(angle))
for idx in eachindex(angle, dist) 
    Plist[idx] = P(dist[idx]*cosd(angle[idx]),dist[idx]*sind(angle[idx]),0.0)
end

A = zeros(length(Plist)*3,6)
for idx in eachindex(Plist)
    jdx = (idx-1)*3
    A[jdx+1,1] = 1
    A[jdx+1,5] = Plist[idx].z
    A[jdx+1,6] = -Plist[idx].y
    A[jdx+2,2] = 1
    A[jdx+2,4] = -Plist[idx].z
    A[jdx+2,6] = Plist[idx].x
    A[jdx+3,3] = 1
    A[jdx+3,4] = Plist[idx].y
    A[jdx+3,5] = -Plist[idx].x
end

# A*x = b
# A is a function only of sensor positions so we only need to solve the inverse once
# b is the measured values
# x is spacemouse orientation
# Least squares fit would be
C = inv(transpose(A)*A)*transpose(A)

# Matrix has a lot of zeros. Just print a simplified
out = ["X", "Y", "Z", "RX", "RY", "RZ"]
sensor = ["X", "Y", "Z"]
for idx in eachindex(out)
    print(out[idx], " = ")
    isfirst = true
    for sensNum in eachindex(Plist)
        for sensIdx in 1:3
            jdx = (sensNum-1)*3 + sensIdx
            val = C[idx,jdx]
            if abs(val) > 1e-14
                if isfirst
                    print(val, "*", sensor[sensIdx], sensNum)
                    isfirst = false
                else
                    if val > 0
                        print(" + ")
                    else
                        print(" - ")
                    end
                    print(abs(val), "*", sensor[sensIdx], sensNum)
                end
            end
        end
    end
    print("\n")
end

