module PowerMethod

using LinearAlgebra

export stationary_distribution

function stationary_distribution(P::Matrix{Float64}, π₀::Union{Missing, Vector{Float64}} = missing, ϵ::Float64 = 1e-3)::Vector{Float64}

    n = size(P, 1)
    π₀ = ismissing(π₀) ? repeat([inv(n)], n) : π₀
    Pᵀ = transpose(P)

    π = Pᵀ * π₀
    while norm(π - π₀) >= ϵ
        π₀ = π
        π = Pᵀ * π₀
    end

    π
end

end