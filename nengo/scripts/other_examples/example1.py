import nengo

model = nengo.Network()
with model:
    a = nengo.Ensemble(n_neurons=100, dimensions=2, radius=1.5,
                       #neuron_type=nengo.Sigmoid(),
                       )
    
    stim = nengo.Node([0,0])
    nengo.Connection(stim, a)
    
    output = nengo.Node(size_in=1)
    
    inputs = [[1,1], [1,-1], [-1, 1], [-1,-1]]
    outputs = [[1], [-1], [-1], [1]]
    
    def multiply(x):
        return x[0]*x[1]

    #nengo.Connection(a, output, eval_points=inputs, function=outputs)
    nengo.Connection(a, output, function=multiply)