require(tidyr)
require(dplyr)
require(extrafont)
require(ggplot2)

# Summarize crimes by community area
ndfCr <- dfCr %>% group_by(COMMUNITY_AREA,PRIMARY_TYPE) %>% summarise(CRIME_COUNT = n())

# Re-order safety levels
dfPS$SAFETY_LEVEL <- factor(dfPS$SAFETY, c("Very Weak","Weak", "Average", "Strong", "Very Strong", "NDA"))

# Join
dfCrPS <- inner_join(dfPS, ndfCr, by = c("COMMUNITY_AREA"="COMMUNITY_AREA")) %>% select(PRIMARY_TYPE, SAFETY_LEVEL, MISCONDUCT_RATE, CRIME_COUNT) %>% filter(PRIMARY_TYPE == "NARCOTICS")

#Create the Point Plot
ggplot() + 
  coord_cartesian() + 
  scale_x_discrete() +
  scale_y_continuous() +
  # facet_grid(PR.) +
  labs(title='Public School Safety Rating and Misconduct Rate with Narcotic Abuse in the Community Area') +
  labs(x="Safety Rating", y=paste("Misconduct Rate (Per 1000 Students)")) +
  layer(data=dfCrPS, 
        mapping=aes(x=as.character(SAFETY_LEVEL), y=as.numeric(MISCONDUCT_RATE), color=SAFETY_LEVEL),
        stat="identity",
        stat_params=list(),
        geom="point",
        geom_params=list(alpha=.55), 
        position=position_jitter(width=0.2)
  )
