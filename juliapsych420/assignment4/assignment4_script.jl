include("integrate_and_fire.jl")

using .IntegrateAndFire

function run()
    deltaT = 0.05 # every 100 ms
    startTime = 0. # seconds
    injectionStartTime = 1. 
    injectionEndTime = 6.
    capacitor = 1.
    resistor = 2.
    threshold = 3.
    spikeValue = 8.
    injectionCurrent = 4.3
    initialVoltage = 0.


    iAndF = initializeIntegrateAndFire(deltaT, startTime, injectionStartTime,
        injectionEndTime, capacitor, resistor, threshold, spikeValue,
        injectionCurrent, initialVoltage
    )

    runTime = 10.0

    fire(iAndF, runTime)

    plotIandF(iAndF, "voltage")
    plotIandF(iAndF, "current")

end