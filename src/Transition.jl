module Transition

include("Nodes.jl")

using Nodes

export transition_matrix, generate_nodes

transition_matrix(nodes::Vector{Node})::Matrix{Float64} = mapreduce(permutedims, vcat, [n.pᵦᵅ for n in nodes])

generate_nodes(transition_matrix::Matrix{Float64}) = (transition -> Node(Vector{Float64}(transition))).(eachrow(transition_matrix))

end