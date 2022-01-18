# -*- coding: utf-8 -*-
"""
Created on Tue Jan 18 18:12:43 2022

@author: imbasmd
"""
# Commented out IPython magic to ensure Python compatibility.
import numpy as np             #for numerical computations like log,exp,sqrt etc
import pandas as pd            #for reading & storing data, pre-processing
import matplotlib.pylab as plt #for visualization
#for making sure matplotlib plots are generated in Jupyter notebook itself
# %matplotlib inline             
import statsmodels.api as sm
from statsmodels.tsa.arima.model import ARIMA
from matplotlib.pylab import rcParams
from fxpmath import Fxp
import pmdarima as pm
import torch
from torch import nn
from numpy import loadtxt
import pandas as pd 
import os
rcParams['figure.figsize'] = 20, 6

def generate_test_data_fixed_point (data,file_name):
    x = Fxp(data, signed=True, n_word=32, n_frac=15)
    # x.info(verbose=3)
    binary = x.bin()
    output = pd.DataFrame(binary)
    output.to_csv("C:/2021fall/IL2232/ARIMA design/testdata/"+file_name+".csv",index=False,header=False)

def predict_one_step(model_res, data, testset_start, threshold,mean,var):
    tset = data[:testset_start]
    testset = data[testset_start+1:]
    pred = [1]
    labels = [0]
    ac = []
    for i in range (0,len(data)-testset_start-1):
        res = model_res.apply(tset)
        next_step_pred = res.predict(testset_start+i,testset_start+i)[0]
        error = (data[testset_start+i+1] - next_step_pred)
        anomaly_score = (error-mean)*(1/var)*(error-mean)
        tset = np.append(tset,testset[i])
        # if (anomaly_score<threshold):
        #     tset = np.append(tset,testset[i])
        #     labels.append(0)
        # else:
        #     tset = np.append(tset,next_step_pred)
        #     labels.append(1)
        pred.append(next_step_pred)
        ac.append(anomaly_score)
        # pred_e.append(pred_error)
        
    return pred,labels,ac
        
    
def anomaly_score(seq_true,seq_pred):
    error = seq_true-seq_pred
    mean = np.mean(error)
    var = np.var(error)
    score = (error-mean)*(1/var)*(error-mean)
    return score

def get_threshold(seq_true,seq_pred):
    error = seq_true-seq_pred
    mean = np.mean(error)
    var = np.var(error)
    score = (error-mean)*(1/var)*(error-mean)
    max_score = max(score)
    return max_score,mean,var


def get_f1(real_label,detected_label):
    idx = detected_label * 2 + real_label
    tn = (idx == 0.0).sum().item()  # normal and not detected (correct)
    fn = (idx == 1.0).sum().item()  # anomaly and not detected (wrong)
    fp = (idx == 2.0).sum().item()  # normal but detected (wrong)
    tp = (idx == 3.0).sum().item()  # anomaly and detected (correct)
    precision = tp / (tp + fp + 1e-7)
    recall = tp / (tp + fn + 1e-7)
    f1 = 2*(precision * recall)/(precision + recall)
    return f1

dirname = os.path.dirname(__file__)
os.path.join(dirname,"data/artifical_data_with_label.csv")
os.path.join(dirname,"data/trainset.csv")
os.path.join(dirname,"data/testset.csv")

path = os.path.join(dirname,"data/artifical_data_with_label.csv")
data = pd.read_csv(path)
# print(data.columns)
data_without_label = data["Artifical Data"].to_numpy()
train_set = data_without_label[:750]
test_set = data_without_label[750:]
anoamly_labels = data["label"].to_numpy()
test_set_label = data["label"][750:].to_numpy()
# results_ARIMA = pm.auto_arima(train_set, error_action='ignore', trace=True,
#                       suppress_warnings=True, maxiter=100,max_p=10,max_q=10)



model = sm.tsa.statespace.SARIMAX(train_set, order=(2,1,2))
results_ARIMA = model.fit(disp=-1)
print(results_ARIMA.summary())

# get threshold from the trainset
seq_pred = results_ARIMA.predict(1,750)
th,mean,var = get_threshold(train_set,seq_pred)

# do one step prediction and anomaly detection
onestep_pred,detected_label,ac = predict_one_step(results_ARIMA,data_without_label,750,th,mean,var)

# plot
plt.plot(data_without_label[750:],label='original')
plt.plot(np.append(data_without_label[750],onestep_pred[1:]),label='one_step_prediction')
# plt.xlim(750,1000)
plt.legend(loc='best')
plt.show()

fig, ax1 = plt.subplots(figsize=(15,5))
ax1.plot(data_without_label[750:],label='Original')
ax1.plot(np.append(data_without_label[750],onestep_pred[1:]),label='prediction')
ax1.legend(loc='upper left')
ax1.set_ylabel('Value',fontsize=15)
ax1.set_xlabel('Index',fontsize=15)
ax2 = ax1.twinx()
ax2.plot(np.append(ac[0],ac), label='Anomaly scores from \nmultivariate normal distribution',
          color='red', marker='.', linestyle='--', markersize=1, linewidth=1)
ax2.axhline(y=th, label='Threshold',color='g', linestyle='--')
ax2.legend(loc='upper right')
ax2.set_ylabel('anomaly score',fontsize=15)
plt.title('Anomaly detection based on ARIMA model', fontsize=18, fontweight='bold')

plt.tight_layout()
plt.show()

# get f1 score
detected_label = np.array(detected_label)
real_label = test_set_label
f1 = get_f1(real_label,detected_label)
print("f1 score =",f1)
print("threshold =",th)
print("mean =",mean)
print("var =",var)
##################
npa = np.asarray(onestep_pred, dtype=np.float32)
generate_test_data_fixed_point(test_set,"anomaly_set")
generate_test_data_fixed_point(test_set,"anomaly_set")
##################

