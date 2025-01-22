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

function isunitvec(v; atol = eps(Float64), rtol = eps(Float64))
  if !isapprox(norm(v), 1; atol, rtol)
    return false
  end
  return true
end

function normsq(v)
  return dot(v, v)
end

iszerovec(v; atol = eps(Float64), rtol = eps(Float64)) = isapprox(norm(v), 0; atol, rtol)

function isunittwist(v; atol = eps(Float64), rtol = eps(Float64))
  if length(v) != 6
    throw(DomainError("Twist vector must have 6 elements"))
  end
  return isunitvec(v[4:6]; atol, rtol) ||
         (iszerovec(v[4:6]; atol, rtol) && isunitvec(v[1:3]; atol, rtol))
end

function isunittwist2(v; atol = eps(Float64), rtol = eps(Float64))
  if length(v) != 3
    throw(DomainError("Twist vector must have 3 elements"))
  end
  return isunitvec(v[3]; atol, rtol) ||
         (iszerovec(v[3]; atol, rtol) && isunitvec(v[1:2]; atol, rtol))
end

export unitvec, isunitvec, normsq, iszerovec, isunittwist, isunittwist2
end # module
