using Test
using SpatialMath.Geometry2D
using LinearAlgebra

@testset "Polygon2" begin
  @testset "constructor" begin
    p = Polygon2([(1, 2), (3, 2), (2, 4)])
    @test p isa Polygon2
    @test length(p) == 3
    @test string(p) == "Polygon2 with 4 vertices"
    @test vertices(p) ≈ [1 3 2; 2 2 4]
    @test vertices(p, unique = false) ≈ [1 3 2 1; 2 2 4 2]
  end

  @testset "physical" begin
    p = Polygon2([-1 1 1 -1; -1 -1 1 1])

    @test area(p) ≈ 4
    @test moment(p, 0, 0) ≈ 4
    @test moment(p, 1, 0) ≈ 0
    @test moment(p, 0, 1) ≈ 0
    @test centroid(p) ≈ [0, 0]

    @test radius(p) ≈ √2
    @test bbox(p) ≈ [-1, -1, 1, 1]
  end

  @testset "contains" begin
    p = Polygon2([-1 1 1 -1; -1 -1 1 1])

    @test Geometry2D.contains(p, [0, 0], radius = 1e-6)
    @test Geometry2D.contains(p, [1, 0], radius = 1e-6)
    @test Geometry2D.contains(p, [-1, 0], radius = 1e-6)
    @test Geometry2D.contains(p, [0, 1], radius = 1e-6)
    @test Geometry2D.contains(p, [0, -1], radius = 1e-6)

    @test !Geometry2D.contains(p, [0, 1.1], radius = 1e-6)
    @test !Geometry2D.contains(p, [0, -1.1], radius = 1e-6)
    @test !Geometry2D.contains(p, [1.1, 0], radius = 1e-6)
    @test !Geometry2D.contains(p, [-1.1, 0], radius = 1e-6)
  end

  @testset "edges" begin
    p = Polygon2([(1, 2), (3, 2), (2, 4)])
    e = collect(edges(p))

    @test e[1] == ((1, 2), (3, 2))
    @test e[2] == ((3, 2), (2, 4))
    @test e[3] == ((2, 4), (1, 2))
  end

  @testset "missing" begin
    "FIXME: Polygon2 missing methods"
    p = Polygon2([(1, 2), (3, 2), (2, 4)])
    @test_broken Geometry2D.transform(p)
    @test_broken Geometry2D.intersect(p)
    @test_broken Geometry2D.intersect_linet(p, Line2([1, 2]))
  end
end
