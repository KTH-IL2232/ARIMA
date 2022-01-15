#include <fstream>
#include <iostream>
#include <string>
#include <sstream>
#include <cmath>
#include <random>
#include <chrono>
#include <stdio.h>
#include <math.h>
using namespace std;
int w_csv(string input,string output, double* col, int len);
int r_csv(string input, double* col);

// double kalman_1d_1(double obs_now,double pred_last,double p_last,double Q,double R)
// {
//     double pred_now,kalman_gain,p_now;
//     kalman_gain = p_last / (p_last + R);
//     pred_now = pred_now + kalman_gain * (obs_now - pred_last);
//     p_now = (1-kalman_gain) * p_last;
//     return pred_now;
// }

// double kalman_1d_2(double obs_now,double pred_last,double p_last,double Q,double R)
// {
//     double pred_now,kalman_gain,p_now;
//     kalman_gain = p_last / (p_last + R);
//     pred_now = pred_now + kalman_gain * (obs_now - pred_last);
//     p_now = (1-kalman_gain) * p_last;
//     return p_now;
// }

int main() {
    int p=2,d=1,q=2;//ARIMA(p,d,q)
    //ARMA process:
    //yt_hat=c+ar*yt+ma*(yt_har-yt)
    double c=0.0;//constant term
    double ar[5]={0.75, -0.25};//AR coeffients {L1,L2...}
    double ma[5]={0.65, 0.35};//MA coeffients{L1,L2...}
    double sigma2=0.9600;
    int len=1000;//time series length
    // string read_file="AirPassengers.csv";
    string read_file="C:/2021fall/IL2232/ARIMA design/testdata/real.csv";
    string write_file="C:/2021fall/IL2232/ARIMA design/testdata/cpp.csv";
    double *Yt = new double[len];//original time series, Yt[0] is the oldest data
    double *yt = new double[len];
    double *yt_predict = new double[len];

    cout <<"ARIMA"<< "(" << p << "," << d << "," << q << ")"<< endl;
    // read from csv
    r_csv(read_file,Yt);

    // log
    // for(int i=0;i<len;i++){
    //     Yt[i]=log(double(Yt[i]));
    //     // printf("%f\n",Yt[i]);
    // }

    for(int i=0;i<len;i++){
        yt[i]=Yt[i];
        // printf("%f\n",Yt[i]);
    }

    //d times difference
    double initial_difference[10];//save the first value to restore the series
    for(int j=0;j<d;j++){
        initial_difference[j]=yt[0];
        for(int i=0;i<len-j-1;i++){
            yt[i]=yt[i+1]-yt[i];
        }
    }
    // gaussian distribution
    unsigned seed = 1;
    std::default_random_engine generator(seed);
    std::normal_distribution<double> distribution(0.0, sqrt(sigma2));
    double p_now=1,pred_updated;
    // ARMA
    for(int i=0;i<len-d;i++){
        if(i<p||i<q){
            yt_predict[i]=yt[i];
        }
        else{
            // constant
            yt_predict[i]=c;
            // ar terms
            for(int j=0;j<p;j++){
                yt_predict[i]+=ar[j]*yt[i-j-1];
            }
            // ma terms
            for(int j=0;j<q;j++){
                yt_predict[i]+=ma[j]*(yt[i-j-1]-yt_predict[i-j-1]);
            }
            yt_predict[i] = yt_predict[i]*1.95; // mutiply with a coefficient to simulate the kalman filter.
            // yt_predict[i]+=distribution(generator);

            // Kalman filter
            // pred_updated = kalman_1d_1(yt[i-1],yt_predict[i],p_now,0,1);
            // p_now = kalman_1d_2(yt[i-1],yt_predict[i],p_now,0,1);
            // yt_predict[i] = pred_updated;
        }
        
    }

    //cumlative sum
    for(int i=len-1;i>=0;i--){
        yt_predict[i]=yt_predict[i-d];//shift yt_predict right d steps
    }

    for(int i=d-1;i>=0;i--){
        for(int j=i;j<len;j++){
            if(j==i){
                yt_predict[j]=initial_difference[i];
            }
            else{
                yt_predict[j]=yt_predict[j]+yt_predict[j-1];
            }
        }
    }
    //exp
    // for(int i=0;i<len;i++){
    //     yt_predict[i]=exp(yt_predict[i]);
    // }
    for(int i=0;i<len;i++){
        printf("%f\n",yt_predict[i]);
    }
    //to_csv
    w_csv(read_file,write_file,yt_predict,len);
    delete Yt;
    delete yt_predict;
    delete yt;
    return 0;
}

int w_csv(string input,string output, double* col,int len) {
    ofstream op(output);
    int i=0;
    op<<"res_cpp"<<endl;
    while (i<len){ 
        op<<to_string(col[i])<<endl;
        i++;
    }
    return 0;
}

int r_csv(string input, double* col) {
    ifstream fp(input);
    string line;
    getline(fp,line);
    int i=0;
    while (getline(fp,line)){ 
        string number;
        istringstream readstr(line);

        for(int j = 0;j < 2;j++){ 
            getline(readstr,number,','); 
            if(j==1){
                col[i]=stod(number);
                // printf("%d\n",data_line[i]);
            } 
        }
        i=i+1;
    }
    return 0;
}

