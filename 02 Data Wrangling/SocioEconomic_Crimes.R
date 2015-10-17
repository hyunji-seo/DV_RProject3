require(tidyr)
require(dplyr)
require(extrafont)
require(ggplot2)

ndfCr <- dfCr %>% group_by(PRIMARY_TYPE, COMMUNITY_AREA) %>% summarise(COUNT = n()) %>% arrange(COMMUNITY_AREA)
#View(ndfCr)

pdC <- ndfCr
pdS <- dfSocio
ndf<- dplyr::right_join(pdC, pdS, by="COMMUNITY_AREA")
SEC <- ndf%>%  filter(PRIMARY_TYPE=='BATTERY' | PRIMARY_TYPE=='BURGLARY' | PRIMARY_TYPE=='CRIMINAL DAMAGE' | PRIMARY_TYPE=='DECEPTIVE PRACTICE' | PRIMARY_TYPE=='NARCOTICS' | PRIMARY_TYPE =='OTHER OFFENSE' | PRIMARY_TYPE=='ROBBERY' | PRIMARY_TYPE=='THEFT') 
ggplot() + 
  coord_cartesian() + 
  scale_x_discrete() +
  scale_y_continuous() +
  labs(title='Chicago Data') +
  labs(x=paste("Type of Crime"), y=("Community Area Number"), color=("Hardship Index")) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1)) +
  layer(data=SEC, 
        mapping=aes(x=as.character(PRIMARY_TYPE), y=as.numeric(COMMUNITY_AREA), color=HARDSHIP_INDEX),
        stat="identity",
        stat_params=list(),
        geom="point",
        geom_params=list(),
        position=position_jitter(width=0.2, height=0)
  )
