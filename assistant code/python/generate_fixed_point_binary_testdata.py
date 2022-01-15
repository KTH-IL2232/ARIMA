# -*- coding: utf-8 -*-
"""
Created on Sun Oct 31 19:52:29 2021

@author: imbasmd
"""

import numpy as np
import pandas as pd
import matplotlib.pylab as plt

import statsmodels.api as sm
from statsmodels.graphics.tsaplots import plot_predict
from statsmodels.tsa.arima_process import arma_generate_sample
from statsmodels.tsa.arima.model import ARIMA

from fxpmath import Fxp

from matplotlib.pylab import rcParams
from statsmodels.graphics.tsaplots import plot_predict
rcParams['figure.figsize'] = 15, 6

np.random.seed(12345)
# set ARMA coefficients here, ARMA(2,2)
arparams = np.array([0.75, -0.25])
maparams = np.array([0.65, 0.35])


arparams = np.r_[1, -arparams]
maparams = np.r_[1, maparams]
nobs = 1000
y = arma_generate_sample(arparams, maparams, nobs, 1)
Y = np.empty(nobs, dtype =float) 
for i in range(len(y)):
    if(i==0):
        Y[i]=0
    else:
        Y[i]=Y[i-1]+y[i-1]
    
Y[776] = -50;
Y[786] = -70;
Y[810] = 50;
Y[856] = 0;
Y[874] = 50;
# Y[896] = 0;
Y[908] = -20;
Y[965] = 100;
Y[985] = -50;
Y[998] = 0;


# ecg dataset
path = "C:/2021fall/IL2232/ARIMA/codes/data.csv"

df = pd.read_csv(path)
df = df.drop(labels='Unnamed: 0',axis=1)
class_names = ['Normal','R on T','PVC','SP','UB']
new_columns = list(df.columns)
new_columns[-1] = 'target'
df.columns = new_columns

normal_df = df[df.target == 1].drop(labels='target', axis=1)
anomaly_df = df[df.target != 1].drop(labels='target', axis=1)


d = df[df.target == 1].drop(labels='target', axis=1).mean(axis=0).to_numpy()
# set dataset
data = Y

da = pd.DataFrame(data,columns=['Artifical Data'])
da.to_csv("C:/2021fall/IL2232/ARIMA design/testdata/real.csv",index=False,header=False)

arma_mod = sm.tsa.statespace.SARIMAX(data, order=(2, 1, 2), trend="n")
results_ARIMA = arma_mod.fit(disp=0)
print(results_ARIMA.summary())
predictions_ARIMA = results_ARIMA.predict(0,len(data)-1)

x = Fxp(data, signed=True, n_word=32, n_frac=15)
# x.info(verbose=3)
binary = x.bin()
output = pd.DataFrame(binary,columns=['data'])
def addstart(r):
    return r+','
output['data'] = output.apply(lambda row: addstart(row['data']),axis=1)
output.to_csv("C:/2021fall/IL2232/ARIMA design/testdata/1.csv",index=False,header=False,quotechar=' ')

x = Fxp(arparams, signed=True, n_word=32, n_frac=15)
binary_ar = x.bin(frac_dot=True)

x = Fxp(maparams, signed=True, n_word=32, n_frac=15)
binary_ma = x.bin(frac_dot=True)

mod_output = pd.read_csv("C:/2021fall/IL2232/ARIMA design/testdata/2.txt",dtype=str)
# mod_output.drop(index=[-1,-2,-3],inplace=True)
# print(mod_output.columns)
res = mod_output['data'].to_numpy()
res_list = res[:len(data)].tolist()

res_fixed = Fxp(res_list,signed=True, n_word=32, n_frac=15)
# print(res_fixed)
result_rtl = res_fixed.get_val()

path = "C:/2021fall/IL2232/ARIMA design/testdata/cpp.csv"
rescpp = pd.read_csv(path)
rescpp = rescpp['res_cpp'].to_numpy()

# resids = results_ARIMA.resid

# error = data - predictions_ARIMA
# new_predict = np.zeros(1000)
# new_predict[1:1000] = 0.8295*data[:999]+-0.5250*error[:999]

arma_mod_2 = ARIMA(y, order=(2, 0, 2), trend="n")
results_ARMA = arma_mod_2.fit()
predictions_ARMA = results_ARMA.predict(0,len(y)-1)
print(results_ARMA.summary())
t = np.empty(nobs, dtype = float) 
for i in range(len(y)):
    if(i==0):
        t[i]=0
    else:
        t[i]=t[i-1]+predictions_ARMA[i-1]*1.9


plt.title('Trainset', fontsize=18, fontweight='bold')
plt.plot(data,label='Original')
# plt.plot(predictions_ARIMA,label='Prediction_Py')
# plt.plot(t,label='prediction_arma')
# plt.plot(new_predict,label='New')
# plt.plot(rescpp,label='Prediction_cpp')
# plt.plot(np.append([],result_rtl),label='Prediction_RTL')
plt.xlim(0,750)
plt.legend(loc='best')
plt.show()

plt.title('Testset', fontsize=18, fontweight='bold')
# plt.plot(data,label='Original')
plt.xlim(751,1000)
plt.legend(loc='best')
plt.show()

plt.title('Testset', fontsize=18, fontweight='bold')
plt.plot(data,label='Original')
plt.xlim(750,1000)
plt.legend(loc='best')
plt.show()

# plot_predict(results_ARIMA,1,200)