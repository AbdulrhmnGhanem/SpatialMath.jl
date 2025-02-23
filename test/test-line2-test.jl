using Test
using SpatialMath.Geometry2D

@testset "Line2" begin
  @testset "constructor" begin
    l = Line2([1, 2, 3])
    @test repr(l) == "Line2(1, 2, 3)"

    l = Geometry2D.join_points([0, 0], [1, 2])
    @test vec(l) == [-2, 1, 0]

    l = Geometry2D.general_line(2, 1)
    @test vec(l) == [2, -1, 1]
  end
end
