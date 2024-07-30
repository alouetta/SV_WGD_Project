## Script to create a pdf showing plot location coordinates onto a map. Created with the help of Stack overflow by V.Millar.

install.packages("ggplot2")
install.packages("maps")
install.packages("rnaturalearth")
install.packages("rnaturalearthdata")
install.packages("sf")

library(ggplot2)
library(maps)
library(rnaturalearth)
library(rnaturalearthdata)
library(sf)

world <- ne_countries(scale = "medium", returnclass = "sf")

# Filter for the countries of interest
countries <- world[world$sovereignt %in% c("Romania", "Poland", "Slovakia", "Hungary"), ]

# Calculate centroids for the country labels
countries_centroids <- st_centroid(countries)
countries_centroids <- st_coordinates(countries_centroids)
countries$centroid_lon <- countries_centroids[,1]
countries$centroid_lat <- countries_centroids[,2]


wgd_loc <- data.frame(
  ID = c("PHD",	"BAB",	"HNI",	"SNO",	"SZI",	"SUB"	,"TRD",	"VEL",	"ZEP","HLI",	"VSD",	"INE",	"HRA",	"KAM",	"PHT",	"SPI",	"TKO",	"TRE"	,"TRT",	"ZAP"),
  Latitude = c(48.95523	,49.043514,	48.8775,	49.17408333	,46.80667,	48.96030556	,49.250216	,49.162,	49.20652778	,49.17	,49.176168	,47.53931,	49.00716,	49.210747,	48.95523,	48.98296667	,49.204509,	48.894439	,49.250216	,49.278343),
  Longitude = c(20.4161,	20.180772	,20.5275	,18.8617	,17.43444,	20.38327778	,20.205255,	20.15419444,	20.21505556,	20.03	,20.149984	,24.88677,	20.286407,	20.928184	,20.4161,	20.77745,	19.735202,	18.04673,	20.205255,	19.96706),
  Color = c("orange", "blue", "green", "pink", "red", "yellow", "purple","red", "orange","white", "black", "turquoise","pink","brown","forestgreen","yellow", "red","navy", "blue","turquoise"),  # Add a color column
  Shape = c(19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 19, 18, 18, 18, 18, 18, 18, 18, 18, 18)
)


# Define the range of the axes to zoom into the area of interest
xlim_range <- c(16, 25)  # Longitude range
ylim_range <- c(46, 50)  # Latitude range



pdf(file="Map_WGD_zoom.pdf", 
    width = 7, height = 7, useDingbats = FALSE) 
# Plot the map
ggplot(data = countries) +
  geom_sf() +
  geom_point(data = wgd_loc, aes(x = Longitude, y = Latitude, color = Color, shape = factor(Shape)), size = 3 ) +
  geom_text(data = wgd_loc, aes(x = Longitude, y = Latitude, label = ID), vjust = -1, hjust = 1.5, color = "black", size = 2) +
  geom_text(data = countries, aes(x = centroid_lon, y = centroid_lat, label = sovereignt), color = "black", size = 4) +
  theme_classic() +
  scale_color_identity() + # This ensures the colors are taken directly from the data
  scale_shape_manual(name = "Ploidy", values = c(19, 18),labels =c("Tetraploid", "Diploid")) +
                       coord_sf(xlim = xlim_range, ylim = ylim_range)

dev.off()
