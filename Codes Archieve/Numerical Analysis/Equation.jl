module eq

export bisection


"""
    Bisection iteration to get the solution of equation f(x*) = 0.
"""

function bisection(f::Function, a::Real, b::Real; MAX_STEP::Int = 100, steps::Int = 0, iter::Int = 0, eps::Float64 = 1e-6)
    if(a > b) error("a must less than b.") end

    if(iter != 0)
        while(steps < iter)
            mid = (a + b)/2
            if(sign(f(mid)) == sign(f(a)))
                a = mid
                steps += 1
            else
                b = mid
                steps += 1
            end
        end
        return (mid, steps, f(mid))
    else
        mid = (a + b)/2
        while(abs(f(mid)) > eps && steps <= MAX_STEP)
            mid = (a + b)/2
            if(sign(f(mid)) == sign(f(a)))
                a = mid
                steps += 1
            else
                b = mid
                steps += 1
            end
        end
    end

    (mid, steps, f(mid))
end



end