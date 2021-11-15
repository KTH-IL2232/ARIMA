# -*- coding: utf-8 -*-
"""
Created on Thu Oct 21 18:02:40 2021

@author: imbasmd
"""

import numpy as np
import pandas as pd
import matplotlib.pylab as plt

import statsmodels.api as sm
from statsmodels.graphics.tsaplots import plot_predict
from statsmodels.tsa.arima_process import arma_generate_sample
from statsmodels.tsa.arima.model import ARIMA

from matplotlib.pylab import rcParams
rcParams['figure.figsize'] = 10, 6

np.random.seed(12345)

arparams = np.array([0.75, -0.25])
maparams = np.array([0.65, 0.35])

arparams = np.r_[1, -arparams]
maparams = np.r_[1, maparams]
nobs = 1000
y = arma_generate_sample(arparams, maparams, nobs)
Y = np.empty(nobs, dtype =float) 
for i in range(len(y)):
    if(i==0):
        Y[i]=1
    else:
        Y[i]=Y[i-1]+y[i-1]
    
data = pd.DataFrame(Y,columns=['Artifical Data'])

# dates = pd.date_range("1980-1-1", freq="M", periods=nobs)
# y = pd.Series(y, index=dates)
# Y = pd.Series(Y, index=dates)
arma_mod = sm.tsa.statespace.SARIMAX(Y[:750], order=(2, 1, 2), trend="n")
results_ARIMA = arma_mod.fit()
print(results_ARIMA.summary())

Y[776] = -50;
Y[786] = -70;
Y[810] = 50;
Y[856] = 0;
Y[874] = 5;
Y[896] = 0;
Y[908] = -20;
Y[965] = 100;
Y[985] = -50;
Y[998] = 0;

data = pd.DataFrame(Y,columns=['Artifical Data'])
data['label']= 1
data['label'].loc[776] = 0;
data['label'].loc[786] = 0;
data['label'].loc[810] = 0;
data['label'].loc[856] = 0;
data['label'].loc[874] = 0;
data['label'].loc[896] = 0;
data['label'].loc[908] = 0;
data['label'].loc[985] = 0;
data['label'].loc[998] = 0;
data.to_csv("C:/2021fall/IL2232/ARIMA/codes/data/artifical_data_with_label.csv")
data.loc[1:750].to_csv("C:/2021fall/IL2232/ARIMA/codes/data/trainset.csv")
data.loc[751:1000].to_csv("C:/2021fall/IL2232/ARIMA/codes/data/testset.csv")

results = results_ARIMA.apply(Y)
prediction = results.predict(0,nobs)

plt.plot(y,label='y')
# plt.plot(predictions_ARIMA,label='Prediction_ARIMA')
plt.plot(Y,label='Y')
# plt.plot(prediction, label='prediction')
# plt.xlim((750,1000))
plt.legend(loc='best')
plt.show()