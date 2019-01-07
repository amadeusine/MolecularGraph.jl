#
# This file is a part of graphmol.jl
# Licensed under the MIT License http://opensource.org/licenses/MIT
#

@testset "graph.vf2" begin

@testset "subgraph" begin
    g = VectorUDGraph(6, [(1,2), (2,3), (2,4), (2,5), (5,6)])
    h = VectorUDGraph(6, [(1,2), (2,3), (3,4), (3,5), (3,6)])
    @test is_subgraph(h, g)
    @test is_isomorphic(g, h)
    h2 = VectorUDGraph(7, [(1,2), (2,3), (3,4), (3,5), (3,6), (6,7)])
    @test is_subgraph(g, h2)
    @test !is_isomorphic(h2, g)
    h3 = VectorUDGraph(6, [(1,2), (2,3), (3,4), (3,5), (3,6), (6,1)])
    @test !is_subgraph(g, h3)
end

end # graph.vf2