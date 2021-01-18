## Libraries -------------------------------------------------------------------
library(magrittr)
library(dplyr)
library(tidyr)
library(stringr)
library(lubridate)
library(ennet)

## Read discussions data -------------------------------------------------------

## Read discussions dataset
discussions <- get_db_discussions()

## Get themes data -------------------------------------------------------------
themes <- get_themes()$themes

## Get topics by themes data ---------------------------------------------------
topics <- get_themes_topics()

## Read hourlies topics data ---------------------------------------------------
#gh_data <- "https://github.com/katilingban/ennet_db/blob/main/data/"
#current_year <- Sys.Date() %>% lubridate::year()
#current_month <- Sys.Date() %>% lubridate::month()

##
#all_months_years <- c("December_2020",
#                      paste(month.name[1:current_month], 
#                            current_year, sep = "_"))

##
#fn <- paste("ennet_topics_", all_months_years, ".csv", sep = "")

#hourlies <- data.frame()

##
#for (i in fn) {
#  x <- try(read.csv(paste(gh_data, i, "?raw=TRUE", sep = "")), silent = TRUE)
#  
#  if (class(x) == "data.frame") {
    ##
#    names(x) <- names(x) %>%
#      stringr::str_replace(pattern = "_", replacement = " ")
    
    ##
#    x <- x %>%
#      tidyr::pivot_longer(cols = starts_with(match = c("Views", "Replies")), 
#                          names_to = c("Interaction", "Extraction"),
#                          names_sep = " ",
#                          values_to = "n") %>%
#      mutate(Extraction = lubridate::ymd_hms(Extraction)) #%>%
      #tidyr::pivot_wider(names_from = Interaction, values_from = n)
    
    ##
#    hourlies <- rbind(hourlies, x)
#  }
#}

## Convert to tibble
#hourlies <- hourlies %>%
#  mutate(n = ifelse(is.na(n), 0, n))

## clean-up 
#rm(all_months_years, current_month, current_year, fn, i, x)

## Process dailies topics data -------------------------------------------------
#dailies <- hourlies %>%
#  group_by(Theme, Topic, Author, Posted, Link, Interaction,
#           `Extraction Date` = as.Date(Extraction)) %>%
#  filter(Extraction == max(Extraction, na.rm = TRUE)) %>%
#  ungroup()

## Tally daily views
#x <- dailies %>%
#  group_by(Theme, Interaction, `Extraction Date`) %>%
#  count(Posted, name = "nPosts") %>%
#  summarise(nPosts = sum(nPosts), .groups = "drop") %>%
#  pivot_wider(names_from = Interaction, values_from = nPosts) %>%
#  select(Theme:Replies) %>%
#  rename(nPosts = Replies)

#daily_interactions <- dailies %>%
#  group_by(Theme, Interaction, `Extraction Date`, .add = TRUE) %>%
#  summarise(nInteractions = sum(n), .groups = "drop") %>%
#  pivot_wider(names_from = Interaction, values_from = nInteractions) %>%
#  group_by(Theme) %>%
#  mutate(`New Replies` = c(0, diff(Replies, 1)),
#         `New Views` = c(0, diff(Views, 1))) %>%
#  full_join(x) %>%
#  ungroup()
 
daily_interactions <- read.csv(file = "https://raw.githubusercontent.com/katilingban/ennet_db/main/data/ennet_topics_daily_interactions.csv")
daily_interactions <- daily_interactions %>%
  tibble::tibble() %>%
  mutate(Extraction.Date = as.Date(Extraction.Date)) %>%
  rename(`Extraction Date` = Extraction.Date,
         `New Replies` = New.Replies,
         `New Views` = New.Views)

## Process weeklies topics data ------------------------------------------------
#weeklies <- dailies %>%
#  group_by(Theme, Topic, Author, Posted, Link, Interaction,
#           `Extraction Week` = cut(`Extraction Date`, 
#                                   breaks = "1 week", 
#                                   start.on.monday = FALSE) %>%
#             as.Date()) %>%
#  filter(Extraction == max(Extraction, na.rm = TRUE)) %>%
#  ungroup()

## Tally weekly views
#x <- dailies %>%
#  group_by(Theme, Interaction, 
#           `Extraction Week` = cut(`Extraction Date`, 
#                                   breaks = "1 week", 
#                                   start.on.monday = FALSE) %>%
#             as.Date()) %>%
#  count(Posted, name = "nPosts") %>%
#  summarise(nPosts = sum(nPosts), .groups = "drop") %>%
#  pivot_wider(names_from = Interaction, values_from = nPosts) %>%
#  select(Theme:Replies) %>%
#  rename(nPosts = Replies)

#weekly_interactions <- weeklies %>%
#  group_by(Theme, Interaction, `Extraction Week`, .add = TRUE) %>%
#  summarise(nInteractions = sum(n), .groups = "drop") %>%
#  pivot_wider(names_from = Interaction, values_from = nInteractions) %>%
#  group_by(Theme) %>%
#  mutate(`New Replies` = c(0, diff(Replies, 1)),
#         `New Views` = c(0, diff(Views, 1))) %>%
#  full_join(x) %>%
#  ungroup()

weekly_interactions <- read.csv(file = "https://raw.githubusercontent.com/katilingban/ennet_db/main/data/ennet_topics_weekly_interactions.csv")
weekly_interactions <- weekly_interactions %>%
  tibble::tibble() %>%
  mutate(Extraction.Week = as.Date(Extraction.Week)) %>%
  rename(`Extraction Week` = Extraction.Week,
         `New Replies` = New.Replies,
         `New Views` = New.Views)

## Process monthlies topics data -----------------------------------------------
#monthlies <- dailies %>%
#  group_by(Theme, Topic, Author, Posted, Link, Interaction,
#           `Extraction Month` = cut(`Extraction Date`, breaks = "1 month") %>%
#             as.Date()) %>%
#  filter(Extraction == max(Extraction, na.rm = TRUE)) %>%
#  ungroup()

## Tally monthly views
#x <- dailies %>%
#  group_by(Theme, Interaction, 
#           `Extraction Month` = cut(`Extraction Date`, 
#                                    breaks = "1 month") %>%
#             as.Date()) %>%
#  count(Posted, name = "nPosts") %>%
#  summarise(nPosts = sum(nPosts), .groups = "drop") %>%
#  pivot_wider(names_from = Interaction, values_from = nPosts) %>%
#  select(Theme:Replies) %>%
#  rename(nPosts = Replies)

#monthly_interactions <- monthlies %>%
#  group_by(Theme, Interaction, `Extraction Month`, .add = TRUE) %>%
#  summarise(nInteractions = sum(n), .groups = "drop") %>%
#  pivot_wider(names_from = Interaction, values_from = nInteractions) %>%
#  group_by(Theme) %>%
#  mutate(`New Replies` = c(0, diff(Replies, 1)),
#         `New Views` = c(0, diff(Views, 1))) %>%
#  full_join(x) %>%
#  ungroup()

monthly_interactions <- read.csv(file = "https://raw.githubusercontent.com/katilingban/ennet_db/main/data/ennet_topics_monthly_interactions.csv")
monthly_interactions <- monthly_interactions %>%
  tibble::tibble() %>%
  mutate(Extraction.Month = as.Date(Extraction.Month)) %>%
  rename(`Extraction Month` = Extraction.Month,
         `New Replies` = New.Replies,
         `New Views` = New.Views)

## Process yearlies topics data ------------------------------------------------
#yearlies <- dailies %>%
#  group_by(Theme, Topic, Author, Posted, Link, Interaction,
#           `Extraction Year` = cut(`Extraction Date`, breaks = "1 year") %>%
#             as.Date()) %>%
#  filter(Extraction == max(Extraction, na.rm = TRUE)) %>%
#  ungroup()

## Tally monthly views
#x <- yearlies %>%
#  group_by(Theme, Interaction, 
#           `Extraction Year` = cut(`Extraction Date`, 
#                                    breaks = "1 year") %>%
#             as.Date()) %>%
#  count(Posted, name = "nPosts") %>%
#  summarise(nPosts = sum(nPosts), .groups = "drop") %>%
#  pivot_wider(names_from = Interaction, values_from = nPosts) %>%
#  select(Theme:Replies) %>%
#  rename(nPosts = Replies)

#yearly_interactions <- yearlies %>%
#  group_by(Theme, Interaction, `Extraction Year`, .add = TRUE) %>%
#  summarise(nInteractions = sum(n), .groups = "drop") %>%
#  pivot_wider(names_from = Interaction, values_from = nInteractions) %>%
#  group_by(Theme) %>%
#  mutate(`New Replies` = c(0, diff(Replies, 1)),
#         `New Views` = c(0, diff(Views, 1))) %>%
#  full_join(x) %>%
#  ungroup()

yearly_interactions <- read.csv(file = "https://raw.githubusercontent.com/katilingban/ennet_db/main/data/ennet_topics_yearly_interactions.csv")
yearly_interactions <- yearly_interactions %>%
  tibble::tibble() %>%
  mutate(Extraction.Year = as.Date(Extraction.Year)) %>%
  rename(`Extraction Year` = Extraction.Year,
         `New Replies` = New.Replies,
         `New Views` = New.Views)
