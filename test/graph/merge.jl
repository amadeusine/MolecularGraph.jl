#
# This file is a part of graphmol.jl
# Licensed under the MIT License http://opensource.org/licenses/MIT
#

@testset "graph.merge" begin

@testset "shallowmerge" begin
    G = MapUDGraph(1:5, [(1, 2), (2, 3), (3, 4), (4, 5)])
    H = MapUDGraph(1:5, [(1, 2), (2, 3), (3, 4), (4, 5)])
    U, nmap, emap = shallowmerge(G, H)
    @test nodecount(U) == 10
    @test edgecount(U) == 8
    @test issetequal(
        [tuple(sort(collect(c))...) for c in connected_components(U)],
        [tuple(1:5...), tuple(6:10...)]
    )
    @test getnode(U, 4) !== getnode(U, 9)
    @test getedge(U, 4) !== getedge(U, 8)
    # shallowmerge does not copy Node and Edge objects
    U, nmap, emap = shallowmerge(G, G)
    @test getnode(U, 4) === getnode(U, 9)
    @test getedge(U, 4) === getedge(U, 8)
end

end # graph.merge