//' Calculate mixture Sequential Probability Ratio Test in Cpp
//'
//' @param x,y Numeric vectors
//' @param sigma Population standard deviation
//' @param tau Mixture variance
//' @param theta Hypothesised difference between \code{x} and \code{y}
//' @param distribution The desired distribution.
//' @param alpha Significance level
//' @return The likelihood ratio
//' @name testing
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


// [[Rcpp::export]]
NumericVector testing(Rcpp::NumericVector x, Rcpp::NumericVector y, double sigma, double tau, double theta=0, String distribution = "normal"){
  
  int n = x.size();
  NumericVector out(n);
  
  for(int i = 0; i < n; ++i)
  {
    out[i]  = sqrt((2 * pow(sigma,2) / (2*pow(sigma,2) + (i+1) * pow(tau,2)))) * 
      exp((pow((i+1),2)*pow(tau,2)*pow((meanC(x[Rcpp::Range(0,(i+1))])- meanC(y[Rcpp::Range(0,(i+1))]) - theta),2))/(4*pow(sigma,2)*(2*pow(sigma,2) + (i+1) * pow(tau,2))));
    
  }
  
  
  return out;
  
  
}

