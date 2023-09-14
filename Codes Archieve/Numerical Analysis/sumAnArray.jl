function sumArray(arr)
    sum = zero(eltype(arr))
    for a in arr
        sum += a
    end
    sum
end