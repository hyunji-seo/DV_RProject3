#Using one ETL File per CSV, change your measures AND change dfC to be dfC for crimes dfS for Socioeconomic etc...
require(tidyr)
require(dplyr)
require(ggplot2)

#setwd("C:\\Users\\hyunji\\Documents\\DataVisualization\\DV_RProject3\\01 Data\\CSVs")

file_path <- "Chicago_Crimes.csv"

dfC <- read.csv(file_path, stringsAsFactors = FALSE)

# Replace "." (i.e., period) with "_" in the column names.
names(dfC) <- gsub("\\.+", "_", names(dfC))

str(dfC) # Uncomment this and  run just the lines to here to get column types to use for getting the list of measures.

#measures <- c("ID", "Beat", "District", "Ward", "Community_Area", "X_Coordinate", "Y_Coordinate", "Year", "Latitude", "Longitude")
measures <- NA # Do this if there are no measures.

# Get rid of special characters in each column.
# Google ASCII Table to understand the following:
for(n in names(dfC)) {
  dfC[n] <- data.frame(lapply(dfC[n], gsub, pattern="[^ -~]",replacement= ""))
}

dimensions <- setdiff(names(dfC), measures)
if( length(measures) > 1 || ! is.na(dimensions)) {
  for(d in dimensions) {
    # Get rid of " and ' in dimensions.
    dfC[d] <- data.frame(lapply(dfC[d], gsub, pattern="[\"']",replacement= ""))
    # Change & to and in dimensions.
    dfC[d] <- data.frame(lapply(dfC[d], gsub, pattern="&",replacement= " and "))
    # Change : to ; in dimensions.
    dfC[d] <- data.frame(lapply(dfC[d], gsub, pattern=":",replacement= ";"))
  }
}

# The following is an example of dealing with special cases like making state abbreviations be all upper case.
# df["State"] <- data.frame(lapply(df["State"], toupper))

# Get rid of all characters in measures except for numbers, the - sign, and period.dimensions
if( length(measures) > 1 || ! is.na(measures)) {
  for(m in measures) {
    dfC[m] <- data.frame(lapply(dfC[m, ], gsub, pattern="[^--.0-9]",replacement= ""))

  }
}

write.csv(dfC, paste(gsub(".csv", "", file_path), ".reformatted.csv", sep=""), row.names=FALSE, na = "")

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
