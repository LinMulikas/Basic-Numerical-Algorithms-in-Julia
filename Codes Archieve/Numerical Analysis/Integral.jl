module intg
export integral 

include("Polynomial.jl")
using .poly

const global gauss_table = Dict([
    (2, (
        [-0.5773502692, 0.5773502692], 
        [1, 1])),
    (3, (
        [-0.7745966692, 7745966692, 0], 
        [0.5555555556, 0.5555555556, 0.8888888889])),
    (4, (
        [-0.8611363116, 0.8611363116, -0.3399810436, 0.3399810436],
        [0.3478548451, 0.3478548451, 0.6521451549, 0.6521451549]))
])

function integral(p::Poly, a::Number, b::Number)
    deg = p.deg
    res_coef = Vector{Number}(undef, deg + 2)
    res_coef[1] = 0
    for i in range(1, deg + 1)
        res_coef[i + 1] = p.coef[i]/i
    end
    res_poly = Poly(res_coef)
    res_poly(b) - res_poly(a)
end

function integral(f::Function, a::Number, b::Number; order = 0::Int, method = 2, eps = 1e-4, ret_cnt=false::Bool)
    I = 0
    cnt = 1

    # Calculate the integral by n division.
    if(order != 0)
        if(method == 1)
            h = (b - a)/2^order
            I += h*(f(a) + f(b))
            for i in range(1, 2^order - 1)
                I += 2*h*f(a + i*h)
            end
        elseif(method == 2)
            h = (b - a)/2^order
            I += (f(a) + f(b))*h/3
            for i in range(1, 2^order - 1)
                I += 2^((i%2 + 1))*f(a + i*h)*h/3
            end
        elseif(method == 3)
            if(order < 2 || order > 8)
                error("The order of Gauss numerical integral n need to satisfies: 2 ≤ n ≤ 8.")
            end

            if(a != -1 || b != 1)
                f̂ = t -> f((t + 1)*(b - a)/2)
            else
                f̂ = f
            end

            X = gauss_table[order][1]
            W = gauss_table[order][2]

            return (W' * f̂.(X))*(b - a)/2
        end
    # Calculate the integral converging under eps by Simpson method.
    else 
        n = 1
        I_old = integral(f, a, b, order = n)
        I_new = integral(f, a, b, order = 2*n)
        while(abs(I_new - I_old) > eps)
            I_old = I_new
            n *= 2
            cnt += 1
            I_new = integral(f, a, b, order = n)
        end
        I = I_new
        if(ret_cnt) return (I, cnt) end
    end

    I
end




end