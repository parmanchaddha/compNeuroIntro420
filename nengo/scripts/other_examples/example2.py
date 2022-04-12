import nengo

model = nengo.Network()
with model:
    
    velocity = nengo.Ensemble(n_neurons=2000, dimensions=2, radius=2)
    stim_v = nengo.Node([0,0])
    nengo.Connection(stim_v, velocity)
    
    position = nengo.Ensemble(n_neurons=2000, dimensions=2, radius=2)
    
    tau = 0.1
    
    def v2p(v):
        return tau*v
    nengo.Connection(velocity, position, function=v2p, synapse=tau)

    def p2p(p):
        return p
    nengo.Connection(position, position, function=p2p, synapse=tau)