module Vector

using LinearAlgebra: LinearAlgebra, norm, dot

function unitvec(v)
  norm_v = norm(v)
  if norm_v == 0
    throw(DomainError("Zero vector has no direction"))
  end
  return v / norm_v
end

unitvec(v::Tuple) = unitvec(collect(v))

function isunitvec(v; atol = 1e-12, rtol = 1e-12)
  if !isapprox(norm(v), 1; atol, rtol)
    return false
  end
  return true
end

function normsq(v)
  return dot(v, v)
end

export unitvec, isunitvec, normsq
end # module
