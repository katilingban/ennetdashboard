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

## Process dailies topics data -------------------------------------------------
daily_interactions <- read.csv(file = "https://raw.githubusercontent.com/katilingban/ennet_db/main/data/ennet_topics_daily_interactions.csv")
daily_interactions <- daily_interactions %>%
  tibble::tibble() %>%
  mutate(Extraction.Date = as.Date(Extraction.Date)) %>%
  rename(`Extraction Date` = Extraction.Date,
         `New Replies` = New.Replies,
         `New Views` = New.Views)

## Process weeklies topics data ------------------------------------------------
weekly_interactions <- read.csv(file = "https://raw.githubusercontent.com/katilingban/ennet_db/main/data/ennet_topics_weekly_interactions.csv")
weekly_interactions <- weekly_interactions %>%
  tibble::tibble() %>%
  mutate(Extraction.Week = as.Date(Extraction.Week)) %>%
  rename(`Extraction Week` = Extraction.Week,
         `New Replies` = New.Replies,
         `New Views` = New.Views)

## Process monthlies topics data -----------------------------------------------
monthly_interactions <- read.csv(file = "https://raw.githubusercontent.com/katilingban/ennet_db/main/data/ennet_topics_monthly_interactions.csv")
monthly_interactions <- monthly_interactions %>%
  tibble::tibble() %>%
  mutate(Extraction.Month = as.Date(Extraction.Month)) %>%
  rename(`Extraction Month` = Extraction.Month,
         `New Replies` = New.Replies,
         `New Views` = New.Views)

## Process yearlies topics data ------------------------------------------------
yearly_interactions <- read.csv(file = "https://raw.githubusercontent.com/katilingban/ennet_db/main/data/ennet_topics_yearly_interactions.csv")
yearly_interactions <- yearly_interactions %>%
  tibble::tibble() %>%
  mutate(Extraction.Year = as.Date(Extraction.Year)) %>%
  rename(`Extraction Year` = Extraction.Year,
         `New Replies` = New.Replies,
         `New Views` = New.Views)
