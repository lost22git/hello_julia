using Test

@test sizeof(Bool) == 1
@test sizeof(Char) == 4

@test sizeof(Int) == 8
@test sizeof(Int8) == 1
@test sizeof(Int16) == 2
@test sizeof(Int32) == 4
@test sizeof(Int64) == 8
@test sizeof(Int128) == 16

@test sizeof(Float32) == 4
@test sizeof(Float64) == 8

typeof([1,2,3]) == Vector{Int64}
typeof([1;2;3]) == Vector{Int64}
typeof([1 2 3]) == Matrix{Int64}

