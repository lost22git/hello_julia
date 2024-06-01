using HTTP
using JSON3

begin
  withenv("https_proxy" => "http://localhost:55556") do
    response = HTTP.get("https://httpbin.org/ip", headers=["accpet" => "application/json", "content-type" => "application/json"])

    @show response.status

    json_root = response.body |> JSON3.read
    @show json_root["origin"]
  end
end

begin
  buffer = IOBuffer()
  JSON3.write(buffer, Dict("hello" => "Julia"))
  buffer |> seekstart 

  response = HTTP.post("https://httpbin.org/post", headers=["accpet" => "application/json", "content-type" => "application/json"], body=buffer)

  @show response.status

  json_root = response.body |> JSON3.read
  @show json_root["json"]
end
