library(tidyverse)

library(DBI)
library(RPostgreSQL)
library(dbplyr)

library(helpers)

con <- DBI::dbConnect(
  drv = dbDriver("PostgreSQL"),
  host = "localhost",
  dbname = "lipad"
)

hansard_db <- tbl(con, "dilipadsite_basehansard")
