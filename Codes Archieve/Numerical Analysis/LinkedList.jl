# Node
"""
这个文件学习了类型限制，如何实现 show 接口
"""

mutable struct Node{T}
    val :: Union{T, Nothing}
    next :: Union{Node{T}, Nothing}
end

function Node(val)
    Node(val, nothing)
end

Base.show(io::IO, node::Node) = isnothing(node.val) ? print(io, "nothing") : print(io, node.val)

### List

mutable struct SingleList{T}
    head :: Node{T}
    tail :: Node{T}
    size :: Int
end

function SingleList{T}() where {T}
    tail = Node{T}(nothing, nothing)
    head = Node{T}(nothing, tail)
    SingleList{T}(head, tail, 0)
end

## implements

Base.iterate(lst::SingleList) = lst.size == 0 ? nothing : lst.head.next
Base.iterate(lst::SingleList, tmp = lst.head) = (tmp.next == lst.tail) ? nothing : (tmp.next, tmp.next)


## methods
function Base.insert!(lst :: SingleList{T}, node :: Node{T}, index :: Int) where{T}
    if index < 0
        error("Index must be a non-negative number.")
    else
        cnt = 0
        tmp = lst.head
        while(cnt < index && tmp.next != lst.tail)
            tmp = tmp.next
            cnt += 1
        end
        node.next = tmp.next
        tmp.next = node
        lst.size += 1
    end
end

function Base.push!(lst :: SingleList{T}, node :: Node{T}) where{T}
    insert!(lst, node, lst.size)
end

function Base.show(io::IO, lst::SingleList)
    res = []
    for node in lst
        push!(res, repr(node))
    end
    push!(res)
    print(io, res)
end

lst1 = SingleList{Float64}()
for i in 1:10
    push!(lst1, Node(rand()))
end

print(lst1)