#
# This file is a part of MolecularGraph.jl
# Licensed under the MIT License http://opensource.org/licenses/MIT
#

export max_matching, is_perfect_matching


function findaugpath(g::SimpleGraph{T}, matching::Set{Edge{T}}) where T
    head = Set(vertices(g))  # Initial exposed node set
    for m in matching
        setdiff!(head, src(m), dst(m))
    end
    @debug "head: $(head)"
    pred = Dict{T,T}()  # F tree
    for v in head
        pred[v] = v
    end
    while !isempty(head)
        v = pop!(head)
        @debug "  v: $(v)"
        unmarked = setdiff(Set(edges(g)), matching)
        for w in neighbors(g, v)
            undirectededge(T, v, w) in unmarked || continue
            @debug "    w: $(w)"
            if !(w in keys(pred))
                incs = Set(undirectededge(T, w, nbr) for nbr in neighbors(g, w))
                e2 = only(intersect(incs, matching))
                x = src(e2) == w ? dst(e2) : src(e2)
                @debug "      x: $(x)"
                pred[w] = v
                pred[x] = w
                union!(head, x)
                continue
            end
            p1 = bfs_path(pred, v)
            p2 = bfs_path(pred, w)
            length(p2) % 2 == 1 || continue  # if dist(w, root(w)) is odd, do nothing
            if p1[1] != p2[1]
                p = vcat(p1, reverse(p2))
                @debug "      P: $(p) (extend tree)"
                return p
            end
            # Contract a blossom
            bsrc = intersect(p1, p2)[end]
            bpath = union([bsrc], setdiff(p1, p2), reverse(setdiff(p2, p1)))
            g_cont = copy(g)  # G'
            gc_vrev = merge_vertices!(g_cont, bpath)
            # induced_subgraph i in G' => vmap[i] in G
            # merge_vertices! i in G => vrev[i] in G'
            bn = minimum(bpath)  # contracted blossom
            @debug "      Recursion: $(bpath) -> $(bn)"
            cmat = Set(undirectededge(T, gc_vrev[src(e)], gc_vrev[dst(e)]) for e in matching)
            m_cont = intersect(cmat, edges(g_cont))  # M'
            p_cont = findaugpath(g_cont, m_cont)  # P'
            # @assert length(p_cont) % 2 == 0
            # Lifting
            gc_vmap = Dict(v => i for (i, v) in enumerate(gc_vrev))
            p = [gc_vmap[n] for n in p_cont]
            if !(bn in p_cont)
                @debug "      P: $(p) (no blossom in augpath)"
                return p
            end
            pos = findfirst(x -> x == bn, p_cont)
            if pos == 1 || pos == length(p)
                nbrpos = pos == 1 ? 2 : length(p) - 1
                bdst = bpath[findfirst(x -> has_edge(g, p[nbrpos], x), bpath)]
                if bsrc == bdst
                    p[pos] = bsrc
                    @debug "      P: $(p) (blossom root is exposed)"
                    return p
                end
            else
                inlet = bpath[findfirst(x -> has_edge(g, p[pos-1], x), bpath)]
                outlet = bpath[findfirst(x -> has_edge(g, p[pos+1], x), bpath)]
                @assert inlet == bsrc || outlet == bsrc
                bdst = inlet == bsrc ? outlet : inlet
            end
            r = noweight_shortestpath(g, bsrc, bdst)
            if length(r) % 2 == 0
                # find even length path
                brk = (r[1], r[2])
                rem_edge!(g, brk...)
                r = noweight_shortestpath(g, bsrc, bdst)
                add_edge!(g, undirectededge(T, brk...))
            end
            baug = pos % 2 == 0 ? reverse(r) : r
            p = union(p[1:pos-1], baug, p[pos+1:end])
            @debug "      P: $(p) (lifted)"
            return p
        end
    end
    return Int[]
end


function findmaxmatch(g::SimpleGraph{T}, matching::Set{Edge{T}}) where T
    P = findaugpath(g, matching)
    # @assert length(P) % 2 == 0
    isempty(P) && return matching
    p_edges = Set{Edge{T}}()
    for i in 1:length(P)-1
        push!(p_edges, undirectededge(T, P[i], P[i + 1]))
    end
    augment = symdiff(p_edges, matching)
    # @assert length(matching) + 1 == length(augment)
    return findmaxmatch(g, augment)
end


"""
    max_matching(G::SimpleGraph; method=:Blossom) -> Set{Int}

Compute maximum cardinality matching by Edmonds' blossom algorithm and return the set of matched edges.
"""
max_matching(g::SimpleGraph{T}; method=:Blossom) where T = findmaxmatch(g, Set{Edge{T}}())


"""
    is_perfect_matching(G::SimpleGraph) -> Bool
    is_perfect_matching(G::SimpleGraph, matching::Set{Int}) -> Bool

Return if the given graph has a perfect matching.
"""
is_perfect_matching(g::SimpleGraph) = length(max_matching(g)) * 2 == nv(g)
is_perfect_matching(g::SimpleGraph, matching) = length(matching) * 2 == nv(g)
