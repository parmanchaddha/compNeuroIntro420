from typing import Dict
import numpy as np
import nengo
from nengo.processes import Piecewise
import matplotlib.pyplot as plt
from math import sin
import json
import argparse

parser = argparse.ArgumentParser(description='Script Arguments')
parser.add_argument("--runtime", type=float, default=24)

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

INITIAL_CONDITIONS: Dict[str, float] = {
    "P0": 0.5,
    "P1": 0.5,
    "P2": 0.5,
    "Pn": 0.8,
    "mrna": 0.5
}

def create_model():
    model = nengo.Network()
    with model:
        radius = 10
        n_neurons = 500
        mrna = nengo.Ensemble(n_neurons=n_neurons, dimensions=1, radius=radius)
        mrna_deriv = nengo.Ensemble(n_neurons=n_neurons, dimensions=1, radius=radius)

        p0 = nengo.Ensemble(n_neurons=n_neurons, dimensions=1, radius=radius)
        p0_deriv = nengo.Ensemble(n_neurons=n_neurons, dimensions=1, radius=radius)
        
        p1 = nengo.Ensemble(n_neurons=n_neurons, dimensions=1, radius=radius)
        p1_deriv = nengo.Ensemble(n_neurons=n_neurons, dimensions=1, radius=radius)

        p2 = nengo.Ensemble(n_neurons=n_neurons, dimensions=1, radius=radius)
        p2_deriv = nengo.Ensemble(n_neurons=n_neurons, dimensions=1, radius=radius)
        
        pn = nengo.Ensemble(n_neurons=n_neurons, dimensions=1, radius=radius)
        pn_deriv = nengo.Ensemble(n_neurons=n_neurons, dimensions=1, radius=radius)

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

        tao = 0.10
        deriv_tao = 1.0
        # Connect all the derivatives with themselves and a synapse
        def connect_pn(x):
            return deriv_tao*x
        nengo.Connection(pn_deriv, pn, function=connect_pn)
        def connect_p0(x):
            return deriv_tao*x
        nengo.Connection(p0_deriv, p0, function=connect_p0)
        def connect_p1(x):
            return deriv_tao*x
        nengo.Connection(p1_deriv, p1, function=connect_p1)
        def connect_p2(x):
            return deriv_tao*x
        nengo.Connection(p2_deriv, p2, function=connect_p2)
        def connect_mrna(x):
            return deriv_tao*x
        nengo.Connection(mrna_deriv, mrna, function=connect_mrna)

        # Make all inputs
        input_p0 = nengo.Node(Piecewise({0: [INITIAL_CONDITIONS['P0']], tao: [0]}))
        nengo.Connection(input_p0, p0, synapse=tao)
        
        input_p1 = nengo.Node(Piecewise({0: [INITIAL_CONDITIONS['P1']], tao: [0]}))
        nengo.Connection(input_p1, p1, synapse=tao)
        
        input_p2 = nengo.Node(Piecewise({0: [INITIAL_CONDITIONS['P2']], tao: [0]}))
        nengo.Connection(input_p2, p2, synapse=tao)

        input_pn = nengo.Node(Piecewise({0: [INITIAL_CONDITIONS['Pn']], tao: [0]}))
        nengo.Connection(input_pn, pn, synapse=tao)

        input_mrna = nengo.Node(Piecewise({0: [INITIAL_CONDITIONS['mrna']], tao: [0]}))
        nengo.Connection(input_mrna, mrna, synapse=tao)

        # Probes
        probes = {
            "mrna_probe": nengo.Probe(mrna),
            "p0_probe": nengo.Probe(p0),
            "p1_probe": nengo.Probe(p1),
            "p2_probe": nengo.Probe(p2),
            "pn_probe": nengo.Probe(pn)
        }
    return model, probes


def run_simulation(model, probes, runtime=24):
    with nengo.Simulator(model) as sim:  # Create the simulator
        sim.run(runtime)
        plot_results(sim, probes, sim_time=runtime)


def moving_average(a,n):
    a = a.reshape(1, a.size)[0]
    N=len(a)
    return np.array([np.mean(a[i:i+n]) for i in np.arange(0,N-n+1)])


def plot_results(sim, probes: dict, sim_time = 100):
    with  open('last_used.json', 'r') as file:
        iter = json.load(file)['act-iter']
    
    # Time Graph
    for i in ["mrna_probe", "p0_probe", "p1_probe", "p2_probe", "pn_probe"]:
        averaged = moving_average(sim.data[probes[i]], 9)
        # averaged = averaged[0]
        averaged = np.pad(averaged, (4, 4), 'constant')
        label_name = i.split("_")[0]
        plt.figure(figsize=(8,6))
        # plt.plot(sim.trange(), sim.data[probes[i]])
        plt.plot(sim.trange(), averaged)
        plt.xlabel("Time (hr)")
        plt.ylabel(label_name)
        plt.title(f"Time (hr) versus {label_name} concentration")
        plt.savefig(f"plots/iteration{iter}_{label_name}_{sim_time}hr.png")
        plt.show()

    plt.figure(figsize=(8,6))
    plt.scatter(sim.data[probes['pn_probe']], sim.data[probes["mrna_probe"]])
    plt.xlabel("PER Concetration")
    plt.ylabel("PER mRNA Concentration")
    plt.title(f"PER Concentration versus PER mRNA Concentration")
    plt.savefig(f"plots/iteration{iter}_per_vs_mrna.png")
    plt.show()

    with  open('last_used.json', 'w') as file:
        json.dump({'act-iter': iter+1}, file)


if __name__ == "__main__":
    args = parser.parse_args()
    runtime = args.runtime

    model, probes = create_model()
    run_simulation(model, probes, runtime=runtime)
