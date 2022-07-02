module KullbackLeibler

include("Clusters.jl")

using Clusters.jl

export objective


function objective_element(cluster::Cluster)::Float64

    i = cluster.i
    cluster.pᵢⱼ[i] * log(cluster.pᵢʲ[i] / cluster.pᵢ) + (1 - cluster.pᵢⱼ[i]) * log((1 - cluster.pᵢʲ[i]) / (1 - cluster.pᵢ))

end

objective(clusters::Vector{Cluster}) = sum(objective_element.(clusters))

end