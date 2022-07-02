module SimulatedAnnealing

include("Network.jl")
using Network

export heat_bath

function hamiltonian(network::Network, node::Node, cluster::Cluster)::Float64

    δ = [n.cluster for n in network.nodes] .== cluster.i
    δ[node.β] = 0
    -sum((network.transition_matrix[node.β, :] + network.transition_matrix[:, node.β]) .* δ)    

end

function heat_bath(network::Network, T::float, steps::Integer, kᵦ::Float64 = 1.380649e-23)::Network

    network_copy = deepcopy(network)
    for step in 1:steps
        node = rand(network_copy.nodes)
        hamiltionians = (cluster -> hamiltionian(network_copy, node, cluster)).(network_copy.clusters)
        acceptances = (H -> exp(-H * inv(kᵦ*T))).(hamiltionians)
        probabilities = acceptances / sum(acceptances)
        u = rand()
        network_copy = move_node(network_copy, node, network_copy.clusters[findall(pᵢ -> u < pᵢ, cumsum(probabilities))[1]])
    end

    network_copy
end