fa(x) = (println("a"); x)
fb(x) = (println("b"); x)
fc(x) = (println("c"); x)

macro >(fs...)
    ex = :($(last(fs))(x))
    for f in reverse(fs[1 : end - 1])
        ex = :($f($ex))
    end
    
    :(x -> $ex)
end

f = @> fa fb fc
f(2)