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
  @test_broken wrap_mpi2_pi2(0.6 * π) ≈ 0.4 * π
  @test_broken wrap_mpi2_pi2(-0.6 * π) ≈ -0.4 * π
  @test_broken wrap_mpi2_pi2([0, -0.5 * π, 0.5 * π, 0.6 * π, -0.6 * π]) ≈
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
    # @test_broken angle_wrap(θ, mode = :mpi22pi2) ≈ wrap_mpi2_pi2(θ)
    # @test_broken angle_wrap(-θ, mode = :mpi22pi2) ≈ wrap_mpi2_pi2(-θ)
    @test_throws ArgumentError angle_wrap(θ, mode = :foo)
  end
end
