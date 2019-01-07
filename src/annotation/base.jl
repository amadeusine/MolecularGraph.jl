#
# This file is a part of graphmol.jl
# Licensed under the MIT License http://opensource.org/licenses/MIT
#

export
    default_annotation!


function default_annotation!(mol::VectorMol)
    topology!(mol)
    elemental!(mol)
    rotatable!(mol)
    aromatic!(mol)
    # wclogp!(mol)
    return
end