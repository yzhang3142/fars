
<!-- README.md is generated from README.Rmd. Please edit that file -->
rpkgtutorial
============

This package is created as part of the assessment for the course Building R Packages on Coursera.

Installation
------------

You can install rpkgtutorial from github with:

``` r
# install.packages("devtools")
devtools::install_github("yzhang3142/rpkgtutorial")
```

Example
-------

This is a basic example which shows you how to solve a common problem:

``` r
fars_summarize_years(c(2013, 2014))

fars_map_state(4, 2013)
```

This assessment is evaluated based on the following questions:
--------------------------------------------------------------

-   Does this package contain the correct R file(s) under the R/ directory?
-   Does this package contain a man/ directory with corresponding documentation files?
-   Does this package contain a vignette which provides a meaningful description of the package and how it should be used?
-   Does this package have at least one test included in the tests/ directory?
-   Does this package have a NAMESPACE file?
-   Does the README.md file for this directory have a Travis badge?
-   Is the build of this package passing on Travis?
-   Are the build logs for this package on Travis free of any errors, warnings, or notes?

Travis CI Passing Badge
-----------------------

Successfully built on Travis: ![alt text](https://travis-ci.org/yzhang3142/rpkgtutorial.svg?branch=master)
