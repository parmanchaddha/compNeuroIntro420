module Hopfield

using LinearAlgebra
using Random
export HopfieldNetwork, initializeHopfieldNetwork, matchPattern

"""HopfieldNetwork

Attributes

weights: A `size` by `size` matrix of Float64 elements representing nodal
connection of the Hopfield network.

size: The length of each dimension of the matrix.
"""
mutable struct HopfieldNetwork
    weights::Matrix{Float64}
    size::Int64
end


"""initializeHopfieldNetwork

Args

trainingPatterns: A vector/list of training patterns that the hopfield
network should memorize. These must have 2 dimensions, be of size `size`,
and be square.

size: The size/length of each dimension. Since we are assumming a square input,
sizeX = sizeY = size.

"""
function initializeHopfieldNetwork(
    trainingPatterns::Vector{Matrix{Float64}},
    size::Int64
)
    weights = _memorize(trainingPatterns, size)
    thisNetwork = HopfieldNetwork(weights, size)
    return thisNetwork
end


function isclose(x,y)
    return isapprox(x,y,atol=1.e-9)
end


"""_memorize
Returns a set of weights corresponding to the memorization of each training pattern.
"""
function _memorize(trainingPatterns::Vector{Matrix{Float64}}, size::Int64, maxIterations::Int64 = 1000)
    weights = zeros(size^2, size^2)
    currentIteration = 1
    numPatterns = length(trainingPatterns)
    while (currentIteration <= maxIterations)
        patternsMemorized = 0
        lastWeights = deepcopy(weights)
        trainingPatterns = trainingPatterns[randperm(length(trainingPatterns))]
        weights = _calculateWeights(weights, trainingPatterns, size)
        for thisPattern in trainingPatterns
            output = matchPattern(thisPattern, weights, size)
            if isclose(output, thisPattern)
                patternsMemorized += 1
            end
        end
        println("Iteration Number $(currentIteration). Patterns Memorized: $(patternsMemorized)")
        currentIteration += 1
        if (patternsMemorized == numPatterns) || (isclose(lastWeights, weights))
            break
        end
    end

    return weights
end

"""_calculateWeights: Calculate the new weights given the training patterns.

Args

weights: A `size` by `size` matrix of Float64 elements representing nodal
connection weights of the Hopfield network.

trainingPatterns: A vector/list of training patterns that the hopfield
network should memorize. These must have 2 dimensions, be of size `size`,
and be square.

size: The size/length of each dimension. Since we are assumming a square input,
sizeX = sizeY = size.
"""
function _calculateWeights(weights::Matrix{Float64}, trainingPatterns::Vector{Matrix{Float64}}, size::Int64)
    for pattern in trainingPatterns
       weights += (vec(pattern) * vec(pattern)')
    end
    weights /= size
    weights[diagind(weights)] .= 0.0
    return weights
end


"""matchPattern
"""
function matchPattern(pattern::Matrix{Float64}, weights::Matrix{Float64}, patternSize::Int64)
    output = zeros(patternSize, patternSize)
    for row_i in range(1, patternSize)
        for col_i in range(1, patternSize)
            output[row_i,col_i] = ((vec(pattern)' * weights[row_i,:]) * pattern[row_i,col_i]) > 0 ? 1 : -1 
        end
    end
    return output
end

end # module