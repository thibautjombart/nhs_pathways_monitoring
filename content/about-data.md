---
date: "2020-06-02"
title: About the data
---

We use the [NHS pathways data](https://digital.nhs.uk/dashboards/nhs-pathways)
reporting potential COVID-19 cases in England. These data include all reports
classified as '*potential COVID-19 cases*' notified via calls to 111, 999, and
[111-online](https://111.nhs.uk/) systems. These data are **not confirmed
cases**, and are subject to unknown reporting biases. They likely include a
substantial fraction of 'false positives' (cases classified as potential
COVID-19 which are in fact due to other illness), as well as under-reporting
(true COVID-19 cases not reported). Last, as these data are using
self-reporting, it is likely that individual perceptions as well as ease of
access to the reporting platforms impact the observed numbers. 


For a discussion of how these data can be interpreted and associated caveats,
see [this
article](https://www.medrxiv.org/content/10.1101/2020.05.16.20103820v1) (under
review). A shorter version can be found online on [this
post](https://cmmid.github.io/topics/covid19/nhs-pathways.html).


## Data source

The NHS pathways data used on this website are publicly available from the [NHS
dashboard]( https://digital.nhs.uk/dashboards/nhs-pathways).  We use a version
in which additional and information (NHS regions) has been added, daily updated
from Quentin Leclerc's github
[repository](https://github.com/qleclerc/nhs_pathways_report).


## Getting the latest data in R

You can get the latest version of these data using R by typing the following
commands:

```r

pathways <- tempfile()
url <- paste0("https://github.com/qleclerc/nhs_pathways_report/",
              "raw/master/data/rds/pathways_latest.rds")
download.file(url, pathways)
pathways <- readRDS(pathways)
              
```
