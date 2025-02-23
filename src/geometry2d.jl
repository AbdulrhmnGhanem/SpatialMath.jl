module Geometry2D

using LinearAlgebra: cross, dot

export Line2, join_points, general_line, contains

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

function general_line(m::Number, c::Number)::Line2
  return Line2(m, -1, c)
end

function contains(l::Line2, p::AbstractVector{T}) where {T<:Number}
  length(p) in (2, 3) ||
    throw(DimensionMismatch("p must has homogeneous line representation: ax + by + c = 0"))

  _p = length(p) == 2 ? vcat(p, 1) : p
  return dot(l, _p) ≈ 0
end

function intersect(l1::Line2, l2::Line2)
  c = cross(l1, l2)
  return abs(c[end]) > 0
end
end  # module
