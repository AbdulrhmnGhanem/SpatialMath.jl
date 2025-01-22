module Vector

using LinearAlgebra: LinearAlgebra, norm

function unitvec(v)
  norm_v = norm(v)
  if norm_v == 0
    throw(DomainError("Zero vector has no direction"))
  end
  return v / norm_v
end

unitvec(v::Tuple) = unitvec(collect(v))

function isunitvec(v; eps = 1e-12)
  return norm(v) ≈ 1
end

export unitvec
end # module
