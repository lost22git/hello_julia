#!/usr/bin/env -S julia "$0" "$@" ; exit $?

macro t(title, block)
  @eval println("\n------$(rpad($title, 33, '-'))")
  @eval $block
end

macro tt(title, block)
  @eval $block
end

using Test

@t "raw string" begin
  println(raw"'\e[33mJulia\e[m'", " => ", "\e[33mJulia\e[m")
end

@t "regex string" begin
  println(match(r"\d+", "33ia"))
end

@t "multiline string" begin
  println("""
          # Todo
            - itme1
            - item2
          """)
end

@tt "concat by string()" begin
  @test string("Lang", ": ", "Julia") == "Lang: Julia"
end

@tt "concat by (*)" begin
  @test "Lang: " * "Julia" == "Lang: Julia"
end

using Printf
@t "format" begin
  @printf "Lang: %-10s\n" "Julia"
  println(@sprintf "Lang: %10s" "Julia")
end

@tt "padding" begin
  @test lpad("Julia", 10, "*") == "*****Julia"
  @test rpad("Julia", 10, "*") == "Julia*****"
end

@tt raw"interpolate ($)" begin
  @test """$(lpad("Julia", 10, '*'))""" == "*****Julia"
end

@tt "char at" begin
  @test "Julia"[1] == 'J'
  @test "Julia"[begin] == 'J'
  @test "Julia"[end] == 'a'
  @test "Julia"[end-1] == 'i'
end

@tt "substring" begin
  @test "Julia"[1:2] == "Ju"
  @test "Julia"[1:(end-1)] == "Juli"
end

@tt "split" begin
  @test split("Lang::Julia", ':', keepempty=false) == ["Lang", "Julia"]
  @test split("Lang::Julia", ':', keepempty=true) == ["Lang", "", "Julia"]
  @test split("Lang::Julia", ':', limit=2, keepempty=true) == ["Lang", ":Julia"]

  @test rsplit("Lang::Julia", ':', limit=2, keepempty=true) == ["Lang:", "Julia"]
end

@tt "isspace" begin
  for c = "\t\r\n"
    @test isspace(c)
  end
end

@tt "join" begin
  @test join(["Lang", "Julia"], ": ") == "Lang: Julia"
end
