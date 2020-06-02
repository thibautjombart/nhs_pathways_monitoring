---
date: "2020-06-02"
title: About the model
---

The trend analyses presented here use Automatic Selection of Models Outlier
DEtection for Epidemics (ASMODEE). **This new algorithm has not been peer reviewed
yet.**



## ASMODEE in a nutshell

ASMODEE aims to detect recent deviation from the trend followed by the data in
time series. Data is first partitioned into 'recent' data, using the last ‘k’
observations as supplementary individuals, and older data used to fit the
trend. Trend-fitting is done by fitting a series of user-specified models for
the time series, with different methods for selecting best fit (see details, and
the argument ‘method’). The prediction interval is then calculated for the best
model, and every data point (including the training set and supplementary
individuals) falling outside are classified as 'outliers'. The value of ‘k’ can
be fixed by the user, or automatically selected to minimise outliers in the
training period and maximise and the detection of outliers in the recent period.



## Implementation

### R package *epichange*

ASMODEE is implemented in the R package
[*epichange*](https://github.com/reconhub/epichange), hosted by the [R Epidemics
Consortium](https://www.repidemicsconsortium.org/). 


### Try it out

You can install *epichange* from R by typing:

```r
if (!require(remotes)) {
  install.packages("remotes")
}
remotes::install_github("reconhub/epichange")
```

To try the package, first check the documentation of `asmodee`, and run the example:

```r
library(epichange)
?asmodee
example(asmodee)
```

### Contributions 

This package is still under
development. Contributions are most welcome. A good place to start would be to
look at the current [issues](https://github.com/reconhub/epichange/issues).
