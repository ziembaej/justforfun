library(data.table)
library(openxlsx)
library(readxl)
library(tidyverse)
library(rlist)
library(lubridate)

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
datr <- new[, c("Link", "Created at", "Balance Forward", "Importer", "Reason for Edit", "If BF Removed, Why?", "Notes")]
setnames(datr, old = c("Link",  "Created at", "Balance Forward", "Importer", "Reason for Edit", "If BF Removed, Why?", "Notes"),
         new = c("Link",  "bill_created","BF", "Importer", "ReasonEdit", "BFWhy", "Notes"))
datr = datr[!is.na(BF),]

datr[,  bill_created_month := floor_date(as.Date(bill_created, format ="YYYY-MM-DD"), unit = "month")]



datr[, ct :=1]
imps <- datr[, .(imp_ct = sum(ct, na.rm=T)) , keyby = Importer]
imp2 <- imps[imp_ct>50,]

reasons <- datr[!is.na(ReasonEdit), .(count = sum(ct, na.rm=T)), keyby = .(Importer, BFWhy, Notes) ]

late <- datr[str_detect(BFWhy, regex("late", ignore_case = TRUE)), 
             .(count = sum(ct, na.rm=T)), keyby = .(bill_created_month, Importer, BFWhy, Notes) ]

late_w_links <- datr[str_detect(BFWhy, regex("late", ignore_case = TRUE)),] 

  
  