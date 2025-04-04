## Neural Network


Neural networks are made up objects called "layers" and "neurons" and these things connect to each other in a specific way. Each layer has some number of neurons. For example, the first layer might have 10 neurons, the second might have 15, and so on. The number of layers and the number of neurons in each layer is a "hyperparameter", the user picks how many of each. Let's take a look at a single neuron.

$$
v_3^{(1)} = g(\boldsymbol{w}_3^{(1)}\boldsymbol{x} + b_3^{(1)})
$$


- The LHS, $v_3^{(1)}$, will be the output. The superscript $(1)$ refers to the layer number; the subscript $3$ refers to the neuron.

    An output here means just a single number. If we have say 15 neurons (subscript) for this first layer (superscript), then we will have 15 numbers come out of this first layer: $\boldsymbol{v^{(1)}} = \{v^{(1)}_{1}, v^{(1)}_{1}, ..., v^{(1)}_{15}\}$ where the bolded $v$ means a vector.

- $\boldsymbol{x}$ is our input vector.
- $\boldsymbol{w}$ is the weight/coefficient vector.
- $b$ is a bias or the intercept term, shifting the value of $\boldsymbol{w}\cdot\boldsymbol{x}$ up or down.
- $g$ refers to a "non-linear" function, often called as the "activation function".
