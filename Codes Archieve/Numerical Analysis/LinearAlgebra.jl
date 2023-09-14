module LA

export solve, jacobi, gaussSeidel, norm

function norm2(X::Vector{T}) where{T <: Number}
    sqrt(sum(X.^2))
end

function norm0(X::Vector{T}) where{T <: Number}
    X = map(x -> abs(x), X)
    maximum(X)
end

function Dot(x::Vector{X}, y::Vector{Y}) where{X, Y <: Number}
    if(size(x) != size(y))
        error("The size of two vectors need to be same.")
    end

    res = 0
    (n, ) = size(x)

    for i in range(1, n)
        res += x[i]*y[i]
    end

    res
end

function Base.:*(x::Vector{X}, y::Vector{Y}) where{X, Y <: Number}
    if(size(x) != size(y))
        error("The size of two vectors need to be same.")
    end

    res = 0
    (n, ) = size(x)

    for i in range(1, n)
        res += x[i]*y[i]
    end

    res
end



function inv(A::Matrix)
    
end




"""
    Solve the linear system Ax = b.
    Choosing method by the parameter "method", the candidate methods including "jacobi", "gaussSeidel".
"""

function solve(A::Matrix{X}, b::Vector{Y}, x::Vector{Z} = zeros(1), step::Int = 0; printStep::Bool = false, method = "jacobi", N = 100) where{X, Y, Z <: Number}

    (m, n) = size(A)
    if(m != n || m == 0 || n == 0)
        error("The size of A need to be n*n with n > 0.")
    end

    if(x == zeros(1))
        x = zeros(n)
    end
    if(method == "gaussElimination")

    end

    # Jacobi Method
    if(method == "jacobi")
        x = jacobi(A, b, x, step, printStep = printStep)
        return x
    end

    if(method == "gaussSeidel")
        x = gaussSeidel(A, b, x, step, printStep = printStep)
        return x
    end
end



function jacobi(A::Matrix{X}, b::Vector{Y}, x::Vector, step = 0; printStep = false, N = 100) where{X, Y, Z <: Number}
    cnt = 0
    (m, n) = size(A)
    if(step == 0)
        while(cnt < N)
            x_ = Vector{Number}(undef, n)

            for i in range(1, n)
                a_ii = A[i, i]
                b_i = b[i]
                r_i = A[i, :]
                r_i[i] = 0
                x_[i] = (b_i - r_i * x)/a_ii
            end

            x = x_
            if(printStep) 
                print("Step ")
                print(cnt + 1)
                print(": ")
                println(x) 
            end
            cnt += 1
        end
    else
        while(cnt < step)
            for i in range(1, n)
                a_ii = A[i, i]
                b_i = b[i]
                r_i = A[i, :]
                x_[i] = (b_i - (r_i * x - a_ii*x[i]))/a_ii
            end
            x = x_
            if(printStep) 
                print("Step ")
                print(cnt + 1)
                print(": ")
                println(x) 
            end
            cnt += 1
        end
    end

    x
end

function gaussSeidel(A::Matrix, b::Vector, x::Vector, step = 0; printStep = false, N = 100)
    (m, n) = size(A)
    cnt = 0

    x = Vector{Float32}(x)

    if(step == 0)
        while(cnt < N)
            for i in range(1, n)
                a_ii = A[i, i]
                b_i = b[i]
                r_i = A[i, :]
                r_i[i] = 0
                x[i] = (b_i - r_i * x)/a_ii
            end

            if(printStep) 
                print("Step ")
                print(cnt + 1)
                print(": ")
                println(x) 
            end
            cnt += 1
        end
    else
        while(cnt < step)
            for i in range(1, n)
                a_ii = A[i, i]
                b_i = b[i]
                r_i = A[i, :]
                x[i] = (b_i - (r_i * x - a_ii*x[i]))/a_ii
            end
            if(printStep) 
                print("Step ")
                print(cnt + 1)
                print(": ")
                println(x) 
            end
            cnt += 1
        end
    end

end


end