module diff

export D1_at

include("Polynomial.jl")

using .poly 

function D1_at(f::Function, X::Vector{T}, x::T) where{T <: Number}
    D1_at(X, f.X, x)
end

"""
    Using the interpolation method to get the first order differentiation 
at point x_k.

"""
function D1_at(X::Vector, Y::Vector, x::Number)
    p = largrange(X, Y)
    polyval(D(p), x)
end

"""
    Input 3 points [x₀-h, x₀, x₀ + h] to get the approximation of f''(x₀).
"""
function D2_at(f::Function, x::T; h = 1e-4) where {T <: Number}
    (f(x - h) + f(x + h) - 2*f(x))/h^2
end

"""
    Get the formulary form (also polynomial) of a polynomial.
"""
function D(p::Poly; times = 1)
    if(times > 1) return D(p, times = times - 1) end
    res = Vector{Number}(undef, p.deg)
    for i in range(1, p.deg)
        res[i] = p.coef[i + 1]*i
    end

    Poly(res)
end


end