### A Pluto.jl notebook ###
# v0.17.5

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 9adb63cd-b778-472c-9535-e6da7b2fd07e
begin
	import Pkg

	# The `activate` function activates my base julia environment. Enter the path of YOUR environment to get this to work.
	# Alternatively, clone the github repo to get an exact clone of the environment as specified in `project.toml`.
	# https://github.com/parmanchaddha/compNeuroIntro420/tree/lisp/juliapsych420
	Pkg.activate("/Users/pchaddha/OneDrive - University of Waterloo/Waterloo - 4B/psych_420_intro_to_computational_neuroscience/compNeuroIntro420/juliapsych420")
	using PlutoUI
end

# ╔═╡ 267dee63-be80-4b5b-b761-88dab9c47445
# Include the `hodgkin_huxley.jl` file in the same directory as this notebook! 
include(joinpath(@__DIR__, "hodgkin_huxley.jl"))

# ╔═╡ 13990de4-16fd-47f8-accd-91678397b884
md"
# Assignment 5 - Hodgkin Huxley

## Meta
Author: Parmandeep Chaddha.

Date: Feb 18, 2022.  

## Objective
Implement the Hodgkin Huxley model of the Neuron, and evaluate respone based on different input characteristics.

## Requirements
Requires a Julia environment with the following packages:
1. `Plots`.
2. `PlutoUI`.
It is recommended that you set up a Julia environment as specified in the `project.toml` on my GIT: [Git Hub] (https://github.com/parmanchaddha/compNeuroIntro420/blob/lisp/juliapsych420/Project.toml)  
"

# ╔═╡ 23f22d20-7fca-4645-ad34-9ca8a3d22f5f
md"Include the `hodgkin_huxley.jl` file in the same directory as this notebook!"

# ╔═╡ 8c8ce0ff-2c33-47f6-a7bb-01c8802d7141
md"
## Test Case 1
Basic test case, with most values matching the HH notebook. 
"

# ╔═╡ ae0fc4cc-4da6-4ab9-8ff4-a1a3d0dee756
begin
	function testCase1()
		neuron = HodgkinHuxley.initializeNeuron()
		runTime = 250.0
		HodgkinHuxley.runHodgkinHuxley(neuron, runTime)
		HodgkinHuxley.plotHodgkinHuxley(neuron)		
	end
	testCase1()
end

# ╔═╡ 8aba2d7e-4372-400f-a1ef-f41fd5e74c3c
md"
## Test Case 2
Interactive test case using PlutoUI. Feel free to play with the numbers below and watch the plot change.
"

# ╔═╡ ee7aa285-cd4c-485e-be69-72427d39a9ca
md"""
The injection current is: $(@bind injectionCurrent Slider(1.:100., default=50)). 

The delta_time is $(@bind deltaT NumberField(0.01:0.01:0.2, default=0.01)).

The initialVoltage is $(@bind initialVoltage NumberField(0.:30.,0.)).

The current start time is $(@bind currentStartTime NumberField(1.:100.,10.0)).

The current stop time is $(@bind currentStopTime NumberField(10.:1000., 150.0)).

The capacitor value is $(@bind cap NumberField(0.5:0.5:10.0, 1.0)). Since the capacitor value is an indicater of `tao`, play with this to see the number of spikes change!

The run time of the device is $(@bind runTime NumberField(100.:1000., default=250.0)).

"""

# ╔═╡ 176004fe-7c65-4955-9c25-335999f57508
begin
	function testCase2()
		neuron = HodgkinHuxley.initializeNeuron(
			deltaT=float(deltaT),
			initialVoltage=float(initialVoltage),
			startTime=float(currentStartTime),
			stopTime=float(currentStopTime),
			injectionCurrent=float(injectionCurrent),
			cap=float(cap)
		)
		HodgkinHuxley.runHodgkinHuxley(neuron, float(runTime))
		HodgkinHuxley.plotHodgkinHuxley(neuron)
	end
	testCase2()
end

# ╔═╡ Cell order:
# ╟─13990de4-16fd-47f8-accd-91678397b884
# ╠═9adb63cd-b778-472c-9535-e6da7b2fd07e
# ╟─23f22d20-7fca-4645-ad34-9ca8a3d22f5f
# ╠═267dee63-be80-4b5b-b761-88dab9c47445
# ╟─8c8ce0ff-2c33-47f6-a7bb-01c8802d7141
# ╠═ae0fc4cc-4da6-4ab9-8ff4-a1a3d0dee756
# ╟─8aba2d7e-4372-400f-a1ef-f41fd5e74c3c
# ╟─ee7aa285-cd4c-485e-be69-72427d39a9ca
# ╟─176004fe-7c65-4955-9c25-335999f57508
