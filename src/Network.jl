module Network

include("Nodes.jl")
include("Clusters.jl")
include("KullbackLeibler.jl")
include("Transition.jl")
include("PowerMethod.jl")

using Nodes, Clusters, KullbackLeibler, Transition, PowerMethod

export Network, move_node

mutable struct Network
    nodes::Vector{Node}
    clusters::Vector{Cluster}
    transition_matrix::Matrix{Float64}
    objective::Float64
    function Network(transition_matrix::Matrix{Float64})
        nodes = generate_nodes(transition_matrix)
        π = stationary_distribution(transition_matrix, π₀ = [node.pᵦ for node in nodes])
        (node -> node.pᵦ = π[node.β]).(nodes)
        clusters = Cluster.(nodes)
        objective = objective(clusters)
        new(nodes, clusters, transition_matrix, objective)
    end
    function Network(nodes::Vector{Node})
        transition_matrix = transition_matrix(nodes)
        π = stationary_distribution(transition_matrix, π₀ = [node.pᵦ for node in nodes])
        (node -> node.pᵦ = π[node.β]).(nodes)
        clusters = Cluster.(nodes)
        objective = objective(clusters)
        new(nodes, clusters, transition_matrix, objective)
    end
end

function Base.setproperty!(network::Network, field::Symbol, value)
    if field === :clusters
        setfield!(network, field, filter(cluster -> length(cluster.nodes > 0), value))
    else
        setfield!(network, field, value)
    end
end

function move_node(network::Network, node::Node, cluster::Cluster)::Network

    from_cluster = network.clusters[node.i]
    deleteat!(from_cluster.nodes, findall(n -> n.β == node.β, from_cluster.nodes))
    node.cluster = cluster.i
    push!(cluster.nodes, node)
    from_cluster.pᵢ -= node.pᵦ
    cluster.pᵢ += node.pᵦ
    for cluster in network.clusters
        cluster.pᵢⱼ = pᵢⱼ(cluster.i, network.clusters)
        cluster.pᵢʲ = pᵢʲ(cluster)
    end

    network
end

function merge_clusters(clusters::Vector{Cluster}, from::Integer, to::Integer)::Vector{Cluster}

    from_cluster = clusters[findfirst(cluster -> cluster.i == from, clusters)] 
    to_cluster = clusters[findfirst(cluster -> cluster.i == to, clusters)]

    (node -> node.cluster = to).(from_cluster.nodes)
    append!(to_cluster.nodes, from_cluster.nodes)
    from_cluster.nodes = Vector{Node}()
    from_cluster.pᵢ = 0
    to_cluster.pᵢ = sum([node.pᵦ for node in to_cluster.nodes])
    for cluster in clusters
        cluster.pᵢⱼ = pᵢⱼ(cluster.i, clusters)
        cluster.pᵢʲ = pᵢʲ(cluster)
    end

    clusters
end

end