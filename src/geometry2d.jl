module Geometry2D

using LinearAlgebra: cross, dot, norm

export Line2,
  contains,
  general_line,
  join_points,
  Polygon2,
  area,
  bbox,
  centroid,
  edges,
  intersect_line,
  intersect,
  moment,
  radius,
  vertices,
  transform

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

struct Polygon2{T}
  vertices::Matrix{T}
end

function Polygon2(points::Vector{<:Tuple})
  verts = reduce(hcat, [[x[1], x[2]] for x in points])
  Polygon2(verts)
end

Polygon2(vertices::AbstractMatrix) = Polygon2(vertices)

Base.show(io::IO, p::Polygon2) =
  print(io, "Polygon2 with $(size(p.vertices, 2) + 1) vertices")
Base.length(p::Polygon2) = size(p.vertices, 2)

function vertices(p::Polygon2; unique::Bool = true)
  if unique
    return p.vertices
  else
    return hcat(p.vertices, p.vertices[:, 1])
  end
end

function _binomial(n::Int, k::Int)
  k < 0 && return 0
  k > n && return 0
  k = min(k, n - k)
  result = 1
  for i = 1:k
    result *= (n - i + 1) / i
  end
  return result
end

function moment(p::Polygon2, px::Int, qy::Int)

  verts = vertices(p, unique = true)
  x, y = verts[1, :], verts[2, :]
  m = 0.0
  n = length(p)

  for l = 1:n
    l1 = mod1(l - 1, n)
    dx = x[l] - x[l1]
    dy = y[l] - y[l1]
    A = x[l] * dy - y[l] * dx

    s = 0.0
    for i = 0:px
      for j = 0:qy
        s +=
          (-1)^(i + j) * _binomial(px, i) * _binomial(qy, j) / (i + j + 1) *
          x[l]^(px - i) *
          y[l]^(qy - j) *
          dx^i *
          dy^j
      end
    end
    m += A * s
  end

  return m / (px + qy + 2)
end

area(p::Polygon2) = abs(moment(p, 0, 0))

function centroid(p::Polygon2)
  m00 = moment(p, 0, 0)
  [moment(p, 1, 0) / m00, moment(p, 0, 1) / m00]
end

function radius(p::Polygon2)
  c = centroid(p)
  maximum(norm.(eachcol(p.vertices .- c)))
end

function bbox(p::Polygon2)
  [
    minimum(p.vertices[1, :]),
    minimum(p.vertices[2, :]),
    maximum(p.vertices[1, :]),
    maximum(p.vertices[2, :]),
  ]
end

function _point_in_polygon(point::AbstractVector, polygon::Matrix, radius::Real)
  inside = false
  n = size(polygon, 2)
  j = n

  for i = 1:n
    # Check if point is within radius of any edge
    if radius > 0
      # Get current edge points
      p1, p2 = polygon[:, i], polygon[:, j]

      # Calculate distance from point to line segment
      edge = p2 - p1
      len_sq = sum(abs2, edge)
      if len_sq != 0
        t = max(0, min(1, dot(point - p1, edge) / len_sq))
        projection = p1 + t * edge
        dist = norm(point - projection)
        if dist ≤ radius
          return true
        end
      end
    end

    # Standard odd-parity test
    if ((polygon[2, i] > point[2]) != (polygon[2, j] > point[2])) && (
      point[1] <
      (polygon[1, j] - polygon[1, i]) * (point[2] - polygon[2, i]) /
      (polygon[2, j] - polygon[2, i]) + polygon[1, i]
    )
      inside = !inside
    end
    j = i
  end

  # For negative radius, shrink the polygon
  if radius < 0 && inside
    # Check if point is at least |radius| distance from all edges
    for i = 1:n
      p1, p2 = polygon[:, i], polygon[:, mod1(i + 1, n)]
      edge = p2 - p1
      len_sq = sum(abs2, edge)
      if len_sq != 0
        t = max(0, min(1, dot(point - p1, edge) / len_sq))
        projection = p1 + t * edge
        if norm(point - projection) < abs(radius)
          return false
        end
      end
    end
  end

  return inside
end

function contains(p::Polygon2, point::AbstractVector; radius::Real = 0.0)
  return _point_in_polygon(point, vertices(p, unique = true), radius)
end

function edges(p::Polygon2)
  verts = vertices(p, unique = true)
  n = size(verts, 2)
  return ((tuple(verts[:, i]...), tuple(verts[:, mod1(i + 1, n)]...)) for i = 1:n)
end

function intersect(p::Polygon2)
  return false
end

function intersect_line(::Polygon2, ::Line2)
  return false
end

function transform(::Polygon2)
  return false
end
end  # module
