#!/usr/bin/env julia

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

  @test SubString("Julia", 1:2) == "Ju"
  @test SubString("Julia", 1, 2) == "Ju"
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

@tt "length (code units)" begin
  @test length("hello👻") == 6
end

@tt "sizeof (bytes)" begin
  @test sizeof("hello👻") == (5 + 4)
end

@tt "lazy string" begin
  lang = "Julia"
  @test "Lang: $lang" == "Lang: Julia"
  @test lazy"Lang: $lang" == "Lang: Julia"
end

@tt "regex parse" begin
  m = match(r"(?<hour>\d{2}):(?<minute>\d{2}):(?<second>\d{2})", "11:22:33")
  @test m.match == "11:22:33"
  @test m["hour"] == "11"
  @test m["minute"] == "22"
  @test m["second"] == "33"

  @test collect(m.captures) == ["11", "22", "33"]
end

@tt "findnext / findprev / findfirst / findlast" begin
  @test findnext("Julia", "Hello Julia", 1) == 7:11
  @test findnext("Julia", "Hello Julia", 8) == nothing
  @test findnext(r"Julia", "Hello Julia", 1) == 7:11
  @test findnext(isspace, "Hello Julia", 1) == 6
end

@tt "occursin / contains" begin
  @test occursin("Julia", "Hello Julia") == true
  @test contains("Hello Julia", "Julia") == true

  @test occursin("julia", "Hello Julia") == false
  @test contains("Hello Julia", "julia") == false

  @test occursin(r"(j|J)ulia", "Hello Julia") == true
  @test contains("Hello Julia", r"(j|J)ulia") == true
end

@tt "replace" begin
  @test replace("Julia", "Ju" => "ju") == "julia"
  @test replace("Julia", r"(l|i)" => "L") == "JuLLa"
  @test replace("Julia", r"(l|i)" => "L") == "JuLLa"
  @test replace("Julia", r"(l|i)" => "L", count=1) == "JuLia"
  @test replace("Julia", r"(l|i)" => s"\1L") == "JulLiLa"
  @test replace("Julia", r"(l|i)" => s"\1L", count=1) == "JulLia"
  @test replace("Julia", "l" => "L", "i" => "I") == "JuLIa"
end

@tt "strip" begin
  @test strip("  Julia  ") == "Julia"
  @test rstrip("  Julia  ") == "  Julia"
  @test lstrip("  Julia  ") == "Julia  "

  @test strip("[ Julia ]", ['[', ']', ' ']) == "Julia"
end

@tt "chop" begin
  @test chop("Julia") == "Juli"
  @test chop("Julia", head=2, tail=1) == "li"

  @test chopprefix("Julia", "Ju") == "lia"
  @test chopsuffix("Julia", "a") == "Juli"

  @test chomp("abc\n") == "abc"

end
