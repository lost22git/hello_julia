#!/usr/bin/env -S julia --threads 8

println("threads: $(Threads.nthreads())")


# schedule task
begin
  println("thread[$(Threads.threadid())] schedule task begin")

  chan = Channel(1)

  task = @task begin
    println("thread[$(Threads.threadid())] is running...")
    wait(chan)
    println("thread[$(Threads.threadid())] is end")
  end

  schedule(task)

  istaskstarted(task) |> println
  istaskdone(task) |> println

  put!(chan, nothing)
  wait(task)

  istaskstarted(task) |> println
  istaskdone(task) |> println

  println("thread[$(Threads.threadid())] schedule task end")
end

# @async
begin
  println("thread[$(Threads.threadid())] @async begin")

  start_chan = Channel(1)
  end_chan = Channel(1)

  @async begin
    println("thread[$(Threads.threadid())] is running...")
    wait(start_chan)
    println("thread[$(Threads.threadid())] is end")
    put!(end_chan, nothing)
  end

  put!(start_chan, nothing)
  wait(end_chan)

  println("thread[$(Threads.threadid())] @async end")
end

# @sync
begin
  println("thread[$(Threads.threadid())] @sync begin")

  @sync begin
    Threads.@spawn begin 
      sleep(1)
      println("thread[$(Threads.threadid())] is running...")
    end
    Threads.@spawn begin 
      sleep(1)
      println("thread[$(Threads.threadid())] is running...")
    end
  end

  println("thread[$(Threads.threadid())] @sync end")
end
