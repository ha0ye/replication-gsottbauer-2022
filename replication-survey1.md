Supplementary-Survey1
================

# Setup

First, load up the necessary packages. We are operating in interactive
mode, so `{{tidyverse}}` can be used and is inclusive of `{{ggplot2}}`,
`{{scales}}`, and `{{dplyr}}`.

``` r
library(readstata13)
library(psych)
library(tidyverse)
```

    ## ── Attaching core tidyverse packages ──────────────────────── tidyverse 2.0.0 ──
    ## ✔ dplyr     1.1.0     ✔ readr     2.1.4
    ## ✔ forcats   1.0.0     ✔ stringr   1.5.0
    ## ✔ ggplot2   3.4.1     ✔ tibble    3.1.8
    ## ✔ lubridate 1.9.2     ✔ tidyr     1.3.0
    ## ✔ purrr     1.0.1     
    ## ── Conflicts ────────────────────────────────────────── tidyverse_conflicts() ──
    ## ✖ ggplot2::%+%()   masks psych::%+%()
    ## ✖ ggplot2::alpha() masks psych::alpha()
    ## ✖ dplyr::filter()  masks stats::filter()
    ## ✖ dplyr::lag()     masks stats::lag()
    ## ℹ Use the ]8;;http://conflicted.r-lib.org/conflicted package]8;; to force all conflicts to become errors

We don’t need to set paths, and assume folks will follow the practice of
using an RStudio project with the project folder as the main parent
folder. All paths are thus local to that.

``` r
datafile_survey_1 <- here::here("data", "MasterFile_Survey1.dta")
```

# Survey 1 (German Internet Panel)

## Read in data

``` r
# load data - labels will be lost
df_study1 <- read.dta13(file = datafile_survey_1, 
                        convert.factors = TRUE, 
                        nonint.factors = TRUE)
```

## Recoding

``` r
dat_study1 <- df_study1 %>%
    rename(priming = rich) %>%
    mutate(priming = case_match(priming, 
                                0 ~ "primed poor", 
                                1 ~ "primed rich"), 
           income = income * 1000, 
           male = male * 100, 
           married = married * 100, 
           student = student * 100, 
           east = east * 100)
```

## Generate Table 1 (sample summary statistics - survey 1)

``` r
summary_vars <- c("income", "male", "age", "edu", "married", 
                  "student", "religiousness", "east", "leftright")

# define function to count number of not NA values
obs <- function(x, na.rm) {sum(is.finite(x))}

# define function to create summary table
make_summary_table <- function(df, vars = summary_vars)
{
    summarize_at(df, vars, 
                 list(obs = obs, mean = mean, sd = sd), na.rm = TRUE) %>%
    pivot_longer(cols = everything(), 
                 names_to = c("set", ".value"), 
                 names_pattern = "(.+)_([a-z]+)")
}

# generate separate tables for primed poor and primed rich
dat_rich <- dat_study1 %>%
    filter(priming == "primed rich")

dat_poor <- dat_study1 %>%
    filter(priming == "primed poor")

summary_rich <- make_summary_table(dat_rich)
summary_poor <- make_summary_table(dat_poor)
```

### Primed rich

| set           |  obs |   mean |     sd |
|:--------------|-----:|-------:|-------:|
| income        | 1509 | 2075.3 | 1406.0 |
| male          | 2253 |   51.7 |   50.0 |
| age           | 2252 |   50.6 |   15.6 |
| edu           | 2268 |    2.0 |    1.4 |
| married       | 2393 |   52.8 |   49.9 |
| student       | 2393 |    4.4 |   20.6 |
| religiousness | 2243 |    4.4 |    3.0 |
| east          | 2392 |   19.4 |   39.5 |
| leftright     | 1994 |    5.3 |    2.0 |

### Primed poor

| set           |  obs |   mean |     sd |
|:--------------|-----:|-------:|-------:|
| income        | 1505 | 2050.0 | 1381.5 |
| male          | 2254 |   50.8 |   50.0 |
| age           | 2255 |   49.7 |   15.6 |
| edu           | 2270 |    2.0 |    1.4 |
| married       | 2392 |   50.3 |   50.0 |
| student       | 2392 |    4.7 |   21.1 |
| religiousness | 2263 |    4.4 |    3.0 |
| east          | 2391 |   19.2 |   39.4 |
| leftright     | 2014 |    5.2 |    1.9 |
