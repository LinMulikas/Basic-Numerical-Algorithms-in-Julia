# Fundamental type system

# Constructor of struct

## Basic
```Julia
struct Name
    innerParam1
    innerParam2
    [Inner Constructor:{
        Name(Param1, Param2) = new(Param1, Param2)
    }]

end 
```

Julia 用 new 关键字作为 struct singleton 的创造，Julia 的所有内部参数应该在结构生成的时候就创建好。


## Recursive

考虑到循环的结构，Julia 支持使用循环定义（似乎能够类似 Natioanl Number 的 successor）


# Meta Programming

# 








