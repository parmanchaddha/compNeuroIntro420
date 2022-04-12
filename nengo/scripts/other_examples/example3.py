import nengo

model = nengo.Network()
with model:
    
    food = nengo.Ensemble(n_neurons=200, dimensions=2)
    stim_food = nengo.Node([0,0])
    nengo.Connection(stim_food, food)
    
    brightness = nengo.Ensemble(n_neurons=100, dimensions=1)
    stim_bright = nengo.Node([0])
    nengo.Connection(stim_bright, brightness)
    
    
    
    velocity = nengo.Ensemble(n_neurons=2000, dimensions=2, radius=2)
    
    
    #nengo.Connection(food, velocity)
    
    do_food = nengo.Ensemble(n_neurons=500, dimensions=3, radius=1.5)
    def food_func(x):
        food_x, food_y, bright = x
        if bright < 0:
            return food_x, food_y
        else:
            return 0, 0
    nengo.Connection(do_food, velocity, function=food_func)
    
    def func1(x):
        return x[0],x[1], 0
    nengo.Connection(food, do_food, function=func1)
    def func2(x):
        return 0, 0, x[0]
    nengo.Connection(brightness, do_food, function=func2)
    
    
    
    do_home = nengo.Ensemble(n_neurons=500, dimensions=3, radius=1.5)
    def home_func(x):
        home_x, home_y, bright = x
        if bright > 0:
            return -home_x, -home_y
        else:
            return 0, 0
    nengo.Connection(do_home, velocity, function=home_func)
    
    position = nengo.Ensemble(n_neurons=2000, dimensions=2, radius=2)
    
    def func1(x):
        return x[0],x[1], 0
    nengo.Connection(position, do_home, function=func1)
    def func2(x):
        return 0, 0, x[0]
    nengo.Connection(brightness, do_home, function=func2)
    
    
    
    
    
    
    

    
    
    tau = 0.1
    
    def v2p(v):
        return tau*v
    
    #v = nengo.Node(size_in=2)

    nengo.Connection(velocity, position, function=v2p, synapse=tau)

    #nengo.Connection(velocity, v, function=v2p)
    #nengo.Connection(v, position, synapse=tau)
    
    def p2p(p):
        return p
    nengo.Connection(position, position, function=p2p, synapse=tau)
    
    