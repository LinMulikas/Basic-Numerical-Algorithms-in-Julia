module poly

export Poly, polyval, poly_to_fn, largrange

"""
    Polynomial Function Type.
"""
abstract type AbstractPolynomial end


"""
    Standard polynomial type and other constructors.
"""

mutable struct Poly <: AbstractPolynomial
    coef :: Vector{Number}
    deg :: Int
end

function Poly(coef::Vector{T}) where {T <: Number}
    Poly(coef, size(coef)[1] - 1)
end

function Poly(x::Number)
    Poly([x])
end

"""
    Operators and reload.
"""

function Base.:+(p1 :: Poly, p2 :: Poly)
    if(iszero(p1)) return p2 end
    if(iszero(p2)) return p1 end

    max_deg = max(p1.deg, p2.deg)
    res = zeros(max_deg + 1)

    for i in range(1, max_deg + 1)
        a = i <= p1.deg + 1 ? p1.coef[i] : 0
        b = i <= p2.deg + 1 ? p2.coef[i] : 0
        res[i] = a + b
    end

    Poly(res)
end

function Base.:-(p1 :: Poly, p2 :: Poly)
    p1 + ((-1)*p2)
end

function Base.:*(p1 :: Poly, p2 :: Poly)
    max_deg = p1.deg + p2.deg
    res = zeros(max_deg + 1)

    for i in range(1, p1.deg + 1)
        for j in range(1, p2.deg + 1)
            res[i + j - 1] += p1.coef[i] * p2.coef[j]
        end
    end

    while(res[size(res)[1]] == 0)
        popat!(res, size(res)[1])
    end

    Poly(res, size(res)[1]-1)
end

function Base.:*(a :: Number, p :: Poly)
    if(a == 0) return Poly([0]) end
    res = Poly(p.coef)
    res.coef *= a
    res
end

function Base.:*(p :: Poly, a :: Number)
    if(a == 0) return Poly([0]) end
    res = Poly(p.coef)
    res.coef *= a
    res
end

function Base.:/(p::Poly, a::Number)
    if(a == 0) error("The number can't be zero.") end
    p *= (1/a)
    p
end

function Base.:(==)(p1::Poly, p2::Poly)
    if(p1.deg != p2.deg)
        return false
    end

    for i in range(1, p1.deg + 1)
        if(p1.coef[i] != p2.coef[i])
            return false
        end
    end
    
    true
end

function Base.:^(p::Poly, x::Int)
    if(x == 1) return p
    else
        return p*(p^(x - 1))
    end
end

function Base.zero(::Poly)
    Poly([0], 0)
end

function polyval(p::Poly, x::Number)
    sum = 0

    for i in range(1, p.deg + 1)
        sum += p.coef[i] * x^(i - 1)
    end

    sum
end

function (p::Poly)(x::Number)
    polyval(p, x)
end

function D(p::Poly; times = 1)
    if(times > 1) return D(p, times = times - 1) end
    res = Vector{Number}(undef, p.deg)
    for i in range(1, p.deg)
        res[i] = p.coef[i + 1]*i
    end

    Poly(res)
end

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

function poly_to_fn(p::Poly)
    x -> polyval(p, x)
end

"""
    Interpolation
"""

"""
    Return the polynomial of largrange interpolation with X, Y.
"""

function largrange(X::Vector{T}, Y::Vector{T}, getLks=false::Bool) where {T <: Number}
    if(size(X) != size(Y)) error("Xs and Ys must have same length.") end

    n = size(X)[1]
    Lks = Vector{Poly}(undef, n)

    for i in range(1, n)
        l_k = Poly([1], 0)
        denominator = 1
        for j in range(1, n)
            if(i != j)
                l_k *= Poly([-X[j], 1])
                denominator *= (X[i] - X[j])
            end
        end
        Lks[i] = l_k /= denominator
    end

    if(getLks) return Lks end

    p = Poly(0)

    for i in range(1, n)
        p += Lks[i] * Y[i]
    end

    p
end

function dd_table(X::Vector{T}, Y::Vector{T}) where{T <: Number}
    n = size(X)[1]
    table = Matrix{T}(undef, n, n)
    table[:, 1] = Y

    for j in range(2, n)
        for i in range(j, n)
            table[i, j] = (table[i, j - 1] - table[i - 1, j - 1])/(X[i] - X[i - j + 1])
        end
    end

    table

end

function newtonF(X::Vector{Float64}, Y::Vector{Float64}, x::Float64, deg::Int)
    n = size(X)[1]
    table = dd_table(X, Y)
    res = Y[1]

    for iter_deg in range(1, deg)
        ω = 1
        for i in range(1, iter_deg)
            ω *= (x - X[i])
        end
        res += ω*table[iter_deg + 1, iter_deg + 1]
    end

    res
end

function newtonB(X::Vector{Float64}, Y::Vector{Float64}, x::Float64, deg::Int)
    n = size(X)[1]
    table = dd_table(X, Y)
    res = Y[n]

    for iter_deg in range(1, deg)
        ω = 1
        for i in range(1, iter_deg)
            ω *= (x - X[n - (i - 1)])
        end
        res += ω*table[n, iter_deg + 1]
    end

    res
end

function hermite(X::Vector{T}, fx::Vector{T}, Dfx::Vector{T}) where {T <: Number}
    n = size(X)[1]
    lks = largrange(X, fx, true)

    # Get Hks and Ĥks
    Hs = Vector{Poly}(undef, n)
    Hks = Vector{Poly}(undef, n)
    Ĥks = Vector{Poly}(undef, n)

    for i in range(1, n)
        ak = (Poly([1]) - (2* (D(lks[i])(X[i])) * Poly([-X[i], 1]) ))
        bk = Poly([-X[i], 1])
        lk = (lks[i])^2

        Hks[i] = ak * lk
        Ĥks[i] = bk * lk
        Hs[i] = Hks[i]*fx[i] + Ĥks[i]*Dfx[i]
    end

    sum(Hs)
end

end