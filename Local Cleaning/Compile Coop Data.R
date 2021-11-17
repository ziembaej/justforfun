library(data.table)
library(openxlsx)
library(readxl)
library(tidyverse)
library(rlist)
# path = "/Users/eric.ziemba/Downloads/Wego Bill Verification Vol. III.xlsx"
# listsheets = list(excel_sheets(path))
# 
# dt = read_excel(path, sheet = "Instructions")
# 
# df = data.frame()
# setDT(df)
# df[, `:=`(Link = "",
#           Invoice_Date = as.Date(1),
#           Created_at = as.Date(1),	
#           Amount_Due = as.numeric(1),
#           "# Lines" = as.numeric(0),
#           Balance_Forward = as.character(x),
#           Negative_Line_Item	Summary	ECM	Importer	Need to Check	Checked	Reason for Edit	If BF Removed, Why?	
#             Notes = as.character(a)]

path <- "/Users/eric.ziemba/Downloads/"
# set the working directory 
setwd(path)

# accessing all the sheets 
sheets = excel_sheets("Wego Bill Verification Vol. IV.xlsx")
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

