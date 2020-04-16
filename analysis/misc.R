library(lubridate)
library(fuzzyjoin)
library(skimr)

## which days were sitting days?
parlsess_db <- tbl(con, "dilipadsite_parlsess")

sessions <- parlsess_db %>%
  collect() %>%
  mutate(
    enddate = as_date(ifelse(parlsessid == "42-1", date("2019-09-11"), enddate))
  ) %>%
  mutate(session_interval = interval(startdate, enddate)) %>%
  arrange(parlnum, sessnum)

sitting_days_raw <- hansard_db %>%
  count_group(speechdate) %>%
  collect()

sitting_days <- sitting_days_raw %>%
  mutate(
    year = year(speechdate),
    month = month(speechdate, label = TRUE),
    wday = wday(speechdate, label = TRUE, week_start = 1)
  )

sitting_days <- sitting_days %>%
  fuzzy_left_join(
    sessions %>% select(parlsessid, startdate, enddate),
    by = c(
      "speechdate" = "startdate",
      "speechdate" = "enddate"
    ),
    match_fun = list(`>=`, `<=`)
  ) %>%
  select(-startdate, -enddate)

sitting_days %>%
  group_by(wday) %>%
  skim(year, month, count)

