using Test
using SpatialMath.Geometry2D

@testset "Line2" begin
  @testset "constructor" begin
    l = Line2([1, 2, 3])
    @test repr(l) == "Line2(1, 2, 3)"

    l = join_points([0, 0], [1, 2])
    @test vec(l) == [-2, 1, 0]

    l = general_line(2, 1)
    @test vec(l) == [2, -1, 1]
  end

  @testset "contains" begin
    l = join_points([0, 0], [1, 2])
    @test Geometry2D.contains(l, [0, 0])
    @test Geometry2D.contains(l, [1, 2])
    @test Geometry2D.contains(l, [2, 4])
    @test !Geometry2D.contains(l, [1, 1])
  end

  @testset "intersection" begin
    l1 = join_points([0, 0], [2, 0])  # x-axis
    l2 = join_points([0, 1], [2, 1])  # y = 1
    @test !Geometry2D.intersect(l1, l2)

    l2 = join_points([2, 1], [2, -1])  # x = 2
    @test Geometry2D.intersect(l1, l2)
  end
end
