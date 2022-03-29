import numpy as np
import random as r
from typing import List, Tuple


def make_pattern_sizes(min_dims: int = 3, max_dims: int = 6) -> Tuple[int, np.ndarray]:
    """
    """
    num_patterns = r.randint(5, 10)
    pattern_size = np.repeat(r.randint(min_dims, max_dims), 2)
    return (num_patterns, pattern_size)


def make_patterns(num_patterns: int, pattern_size: int) -> List[np.ndarray]:
    """Randomly generate `n` 2D patterns with `pattern_size[0]` rows and
    `pattern_size[1]` columns for the Hopfield network.
    """
    patterns = []
    for n in range(num_patterns):
        # Generate a random array of 1s and -1s
        this_pattern = np.array([[
                np.round(r.random()) * 2 - 1
                for i in range(pattern_size[0])
            ] for j in range(pattern_size[1])
        ])
        patterns.append(this_pattern)
    return patterns


def make_weights(patterns: List[np.ndarray]) -> np.ndarray:
    pattern_size = patterns[0].size
    weights = np.zeros(shape=(pattern_size, pattern_size))
    for p in patterns:
        weights = (1.0/pattern_size) * (weights + np.outer(p,p))
    np.fill_diagonal(weights,0)
    return weights

def get_output(pattern: np.ndarray, weights: np.ndarray) -> np.ndarray:
    output = pattern.copy()
    rows = np.arange(pattern.shape[0])
    cols = np.arange(pattern.shape[1])
    num_iterations: int = 0
    while num_iterations < 100:
        r.shuffle(rows)
        r.shuffle(cols)
        last_pattern = output.copy()
        for row_i in rows:
            for col_i in cols:
                this_output = (np.reshape(output,(1,output.size)) @ weights[row_i]) * output[row_i][col_i]
                if this_output > 0:
                    output[row_i][col_i] = 1.
                else:
                    output[row_i][col_i] = -1.
        if np.array_equal(last_pattern, output):
            break
        num_iterations += 1
    print(num_iterations)
    return output
