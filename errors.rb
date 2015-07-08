before do
    content_type 'application/json'
end

not_found do
  {error: "Graph not found!"}.to_json
end

error 400 do
  {error: "Invalid request!"}.to_json
end

error 409 do
  {error: "Graph with provided name already exists!"}.to_json
end

error 500...600 do
  {error: "Internal server error!"}.to_json
end
