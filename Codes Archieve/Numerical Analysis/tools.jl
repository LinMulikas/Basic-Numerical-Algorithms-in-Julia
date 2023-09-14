using InteractiveUtils

"""

Show a type tree of a type and all its subtypes.

"""
function viewTypeTree(TypeName, depth = 0)
    println("    "^depth, TypeName)
    for type in subtypes(TypeName)
        viewTypeTree(type, depth + 1)
    end
end

viewTypeTree(AbstractMatrix)