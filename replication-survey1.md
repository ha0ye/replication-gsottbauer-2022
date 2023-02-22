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

``` r
library(gt)
```

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

left_join(summary_rich, summary_poor, by = "set", 
          suffix = c("", ".")) %>%
    mutate_at(vars(-"set"), ~(round(., digits = 1))) %>%
    rename(variable = set) %>%
    gt() %>%
    tab_spanner(label = "primed rich", 
                columns = c("obs", "mean", "sd")) %>%
    tab_spanner(label = "primed poor", 
                columns = c("obs.", "mean.", "sd."))
```

<div id="ggfrzmzjyg" style="overflow-x:auto;overflow-y:auto;width:auto;height:auto;">
<style>html {
  font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Helvetica Neue', 'Fira Sans', 'Droid Sans', Arial, sans-serif;
}

#ggfrzmzjyg .gt_table {
  display: table;
  border-collapse: collapse;
  margin-left: auto;
  margin-right: auto;
  color: #333333;
  font-size: 16px;
  font-weight: normal;
  font-style: normal;
  background-color: #FFFFFF;
  width: auto;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #A8A8A8;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #A8A8A8;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
}

#ggfrzmzjyg .gt_heading {
  background-color: #FFFFFF;
  text-align: center;
  border-bottom-color: #FFFFFF;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#ggfrzmzjyg .gt_title {
  color: #333333;
  font-size: 125%;
  font-weight: initial;
  padding-top: 4px;
  padding-bottom: 4px;
  border-bottom-color: #FFFFFF;
  border-bottom-width: 0;
}

#ggfrzmzjyg .gt_subtitle {
  color: #333333;
  font-size: 85%;
  font-weight: initial;
  padding-top: 0;
  padding-bottom: 6px;
  border-top-color: #FFFFFF;
  border-top-width: 0;
}

#ggfrzmzjyg .gt_bottom_border {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ggfrzmzjyg .gt_col_headings {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
}

#ggfrzmzjyg .gt_col_heading {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 6px;
  padding-left: 5px;
  padding-right: 5px;
  overflow-x: hidden;
}

#ggfrzmzjyg .gt_column_spanner_outer {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: normal;
  text-transform: inherit;
  padding-top: 0;
  padding-bottom: 0;
  padding-left: 4px;
  padding-right: 4px;
}

#ggfrzmzjyg .gt_column_spanner_outer:first-child {
  padding-left: 0;
}

#ggfrzmzjyg .gt_column_spanner_outer:last-child {
  padding-right: 0;
}

#ggfrzmzjyg .gt_column_spanner {
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: bottom;
  padding-top: 5px;
  padding-bottom: 5px;
  overflow-x: hidden;
  display: inline-block;
  width: 100%;
}

#ggfrzmzjyg .gt_group_heading {
  padding: 8px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
}

#ggfrzmzjyg .gt_empty_group_heading {
  padding: 0.5px;
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  vertical-align: middle;
}

#ggfrzmzjyg .gt_from_md > :first-child {
  margin-top: 0;
}

#ggfrzmzjyg .gt_from_md > :last-child {
  margin-bottom: 0;
}

#ggfrzmzjyg .gt_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  margin: 10px;
  border-top-style: solid;
  border-top-width: 1px;
  border-top-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 1px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 1px;
  border-right-color: #D3D3D3;
  vertical-align: middle;
  overflow-x: hidden;
}

#ggfrzmzjyg .gt_stub {
  color: #333333;
  background-color: #FFFFFF;
  font-size: 100%;
  font-weight: initial;
  text-transform: inherit;
  border-right-style: solid;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
  padding-left: 12px;
}

#ggfrzmzjyg .gt_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ggfrzmzjyg .gt_first_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
}

#ggfrzmzjyg .gt_grand_summary_row {
  color: #333333;
  background-color: #FFFFFF;
  text-transform: inherit;
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
}

#ggfrzmzjyg .gt_first_grand_summary_row {
  padding-top: 8px;
  padding-bottom: 8px;
  padding-left: 5px;
  padding-right: 5px;
  border-top-style: double;
  border-top-width: 6px;
  border-top-color: #D3D3D3;
}

#ggfrzmzjyg .gt_striped {
  background-color: rgba(128, 128, 128, 0.05);
}

#ggfrzmzjyg .gt_table_body {
  border-top-style: solid;
  border-top-width: 2px;
  border-top-color: #D3D3D3;
  border-bottom-style: solid;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
}

#ggfrzmzjyg .gt_footnotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#ggfrzmzjyg .gt_footnote {
  margin: 0px;
  font-size: 90%;
  padding: 4px;
}

#ggfrzmzjyg .gt_sourcenotes {
  color: #333333;
  background-color: #FFFFFF;
  border-bottom-style: none;
  border-bottom-width: 2px;
  border-bottom-color: #D3D3D3;
  border-left-style: none;
  border-left-width: 2px;
  border-left-color: #D3D3D3;
  border-right-style: none;
  border-right-width: 2px;
  border-right-color: #D3D3D3;
}

#ggfrzmzjyg .gt_sourcenote {
  font-size: 90%;
  padding: 4px;
}

#ggfrzmzjyg .gt_left {
  text-align: left;
}

#ggfrzmzjyg .gt_center {
  text-align: center;
}

#ggfrzmzjyg .gt_right {
  text-align: right;
  font-variant-numeric: tabular-nums;
}

#ggfrzmzjyg .gt_font_normal {
  font-weight: normal;
}

#ggfrzmzjyg .gt_font_bold {
  font-weight: bold;
}

#ggfrzmzjyg .gt_font_italic {
  font-style: italic;
}

#ggfrzmzjyg .gt_super {
  font-size: 65%;
}

#ggfrzmzjyg .gt_footnote_marks {
  font-style: italic;
  font-weight: normal;
  font-size: 65%;
}
</style>
<table class="gt_table">
  
  <thead class="gt_col_headings">
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_left" rowspan="2" colspan="1">variable</th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="3">
        <span class="gt_column_spanner">primed rich</span>
      </th>
      <th class="gt_center gt_columns_top_border gt_column_spanner_outer" rowspan="1" colspan="3">
        <span class="gt_column_spanner">primed poor</span>
      </th>
    </tr>
    <tr>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">obs</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">mean</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">sd</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">obs.</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">mean.</th>
      <th class="gt_col_heading gt_columns_bottom_border gt_right" rowspan="1" colspan="1">sd.</th>
    </tr>
  </thead>
  <tbody class="gt_table_body">
    <tr><td class="gt_row gt_left">income</td>
<td class="gt_row gt_right">1509</td>
<td class="gt_row gt_right">2075.3</td>
<td class="gt_row gt_right">1406.0</td>
<td class="gt_row gt_right">1505</td>
<td class="gt_row gt_right">2050.0</td>
<td class="gt_row gt_right">1381.5</td></tr>
    <tr><td class="gt_row gt_left">male</td>
<td class="gt_row gt_right">2253</td>
<td class="gt_row gt_right">51.7</td>
<td class="gt_row gt_right">50.0</td>
<td class="gt_row gt_right">2254</td>
<td class="gt_row gt_right">50.8</td>
<td class="gt_row gt_right">50.0</td></tr>
    <tr><td class="gt_row gt_left">age</td>
<td class="gt_row gt_right">2252</td>
<td class="gt_row gt_right">50.6</td>
<td class="gt_row gt_right">15.6</td>
<td class="gt_row gt_right">2255</td>
<td class="gt_row gt_right">49.7</td>
<td class="gt_row gt_right">15.6</td></tr>
    <tr><td class="gt_row gt_left">edu</td>
<td class="gt_row gt_right">2268</td>
<td class="gt_row gt_right">2.0</td>
<td class="gt_row gt_right">1.4</td>
<td class="gt_row gt_right">2270</td>
<td class="gt_row gt_right">2.0</td>
<td class="gt_row gt_right">1.4</td></tr>
    <tr><td class="gt_row gt_left">married</td>
<td class="gt_row gt_right">2393</td>
<td class="gt_row gt_right">52.8</td>
<td class="gt_row gt_right">49.9</td>
<td class="gt_row gt_right">2392</td>
<td class="gt_row gt_right">50.3</td>
<td class="gt_row gt_right">50.0</td></tr>
    <tr><td class="gt_row gt_left">student</td>
<td class="gt_row gt_right">2393</td>
<td class="gt_row gt_right">4.4</td>
<td class="gt_row gt_right">20.6</td>
<td class="gt_row gt_right">2392</td>
<td class="gt_row gt_right">4.7</td>
<td class="gt_row gt_right">21.1</td></tr>
    <tr><td class="gt_row gt_left">religiousness</td>
<td class="gt_row gt_right">2243</td>
<td class="gt_row gt_right">4.4</td>
<td class="gt_row gt_right">3.0</td>
<td class="gt_row gt_right">2263</td>
<td class="gt_row gt_right">4.4</td>
<td class="gt_row gt_right">3.0</td></tr>
    <tr><td class="gt_row gt_left">east</td>
<td class="gt_row gt_right">2392</td>
<td class="gt_row gt_right">19.4</td>
<td class="gt_row gt_right">39.5</td>
<td class="gt_row gt_right">2391</td>
<td class="gt_row gt_right">19.2</td>
<td class="gt_row gt_right">39.4</td></tr>
    <tr><td class="gt_row gt_left">leftright</td>
<td class="gt_row gt_right">1994</td>
<td class="gt_row gt_right">5.3</td>
<td class="gt_row gt_right">2.0</td>
<td class="gt_row gt_right">2014</td>
<td class="gt_row gt_right">5.2</td>
<td class="gt_row gt_right">1.9</td></tr>
  </tbody>
  
  
</table>
</div>
