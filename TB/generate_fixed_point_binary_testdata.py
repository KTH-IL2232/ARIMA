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
rcParams['figure.figsize'] = 10, 6

np.random.seed(100)

arparams = np.array([0.75,0.2])
maparams = np.array([0.5,-0.2])

arparams = np.r_[1, -arparams]
maparams = np.r_[1, maparams]
nobs = 1000
y = arma_generate_sample(arparams, maparams, nobs, 1)
Y = np.empty(nobs, dtype =float) 
for i in range(len(y)):
    if(i==0):
        Y[i]=1
    else:
        Y[i]=Y[i-1]+y[i-1]
    
data = pd.DataFrame(Y,columns=['Artifical Data'])
data.to_csv("C:/2021fall/IL2232/ARIMA design/testdata/real.csv",index=False,header=False)

arma_mod = sm.tsa.statespace.SARIMAX(Y, order=(2, 1, 2), trend="n")
results_ARIMA = arma_mod.fit()
print(results_ARIMA.summary())
predictions_ARIMA = results_ARIMA.predict(1,len(data))

x = Fxp(Y, signed=True, n_word=32, n_frac=15)
# x.info(verbose=3)
binary = x.bin()
output = pd.DataFrame(binary)
output.to_csv("C:/2021fall/IL2232/ARIMA design/testdata/1.csv",index=False,header=False)

x = Fxp(arparams, signed=True, n_word=32, n_frac=15)
binary_ar = x.bin(frac_dot=True)

x = Fxp(maparams, signed=True, n_word=32, n_frac=15)
binary_ma = x.bin(frac_dot=True)

mod_output = pd.read_csv("C:/2021fall/IL2232/ARIMA design/testdata/2.txt",dtype=str)
# mod_output.drop(index=[-1,-2,-3],inplace=True)
# print(mod_output.columns)
res = mod_output['data'].to_numpy()
res_list = res[:995].tolist()

res_fixed = Fxp(res_list,signed=True, n_word=32, n_frac=15)
# print(res_fixed)


# path = "C:/2021fall/IL2232/ARIMA/codes/rescpp.csv"
# rescpp = pd.read_csv(path)
# col = rescpp.columns
# rescpp = rescpp.drop(labels=col[0],axis=1)


plt.title('ARIMA(2,1,2)')
plt.plot(Y,label='Original')
# plt.plot(predictions_ARIMA,label='Prediction_Py')
plt.plot(res_fixed,label='Prediction_RTL')
# plt.plot(rescpp,label='Prediction_cpp')
# plt.xlim(100,200)
plt.legend(loc='best')
plt.show()