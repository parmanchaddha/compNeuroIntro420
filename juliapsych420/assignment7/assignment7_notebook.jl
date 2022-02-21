### A Pluto.jl notebook ###
# v0.17.5

using Markdown
using InteractiveUtils

# ╔═╡ ae26a81e-5aa8-4b3c-a61e-1a4ad85e036e
begin
	using Pkg

	# Change this line to the directory in which the project.toml is stored. If they are in the same directory, use the commented activation command.
	# Pkg.activate(@__DIR__)
	Pkg.activate("/Users/pchaddha/OneDrive - University of Waterloo/Waterloo - 4B/psych_420_intro_to_computational_neuroscience/compNeuroIntro420/juliapsych420")
end

# ╔═╡ d4c661c1-4c19-40fb-be20-efa51db647f6
begin
	include(joinpath(@__DIR__, "perceptron.jl"))
end

# ╔═╡ e3fef428-91d5-11ec-2e7b-5fc5b176b6b5
md"
# Assignment 7 - Perceptron

## Meta
Author: Parmandeep Chaddha.

Date: Feb 19, 2022.

## Objective
1. Demonstrate the linear separability in 2D using a Perceptron.
2. Demonstrate the linear separability in 1D using a Perceptron.
3. Demonstrate the linear separability in 3D using a Perceptron.

## Requirements
The requirements for the Perceptron module are:
1. `Random (base)`
2. `LinearAlgebra`
3. `CSV`
4. `DataFrames`
5. `Plots`

## Setup
1. An updated `project.toml` file should be downloaded from: [Git Hub Link](https://github.com/parmanchaddha/compNeuroIntro420/blob/lisp/juliapsych420/Project.toml) or the directory should be cloned.
2. Instll the project.toml file using the instructions:
	- `activate .` (in the directory where the project.toml is stored)
	- `instantiate`

"

# ╔═╡ 58d8f93f-3c7f-40e7-b401-b0145674dd16
md"
## The Perceptron

### 2D Separable Data
Separe data with 2 input dimensions.
"

# ╔═╡ 7c014550-cd03-46e1-a033-0e6fa7ace694
data = Perceptron.readSavedData()

# ╔═╡ 07ea9e43-81f4-4668-8edc-17c7a7ee80e3
begin
	p = Perceptron.initalizeNeuron(2, learningRate=1.0, bias=1.0)
	Perceptron.trainNeuron(data, p, minAccuracy=0.99, maxIterations=10);
	p
end

# ╔═╡ 2c3af68f-50a3-47c6-92cd-0d77c1616ac8
loss, accuracy = Perceptron.runEpoch(data, p, withUpdate=false)

# ╔═╡ a6fcff98-80fc-468f-b30c-e5c488af4358
Perceptron.plotClassifier(data, p)

# ╔═╡ 259c61a0-3ebf-4bcc-a810-8c797c64de63
md"
### 1D Separable Data
Let's see if the perceptron can work with 1D separable data.
"

# ╔═╡ 39def073-0953-4062-9d04-5dd8a9523030
data1d = Perceptron.readSavedData(which="1D")

# ╔═╡ d0a68308-8184-4cdd-a805-9eeae0caf091
begin
	p1 = Perceptron.initalizeNeuron(1, learningRate=1.0, bias=-1.0)
	Perceptron.trainNeuron(data1d, p1, minAccuracy=0.99, maxIterations=100);
	p1
end

# ╔═╡ f7c110cd-acbe-46ef-8ad1-59f6f72930cc
Perceptron.plotClassifier1D(data1d, p1)

# ╔═╡ fe01c270-0d76-44b7-9095-318a5763a324
md"
### 3D Separable Data
Let's see if the perceptron can separate data in three dimensions
"

# ╔═╡ 47d680d8-b62d-4fe5-aa89-5b03e6a84cee
data3d = Perceptron.readSavedData(which="3D")

# ╔═╡ ea49d3fd-8702-4d54-88df-799e0ffb440b
begin
	p3 = Perceptron.initalizeNeuron(1, learningRate=1.0, bias=-1.0)
	Perceptron.trainNeuron(data3d, p3, minAccuracy=0.99, maxIterations=100);
	p3
end

# ╔═╡ 8bcf66bb-0a7f-456e-a30c-1979cb3579be
md"
## Conclusion
The Perceptron is a fairly good classifier of liner data in both 1D, 2D, and 3D domains. However, depending on the `margin` of the linear classification, it may not converge at a rapid speed with `online` training. However, the accuracy in all cases is above 0.96:
1. 0.96 in 1D
2. 0.98 in 2D
3. 0.97 in 3D

These are well within acceptable range, especially for such a simple classifier.
"

# ╔═╡ Cell order:
# ╟─e3fef428-91d5-11ec-2e7b-5fc5b176b6b5
# ╠═ae26a81e-5aa8-4b3c-a61e-1a4ad85e036e
# ╠═d4c661c1-4c19-40fb-be20-efa51db647f6
# ╟─58d8f93f-3c7f-40e7-b401-b0145674dd16
# ╠═7c014550-cd03-46e1-a033-0e6fa7ace694
# ╠═07ea9e43-81f4-4668-8edc-17c7a7ee80e3
# ╠═2c3af68f-50a3-47c6-92cd-0d77c1616ac8
# ╠═a6fcff98-80fc-468f-b30c-e5c488af4358
# ╟─259c61a0-3ebf-4bcc-a810-8c797c64de63
# ╠═39def073-0953-4062-9d04-5dd8a9523030
# ╠═d0a68308-8184-4cdd-a805-9eeae0caf091
# ╠═f7c110cd-acbe-46ef-8ad1-59f6f72930cc
# ╠═fe01c270-0d76-44b7-9095-318a5763a324
# ╠═47d680d8-b62d-4fe5-aa89-5b03e6a84cee
# ╠═ea49d3fd-8702-4d54-88df-799e0ffb440b
# ╟─8bcf66bb-0a7f-456e-a30c-1979cb3579be
