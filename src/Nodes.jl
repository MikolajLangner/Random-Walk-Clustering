module Nodes

export Node

let NODE_ID = 0
    mutable struct Node
        pᵦᵅ::Vector{Float64}
        β::Integer
        pᵦ::Float64
        cluster::Integer
        function Node(pᵦᵅ::Vector{Float64}, pᵦ::Union{Missing, Float64} = missing, τ::Float64 = .15)
            NODE_ID += 1
            if NODE_ID > size(pᵦᵅ, 1)
                throw(BoundsError())
            end
            pᵦ = ismissing(pᵦ) ? inv(size(pᵦᵅ, 1)) : pᵦ
            pᵦᵅ /= sum(pᵦᵅ)
            pᵦᵅ = (1-τ) * pᵦᵅ + τ / size(pᵦᵅ, 1) * ones(size(pᵦᵅ))
            new(pᵦᵅ, NODE_ID, pᵦ, NODE_ID)
        end
    end
end

function Base.setproperty!(node::Node, field::Symbol, value)
    if field === :pᵦ || field === :cluster
        setfield!(node, field, value)
    else
        error("Field $field of `Node` cannot be changed.")
    end
end

end