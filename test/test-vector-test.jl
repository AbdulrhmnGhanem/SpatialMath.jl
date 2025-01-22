using SpatialMath.Vector


@testset "Unit Vector Tests" begin
  @test unitvec([1, 0, 0]) ≈ [1, 0, 0]
  @test unitvec([0, 1, 0]) ≈ [0, 1, 0]
  @test unitvec([0, 0, 1]) ≈ [0, 0, 1]

  @test unitvec((1, 0, 0)) ≈ [1, 0, 0]
  @test unitvec((0, 1, 0)) ≈ [0, 1, 0]
  @test unitvec((0, 0, 1)) ≈ [0, 0, 1]

  @test unitvec([9, 0, 0]) ≈ [1, 0, 0]
  @test unitvec([0, 9, 0]) ≈ [0, 1, 0]
  @test unitvec([0, 0, 9]) ≈ [0, 0, 1]

  @test_throws DomainError unitvec([0, 0, 0])
  @test_throws DomainError unitvec([0])
  @test_throws DomainError unitvec(0)
end
