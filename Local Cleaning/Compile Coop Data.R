library(data.table)
library(openxlsx)
library(readxl)
library(tidyverse)
library(rlist)
# set the working directory
path <- "/Users/eric.ziemba/Downloads/"
setwd(path)

# accessing all the sheets in two files
sheets1 = excel_sheets("Wego Bill Verification Vol. IV.xlsx")
sheets2 = excel_sheets("Wego Bill Verification Vol. III.xlsx")
sheets = list.append(sheets1, sheets2)

d <- list()
for(i in sheets){
  a = read_excel("Wego Bill Verification Vol. IV.xlsx", sheet=i, col_names = TRUE,
                 col_types = c("text", "date", "guess", "guess", "guess",
                               "guess", "guess", "guess", "guess", "guess",
                               "guess", "guess", "guess", "guess", "guess"))
  d = list.append(d,a)
}

new = rbindlist(d, fill = TRUE, use.names = TRUE, idcol = "ID")
setDT(new)
datr <- new[, c("Link", "Balance Forward", "Importer", "Reason for Edit", "If BF Removed, Why?", "Notes")]
setnames(datr, old = c("Link", "Balance Forward", "Importer", "Reason for Edit", "If BF Removed, Why?", "Notes"),
         new = c("Link", "BF", "Importer", "ReasonEdit", "BFWhy", "Notes"))
datr = datr[!is.na(BF),]
