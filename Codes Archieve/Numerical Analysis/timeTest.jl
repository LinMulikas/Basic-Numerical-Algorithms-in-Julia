function factorial(n::Int)
    if(n < 0)
        error("n must be positive!")
    elseif(n == 0)
        return 1
    else
        return n * factorial(n - 1)
    end
end

function fibnacci(n::Int)
    a = b = 1
    c = 1
    cnt = 2
    if (n > 2)
        while (cnt < n)
            a = b
            b = c
            c = a + b
            cnt += 1
        end
        return c
    elseif (n < 0) 
        error("n must be non-negative!")
    return 1

    end
end

function fib2(n::Int) :Int
    if(n < 0) error("n must be non-negative!")
    elseif(n > 2)
        return fib2(n - 2) + fib2(n - 1)
    else
        return 1
    end
end

println(@time factorial(10))
println(@time fibnacci(400))