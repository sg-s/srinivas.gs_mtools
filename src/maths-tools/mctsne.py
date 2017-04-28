#!/usr/bin/env python
# from __future__ import print_function
from MulticoreTSNE import MulticoreTSNE as TSNE
import scipy.io
import numpy as np
import h5py


# read the V_snippets data from whatever matlab dumped out
hf = h5py.File('Vs.mat','r')
Vs = np.array(hf.get('Vs'));

# embed
tsne = TSNE(n_jobs=4)
R = tsne.fit_transform(Vs)

with h5py.File('data.h5', 'w') as hf:
    hf.create_dataset('R', data=R)
