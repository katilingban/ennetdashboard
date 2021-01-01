## Libraries -------------------------------------------------------------------
library(magrittr)
library(dplyr)
library(tidyr)
library(stringr)
library(lubridate)

## Read discussions data -------------------------------------------------------

## Read discussions dataset
gh_data <- "https://github.com/katilingban/ennet_db/blob/main/data/"
link_to_data <- paste(gh_data, "ennet_discussions.csv?raw=TRUE", sep = "")

discussions <- read.csv(link_to_data)
discussions <- tibble::tibble(discussions)

## Get themes data -------------------------------------------------------------
themes <- get_themes()$themes

## Get topics by themes data ---------------------------------------------------
topics <- get_themes_topics()

## Read hourlies topics data ---------------------------------------------------
current_year <- Sys.Date() %>% lubridate::year()
current_month <- Sys.Date() %>% lubridate::month()

##
all_months_years <- c("December_2020",
                      paste(month.name[1:current_month], 
                            current_year, sep = "_"))

##
fn <- paste("ennet_topics_", all_months_years, ".csv", sep = "")

hourlies <- data.frame()

##
for (i in fn) {
  x <- try(read.csv(paste(gh_data, i, "?raw=TRUE", sep = "")), silent = TRUE)
  
  if (class(x) == "data.frame") {
    ##
    names(x) <- names(x) %>%
      stringr::str_replace(pattern = "_", replacement = " ")
    
    ##
    x <- x %>%
      tidyr::pivot_longer(cols = starts_with(match = c("Views", "Replies")), 
                          names_to = c("Interaction", "Extraction"),
                          names_sep = " ",
                          values_to = "n") %>%
      mutate(Extraction = lubridate::ymd_hms(Extraction))
    
    ##
    hourlies <- rbind(hourlies, x)
  }
}

## Convert to tibble
hourlies <- tibble::tibble(hourlies)

## clean-up 
rm(all_months_years, current_month, current_year, fn, i, link_to_data, x)

## Process dailies topics data -------------------------------------------------
dailies <- hourlies %>%
  group_by(Theme, Topic, Author, Posted, Link, Interaction, 
           `Extraction Date` = as.Date(Extraction)) %>%
  filter(Extraction == max(Extraction, na.rm = TRUE))

## Process weeklies topics data ------------------------------------------------
  weeklies <- dailies %>%
  group_by(Theme, Topic, Author, Posted, Link, Interaction, 
           `Extraction Week` = lubridate::isoweek(`Extraction Date`)) %>%
  filter(Extraction == max(Extraction, na.rm = TRUE))

## Process monthlies topics data -----------------------------------------------
monthlies <- dailies %>%
  group_by(Theme, Topic, Author, Posted, Link, Interaction, 
           `Extraction Month` = lubridate::month(`Extraction Date`)) %>%
  filter(Extraction == max(Extraction, na.rm = TRUE))

