require("jsonlite")
require("RCurl")

#Gather data from database fill into local data frame and retrieve headers and summary 
dfHlth <- data.frame(fromJSON(getURL(URLencode('129.152.144.84:5001/rest/native/?query="select * from Chicago_HealthDemographics"'),httpheader=c(DB='jdbc:oracle:thin:@129.152.144.84:1521/PDBF15DV.usuniversi01134.oraclecloud.internal', USER='cs329e_rm46926', PASS='orcl_rm46926', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE), ))

head(dfHlth)
summary(dfHlth)


