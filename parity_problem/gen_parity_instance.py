import argparse
from random import random
import random

def random_feature_list (n):
    l = []
    for i in range (n):
        l.append (random.choice ([1, 0]))
    return l


def choose_relevant_features (n, k):
    l = [0] * n
    for i in range (k):
        j = random.choice (range (n))
        while (l[j]):
            j = random.choice (range (n))
        l[j] = 1
    return l


def get_parity (feat_list, rel_feat):
    answ = False
    for i in range (len (feat_list)):
        if (rel_feat[i]):
            answ = answ != feat_list[i]
    return answ


parser = argparse.ArgumentParser (description = 'Creates a machine \
        learning parity problem instance.')
parser.add_argument ("n", type = int, 
        help = "The total number of features in the problem.")
parser.add_argument ("k", type = int, 
        help = "The number of relevant features to parity calculations.")
parser.add_argument ("m", type = int, 
        help = "The number of examples of parity to be generated.")
args = parser.parse_args()


n = args.n
k = args.k
m = args.m

relevant_features = choose_relevant_features (n, k)
for i in range (m):
    feat_list = random_feature_list (n)
    parity = get_parity (feat_list, relevant_features)
    
    for f in feat_list:
        print (f, end = ' ')
    if (parity):
        print (' 0 1')
    else:
        print (' 1 0')
