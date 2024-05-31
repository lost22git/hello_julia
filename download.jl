
using Downloads
using JSON3
using StructTypes


readas(io, astype) = io |> readchomp |> x -> JSON3.read(x, astype)

begin

  struct IP
    origin::String
  end

  StructTypes.StructType(::Type{IP}) = StructTypes.Struct()

  response_body_io = IOBuffer()

  response = request(
    "https://httpbin.org/ip",
    method="GET",
    headers=Dict("accept" => "application/json"),
    verbose=false,
    output=response_body_io,
  )

  @show response.status
  @show response.message

  ip = response_body_io |> seekstart |> x -> readas(x, IP)

  @show ip
end

begin
  struct Book
    name
    price
    tags
  end

  StructTypes.StructType(::Type{Book}) = StructTypes.Struct()

  request_body_io = IOBuffer()
  response_body_io = IOBuffer()

  JSON3.write(request_body_io, Book("the julia", 11.11, ["programming", "julia"]))
  request_body_io |> seekstart

  response = request(
    "https://httpbin.org/post",
    method="POST",
    headers=Dict("accept" => "application/json", "content-type" => "application/json"),
    verbose=false,
    input=request_body_io,
    output=response_body_io,
  )

  @show response.status
  @show response.message

  book = response_body_io |> seekstart |> JSON3.read |> x -> StructTypes.constructfrom(Book, x["json"])
  @show typeof(book)
  @show book
end

