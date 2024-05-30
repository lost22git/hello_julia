#!/usr/bin/env julia

@show gethostname()
@show getpid()

arg = "--version"

# `inherit` cmd output
#
proc = `julia $arg` |> run
proc = ```
julia $arg
``` |> run

@show proc.exitcode
@show proc.termsignal

# `pipe` cmd output
#
output = read(`julia $arg`, String)
@show output
output = readchomp(`julia $arg`)
@show output

