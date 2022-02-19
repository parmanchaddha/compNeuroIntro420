"""HodgkinHuxley
Implements the Hodgkin Huxley model.

Public Methods:
    Neuron (struct): A neuron structure with proper attributes.
    initializeNeuron (function): Initializes and returns a Neuron object.
    runHodgkinHuxley (function): Simulates a HodgkinHuxley spiking neuron. 
    plotHodgkinHuxley (function): Plots the results of the spiking HodgkinHuxley neuron.

Although other private functions are also accessible, users are encouraged to
use only the above public methods.
"""
module HodgkinHuxley

using Plots

export Neuron, initializeNeuron, runHodgkinHuxley, plotHodgkinHuxley
"""Neuron
A structure to contain the data incorporated in a neuron.
"""
struct Neuron
    voltages::Vector{Float64}
    times::Vector{Float64}
    deltaT::Float64
    injectionCurrent::Float64
    startTime::Float64
    stopTime::Float64
    cap::Float64
    m::Vector{Float64}
    n::Vector{Float64}
    h::Vector{Float64}
    currents::Vector{Float64}
end

chanenlConfigs = Dict(
    "eNa" => 115.,
    "gNa" => 120.,
    "eK" => -12.,
    "gK" => 36.,
    "eL" => 10.6, 
    "gL" => 0.3
)


"""initializeNeuron
Initializer function that interfaces and returns the Neuron structure. 
"""
function initializeNeuron(;
    deltaT::Float64 = 0.01,
    initialVoltage::Float64 = 0.,
    initialTime::Float64 = 0.,
    startTime::Float64 = 10.0,
    stopTime::Float64 = 150.0,
    injectionCurrent::Float64=50.0,
    cap::Float64=1.0,
)
    voltages = [initialVoltage]
    times = [initialTime]
    m = [m_infinity(initialVoltage)]
    n = [n_infinity(initialVoltage)]
    h = [h_infinity(initialVoltage)]
    currents=[_determineCurrent(initialTime, stopTime, startTime, injectionCurrent)]
    neuron = Neuron(
        voltages,
        times,
        deltaT,
        injectionCurrent,
        startTime,
        stopTime,
        cap,
        m,
        n,
        h,
        currents
    )
    return neuron
end


"""runHodgkinHuxley
Requires a `Neuron` object to fill.
A runTime should be specified as well.
"""
function runHodgkinHuxley(neuron::Neuron, runTime::Float64)
    currentTime =neuron.times[end]
    while currentTime < runTime

        currentTime += neuron.deltaT
        push!(neuron.times, currentTime)

        # Determine and update the current Current.
        currentCurrent = _determineCurrent(currentTime, neuron.stopTime, neuron.startTime, neuron.injectionCurrent)
        push!(neuron.currents, currentCurrent)

        # Update m,n,and h.
        _updateSubUnit(neuron, "m")
        _updateSubUnit(neuron, "h")
        _updateSubUnit(neuron, "n")

        # Calculate dvdt and update the voltage
        dvdt = _calculateDvdt(neuron)
        _updateVoltage(neuron, dvdt)
    end
end

"""plotHodgkinHuxley
Plots the HodgkinHuxley Neuron.

Requires a `Neuron` object.
"""
function plotHodgkinHuxley(neuron::Neuron)
    plot(
        neuron.times,
        neuron.voltages,
        title="HodgkinHuxley - Voltage and Current versus Time",
        color=:red,
        label="Voltage (mV)",
        lw=3
    )
    # Add the current on the same plot and xaxis, but with a different `y` axis.
    plot!(
        neuron.times,
        neuron.currents,
        color=:blue,
        lw=3,
        label="Current (mA)"
    )

    xlabel!("Time (s)")

end



"""_determineCurrent
"""
function _determineCurrent(currentTime::Float64, stopTime::Float64, startTime::Float64, injectionCurrent::Float64)
    if (currentTime < startTime)
        return 0
    elseif (currentTime > stopTime)
        return 0
    else
        return injectionCurrent
    end
end

"""_calculateDvdt
"""
function _calculateDvdt(neuron)
    dvdt = (
        (
            neuron.currents[end]
            - (chanenlConfigs["gNa"] * (neuron.m[end]^3) * (neuron.h[end]) * (neuron.voltages[end] - chanenlConfigs["eNa"]))
            - (chanenlConfigs["gK"] * (neuron.n[end]^4) * (neuron.voltages[end] - chanenlConfigs["eK"]))
            - (chanenlConfigs["gL"] * (neuron.voltages[end] - chanenlConfigs["eL"]))
        )
        / neuron.cap
    )
    return dvdt
end



"""updateVoltage
Update the voltage value given a previous voltage value, the current value of
derivative, and a time step.
"""
function _updateVoltage(neuron::Neuron, dvdt::Float64)
    newVoltage = neuron.voltages[end] + dvdt*neuron.deltaT
    push!(neuron.voltages, newVoltage)
end

"""updateSubUnit
Update the "m", `n` or `h` subunit value in the sodium channel.
"""
function _updateSubUnit(neuron::Neuron, which::String)
    if which=="m"
        deriv = calculateDmdt(neuron)
        newM = neuron.m[end] + deriv*neuron.deltaT
        push!(neuron.m, newM)

    elseif which=="n"
        deriv = calculateDndt(neuron)
        newN = neuron.n[end] + deriv*neuron.deltaT
        push!(neuron.n, newN)

    elseif which=="h"
        deriv = calculateDhdt(neuron)
        newH = neuron.h[end] + deriv*neuron.deltaT
        push!(neuron.h, newH)

    else
        return ErrorException("The value specified for `which` should either be `m`, `n`, or `h`.")
    end
end


"""
Describe the opening and closing rates of the different gates in the various
channels as a function of voltage.
"""
function alphaM(vM::Float64)
    return (0.1 * (25 - vM))  / (exp((25 - vM)/ 10) - 1)
end
function alphaN(vM::Float64)
    return (0.01 * (10 - vM))  / (exp((10 - vM) / 10) - 1)
end
function alphaH(vM::Float64)
    return 0.07 * exp(-vM/20)
end
function betaM(vM::Float64)
    return 4 * exp(-vM / 18)
end
function betaN(vM::Float64)
    return 0.125 * exp(-vM / 80)
end
function betaH(vM::Float64)
    1 / (1 + exp((30-vM) / 10))
end

"""calculateDhdt, calculateDmdt, calculateDndt
Calculate the derivatives for the "n" channel, "m" channel, and "h" channel.
"""
function calculateDmdt(neuron::Neuron)
    vM = neuron.voltages[end]
    newAlphaM = alphaM(vM) 
    newBetaM = betaM(vM)
    return (newAlphaM * (1 - neuron.m[end])) - (newBetaM * neuron.m[end])
end
function calculateDndt(neuron::Neuron)
    vM = neuron.voltages[end]
    newAlphaN = alphaN(vM) 
    newBetaN = betaN(vM)
    return (newAlphaN *  (1 - neuron.n[end])) - (newBetaN * neuron.n[end])
end
function calculateDhdt(neuron::Neuron)
    vM = neuron.voltages[end]
    newAlphaH = alphaH(vM)
    newBetaH = betaH(vM)
    return newAlphaH *  (1 - neuron.h[end]) - (newBetaH * neuron.h[end])
end

"""
Calculate the value of the `m`,`n`, and `h` gate at infinity.
"""
function m_infinity(vM::Float64)
    return alphaM(vM) / (alphaM(vM) + betaM(vM))
end
function n_infinity(vM::Float64)
    return alphaN(vM) / (alphaN(vM) + betaN(vM))
end
function h_infinity(vM::Float64)
    return alphaH(vM) / (alphaH(vM) + betaH(vM))
end


end
