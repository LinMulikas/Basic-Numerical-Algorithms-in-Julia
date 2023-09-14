func1 = x -> x^2
function func2(x)
    x^2
end

func3 = (x, y) -> x^2 + y^2

tupA = (1, "Hello World!", func1, func2, func3)

print(typeof(tupA))