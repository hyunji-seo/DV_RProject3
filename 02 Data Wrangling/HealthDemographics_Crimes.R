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

pj <- full_join(pdC, pdH, by="COMMUNITY_AREA") %>% mutate(BIRTHRATE_PERCENT = ntile(BIRTH_RATE, 100), TEEN_BIRTHRATE_PERCENT = ntile(TEEN_BIRTH_RATE, 100)) %>% select(PRIMARY_TYPE, BIRTH_RATE, TEEN_BIRTH_RATE, ASSAULT_HOMICIDE,BIRTHRATE_PERCENT, TEEN_BIRTHRATE_PERCENT) %>% arrange(PRIMARY_TYPE, BIRTHRATE_PERCENT, TEEN_BIRTHRATE_PERCENT) %>% filter(PRIMARY_TYPE %in% c("THEFT", "ASSAULT", "WEAPONS VIOLATION","SEX OFFENSE", "KIDNAPPING", "HUMAN TRAFFICKING", "OTHER NARCOTIC VIOLATION"))
#View(pj)

#Teen Birth Rate
ggplot() + 
  coord_cartesian() + 
  scale_x_continuous() +
  scale_y_continuous() +
  facet_wrap(~PRIMARY_TYPE) +
  labs(title='City of Chicago Health Demographics on Crime Rates (Teen)') +
  labs(x="TEEN_BIRTH_RATE", y=paste("ASSAULT_HOMICIDE")) +
  layer(data=pj, 
        mapping=aes(x=as.numeric(as.character(TEEN_BIRTH_RATE)), y=as.numeric(as.character(ASSAULT_HOMICIDE))),
        stat="boxplot", 
        stat_params=list(), 
        geom="boxplot",
        geom_params=list(color="black", fill="black", alpha=.1), 
        position=position_identity()
  )+
  layer(data=pj, 
        mapping=aes(x=as.numeric(as.character(TEEN_BIRTH_RATE)), y=as.numeric(as.character(ASSAULT_HOMICIDE)), color=PRIMARY_TYPE), 
        stat="identity",
        stat_params=list(),
        geom="point",
        geom_params=list(alpha=.8), 
        position=position_identity()
  )
#General Birth Rate
ggplot() + 
  coord_cartesian() + 
  scale_x_continuous() +
  scale_y_continuous() +
  facet_wrap(~PRIMARY_TYPE) +
  labs(title='City of Chicago Health Demographics on Crime Rates (General)') +
  labs(x="BIRTH_RATE", y=paste("ASSAULT_HOMICIDE")) +
  layer(data=pj, 
        mapping=aes(x=as.numeric(as.character(BIRTH_RATE)), y=as.numeric(as.character(ASSAULT_HOMICIDE))),
        stat="boxplot", 
        stat_params=list(), 
        geom="boxplot",
        geom_params=list(color="black", fill="black", alpha=.1), 
        position=position_identity()
  )+
  layer(data=pj, 
        mapping=aes(x=as.numeric(as.character(BIRTH_RATE)), y=as.numeric(as.character(ASSAULT_HOMICIDE)), color=PRIMARY_TYPE), 
        stat="identity",
        stat_params=list(),
        geom="point",
        geom_params=list(alpha=.8), 
        position=position_jitter(width=0, height=0)
  )
