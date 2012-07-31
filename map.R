library(ggmap)
library(maptools)
library(raster)

gpclibPermit()

data <- read.csv2("data/schulpreis.csv")

data <- cbind(data, geocode(as.character(data$Ort)))
data$Jahr <- factor(data$Jahr)

save(data, file = "data/schulpreis.RData")

map <- getData("GADM", country="Germany", level = 1)

map_2 <- fortify(map, region = "NAME_1")

plot <- ggplot(map_2, aes(long, lat)) + geom_path(aes(group = group), colour = "grey60")
plot <- plot + geom_point(data = data, aes(x = lon, y = lat, colour = Jahr, shape = Preisart, size = 5), alpha = 0.75)
plot <- plot + scale_fill_brewer("Set1", breaks = c(2006,2007,2008,2010,2011,2012))
plot <- plot + coord_map() + theme_bw() + scale_shape_manual(values=c(17,16))
plot <- plot + scale_x_continuous("", breaks=NULL) + scale_y_continuous("", breaks=NULL)
plot <- plot + opts(legend.position = "none")
plot

png(filename="plots/map.png", width=700, height=900, res=100)
plot
dev.off()