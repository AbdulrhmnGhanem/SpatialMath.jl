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

@testset "iszerovec" begin
  @test iszerovec([0])
  @test iszerovec([0, 0])
  @test iszerovec([0, 0, 0])

  @test !iszerovec([1])
  @test !iszerovec([0, 1])
  @test !iszerovec([0, 1, 0])
end

@testset "isunittwist" begin
  @test isunittwist([1, 2, 3, 1, 0, 0])
  @test isunittwist((1, 2, 3, 1, 0, 0))
  @test isunittwist([1, 2, 3, 1, 0, 0])
  @test !isunittwist([1, 2, 3, 1, 0, 1])
  @test isunittwist([1, 0, 0, 0, 0, 0])
  @test !isunittwist([2, 0, 0, 0, 0, 0])
  @test_throws DomainError isunittwist([3, 4])
end

@testset "isunittwist2" begin
  @test isunittwist2([1, 2, 1])
  @test !isunittwist2([1, 2, 3])
  @test isunittwist2([1, 0, 0])
  @test !isunittwist2([2, 0, 0])
  @test_throws DomainError isunittwist2([3, 4])
end

@testset "unittwist" begin
  @test unittwist([0, 0, 0, 1, 0, 0]) ≈ [0, 0, 0, 1, 0, 0]
  @test unittwist([0, 0, 0, 0, 2, 0]) ≈ [0, 0, 0, 0, 1, 0]
  @test unittwist([0, 0, 0, 0, 0, -3]) ≈ [0, 0, 0, 0, 0, -1]

  @test unittwist([1, 0, 0, 1, 0, 0]) ≈ [1, 0, 0, 1, 0, 0]
  @test unittwist([1, 0, 0, 0, 2, 0]) ≈ [0.5, 0, 0, 0, 1, 0]
  @test unittwist([1, 0, 0, 0, 0, -2]) ≈ [0.5, 0, 0, 0, 0, -1]

  @test unittwist([1, 0, 0, 0, 0, 0]) ≈ [1, 0, 0, 0, 0, 0]
  @test unittwist([0, 2, 0, 0, 0, 0]) ≈ [0, 1, 0, 0, 0, 0]
  @test unittwist([0, 0, -2, 0, 0, 0]) ≈ [0, 0, -1, 0, 0, 0]

  @test isnothing(unittwist([0, 0, 0, 0, 0, 0]))
end

@testset "unittwist2" begin
  @test unittwist2([0, 0, 1]) ≈ [0, 0, 1]
  @test unittwist2([0, 0, 2]) ≈ [0, 0, 1]
  @test unittwist2([0, 0, -3]) ≈ [0, 0, -1]

  @test unittwist2([1, 0, 0]) ≈ [1, 0, 0]
  @test unittwist2([0, 2, 0]) ≈ [0, 1, 0]
  @test unittwist2([0, 0, -2]) ≈ [0, 0, -1]

  @test isnothing(unittwist2([0, 0, 0]))
end

@testset "unittwist_norm" begin
  a = unittwist_norm([0, 0, 0, 1, 0, 0])
  @test a[1] ≈ [0, 0, 0, 1, 0, 0]
  @test a[2] ≈ 1

  a = unittwist_norm([0, 0, 0, 0, 2, 0])
  @test a[1] ≈ [0, 0, 0, 0, 1, 0]
  @test a[2] ≈ 2

  a = unittwist_norm([0, 0, 0, 0, 0, -3])
  @test a[1] ≈ [0, 0, 0, 0, 0, -1]
  @test a[2] ≈ 3

  a = unittwist_norm([1, 0, 0, 1, 0, 0])
  @test a[1] ≈ [1, 0, 0, 1, 0, 0]
  @test a[2] ≈ 1

  a = unittwist_norm([1, 0, 0, 0, 2, 0])
  @test a[1] ≈ [0.5, 0, 0, 0, 1, 0]
  @test a[2] ≈ 2

  a = unittwist_norm([1, 0, 0, 0, 0, -2])
  @test a[1] ≈ [0.5, 0, 0, 0, 0, -1]
  @test a[2] ≈ 2

  a = unittwist_norm([1, 0, 0, 0, 0, 0])
  @test a[1] ≈ [1, 0, 0, 0, 0, 0]
  @test a[2] ≈ 1

  a = unittwist_norm([0, 2, 0, 0, 0, 0])
  @test a[1] ≈ [0, 1, 0, 0, 0, 0]
  @test a[2] ≈ 2

  a = unittwist_norm([0, 0, -2, 0, 0, 0])
  @test a[1] ≈ [0, 0, -1, 0, 0, 0]
  @test a[2] ≈ 2

  a = unittwist_norm([0, 0, 0, 0, 0, 0])
  @test isnothing(a[1])
  @test isnothing(a[2])
end

@testset "unittwist2_norm" begin
  a = unittwist2_norm([1, 0, 0])
  @test a[1] ≈ [1, 0, 0]
  @test a[2] ≈ 1

  a = unittwist2_norm([0, 2, 0])
  @test a[1] ≈ [0, 1, 0]
  @test a[2] ≈ 2

  a = unittwist2_norm([0, 0, -3])
  @test a[1] ≈ [0, 0, -1]
  @test a[2] ≈ 3

  a = unittwist2_norm([2, 0, -2])
  @test a[1] ≈ [1, 0, -1]
  @test a[2] ≈ 2

  a = unittwist2_norm([0, 0, 0])
  @test isnothing(a[1])
  @test isnothing(a[2])
end
