module Perceptron
using Random
using LinearAlgebra
using CSV
using DataFrames
using Plots

export PerceptronNeuron, initalizeNeuron, trainNeuron, runEpoch

# An artificial neuron
mutable struct PerceptronNeuron
    bias::Float64
    biasWeight::Float64
    learningRate::Float64
    weights::Vector{Float64}
    oldWeights::Vector{Vector{Float64}}
    accuracy::Vector{Float64}
    error::Vector{Float64}
end

function initalizeNeuron(numInputs::Int64; learningRate::Float64=0.5, bias::Float64=1., biasWeight::Float64=0.1)
    weights = rand(-1:0.01:1, numInputs)
    perceptron = PerceptronNeuron(bias, biasWeight, learningRate, weights, [], [], [])
    return perceptron
end


function trainNeuron(
    data::Dict,
    neuron::PerceptronNeuron;
    minAccuracy::Float64=0.98,
    maxIterations::Int64=100,
    useAdaptiveLearning::Bool=true
)
    epochAccuracy = 0.
    epochError = 0.
    currentIterations = 0
    originalLearningRate = neuron.learningRate
    while (epochAccuracy < minAccuracy) && (currentIterations < maxIterations)
        push!(neuron.oldWeights, neuron.weights)
        if useAdaptiveLearning
            if neuron.learningRate > 1.e-3
                neuron.learningRate = originalLearningRate * exp(-1*currentIterations)
            end
        end

        epochError, epochAccuracy = runEpoch(data, neuron, withUpdate=true)
        
        push!(neuron.accuracy, epochAccuracy)
        push!(neuron.error, epochError)
        currentIterations +=1
    end
    return currentIterations
end


function runEpoch(data::Dict, neuron::PerceptronNeuron; withUpdate=true)
    numCorrect = 0.
    epochError = 0.
    numTotal = length(data["labels"])
    shuffleData(data, numTotal);
    for dp_i in range(1, numTotal)
        target = data["labels"][dp_i]
        datapoint = data["inputs"][dp_i,:]
        output = calculateOutput(neuron, datapoint)
        classified_output = classifySignum(output)

        thisError = abs(target - output);
        epochError += thisError
        if withUpdate
            updateWeights(neuron, output, target, datapoint)
        end

        if isapprox(target, classified_output, atol=1.e-2)
            numCorrect += 1
        end

    end
    epochAccuracy = numCorrect / numTotal
    return epochError, epochAccuracy
end


function updateWeights(neuron::PerceptronNeuron, output::Float64, target::Int64, dp::Vector{Float64})
    errorSignal = neuron.learningRate * (target - output)
    deltaW = (dp .* errorSignal)
    neuron.weights = neuron.weights .+ deltaW
    neuron.biasWeight +=  neuron.bias * errorSignal

    if any(neuron.weights .> 1e4)
        error("The weights are exploding: $(neuron.weights)")
    end
end


"calculateOutput
Calculate the output of the neuron given by the sum of all inputs multiplied by
the weights, and adding the bias term to it.
"
function calculateOutput(neuron::PerceptronNeuron, dp::Vector{Float64})
    return sum(dp .* neuron.weights) + neuron.bias*neuron.biasWeight
end


function classifySignum(output::Float64)
    return output > 0 ? 1 : -1
end


function readSavedData(;which::String = "2D")
    data = CSV.read("./data$(which).csv", DataFrame)
    permute_df!(data)
    inputs = Matrix(select(data, Not(:classification)))
    normalizedInputs = inputs / maximum(inputs)
    labels= data.classification
    return Dict("labels"=>labels, "inputs"=>normalizedInputs)
end


function permute_df!(df)
    df[:,:] = df[shuffle(1:size(df, 1)),:]
    return
end

function shuffleData(data::Dict, numTotal::Int64)
    shuffler = randperm(numTotal)
    data["labels"] = data["labels"][shuffler]
    data["inputs"] = data["inputs"][shuffler, :]
    return
end

function plotClassifier(data::Dict, neuron::PerceptronNeuron; which::String = "2D")
    if which == "2D"
        plotClassifier2D(data,neuron)
    elseif which == "1D"
        plotClassifier1D(data,neuron)
    end
end

function plotClassifier1D(data::Dict, neuron::PerceptronNeuron)
    minus = data["labels"] .== -1
    ones = data["labels"] .== 1

    plot(data["inputs"][minus, 1], seriestype = :scatter, title = "1D Classifiable Data", label="Minus Ones")
    plot!(data["inputs"][ones, 1], seriestype = :scatter, label="Ones")

    intercept = -1 * neuron.biasWeight * neuron.bias * neuron.weights[1]
    ys = [intercept for i in range(1,length(data["labels"]))]
	println(ys)
    plot!(ys, label="Classifier")
end

function plotClassifier2D(data,neuron)
    minus = data["labels"] .== -1
    plot(data["inputs"][minus, 1], data["inputs"][minus, 2], seriestype = :scatter, title = "2D Classifiable Data", label="Minus")
    
    ones = data["labels"] .== 1
    plot!(data["inputs"][ones, 1], data["inputs"][ones, 2], seriestype = :scatter, label="Ones")

    xs = collect(-0.3:0.01:0.3)
    slope = -neuron.weights[1]/neuron.weights[2]
    intercept = -neuron.biasWeight
    ys = [(i*slope + intercept) for i in xs]
    plot!(xs, ys, label="Classifier")
end

end