using Test
include("/Users/pchaddha/OneDrive - University of Waterloo/Waterloo - 4B/psych_420_intro_to_computational_neuroscience/compNeuroIntro420/juliapsych420/assignment9/hopfieldNetwork.jl")
using LinearAlgebra

function isclose(x,y)
    return isapprox(x,y,atol=1.e-2)
end

pattern1 = [1. 1. 1.; 1. 1. 1.; -1. -1. -1.]
pattern2 = [1. 1. 1.; -1. -1. -1.; 1. 1. 1.]
pattern3 = [-1. -1. -1; 1. 1. 1.; 1. 1. 1.]
patternSize = 3
weightSize = patternSize ^ 2
trainingPatterns = [
    pattern1,
    pattern2,
    pattern3,
]
third = 1/3
initialWeights = zeros(weightSize, weightSize)
after1IterationWeights = [0.0 -third -third 1.0 -third -third 1.0 -third -third;
    -third 0.0 -third -third 1.0 -third -third 1.0 -third;
    -third -third 0.0 -third -third 1.0 -third -third 1.0;
    1.0 -third -third 0.0 -third -third 1.0 -third -third;
    -third 1.0 -third -third 0.0 -third -third 1.0 -third;
    -third -third 1.0 -third -third 0.0 -third -third 1.0;
    1.0 -third -third 1.0 -third -third 0.0 -third -third;
    -third 1.0 -third -third 1.0 -third -third 0.0 -third;
    -third -third 1.0 -third -third 1.0 -third -third 0.0
]
finalWeights = [0.0 -0.4999999999840668 -0.4999999999840668 1.4999999999522007 -0.4999999999840668 -0.4999999999840668 1.4999999999522007 -0.4999999999840668 -0.4999999999840668; -0.4999999999840668 0.0 -0.49999999998406697 -0.4999999999840668 1.4999999999522007 -0.49999999998406697 -0.4999999999840668 1.4999999999522007 -0.49999999998406697; -0.4999999999840668 -0.49999999998406697 0.0 -0.4999999999840668 -0.49999999998406697 1.4999999999522007 -0.4999999999840668 -0.49999999998406697 1.4999999999522007; 1.4999999999522007 -0.4999999999840668 -0.4999999999840668 0.0 -0.4999999999840668 -0.4999999999840668 1.4999999999522007 -0.4999999999840668 -0.4999999999840668; -0.4999999999840668 1.4999999999522007 -0.49999999998406697 -0.4999999999840668 0.0 -0.49999999998406697 -0.4999999999840668 1.4999999999522007 -0.49999999998406697; -0.4999999999840668 -0.49999999998406697 1.4999999999522007 -0.4999999999840668 -0.49999999998406697 0.0 -0.4999999999840668 -0.49999999998406697 1.4999999999522007; 1.4999999999522007 -0.4999999999840668 -0.4999999999840668 1.4999999999522007 -0.4999999999840668 -0.4999999999840668 0.0 -0.4999999999840668 -0.4999999999840668; -0.4999999999840668 1.4999999999522007 -0.49999999998406697 -0.4999999999840668 1.4999999999522007 -0.49999999998406697 -0.4999999999840668 0.0 -0.49999999998406697; -0.4999999999840668 -0.49999999998406697 1.4999999999522007 -0.4999999999840668 -0.49999999998406697 1.4999999999522007 -0.4999999999840668 -0.49999999998406697 0.0]

# Ensure that the weight updation happens properly for each iterations.
@testset "calculate_weights" begin
    weights = Hopfield._calculateWeights(initialWeights, trainingPatterns, patternSize)
    @test isclose(weights, after1IterationWeights)
end

# #Test to see if a pattern is accurately matched once the weights are finalized.
# @testset "match_pattern" begin
#     output = Hopfield.matchPattern(pattern2, finalWeights, patternSize)
#     print(output)
#     @test isclose(pattern2, output)
# end

# Ensure that weights are iteratively updated until all the training patterns are memorized.
@testset "memorize" begin
    weights = Hopfield._memorize(trainingPatterns, patternSize)
    println("finality")
    @test false
end