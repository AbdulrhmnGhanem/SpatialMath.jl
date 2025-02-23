module Geometry2D

using LinearAlgebra: cross

export Line2

struct Line2{T} <: AbstractVector{T}
  a::T
  b::T
  c::T
end

Line2(v) = Line2(v...)
Line2(a, b, c) = Line2(a, b, c)

Base.show(io::IO, l::Line2) = print(io, "Line2($(l.a), $(l.b), $(l.c))")
Base.size(::Line2) = (3,)
Base.getindex(l::Line2, i::Int) = i == 1 ? l.a : i == 2 ? l.b : l.c

function join_points(
  p1::AbstractVector{T},
  p2::AbstractVector{S},
)::Line2 where {T<:Number,S<:Number}
  length(p1) in (2, 3) ||
    throw(DimensionMismatch("p1 must has homogeneous line representation: ax + by + c = 0"))
  length(p2) in (2, 3) ||
    throw(DimensionMismatch("p2 must has homogeneous line representation: ax + by + c = 0"))

  _p1 = length(p1) == 2 ? vcat(p1, 1) : p1
  _p2 = length(p2) == 2 ? vcat(p2, 1) : p2
  return Line2(cross(_p1, _p2))
end

"""
    general_line(m::Number, c::Number)
    Creates a line from the parameters of the general line `y = mx + c`.
"""
function general_line(m::Number, c::Number)::Line2
  return Line2(m, -1, c)
end
end
