using SpatialMath.Vector
using Symbolics
using LinearAlgebra


@testset "unitvec" begin
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

@testset "isunitvec" begin
  @test isunitvec([1, 0, 0])
  @test isunitvec((1, 0, 0))
  @test isunitvec([1, 0, 0])

  @test !isunitvec([9, 0, 0])
  @test !isunitvec((9, 0, 0))
  @test !isunitvec([9, 0, 0])

  @test isunitvec(1)
  @test isunitvec([1])
  @test isunitvec(-1)
  @test isunitvec([-1])

  @test !isunitvec(2)
  @test !isunitvec([2])
  @test !isunitvec(-2)
  @test !isunitvec([-2])
end


@testset "normsq" begin
  @test normsq([0, 0, 0]) ≈ 0
  @test normsq([1, 2, 3]) ≈ 14
  @test normsq([1, 2, 3]) ≈ 14
end

@testset "symbolic norm" begin
  @variables x y
  v = [x; y]
  @test isequal(norm(v), sqrt(abs2(y) + abs2(x)))
  @test isequal(normsq(v), x^2 + y^2)
end
