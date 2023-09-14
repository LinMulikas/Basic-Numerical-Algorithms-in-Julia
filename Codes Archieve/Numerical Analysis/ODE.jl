module ode

export euler

function euler(f::Function, y0, a, b, n)
    step = (b - a)/n
    yks = Vector{Number}(undef, n + 1)
    yks[1] = y0
    for i in range(1, n)
        yks[i + 1] = yks[i] + step*f(a + n*step, yks[i])
    end
    yks
end

f = (t, y) -> y - t^2 + 1

println(f(0, 1))

end