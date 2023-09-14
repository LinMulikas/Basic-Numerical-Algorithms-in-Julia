using InteractiveUtils

function viewTypeTree(T, depth = 0)
    println("    "^depth, T)
    for type in subtypes(T)
        viewTypeTree(type, depth + 1)
    end
end

viewTypeTree(Number)