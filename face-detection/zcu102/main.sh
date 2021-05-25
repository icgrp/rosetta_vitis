#!/bin/bash -e
qsub -N face  -q icsafe -hold_jid hls_data_mover -m abe -M qsub@qsub.com -l mem=30G -pe onenode 1  -cwd ./build.sh
