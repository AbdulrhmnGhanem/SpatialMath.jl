using SpatialMath
using Documenter

DocMeta.setdocmeta!(SpatialMath, :DocTestSetup, :(using SpatialMath); recursive = true)

const page_rename = Dict("developer.md" => "Developer docs") # Without the numbers
const numbered_pages = [
  file for file in readdir(joinpath(@__DIR__, "src")) if
  file != "index.md" && splitext(file)[2] == ".md"
]

makedocs(;
  modules = [SpatialMath],
  authors = "AbdulrhmnGhanem <research@abdulrhmnghanem.tech>",
  repo = "https://github.com/AbdulrhmnGhanem/SpatialMath.jl/blob/{commit}{path}#{line}",
  sitename = "SpatialMath.jl",
  format = Documenter.HTML(;
    canonical = "https://AbdulrhmnGhanem.github.io/SpatialMath.jl",
  ),
  pages = ["index.md"; numbered_pages],
)

deploydocs(; repo = "github.com/AbdulrhmnGhanem/SpatialMath.jl")
