#
# This file is a part of MolecularGraph.jl
# Licensed under the MIT License http://opensource.org/licenses/MIT
#

module MolecularGraph

    using Dates
    using DelimitedFiles
    using Graphs
    using LinearAlgebra
    using Printf
    using Statistics
    using YAML

    include("./util/meta.jl")
    include("./util/iterator.jl")
    include("./util/math.jl")

    include("./geometry/interface.jl")
    include("./geometry/cartesian.jl")
    include("./geometry/internal.jl")

    include("./model/interface.jl")
    include("./model/atom.jl")
    include("./model/bond.jl")
    include("./model/query.jl")
    include("./model/molgraph.jl")

    include("./graph/product.jl")
    include("./graph/linegraph.jl")
    include("./graph/traversals.jl")
    include("./graph/cycle.jl")
    include("./graph/matching.jl")
    include("./graph/clique.jl")
    include("./graph/planarity.jl")
    # include("./graph/isomorphism_vf2.jl")
    include("./graph/isomorphism_clique.jl")

    # include("./graph/dag.jl")
    # include("./graph/bipartite.jl")

    include("coords.jl")
    include("stereo.jl")

    include("./draw/color.jl")
    include("./draw/interface.jl")
    include("./draw/draw2d.jl")
    include("./draw/svg.jl")
    include("./draw/draw3d.jl")

    include("sdfilereader.jl")
    include("sdfilewriter.jl")
    include("./smarts/base.jl")
    include("./smarts/atom.jl")
    include("./smarts/bond.jl")
    include("./smarts/logicaloperator.jl")
    include("./smarts/molecule.jl")

    include("properties.jl")
    include("preprocess.jl")
    include("mass.jl")
    include("wclogp.jl")
    include("inchi.jl")



    """
    using Requires

    function __init__()
        @require Makie="ee78f7c6-11fb-53f2-987a-cfe4a2b5a57a" 
    end

    include("structurematch.jl")
    include("download.jl")
    include("libmoleculargraph.jl")
    """
end
