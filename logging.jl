#!/usr/bin/env julia

using Dates

@debug "log DEBUG message" time = now() tid = Threads.threadid()

@info "log INFO message" time = now() tid = Threads.threadid()

@warn "log WARN message" time = now() tid = Threads.threadid()

@error "log ERROR message" time = now() tid = Threads.threadid()

