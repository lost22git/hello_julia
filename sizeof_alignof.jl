#!/usr/bin/env julia

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

@test typeof([1, 2, 3]) == Vector{Int64}
@test typeof([1; 2; 3]) == Vector{Int64}
@test typeof([1 2 3]) == Matrix{Int64}

@test sizeof("Julia") == 5
@test sizeof('J') == 4

@test sizeof([1, 2, 3]) == 3 * 8
@test sizeof([1 2 3]) == 3 * 8

@test sizeof(Union{Bool,Int}) == 8
@test sizeof(Union{Bool,Int32}) == 4

@enum Color begin
  red
  green
  blue
end

@test sizeof(Color) == 4
@test sizeof(blue::Color) == 4
@test typeof(blue::Color) == Color

struct Book
  name
  price
  tags
end

book = Book("hello julia", 11.11, ["tech", "julia"])
@test sizeof(book) == 3 * 8
@test sizeof(Book) == 3 * 8

mutable struct MutBook
  name
  price
  tags
end

mut_book = MutBook("hello julia", 11.11, ["tech", "julia"])
@test sizeof(mut_book) == 3 * 8
@test sizeof(MutBook) == 3 * 8
mut_book.name = "the julia"
@test mut_book.name == "the julia"

