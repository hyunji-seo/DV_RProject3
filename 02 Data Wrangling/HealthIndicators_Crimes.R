require(tidyr)
require(dplyr)
require(extrafont)
require(ggplot2)

# Uncomment the following to view the original data
#tbl_df(dfHlth)
#View(dfHlth)

pdH <- dfHlth
pdC <- dfCr
summary(pdH)
summary(pdC)
dplyr::full_join(pdC, pdH, by="COMMUNITY_AREA") %>% View()

