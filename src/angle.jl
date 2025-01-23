module Angle

export wrap_0_2pi, wrap_mpi_pi, wrap_0_pi, wrap_mpi2_pi2

function wrap_0_2pi(θ)
  y = θ .- 2π .* floor.(θ ./ (2π))
  return length(y) == 1 ? y[1] : y
end

function wrap_mpi_pi(θ)
  y = mod.(θ .+ π, 2π) .- π
  return length(y) == 1 ? y[1] : y
end

function wrap_0_pi(θ)
  θ = abs.(θ)
  n = θ ./ π
  n = trunc.(Int, n)
  y = ifelse.(mod.(n, 2) .== 0, θ .- n .* π, (n .+ 1) .* π .- θ)
  return length(y) == 1 ? y[1] : y
end

function wrap_mpi2_pi2(θ)
  n = θ / 2π
  n = trunc.(Int, n)
  y = ifelse.(mod.(n, 2) .== 0, θ - n * π, n * π - θ)
  return length(y) == 1 ? y[1] : y
end

end # module
