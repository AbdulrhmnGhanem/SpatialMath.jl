using SpatialMath.Angle

@testset "wrap_0_to_pi" begin
  @test wrap_0_2pi(0) ≈ 0
  @test wrap_0_2pi(2 * π) ≈ 0
  @test wrap_0_2pi(3 * π) ≈ π
  @test wrap_0_2pi(-π) ≈ π
  @test wrap_0_2pi([0, 2 * π, 3 * π, -π]) ≈ [0, 0, π, π]
end

@testset "wrap_mpi_pi" begin
  @test wrap_mpi_pi(0) ≈ 0
  @test wrap_mpi_pi(-π) ≈ -π
  @test wrap_mpi_pi(π) ≈ -π
  @test wrap_mpi_pi(2 * π) ≈ 0
  @test wrap_mpi_pi(1.5 * π) ≈ -0.5 * π
  @test wrap_mpi_pi(-1.5 * π) ≈ 0.5 * π
  @test wrap_mpi_pi([0, -π, π, 2 * π, 1.5 * π, -1.5 * π]) ≈
        [0, -π, -π, 0, -0.5 * π, 0.5 * π]
end

@testset "wrap_0_pi" begin
  @test wrap_0_pi(0) ≈ 0
  @test wrap_0_pi(π) ≈ π
  @test wrap_0_pi(1.2 * π) ≈ 0.8 * π
  @test wrap_0_pi(-0.2 * π) ≈ 0.2 * π
  @test wrap_0_pi([0, π, 1.2 * π, -0.2 * π]) ≈ [0, π, 0.8 * π, 0.2 * π]
end


@testset "wrap_mpi2_pi2" begin
  @test wrap_mpi2_pi2(0) ≈ 0
  @test wrap_mpi2_pi2(-0.5 * π) ≈ -0.5 * π
  @test wrap_mpi2_pi2(0.5 * π) ≈ 0.5 * π
  @test wrap_mpi2_pi2(0.6 * π) ≈ 0.4 * π
  @test wrap_mpi2_pi2(-0.6 * π) ≈ -0.4 * π
  @test wrap_mpi2_pi2([0, -0.5 * π, 0.5 * π, 0.6 * π, -0.6 * π]) ≈
        [0, -0.5 * π, 0.5 * π, 0.4 * π, -0.4 * π]
end


@testset "angle_wrap" begin
  angles = [0, 0.3, 0.5, 0.8, 1.0, 1.3, 1.5, 1.7, 2]
  for angle_factor in angles
    θ = angle_factor * π
    @test angle_wrap(θ) ≈ wrap_mpi_pi(θ)
    @test angle_wrap(-θ) ≈ wrap_mpi_pi(-θ)
    @test angle_wrap(θ, mode = :mpi2pi) ≈ wrap_mpi_pi(θ)
    @test angle_wrap(-θ, mode = :mpi2pi) ≈ wrap_mpi_pi(-θ)
    @test angle_wrap(θ, mode = :zero22pi) ≈ wrap_0_2pi(θ)
    @test angle_wrap(-θ, mode = :zero22pi) ≈ wrap_0_2pi(-θ)
    @test angle_wrap(θ, mode = :zero2pi) ≈ wrap_0_pi(θ)
    @test angle_wrap(-θ, mode = :zero2pi) ≈ wrap_0_pi(-θ)
    @test angle_wrap(θ, mode = :mpi22pi2) ≈ wrap_mpi2_pi2(θ)
    @test angle_wrap(-θ, mode = :mpi22pi2) ≈ wrap_mpi2_pi2(-θ)
    @test_throws ArgumentError angle_wrap(θ, mode = :foo)
  end
end

@testset "angle_diff" begin
  @test isa(angle_diff(0, 0), Float64)
  @test angle_diff(π, 0) == -π
  @test angle_diff(-π, π) == 0

  x = angle_diff([0, -π, π], 0)
  @test x ≈ [0, -π, -π]
  @test isa(x, Vector{Float64})
  @test angle_diff([0, -π, π], π) ≈ [-π, 0, 0]

  x = angle_diff(0, [0, -π, π])
  @test x ≈ [0, -π, -π]
  @test isa(x, Vector{Float64})
  @test angle_diff(π, [0, -π, π]) ≈ [-π, 0, 0]

  x = angle_diff([1, 2, 3], [1, 2, 3])
  @test x ≈ [0, 0, 0]
  @test isa(x, Vector{Float64})
end

@testset "angle_stats" begin
  θ = range(3π / 2, stop = 5π / 2, length = 50)
  @test isapprox(angle_mean(θ), 0, atol = 1e-12)
  @test angle_std(θ) ≈ 0.9717284050981313

  θ = range(π / 2, stop = 3π / 2, length = 50)
  @test angle_mean(θ) ≈ π
  @test angle_std(θ) ≈ 0.9717284050981313
end
