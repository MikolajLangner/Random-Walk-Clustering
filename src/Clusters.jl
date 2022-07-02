module Clusters

include("Nodes.jl")

using Nodes

export Cluster, pᵢⱼ, pᵢʲ


mutable struct Cluster
    pᵢⱼ::Union{Missing, Vector{Float64}}
    pᵢʲ::Union{Missing, Vector{Float64}}
    i::Integer
    pᵢ::Float64
    nodes::Vector{Node}
    function Cluster(nodes::Vector{Node})
        if length(nodes) == 0
            error("Cluster cannot be empty.")
        end
        pᵢ = sum([node.pᵦ for node in nodes])
        pᵢⱼ = missing
        pᵢʲ = missing
        i = nodes[1].cluster
        if all([node.cluster for node in nodes] .== i)
            new(pᵢⱼ, pᵢʲ, i, pᵢ, nodes)
        else
            error("All nodes must be the same cluster.")
        end
    end
    function Cluster(node::Node)
        pᵢ = node.pᵦ
        pᵢⱼ = missing
        pᵢʲ = missing
        new(pᵢⱼ, pᵢʲ, node.cluster, pᵢ, [node])
    end
end

function Base.setproperty!(cluster::Cluster, field::Symbol, value)
    if field !== :i
        setfield!(cluster, field, value)
    else
        error("Field $field of `cluster` cannot be changed.")
    end
end

function pᵢⱼ(i::Integer, clusters::Vector{Cluster})::Vector{Float64}

    in_nodes = clusters[i].nodes
    out_clusters = [[node.β for node in cluster.nodes] for cluster in clusters]
    [sum([in_node.pᵦ * sum(in_node.pᵦᵅ[out_nodes]) for in_node in in_nodes]) for out_nodes in out_clusters]

end

pᵢʲ(cluster::Cluster)::Vector{Float64} = cluster.pᵢ > 0 ? cluster.pᵢⱼ / cluster.pᵢ : zeros(size(cluster.pᵢⱼ))

end
