import nengo
import matplotlib.pyplot as plt
from math import sin
import json

def create_model():
    """ Create a mock model of the circadian rhythm.
    Returns the model, and probes of the model.
    """
    model = nengo.Network()
    with model:
        # Create the pn, mrna ensemble of neurons.
        pn = nengo.Ensemble(n_neurons=2000, dimensions=1, radius=2) 
        mrna = nengo.Ensemble(n_neurons=2000, dimensions=1, radius=2)
        
        # Create a sinusodial input for the pn ensemble, and connect the stimulus to the ensemble.
        pn_input= nengo.Node(lambda t: sin(t) + 1)
        nengo.Connection(pn_input, pn)

        # Connect the `pn` ensemble to the `mrna` ensemble.
        def pn_to_mrna(v):
            return 0.5 * (1 / (1 + v))
        nengo.Connection(pn, mrna, function=pn_to_mrna, synapse=0.5)

        # Connect the `mrna` nucleus to itself. This is basic integrator architecture.
        def mrna_integrator(c):
            return -0.5 * (c / (1 + c))
        nengo.Connection(mrna, mrna, function=mrna_integrator, synapse=0.5)

        # Create two probes to measure the nucleur-PER concentration and PER MRNA concentration.
        pn_probe = nengo.Probe(pn)
        mrna_probe = nengo.Probe(mrna)
        return model, {
            "pn_probe": pn_probe,
            "mrna_probe": mrna_probe
        }


def run_simulation(model, probes):
    with nengo.Simulator(model) as sim:  # Create the simulator
        sim_time = 2
        sim.run(sim_time) # Run it for 1 second
        plot_results(sim, probes, sim_time=sim_time)


def plot_results(sim, probes: dict, sim_time = 100):
    with  open('last_used.json', 'r') as file:
        iter = json.load(file)['iter']

    # Time Graph
    plt.figure(figsize=(8,6))
    plt.plot(sim.trange(), sim.data[probes["mrna_probe"]]) 
    plt.xlabel("Time (s)")
    plt.ylabel("PER mRNA Concentration")
    plt.title(f"Time versus PER mRNA Concentration simulated for {sim_time} seconds")
    # plt.savefig(f"mock_output_{iter}_{sim_time}s_time.png")
    plt.show()

    # Concentration
    plt.figure(figsize=(8,6))
    plt.plot(sim.data[probes['pn_probe']], sim.data[probes["mrna_probe"]])
    plt.xlabel("Nuclear PER Concetration")
    plt.ylabel("PER mRNA Concentration")
    plt.title(f"Nuclear PER Concentration versus PER mRNA Concentration")
    # plt.savefig(f"mock_output_{iter}_{sim_time}s_concentration.png")
    plt.show()

    with  open('last_used.json', 'w') as file:
        json.dump({'iter': iter+1}, file)


if __name__ == "__main__":
    model, probes = create_model()
    run_simulation(model, probes)