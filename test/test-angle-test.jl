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
