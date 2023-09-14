module nonlinear

export jacobi_iter, gaussSeidel_iter, newton

include("LinearAlgebra.jl")
using .LA



function jacobi_iter(G::Function, x::Vector{T}, eps = 1e-5) where{T <: Number}
    x_ = Vector([.25, .25])
    while(LA.norm0(x_ - x) > eps)
        x = G(x)
    end
    x
end

function gaussSeidel_iter(G::Function, x::Vector{T}, eps = 1e-5) where{T <: Number}
    @assert sizeof(x) > 2
    x_ = G(x)
    while(LA.norm2(x_ - x) > eps)
        x = x_
        x_ = G(x)
    end
    x_
end

function G(X::Vector{T}) where {T <: Number}
    X[1] = (sin(X[1]) + cos(X[2]))/(4*sqrt(5))
    X[2] = (sin(X[1]) + cos(X[2]))/4
    X
end

x = ones(2)

println(jacobi_iter(G, x))



end