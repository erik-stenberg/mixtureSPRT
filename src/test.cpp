//' Calculate mixture Sequential Probability Ratio Test in C++
//'
//' @param x,y Numeric vectors
//' @param xpre,ypre Numeric vectors
//' @param sigma Population standard deviation
//' @param tau Mixture variance
//' @param theta Hypothesised difference between \code{x} and \code{y}
//' @param distribution The desired distribution.
//' @param alpha Significance level
//' @return The likelihood ratio
//' @name cppmSPRT
//' @export

#include <Rcpp.h>
#include<cmath>
#include<string.h>
using namespace Rcpp;
using namespace std;


double meanC(NumericVector x) {
  int n = x.size();
  double total = 0;
  
  for(int i = 0; i < n; ++i) {
    total += x[i];
  }
  return total / n;
}


double covC(NumericVector x, NumericVector y) { 
  int n = x.size();
  double meany = mean(y);
  double meanx = mean(x);
  NumericVector summa(n); 
  for(int i = 0; i < n; i++) {
    summa[i] = (x[i] - meanx) *
               (y[i] - meany);
  }
  return sum(summa)/(n-1); 
}

bool checkNull(Nullable<NumericVector> x) {
  if (x.isNull()) {
    return true;
  } else {
    return false;
  }
}



// [[Rcpp::export]]
NumericVector cppmSPRT(Rcpp::NumericVector x, Rcpp::NumericVector y, Nullable<NumericVector> xpre, Nullable<NumericVector> ypre, double sigma, double tau, double theta=0, Rcpp::CharacterVector distribution = "normal"){
  int n = x.size();
  NumericVector out(n);
  double burnIn = 100;
  CharacterVector norm = "normal";
  CharacterVector bern = "bernoulli";
  
  
 if(checkNull(xpre) == false){
   NumericVector xpre_n = NumericVector(xpre);
   NumericVector ypre_n = NumericVector(ypre);
    for(int i = burnIn; i < n; ++i){
      double k = 0.5 * ((covC(xpre_n[Rcpp::Range(0,(i))], x[Rcpp::Range(0,(i))]) / var(xpre_n[Rcpp::Range(0,(i))])) +
                  (covC(ypre_n[Rcpp::Range(0,(i))], y[Rcpp::Range(0,(i))])/var(ypre_n[Rcpp::Range(0,(i))])));
      
      NumericVector xn = x[Range(0,i)] - k * xpre_n[Range(0,i)];
      NumericVector yn = y[Range(0,i)] - k * ypre_n[Range(0,i)];
      
      double Vn = mean(yn) * (1 - mean(yn)) + mean(xn) * (1-mean(xn));
      //double newsigma = sqrt(Vn/2);
      
      out[i] = sqrt((Vn)/(Vn + (i+1)*pow(tau,2))) * exp((pow((i+1),2)*pow(tau,2)*pow((mean(xn)-mean(yn) - theta),2)) / (2*Vn*(Vn + (i+1)*pow(tau,2))));
      }
    return out;
    
 } else {
   
   if(distribution[0] == norm[0]){
     for(int i = (burnIn+1); i < n; ++i) {
       out[i]  =  sqrt((2 * pow(sigma,2) / (2*pow(sigma,2) + (i+1) * pow(tau,2)))) * exp((pow((i+1),2)*pow(tau,2)*pow((mean(x[Rcpp::Range(0,(i+1))])- mean(y[Rcpp::Range(0,(i+1))]) - theta),2))/(4*pow(sigma,2)*(2*pow(sigma,2) + (i+1) * pow(tau,2))));
     }
   }
   
   else if(distribution[0] == bern[0]) {
     for(int i = (burnIn+1); i < n; ++i) {
       double Vn = mean(x[Range(0,i)]) * (1-mean(x[Range(0,i)])) + mean(y[Range(0,i)]) * (1-mean(y[Range(0,i)]));
       out[i]    = sqrt((Vn)/(Vn + (i+1) * pow(tau,2))) * exp((pow((i+1),2)*pow(tau,2)*pow((mean(x[Rcpp::Range(0,(i))])- mean(y[Rcpp::Range(0,(i))]) - theta),2))/( 2 * Vn * ( Vn  + (i+1) * pow(tau,2))));
     }
   }
  return out;
  }
  
}

