from typing import Dict
import nengo
from nengo.processes import Piecewise
import matplotlib.pyplot as plt
from math import sin
import json

EQUATION_VARS: Dict[str, float] = {
    "vs": 0.76, # nm/h,
    "vm": 0.65, # nm/h,
    "km": 0.5, # nm ,
    "ks": 0.38, #/hr,
    "vd": 0.95, #nM/hr,
    "k1_rate": 1.9, # /hr
    "k2_rate": 1.3, # /hr
    "KT": 1,
    "KD": 0.2,
    "K1": 2, #nM
    "K2": 2,
    "K3": 2,
    "K4": 2,
    "Km": 0.5, # nm ,
    "V1": 3.2,
    "V2": 1.58,
    "V3": 5,
    "V4": 2.5,
    "n": 4,
}

model = nengo.Network()
with model:
    
    mrna = nengo.Ensemble(n_neurons=1000, dimensions=1, radius=5)
    mrna_deriv = nengo.Ensemble(n_neurons=1000, dimensions=1, radius=5)

    p0 = nengo.Ensemble(n_neurons=1000, dimensions=1, radius=5)
    p0_deriv = nengo.Ensemble(n_neurons=1000, dimensions=1, radius=5)
    
    p1 = nengo.Ensemble(n_neurons=1000, dimensions=1, radius=5)
    p1_deriv = nengo.Ensemble(n_neurons=1000, dimensions=1, radius=5)

    p2 = nengo.Ensemble(n_neurons=1000, dimensions=1, radius=5)
    p2_deriv = nengo.Ensemble(n_neurons=1000, dimensions=1, radius=5)
    
    pn = nengo.Ensemble(n_neurons=1000, dimensions=1, radius=5)
    pn_deriv = nengo.Ensemble(n_neurons=1000, dimensions=1, radius=5)

    # Connections to P0_deriv
    def connect_m_to_p0(x):
        return EQUATION_VARS['ks'] * x[0]
    nengo.Connection(mrna, p0_deriv, function=connect_m_to_p0)
    def connect_p0_to_p0_deriv(x):
        return -1 * EQUATION_VARS['V1'] * x[0] / (EQUATION_VARS['K1'] + x[0])
    nengo.Connection(p0, p0_deriv, function=connect_p0_to_p0_deriv)
    def connect_p1_to_p0(x):
        return EQUATION_VARS['V2'] * x[0] / (EQUATION_VARS['K2'] + x[0])
    nengo.Connection(p1, p0_deriv, function=connect_p1_to_p0)


    # Connections to P1_deriv
    def connect_p0_to_p1(x):
        return EQUATION_VARS['V1'] * x[0] / (EQUATION_VARS['K1'] + x[0])
    nengo.Connection(p0, p1_deriv, function=connect_p0_to_p1)
    def connect_p1_to_p1_deriv(x):
        return (
            -1 * EQUATION_VARS['V2'] * x[0] / (EQUATION_VARS['K2'] + x[0])
            -1 * EQUATION_VARS['V3'] * x[0] / (EQUATION_VARS['K3'] + x[0])
        )
    nengo.Connection(p1, p1_deriv, function=connect_p1_to_p1_deriv)
    def connect_p2_to_p1(x):
        return -1 * EQUATION_VARS['V4'] * x[0] / (EQUATION_VARS['K4'] + x[0])
    nengo.Connection(p2, p1_deriv, function=connect_p2_to_p1)


    # Connections to P2_deriv
    def connect_p1_to_p2(x):
        return EQUATION_VARS['V3'] * x[0] / (EQUATION_VARS['K3'] + x[0])
    nengo.Connection(p1, p2_deriv, function=connect_p1_to_p2)
    def connect_p2_to_p2_deriv(x):
        return (
            -1 * EQUATION_VARS['V4'] * x[0] / (EQUATION_VARS['K4'] + x[0])
            -1 * EQUATION_VARS['k1_rate'] * x[0]
            -1 * EQUATION_VARS['vd'] * x[0] / (EQUATION_VARS['KD'] + x[0])
        )
    nengo.Connection(p2, p2_deriv,function=connect_p2_to_p2_deriv)
    def connect_pn_to_p2(x):
        return EQUATION_VARS['k2_rate'] * x[0]
    nengo.Connection(pn, p2_deriv, function=connect_pn_to_p2)

    # Connections to PN_deriv
    def connect_p2_to_pn(x):
        return EQUATION_VARS['k1_rate'] * x[0]
    nengo.Connection(p2, pn_deriv, function=connect_p2_to_pn)
    def connect_pn_to_pn_deriv(x):
        return -1* EQUATION_VARS['k2_rate'] * x[0]
    nengo.Connection(pn, pn_deriv, function=connect_pn_to_pn_deriv)

    # Connections to mrna_deriv
    def connect_pn_to_m(x):
        return (
            EQUATION_VARS['vs']
            * (EQUATION_VARS['KT'] ** EQUATION_VARS['n'] )
            / (
                (EQUATION_VARS['KT'] ** EQUATION_VARS['n'])
                + (x[0] ** EQUATION_VARS['n'])
            )
        )
    nengo.Connection(pn, mrna_deriv, function=connect_pn_to_m)
    def connect_mrna_to_mrna_deriv(x):
        return -1* EQUATION_VARS['vm'] * x[0] / (x[0] + EQUATION_VARS['km']) 
    nengo.Connection(mrna, mrna_deriv, function=connect_mrna_to_mrna_deriv)

    tao = 0.01

    # Connect all the derivatives with themselves and a synapse
    def connect_pn(x):
        return tao*x
    nengo.Connection(pn_deriv, pn, function=connect_pn, synapse=tao)
    def connect_p0(x):
        return tao*x
    nengo.Connection(p0_deriv, p0, function=connect_p0, synapse=tao)
    def connect_p1(x):
        return tao*x
    nengo.Connection(p1_deriv, p1, function=connect_p1, synapse=tao)
    def connect_p2(x):
        return tao*x
    nengo.Connection(p2_deriv, p2, function=connect_p2, synapse=tao)
    def connect_mrna(x):
        return tao*x
    nengo.Connection(mrna_deriv, mrna, function=connect_mrna, synapse=tao)

    # Make all inputs
    input_p0 = nengo.Node(Piecewise({0: [0.2], 0.01: [0]}))
    nengo.Connection(input_p0, p0, synapse=tao)
    
    input_p1 = nengo.Node(Piecewise({0: [0.2], 0.01: [0]}))
    nengo.Connection(input_p1, p1, synapse=tao)
    
    input_p2 = nengo.Node(Piecewise({0: [0.2], 0.01: [0]}))
    nengo.Connection(input_p2, p2, synapse=tao)

    input_pn = nengo.Node(Piecewise({0: [0.5], 0.01: [0]}))
    nengo.Connection(input_pn, pn, synapse=tao)

    input_mrna = nengo.Node(Piecewise({0: [0.5], 0.01: [0]}))
    nengo.Connection(input_mrna, mrna, synapse=tao)

    # Probes
    probes = {
        "mrna_probe": nengo.Probe(mrna),
        "p0_probe": nengo.Probe(p0),
        "p1_probe": nengo.Probe(p1),
        "p2_probe": nengo.Probe(p2),
        "pn_probe": nengo.Probe(pn)
    }