#!/bin/bash

DATASET="tele"
CODE=main.py

echo "==========================================================KK"
echo "==========================================================KK"
echo "Filling data/ directory"
echo "==========================================================KK"
python $CODE $DATASET --save_data=1

echo "==========================================================KK"
echo "==========================================================KK"
echo "Without defense"
echo "==========================================================KK"
python $CODE $DATASET --target_model='nn' --target_l2_ratio=1e-8 --target_data_size=50000

#echo "==========================================================KK"
#echo "==========================================================KK"
#echo "With defense"
#echo "==========================================================KK"
#python $CODE $DATASET --target_model='nn' --target_l2_ratio=1e-2 --target_privacy='grad_pert' --target_dp="dp" --target_epsilon=0.5 --run=1
