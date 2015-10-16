#Using one ETL File per CSV, change your measures AND change dfS to be dfC for crimes dfS for Socioeconomic etc...
require(tidyr)
require(dplyr)
require(ggplot2)

#setwd("C:\\Users\\hyunji\\Documents\\DataVisualization\\DV_RProject3\\01 Data\\CSVs")

file_path <- "Chicago_Socioeconomic.csv"

dfS <- read.csv(file_path, stringsAsFactors = FALSE)

# Replace "." (i.e., period) with "_" in the column names.
names(dfS) <- gsub("\\.+", "_", names(dfS))

str(dfS) # Uncomment this and  run just the lines to here to get column types to use for getting the list of measures.

measures <- c("Community_Area", "PERCENT_OF_HOUSING_CROWDED", "PERCENT_HH_BELOW_POVERTY", "PERCENT_AGED_16_UNEMPLOYED", "PERCENT_AGED_25_WO_HS_DIPLOMA", "PERCENT_AGED_UNDER_18_OVER_64", "PER_CAPITA_INCOME", "HARDSHIP_INDEX")
#measures <- NA # Do this if there are no measures.

# Get rid of special characters in each column.
# Google ASCII Table to understand the following:
for(n in names(dfS)) {
  dfS[n] <- data.frame(lapply(dfS[n], gsub, pattern="[^ -~]",replacement= ""))
}

dimensions <- setdiff(names(dfS), measures)
if( length(measures) > 1 || ! is.na(dimensions)) {
  for(d in dimensions) {
    # Get rid of " and ' in dimensions.
    dfS[d] <- data.frame(lapply(dfS[d], gsub, pattern="[\"']",replacement= ""))
    # Change & to and in dimensions.
    dfS[d] <- data.frame(lapply(dfS[d], gsub, pattern="&",replacement= " and "))
    # Change : to ; in dimensions.
    dfS[d] <- data.frame(lapply(dfS[d], gsub, pattern=":",replacement= ";"))
  }
}

# The following is an example of dealing with special cases like making state abbreviations be all upper case.
# df["State"] <- data.frame(lapply(df["State"], toupper))

# Get rid of all characters in measures except for numbers, the - sign, and period.dimensions
if( length(measures) > 1 || ! is.na(measures)) {
  for(m in measures) {
    dfS[m] <- data.frame(lapply(dfS[m, ], gsub, pattern="[^--.0-9]",replacement= ""))

  }
}

write.csv(dfS, paste(gsub(".csv", "", file_path), ".reformatted.csv", sep=""), row.names=FALSE, na = "")

tableName <- gsub(" +", "_", gsub("[^A-z, 0-9, ]", "", gsub(".csv", "", file_path)))
sql <- paste("CREATE TABLE", tableName, "(\n-- Change table_name to the table name you want.\n")
if( length(measures) > 1 || ! is.na(dimensions)) {
  for(d in dimensions) {
    sql <- paste(sql, paste(d, "varchar2(4000),\n"))
  }
}
if( length(measures) > 1 || ! is.na(measures)) {
  for(m in measures) {
    if(m != tail(measures, n=1)) sql <- paste(sql, paste(m, "number(38,4),\n"))
    else sql <- paste(sql, paste(m, "number(38,4)\n"))
  }
}
sql <- paste(sql, ");")
cat(sql)
