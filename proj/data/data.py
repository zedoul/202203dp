from sklearn.preprocessing import normalize
from sklearn.cluster import KMeans
from pprint import pprint
from collections import Counter
import numpy as np
import pandas as pd
import pickle
import operator
import argparse
from os import listdir
from os.path import isfile, join
import talos
import os
import seaborn as sns
import matplotlib.pyplot as plt

DATA_PATH = '../dataset/'
data = pd.read_csv("../../data/sample_data_intw.csv")

#seperate categorical and numerical columns
non_num=[]
for i in data.columns:
    if data[i].dtype=="object":
        non_num.append(i)

print(non_num)

#drop these columns
data.drop(labels=non_num,axis=1,inplace=True)
#Prepare feature and target sets
x = data.drop(labels=["label"],axis=1)
y = data["label"]
x = talos.utils.rescale_meanzero(x)

#since our data is completely numeric, we can proceed for upsampling
from imblearn.over_sampling import SMOTE
#Initialise smote
smote = SMOTE()
# fit predictor and target variable on smote
x_smote, y_smote = smote.fit_resample(x,y)

print('old shape', x.shape)
print('new shape', x_smote.shape)


from sklearn.model_selection import train_test_split
x_train,x_test,y_train,y_test = train_test_split(x_smote,y_smote,test_size=0.25,random_state=123)
print("length of x_train {} and y_train {}".format(len(x_train),len(y_train)))
print("length of x_test {} and y_test {}".format(len(x_test),len(y_test)))
# split for validation set
x_train,x_valid,y_train,y_valid = train_test_split(x_train,y_train,test_size=0.20,random_state=123)
print("length of x_train {} and y_train {}".format(len(x_train),len(y_train)))
print("length of x_valid {} and y_valid {}".format(len(x_valid),len(y_valid)))


dataset_name = "tele"
pickle.dump(x_smote, open(DATA_PATH+dataset_name+'_features.p', 'wb'))
pickle.dump(y_smote, open(DATA_PATH+dataset_name+'_labels.p', 'wb'))
