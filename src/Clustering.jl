module Clustering

include("Network.jl")
include("SimulatedAnnealing.jl")

using Network, Clusters, KullbackLeibler, SimulatedAnnealing, Combinatorics

export greedy_search, simulated_annealing

check_merge(network::Network, from::Integer, to::Integer)::Vector{Cluster} = merge_clusters(deepcopy(network.clusters), from, to)

function greedy_search(network::Network)::Network

    while true
        actual = objective(network.clusters)
        possibilities = (pair -> check_merge.(network, pair...)).(combinations([cluster.i for cluster in network.clusters], 2))
        maxvalue, maxindex = findmax(objective.(possibilities))
        if maxvalue >= actual
            network.clusters = possibilities[maxindex]
        else
            return network
        end
    end

end

function clustering(network::Network, Ts::Vector{Float64} = collect(0:10.:100), annealing_steps::Integer = 1000)::Tuple{Network, Float64}

    network = greedy_search(network)
    annealed_networks = (T -> heat_bath(network, T, annealing_steps)).(Ts)
    maxvalue, maxindex = findmax(objective.(annealed_networks))
    annealed_networks[maxindex], maxvalue

end