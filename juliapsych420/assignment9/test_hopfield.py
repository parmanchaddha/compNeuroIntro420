import pytest
import unittest 
import numpy as np
import random as r
import hopfield

NUM_PATTERNS = 8
PATTERN_SIZES = np.array([3, 3])
PATTERNS = [
    np.array([[-1.,1.,1.],
        [ 1.,1., -1.],
        [ 1., -1., -1.,]]),
    np.array([[ 1., -1.,  1.],
        [ 1., -1., -1.],
        [-1., -1., -1.,]]),
    np.array([[ 1., -1.,  1.],
        [-1.,  1., -1.],
        [ 1., -1.,  1.,]]),
    np.array([[ 1., -1., -1.],
        [-1.,  1., -1.],
        [ 1., -1.,  1.,]]),
    np.array([[-1., -1., -1.],
        [-1., -1.,  1.],
        [-1.,  1., -1.,]]),
    np.array([[ 1.,  1.,  1.],
        [-1., -1., -1.],
        [-1.,  1., -1.,]]),
    np.array([[-1.,  1., -1.],
        [ 1., -1., -1.],
        [-1., -1.,  1.,]]),
    np.array([[-1.,  1., -1.],
        [ 1.,  1., -1.],
        [ 1., 1., -1.,]]),
]

@pytest.fixture(scope="function")
def practice_weights():
    return np.array([
        [ 0.        , -0.12195168,  0.12496608, -0.12469475, -0.09996617,
         0.12191363, -0.09996617, -0.09756511,  0.09756474],
       [-0.12195168,  0.        , -0.12191776,  0.12225609,  0.09752752,
        -0.12496195,  0.09752752,  0.10000376, -0.10000339],
       [ 0.12496608, -0.12191776,  0.        , -0.12466083, -0.1       ,
         0.12194745, -0.1       , -0.09753128,  0.09753082],
       [-0.12469475,  0.12225609, -0.12466083,  0.        ,  0.10027059,
        -0.12221888,  0.10027059,  0.09725986, -0.09726032],
       [-0.09996617,  0.09752752, -0.1       ,  0.10027059,  0.        ,
        -0.09756474,  0.125     ,  0.121914  , -0.12191363],
       [ 0.12191363, -0.12496195,  0.12194745, -0.12221888, -0.09756474,
         0.        , -0.09756474, -0.09996571,  0.09996617],
       [-0.09996617,  0.09752752, -0.1       ,  0.10027059,  0.125     ,
        -0.09756474,  0.        ,  0.121914  , -0.12191363],
       [-0.09756511,  0.10000376, -0.09753128,  0.09725986,  0.121914  ,
        -0.09996571,  0.121914  ,  0.        , -0.12499953],
       [ 0.09756474, -0.10000339,  0.09753082, -0.09726032, -0.12191363,
         0.09996617, -0.12191363, -0.12499953,  0.        ]
    ])


def test_make_pattern_sizes():
    r.seed(1234)
    num_patterns, pattern_sizes = hopfield.make_pattern_sizes(min_dims=3, max_dims=3)
    assert num_patterns == NUM_PATTERNS
    assert all(pattern_sizes == PATTERN_SIZES)



def test_make_patterns():
    r.seed(1234)
    num_patterns, pattern_sizes = hopfield.make_pattern_sizes(3,3)
    patterns = hopfield.make_patterns(num_patterns, pattern_sizes)
    for pattern_i, pattern in enumerate(PATTERNS):
        np.array_equal(pattern, patterns[pattern_i])


def test_make_weights(practice_weights):
    weights = hopfield.make_weights(patterns=PATTERNS)
    assert np.all(np.isclose(weights, practice_weights))


def test_outputs(practice_weights):
    input_pattern = PATTERNS[0]
    output = hopfield.get_output(pattern=input_pattern, weights=practice_weights)
    assert np.array_equal(output, input_pattern)
    assert False