using GR
import Base.stdin

function walk(step :: Int)
    x = 0
    trace = [x]

    for i in 1:step
        if rand() <= 0.5
            x += 1
        else 
            x -= 1
        end
        push!(trace, x)
    end
    trace
end


step = 100
GR.plot(0:step, walk(step))

x = readline()