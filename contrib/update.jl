dir = joinpath(dirname(@__DIR__), "test")
rm(joinpath(dir, "expected"), force=true, recursive=true)
mkdir(joinpath(dir, "expected"))
for file in readdir(joinpath(dir, "pages"))
    links = extract_links(read(joinpath(dir, "pages", file), String), "https://"*replace(file, "%2F" => "/"))
    open(joinpath(dir, "expected", file), "w") do f
        for link in links
            println(f, link)
        end
    end
end
