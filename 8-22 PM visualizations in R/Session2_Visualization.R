## --------------------------------------------------------------------
################## Part 3: Plotting in ggplot2 #######################
## --------------------------------------------------------------------
#' 
#' `ggplot2` provides a unifying approach to graphics, similar to what we've 
#' begun to see with tidyr. 
#' (https://www.cs.uic.edu/~wilkinson/TheGrammarOfGraphics/GOG.html)
#' 
#' Every ggplot consists of three main elements:
#' - **Data**: The dataframe we want to plot.
#' - **Aes**thetics: The dimensions we want to plot, e.g. x, y, color, size, shape.
#' - **Geom**etry:  The specific visualization shape. Line plot, scatter plot, 
#' bar plot, etc.

## If you have loaded tidyverse(), you don't need to load ggplot2 separately. 
# If not, make sure to load it here.
# install.packages('ggplot2')
library(ggplot2)
library(dplyr)
#### Creating a basic plot. ####
# Suppose we want to plot our bedroom rating data from earlier. How should we do that?
#' We must specify all three key elements here: our Data (`by.bedroom.rating`), 
#' our Aesthetic mapping (`x` and `y` to columns of the data), and our desired 
#' Geometry (`geom_point`). We glue everything together with `+` signs.   

raw_listings <- read.csv('listings_clean.csv')
listings <- raw_listings %>%
  filter(!is.na(bedrooms), !is.na(bathrooms)) %>%
  mutate(price = as.numeric(gsub('[$,]', '', price)), 
         # we are now replacing the price column, not creating a new one
         cleaning_fee = as.numeric(gsub('[$,]', '', cleaning_fee)))


by.bedroom.rating <- listings %>%
  filter(!is.na(review_scores_rating)) %>%
  group_by(bedrooms, review_scores_rating) %>%
  summarize(med.price = median(price), listings = n())

by.bedroom.rating %>%
  ggplot(aes(x=review_scores_rating, y=med.price)) +
  geom_point()

## Reminder: before, we would have done this using:
plot(by.bedroom.rating$review_scores_rating, by.bedroom.rating$med.price)

#' We can use the aesthetics to add a lot more detail to our charts. Suppose we 
#' want to see these points broken out by the number of bedrooms. Let's color 
#' these points by the number of bedrooms by specifying which variable to use 
#' to determine the color of each point.
by.bedroom.rating %>%
  ggplot(aes(x=review_scores_rating, y=med.price, color=factor(bedrooms))) +
  geom_point()
# Note that `factor` essentially tells ggplot to treat `bedrooms` as categorical 
# rather than numeric.


# We can also use geoms to layer additional plot types on top of each other.
# In the following example, we throw in a linear best-fit line for each bedroom class. 
# Note that the same x, y, and color aesthetics propagate through all the geoms.
by.bedroom.rating %>%
  ggplot(aes(x=review_scores_rating, y=med.price, color=factor(bedrooms))) +
  geom_point() +
  geom_smooth(method = lm)

#### Bar Plots: another type of geometry ####
# We use the (`geom_bar`) geometry for plotting bar charts.

# Let's save the summary of neighborhoods by prices so that we can plot it.
by.neighbor <- listings %>%
  group_by(neighbourhood) %>%
  summarize(med.price = median(price))

# We use `stat='identity'` to tell `geom_bar` that we want the height of the bar 
# to be equal to the `y` value. 
by.neighbor %>%
  ggplot(aes(x=neighbourhood, y=med.price)) +
  geom_bar(stat='identity') + 
  theme(axis.text.x=element_text(angle=60, hjust=1)) 
# This rotates the labels on the x-axis so we can read them

# We can make this better! Let's add some color and titles, and reorder the entries 
# to be in descending price order. hjust = 1 horizontally justifies the rotated text 
# to the right. This means that the right side of the text will be aligned with the 
# tick mark on the x-axis.
by.neighbor %>%
  ggplot(aes(x=reorder(neighbourhood, -med.price), y=med.price)) +
  geom_bar(fill='dark blue', stat='identity') +
  theme(axis.text.x=element_text(angle=60, hjust=1)) +
  labs(x='', y='Median price', title='Median daily price by neighborhood')

#### Heatmaps #### 
# A useful geometry for displaying heatmaps in `ggplot` is `geom_tile`. 
# This is typically used when we have data grouped by two different variables, 
# and so we need visualize in 2d. For example, try using `geom_tile` to 
# visualize median price grouped by # bedrooms and bathrooms. You can also 
# change the color scale so that it runs between two colors by adjusting a 
# `scale_fill_gradient` theme:

listings %>%
  group_by(bedrooms, bathrooms) %>%
  summarize(med = median(price)) %>%
  ggplot(aes(x=bedrooms, y=bathrooms, fill=med)) +
  geom_tile() + 
  scale_fill_gradient(low = "white", high = "steelblue") +
  labs(x='Bedrooms', y='Bathrooms', fill='Median price', 
       title = "Comparison of Price")

#### Plotting Distributions ####
# We can pick out a few of these high end neighborhoods and plot a more 
# detailed view of the distribution of price. Two common ways to look at 
# distributions are boxplots and cumulative distribution plots.

# Option 1 - Boxplots: A boxplot shows the 25th and 75th percentiles 
# (top and bottom of the box), the 50th percentile or median (thick middle line), 
# the max/min values (top/bottom vertical lines), and outliers (dots). We see 
# that there are extreme outliers ($3000 per night!!). If we add in
# neighborhood information, we can see that the distributions are quite different 
# (such as Back Bay which has a "heavy tail" of expensive properties) 
listings %>% 
  filter(neighbourhood %in% c('South Boston Waterfront', 'Allston','Back Bay')) %>%
  filter(price < 2000) %>%
  ggplot(aes(x=factor(bedrooms), y=price)) +
  facet_grid(.~neighbourhood) +
  geom_boxplot()

# Option 2 - Cumulative Distribution (CDF) `stat_ecdf` plots the CDF of 
# (i.e. percentiles vs. values) of vectors, which gives you a lot more 
# information about the distribution at the expense of being a bit harder to read.
# Let's plot the distribution of price by number of bedrooms, and use 
# `coord_cartesian` to limit the x-axis range.
listings %>%
  ggplot(aes(price, color=factor(bedrooms))) +
  stat_ecdf() +
  coord_cartesian(xlim = c(0, 1000))

library(hrbrthemes)
library(tidyr)
library(viridis)
# You can also directly put the dataset name inside the specification
# With transparency (right)
transparency <- ggplot(data=listings, aes(x=price, group=factor(bedrooms),
                                          fill=factor(bedrooms))) +
  geom_density(alpha=.4) +
  theme_ipsum()
transparency

# What do you notice here?:
# - Prices cluster around multiples of $50 (look for the vertical lines). 
#   Maybe people should be differentiating on price more!
# - Low-end zero-bedroom units are cheaper than low-end one-bedroom units, 
#   but one-bedroom units are cheaper at the high end. 

#### Saving a plot
# You can use the "Plots" frame (lower right) to flip back through all the 
# plots you've created 
# in the session (arrows), "Zoom" in on plots, and "Export" to save (to a PDF, 
# image, or just to the clipboard).

#' EXERCISE: Explore the Airbnb listings data. Suppose you are thinking about 
#' investing in a property. You have to decide what neighborhood and property 
#' type to buy, what amenities to offer, and how to price your listing. 
#' Use ggplot2 and dplyr to start wrangling the data to inform your 
#' decision process.


#' We will also take a look at some even more examples (quickly)
# https://r-graph-gallery.com/
# https://r-graph-gallery.com/web-scatterplot-corruption-and-human-development.html
# https://r-graph-gallery.com/48-grouped-barplot-with-ggplot2.html
# https://r-graph-gallery.com/257-input-formats-for-network-charts.html
# https://r-graph-gallery.com/311-add-labels-to-hierarchical-edge-bundling.html


# Advanced R plots
# Example credits to https://r-graph-gallery.com/
library(ggiraph) # install.packages('ggiraph')
library(ggplot2) # install.packages('ggplot2')
library(dplyr) # install.packages('dplyr')
library(patchwork) # install.packages('patchwork')
library(tidyr) # install.packages('tidyr')
library(sf) # install.packages('sf')
set.seed(123)

# Read the full world map
world_sf <- read_sf("https://raw.githubusercontent.com/holtzy/R-graph-gallery/master/DATA/world.geojson")
world_sf <- world_sf %>%
  filter(!name %in% c("Antarctica", "Greenland"))

# Create a sample dataset
happiness_data <- data.frame(
  Country = c(
    "France", "Germany", "United Kingdom",
    "Japan", "China", "Vietnam",
    "United States of America", "Canada", "Mexico"
  ),
  Continent = c(
    "Europe", "Europe", "Europe",
    "Asia", "Asia", "Asia",
    "North America", "North America", "North America"
  ),
  Happiness_Score = rnorm(mean = 30, sd = 20, n = 9),
  GDP_per_capita = rnorm(mean = 30, sd = 20, n = 9),
  Social_support = rnorm(mean = 30, sd = 20, n = 9),
  Healthy_life_expectancy = rnorm(mean = 30, sd = 20, n = 9)
)

# Join the happiness data with the full world map
world_sf <- world_sf %>%
  left_join(happiness_data, by = c("name" = "Country"))


# Create the first chart (Scatter plot)
#' tooltip = name: This specifies that when you hover over a point on the plot, 
#' the name of the corresponding country will be displayed as a tooltip.
#' We also want to further filters out any rows where the Happiness Score is 
#' missing 
p1 <- ggplot(world_sf, aes(
  GDP_per_capita,
  Happiness_Score,
  tooltip = name,
  data_id = name,
  color = name
)) +
  geom_point_interactive(data = filter(world_sf, !is.na(Happiness_Score)), size = 4) +
  theme_minimal() +
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    legend.position = "none"
  )

#' We can also try some other themes (theme_light(), theme_dark()), and 
p1_v2 <- ggplot(world_sf, aes(
  GDP_per_capita,
  Happiness_Score,
  tooltip = name,
  data_id = name,
  color = name
)) +
  geom_point_interactive(data = filter(world_sf, !is.na(Happiness_Score)), size = 4) +
  theme_classic() +
  theme(
    axis.title.x = element_text(size = 14, face = "bold"),
    axis.title.y = element_blank(),
    legend.position = "top"
  )
p1_v2

# Create the second chart (Bar plot)
p2 <- ggplot(world_sf, aes(
  x = reorder(name, Happiness_Score),
  y = Happiness_Score,
  tooltip = name,
  data_id = name,
  fill = name
)) +
  geom_col_interactive(data = filter(world_sf, !is.na(Happiness_Score))) +
  coord_flip() +
  theme_minimal() +
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    legend.position = "none"
  )

# Create the third chart (choropleth)
p3 <- ggplot() +
  geom_sf(data = world_sf, fill = "lightgrey", color = "lightgrey")
p3

# Step 2: add the countries with happiness scores
p3 <- ggplot() +
  geom_sf(data = world_sf, fill = "lightgrey", color = "lightgrey")+
  geom_sf_interactive(
    data = filter(world_sf, !is.na(Happiness_Score)),
    aes(fill = name, tooltip = name, data_id = name)
  )
p3

# Step 3: specifies the coordinate reference system (CRS) to be used for the plot.
p3 <- ggplot() +
  geom_sf(data = world_sf, fill = "lightgrey", color = "lightgrey")+
  geom_sf_interactive(
    data = filter(world_sf, !is.na(Happiness_Score)),
    aes(fill = name, tooltip = name, data_id = name)
  ) +
  coord_sf(crs = st_crs(3857))
p3


# Step 4: Remove the background
p3 <- ggplot() +
  geom_sf(data = world_sf, fill = "lightgrey", color = "lightgrey")+
  geom_sf_interactive(
    data = filter(world_sf, !is.na(Happiness_Score)),
    aes(fill = name, tooltip = name, data_id = name)
  ) +
  coord_sf(crs = st_crs(3857)) + 
  theme_void()
p3


# Step 5: Remove the legends
p3 <- ggplot() +
  geom_sf(data = world_sf, fill = "lightgrey", color = "lightgrey") +
  geom_sf_interactive(
    data = filter(world_sf, !is.na(Happiness_Score)),
    aes(fill = name, tooltip = name, data_id = name)
  ) +
  coord_sf(crs = st_crs(3857)) +
  theme_void() +
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    legend.position = "none"
  )
p3

# Combine the plots
combined_plot <- (p1 + p2) / p3 + plot_layout(heights = c(1, 2))

# Create the interactive plot
interactive_plot <- girafe(ggobj = combined_plot)
interactive_plot <- girafe_options(
  interactive_plot,
  opts_hover(css = "fill:red;stroke:black;")
)

# save as an html widget
htmltools::save_html(interactive_plot, "interactive_map.html")


