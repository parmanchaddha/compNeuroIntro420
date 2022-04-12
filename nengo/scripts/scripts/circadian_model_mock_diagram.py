import nengo
import matplotlib.pyplot as plt
from math import sin
import json

model = nengo.Network()
with model:

    pn = nengo.Ensemble(n_neurons=2000, dimensions=1, radius=2)
    concentration = nengo.Ensemble(n_neurons=2000, dimensions=1, radius=2)
    pn_input= nengo.Node(lambda t: sin(t) + 1)
    nengo.Connection(pn_input, pn)
    
    def pn_to_concentration(v):
        return 0.5 * (1 / (1 + v))
    nengo.Connection(pn, concentration, function=pn_to_concentration, synapse=0.5)

    def concentration_integrator(c):
        return -0.5 * (c / (1 + c))
    nengo.Connection(concentration, concentration, function=concentration_integrator, synapse=0.5)

    pn_probe = nengo.Probe(pn)
    concentration_probe = nengo.Probe(concentration)