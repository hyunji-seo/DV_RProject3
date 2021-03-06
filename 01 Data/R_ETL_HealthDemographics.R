#Using one ETL File per CSV, change your measures AND change dfH to be dfC for crimes dfS for Socioeconomic etc...
require(tidyr)
require(dplyr)
require(ggplot2)

#setwd("C:\\Users\\hyunji\\Documents\\DataVisualization\\DV_RProject3\\01 Data\\CSVs")

file_path <- "Chicago_HealthDemographics.csv"

dfH <- read.csv(file_path, stringsAsFactors = FALSE)

# Replace "." (i.e., period) with "_" in the column names.
names(dfH) <- gsub("\\.+", "_", names(dfH))

#str(dfH) # Uncomment this and  run just the lines to here to get column types to use for getting the list of measures.

measures <- c("Community_Area", "Birth_Rate", "General_Fertility_Rate", "Low_Birth_Weight", "Prenatal_Care_First_Trimester", "Preterm_Births", "Teen_Birth_Rate", "Assault_Homicide", "Breast_Cancer_Fem", "Cancer_All_Sites", "Colorectal_Cancer", "Diabetes_related", "Firearm_related", "Inf_Mort_Rate", "Lung_Cancer","Prostate_Cancer_M", "Stroke_Cerebrovascular_Disease", "Child_Blood_Lv_Screening", "Child_Lead_Poisoning", "Tuberculosis", "Below_Poverty_Level", "Crowded_Housing", "Dependency", "No_HS_Diploma", "Per_Capita_Income", "Unemployment")
#measures <- NA # Do this if there are no measures.

# Get rid of special characters in each column.
# Google ASCII Table to understand the following:
for(n in names(dfH)) {
  dfH[n] <- data.frame(lapply(dfH[n], gsub, pattern="[^ -~]",replacement= ""))
}

dimensions <- setdiff(names(dfH), measures)
if( length(measures) > 1 || ! is.na(dimensions)) {
  for(d in dimensions) {
    # Get rid of " and ' in dimensions.
    dfH[d] <- data.frame(lapply(dfH[d], gsub, pattern="[\"']",replacement= ""))
    # Change & to and in dimensions.
    dfH[d] <- data.frame(lapply(dfH[d], gsub, pattern="&",replacement= " and "))
    # Change : to ; in dimensions.
    dfH[d] <- data.frame(lapply(dfH[d], gsub, pattern=":",replacement= ";"))
  }
}

# The following is an example of dealing with special cases like making state abbreviations be all upper case.
# df["State"] <- data.frame(lapply(df["State"], toupper))

# Get rid of all characters in measures except for numbers, the - sign, and period.dimensions
if( length(measures) > 1 || ! is.na(measures)) {
  for(m in measures) {
    dfH[m] <- data.frame(lapply(dfH[m], gsub, pattern="[^--.0-9]",replacement= "x"))

  }
}

write.csv(dfH, paste(gsub(".csv", "", file_path), ".reformatted.csv", sep=""), row.names=FALSE, na = "")

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
