using Test
using LinearAlgebra
using DataFrames
include("/Users/pchaddha/OneDrive - University of Waterloo/Waterloo - 4B/psych_420_intro_to_computational_neuroscience/compNeuroIntro420/juliapsych420/assignment7/perceptron.jl")


dataSet1 = Dict(
    "labels" => [0 1],
    "inputs" => [1. 2.; 3. 4.]
)
dataSet1Params = Dict(
    "numInputs" => 2,
    "learningRate" => 0.5,
    "weights" => [0.2, 0.2],
    "bias" => -1.,
    "biasWeight" => 0.2,
    "output"=>[0.4, 1.2],
    "newWeights" => [
        [0, -0.2, 0.4],
        [3.3, 4.2, -0.7],
    ]
)

function isclose(x::Float64,y::Float64)
    return isapprox(x,y,atol=1.e-3)
end

function TestPerceptron()
    p1 = Perceptron.initalizeNeuron(
        dataSet1Params["numInputs"],
        learningRate=dataSet1Params["learningRate"],
        bias=dataSet1Params["bias"],
        biasWeight=dataSet1Params["biasWeight"]
    )
    p1.weights = dataSet1Params["weights"]
    return p1
end


# Ensure that the Perceptron structure is being initialized properly.
@testset "perceptron_initialization" begin
    p1 = TestPerceptron();
    @test isclose(p1.bias,dataSet1Params["bias"])
    @test p1.weights == dataSet1Params["weights"]
    @test isclose(p1.biasWeight, dataSet1Params["biasWeight"])
end;


# Ensure that the calculateOutput function works correctly.
@testset "perceptron_calculateOutput" begin
    p1 = TestPerceptron();
    for dp_i in range(1, 2)
        target = dataSet1["labels"][dp_i]
        datapoint = dataSet1["inputs"][dp_i,:]
        output = Perceptron.calculateOutput(p1, datapoint)
        @test isclose(output, dataSet1Params["output"][dp_i])
    end
end


# Ensure that the weights are updated appropriately.
@testset "perceptron_updateWeights" begin
    p1 = TestPerceptron();
    for dp_i in range(1, 2)
        target = dataSet1["labels"][dp_i]
        datapoint = dataSet1["inputs"][dp_i,:]
        output = Perceptron.calculateOutput(p1, datapoint)
        Perceptron.updateWeights(p1, output, target, datapoint)

        for weight_i in range(1, 2)
            @test isclose(
                p1.weights[weight_i],
                dataSet1Params["newWeights"][dp_i][weight_i]
            )
        @test isclose(p1.biasWeight, dataSet1Params["newWeights"][dp_i][3])
        end
    end
end
