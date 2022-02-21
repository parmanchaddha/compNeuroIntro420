"CreateData.jl

Create some linearly separable data to use for the perceptron. Depending on the
number of desired dimensions, creates and assigns data using:
    1D:
    Output = (ax + C0) > 0 ? 1 : 0

    2D:
    Output = (ax +by + C0) > 0 ? 1 : 0

    3D:
    Output = (ax +by + cz + C0) > 0 ? 1 : 0

    and so on...

Uses a random number seed for each function for replicability. 
"
module CreateData

using Random
using DataFrames
using CSV

savepath = @__DIR__;
filename1D = "data1D.csv";
filename2D = "data2D.csv";
filename3D = "data3D.csv";


function createEquationConstants(dims::Int64)
    # Set the seed. This seed needs to be set before every call!
    Random.seed!(1234 + dims)
    # Generate the random numbers.
    constants = rand(-0.5:0.01:0.5, dims)
    println(constants)
    return constants
end


"createData1D
Create some linearly separable data in the first dimension (i.e. only x values)
[0.43, -0.02]
"
function createData1D()
    equationConstants = createEquationConstants(2)
    xvals = rand(-100:0.01:100, 500);
    classifications = [(equationConstants[2]*x + equationConstants[1]) > 0 ? 1 : -1 for x in xvals];
    df = DataFrame(
        classification=classifications,
        x1=xvals
    );
    CSV.write(joinpath(savepath, filename1D), df);
end

"createData2D
Create some linearly separable data in the second dimension (i.e. x and y values)
[0.34, 0.48, 0.05]
"
function createData2D()
    equationConstants = createEquationConstants(3)
    xvals = rand(-100:0.01:100, 500);
    yvals = rand(-100:0.01:100, 500)
    classifications = [(
        (equationConstants[3]*y + equationConstants[2]*x + equationConstants[1]) > 0
        ) ? 1 : -1
        for (x,y) in zip(xvals,yvals)
    ]

    df = DataFrame(
        classification=classifications,
        x1=xvals,
        x2=yvals
    )

    CSV.write(joinpath(savepath, filename2D), df)
end

"createData3D
Create some linearly separable data in the third dimension (x,y,z).
[0.42, 0.07, -0.04, 0.06]
"
function createData3D()
    equationConstants = createEquationConstants(4)
    xvals = rand(-100:0.01:100, 500);
    yvals = rand(-100:0.01:100, length(xvals))
    zvals = rand(-100:0.01:100, length(xvals))

    classifications = [(
        equationConstants[4]*z
        + equationConstants[3]*y
        + equationConstants[2]*x
        + equationConstants[1] > 0
        ) ? 1 : -1
        for (x,y,z) in zip(xvals,yvals,zvals)
    ]

    df = DataFrame(
        classification=classifications,
        x1=xvals,
        x2=yvals,
        x3=zvals
    )

    CSV.write(joinpath(savepath, filename3D), df)
end

end