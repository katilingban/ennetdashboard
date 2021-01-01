## Libraries -------------------------------------------------------------------
library(magrittr)
library(dplyr)
library(stringr)
library(lubridate)
library(gh)

## Read data -------------------------------------------------------------------

## Read discussions dataset
gh_data <- "https://github.com/katilingban/ennet_db/blob/main/data/"
link_to_data <- paste(gh_data, "ennet_discussions.csv?raw=TRUE", sep = "")

discussions <- read.csv(link_to_data)
discussions <- tibble::tibble(discussions)

## Read monthly dataset
current_year <- Sys.Date() %>% lubridate::year()
current_month <- Sys.Date() %>% lubridate::month()

##
all_months_years <- c("December_2020",
                      paste(month.name[1:current_month], 
                            current_year, sep = "_"))

##
fn <- paste("ennet_topics_", all_months_years, ".csv", sep = "")

z <- data.frame()

##
for (i in fn) {
  x <- try(read.csv(paste(gh_data, i, "?raw=TRUE", sep = "")))
  
  if (class(x) == "data.frame") {
    x <- x %>%
      tidyr::pivot_longer(cols = starts_with(match = c("Views", "Replies")), 
                          names_to = c("Interaction", "Extracted"),
                          names_sep = "_",
                          values_to = "n")
  }
  
}

##


