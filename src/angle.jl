module Angle

using Match: @match
using Statistics: mean

export wrap_0_2pi,
  wrap_mpi_pi, wrap_0_pi, wrap_mpi2_pi2, angle_wrap, angle_diff, angle_std, angle_mean

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

function angle_wrap(θ; mode = :mpi2pi)
  @match mode begin
    :mpi2pi => wrap_mpi_pi(θ)
    :zero2pi => wrap_0_pi(θ)
    :zero22pi => wrap_0_2pi(θ)
    :mpi22pi2 => wrap_mpi2_pi2(θ)
    _ => throw(ArgumentError("Invalid mode: $mode"))
  end
end

function angle_diff(a, b = nothing)
  if !isnothing(b)
    a = a .- b
  end

  y = mod.(a .+ π, 2π) .- π
  return length(y) == 1 ? y[1] : y
end

function angle_std(Θ)
  X, Y = mean.([cos.(Θ), sin.(Θ)])
  R = hypot(X, Y)
  return sqrt(-2log(R))
end

function angle_mean(Θ)
  X, Y = mean.([cos.(Θ), sin.(Θ)])
  return atan(Y, X)
end

end # module
