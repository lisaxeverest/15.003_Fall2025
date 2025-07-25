# Session 1: Introduction to R + Data Wrangling/Visualization
# Thanks to Andrew Zheng for much of this example's content!

# Key Tools: tidyverse packages (dplyr, ggplot2)

## --------------------------------------------------------------------
################################ Agenda ###############################
## --------------------------------------------------------------------
# Part 1: Data cleaning and summarization in dplyr
# Part 2: dplyr Analysis Examples

# ---------------------------------------------------------------------
########### Part 1: Data cleaning and summarization in dplyr #########
# ---------------------------------------------------------------------

# As you navigate through the world of Analytics, You’ll also need to install some R packages.
# An R package is a collection of functions, data, and documentation that extends the
# capabilities of base R. Using packages is key to the successful use of R.
# R comes with a lot of packages preinstalled in your computer. To see a full list of all the 
# packages installed, click on the "Packages" tab at the bottom panel at the right of your screen.

# How do I install a new package in your machine:
# Option 1: with a command
install.packages("tidyverse")
# Option 2: via an interface: Click Packages at the right bottom panel > Install > type the name in the Packages line.

# Once a package is installed, you still need to load it in each session (but you do not need to re-install it):
library(tidyverse)

#' We just loaded "tidyverse", a master package that contains the most popular data packages,
#' dplyr and ggplot2 (with other useful packages too!)
#' We'll start with dplyr, is a super useful package created by Hadley Wickham that provides
#' several functions for efficiently "slicing-and-dicing" your data. A lot of these functions 
#' are similar to the logic that you use when creating pivot tables. We'll cover the basic 
#' functions: `select`, `filter`, `count`, `summarize`, `mutate`, `group_by`, and `arrange`. 
#' If you are interested in learning more, check out https://cran.r-project.org/web/packages/dplyr/dplyr.pdf.


# Next, load in the rental data (check your working directory!)
raw_listings <- read.csv('listings_clean.csv')

# Our traditional data viewing methods don't work well here--there are too many features and observations
str(raw_listings)
head(raw_listings)

# We will explore various ways to look at the data more easily using the dplyr functions.

##### SELECT function and introduction to "chaining" #####
# The select() function allows you to select a specific column (or set of columns)
# Here we select one column and look at the first few rows using head():

head(raw_listings$price)
head(select(raw_listings, price,bedrooms))

# This is fine, but it's a little awkward having to nest our code like that.  
# Luckily, there is a nifty operator included with tidyr called the **chaining operator** 
# which looks like `%>%` and serves like a pipeline from one function to another. 
# Specifically: `x %>% f` is the same as `f(x)`. In other words, the chaining operator feeds in the object 
# on its left as the first argument into the function on its right.
# You will see this syntax a lot with dplyr, so we'll try it out now. Now we can instead do this:
raw_listings %>% select(price, bedrooms) %>% head()

##### MUTATE function #######
#' The mutate() function allows us to create new columns by doing operations on existing ones.
#' In the listings data, we notice that the  prices are actually strings. 
#' If we want to work with these as numbers, we'll need to convert them. 
#' mutate() can help us here! We need to remove the "$" and "," from the price and then
#' convert it to a numeric variable. The gsub() function lets us strip out unwanted characters,
#' and then as.numeric() call lets us make the result into a number.

## Let's start by figuring out how to convert the prices to numbers. What do the prices look like?
example = raw_listings$price[1:5] # choose a small set of values to work with to see how this works
example 
gsub('[$,]', '', example) # gsub lets us  remove the $ and ,: we replace these both with '' (e.g. nothing)
as.numeric(gsub('[$,]', '', example)) # now that the rows "look like" numbers, we can convert them to numbers

## Now we can put this all together to create a new column in the listings column!
raw_listings %>% 
  mutate(price_numeric = as.numeric(gsub('[$,]', '', price))) %>% 
  select(name, price, price_numeric) %>%
  head()

#### COUNT function ####
#' The count() function gives us the count/length of a column.
#' Here we find how many listings there are with non-NA bedrooms files.
raw_listings %>% count(is.na(bedrooms))
count(raw_listings,  is.na(bedrooms))

# we can also look at the count of all bedrooms!
raw_listings %>% count(bedrooms)

#### FILTER function ####
#' The filter() function lets us filter to a subset of rows. We filter on conditions, just like with 
#' the subset() function.
#' Tip: You can filter using the `%in%` keyword to restrict to row values contained in a set.
## ------------------------------------------------------------------------
raw_listings %>% select(name, neighbourhood, price, bedrooms) %>%
  filter(bedrooms==4) %>% head()

## We could have done the same thing in base R:
head(subset(raw_listings[c("name","neighbourhood","price","bedrooms")], bedrooms == 4))

## Let's try using the %in% operator
## first, what are the unique neighborhoods?
unique(raw_listings$neighbourhood)

## we can restrict our data to look at a subset of this
raw_listings %>% select(name, neighbourhood, price, bedrooms) %>%
  filter(neighbourhood %in% c('Downtown', 'Back Bay', 'Chinatown'))

# Filter the listings to those that accommodate either 2, 4, or 7 AND have at least 2 bedrooms?	

raw_listings %>% filter(accommodates %in% c(2,4,7) & bedrooms >= 2) %>%
  select(id, neighbourhood, accommodates, bedrooms)


#' Note that the tidyverse packages generally do not change the dataframe objects they act on. 
#' For example, the code above doesn't change `listings`, but instead returns a new dataframe 
#' that has the same data as `listings`, plus an extra column. 
#' We could store it in a new variable using "=" or "<-".
#' We want to make sure our data has a correct price column and no missing bedroom or bathroom columns. 
#' We'll assign it to a dataframe named `listings`. 

listings <- raw_listings %>%
  filter(!is.na(bedrooms), !is.na(bathrooms)) %>%
  mutate(price = as.numeric(gsub('[$,]', '', price)), # we are now replacing the price column, not creating a new one
         cleaning_fee = as.numeric(gsub('[$,]', '', cleaning_fee)))

head(listings)

##### ARRANGE function #####
## The arrange() function lets us sort the data by a chosen column (or sets of columns)
## We can also sort this information by price using the arrange function. 
## If you want to sort in descending order, wrap the column name in desc()
listings %>%
  select(name, bedrooms, price) %>%
  arrange(desc(price),desc(bedrooms)) %>%
  head()

##### SUMMARISE function (for aggregation) #####
#' Now, how about a summary statistic, like the average price for a listing? 
#' Let's take our clean dataset and `summarize` it to find out.
listings %>% summarise(avg.price = mean(price))

#### GROUP_BY function ####
#' We can also run summary statistics by group, like a pivot table,
#' We first `group_by` a given variable, and then we summarize within each of the groups.
#' This is similar to creating a pivot table in Excel. 
listings %>%
  group_by(neighbourhood) %>%
  summarize(avg.price = mean(price),
            median.price = median(price))

#' Sort the property types in descending order by the number of people they accommodate.
#' Which has the highest average accommodation capacity?
#' Notice that once we create a column in the summarize() function, it's available later in the series of operations!

listings %>%
  group_by(property_type) %>% 
  summarize(avg.price = mean(price),
            avg.accommodates = mean(accommodates)) %>%
  arrange(desc(avg.accommodates))


##### JOIN functions #####
#' Our last topic will be how to **join** two data frames together. 
#' dplyr has several functions for joining: full_join, left_join, inner_join, etc.
#' They all follow the same syntax: full_join(table1, table2, by='name')
#' Here, you would be joining table1 and table2 on the name column. 
#' An inner_join only includes entries that have a matching row in both table1 and table2, 
#' left_join includes all table1 entries and joins table2 entries where there is a match, and
#' full_join will include all entries from both tables, matching where possible.

## Suppose we want to add in the median neighborhood price for each listing. We could do this as follows:
neighborhood_stats <- listings %>%
  group_by(neighbourhood) %>%
  summarise(median_price = median(price))

inner_join(listings, neighborhood_stats, by = 'neighbourhood') %>%
  select(name, neighbourhood, price, median_price)

## --------------------------------------------------------------------
################# Part 2: dplyr Analysis Examples ####################
## --------------------------------------------------------------------
#' Example 1: examining trends by neighborhood.
#' Suppose we're a little worried these averages are skewed by a few outlier listings.
#' Let's compare the average price, median price, and count of listings in each neighborhood. 
#' The `n()` function here just gives a count of how many rows we have in each group.
#' Notice that we can summarize multiple features at once using summarize().
listings %>%
  group_by(neighbourhood) %>%
  summarize(avg.price = mean(price),
            med.price = median(price),
            num = n())

#' We do notice some red flags to our "mean" approach.
#' 
#' PROBLEM 1: if there are a very small number of listings in a neighborhood compared to the rest of the dataset, 
#' we may worry we don't have a representative sample, or that this data point should be discredited somehow 
#' (on the other hand, maybe it's just a small neighborhood, like Bay Village, and it's actually outperforming 
#' expectation).
#' 
#' PROBLEM 2: if the *median* is very different than the *mean* for a particular neighborhood, 
#' it indicates that we have *outliers* skewing the average.  Because of those outliers, as a rule of thumb, 
#' means tend to be a misleading statistic to use with things like rent prices or incomes.

#' We can address this problem by filtering out 
#' neighborhoods below a threshold count using our new num 
#' variable. Extend the query above to filter to only 
#' neighborhoods with > 200 listings.

listings %>%
  group_by(neighbourhood) %>%
  summarize(avg.price = mean(price),
            med.price = median(price),
            num = n()) %>%
  filter(num > 200)


# Example 2: ratings summarized by the number of bedrooms
# What's new here? we are filtering out NA values.
# You will likely come across a lot of datasets with NAs and they can cause headaches.
# In this example, we are grouping listings together if they have the same review score, 
# and taking the median within the group. We also remove any NA values to get valid medians.
by.bedroom.rating <- listings %>%
  filter(!is.na(review_scores_rating)) %>%
  group_by(bedrooms, review_scores_rating) %>%
  summarize(med.price = median(price), listings = n())


## First, we'll re-load the data and convert strings to factors
raw_listings <- read.csv('listings_clean.csv', stringsAsFactors=TRUE)

listings <- raw_listings %>%
  filter(!is.na(bedrooms), !is.na(bathrooms)) %>%
  mutate(price = as.numeric(gsub('[$,]', '', price)), # we are now replacing the price column, not creating a new one
         cleaning_fee = as.numeric(gsub('[$,]', '', cleaning_fee)))


## --------------------------------------------------------------------
##################  Part III: Imputing Missing Data ######################
## --------------------------------------------------------------------
#' Now we are going to talk about approaches to handling missing data. Often the data you have at hand 
#' will contain missing values, or you create them when you merging datasets.

# Some algorithms can automatically work with missing data (CART, random forest).
# Some will need to exclude observations with missing data (logistic regression).

listings %>% select(name, review_scores_rating, reviews_per_month) %>% head()

# OPTION 1: Only include complete cases (i.e. no NAs in the row) # Warning: you are going to lose data!
listings_cc <- listings %>%
  filter(complete.cases(.))

listings_cc %>% select(name, review_scores_rating, reviews_per_month) %>% head()

# OPTION 2a: You can impute the values using median/mode value for each column
# Median/Mode Imputation is easy using a function in randomForest. 
# Imputes median for numerical columns, and mode for categorical columns
library(randomForest)
listings_imputeMedian <- na.roughfix(listings)
listings_imputeMedian %>% select(name, review_scores_rating, reviews_per_month) %>% head()

listings$reviews_per_month[is.na(listings$reviews_per_month)] = 0

# OPTION 2b: You can also impute the mean, but you can only do this for numerical columns.
# Let's try it on the review_scores_rating column
listings_imputeMean <- listings
listings_imputeMean$review_scores_rating[is.na(listings_imputeMean$review_scores_rating)] <- mean(listings_imputeMean$review_scores_rating, na.rm = TRUE)
listings_imputeMean %>% select(review_scores_rating, reviews_per_month) %>% head()


## --------------------------------------------------------------------
################### Closing Notes: General Tips #######################
## --------------------------------------------------------------------

# 1. How can I figure out the syntax or operations of a function?
# Suppose that you would like to figure out how to take the log base 10.
# You can directly use the help function:
help(log)
# Or you can just use the question mark before the function you are interested in
?log
# Look at the "Arguments" section to look at what kind of inputs the function takes.
# The "Details" section describes also the operations of the function.
# "Examples" will actually show you how to apply it.
# Another option is to just Google it!!
# How do we get then the log base 10?
log10(10)

# 2. What do I do if I get an error?
# First, do not panic! Coding is almost synonymous to debugging!
# You will learn more than what you expect by solving your errors.
# Try to understand the type of error that you encounter. 
# You will see a red message at the bottom of your console describing the error and the expression where it was encountered.

#Here is an example:
log("Maria")     
log(a)
# Object a is not found because it was not defined.
a = 10
log(a)

# Here are some common error messages
# "could not find function" errors, usually caused by typos or not loading a required package
# "Error in if" errors, caused by non-logical data or missing values passed to R's "if" conditional statement
# "Error in eval" errors, caused by references to objects that don't exist
# "cannot open" errors, caused by attempts to read a file that doesn't exist or can't be accessed
# "no applicable method" errors, caused by using an object-oriented function on a data type it doesn't support
# "subscript out of bounds" errors, caused by trying to access an element or dimension that doesn't exist
# package errors caused by being unable to install, compile or load a package.

# A link to the most common errors in R: https://www.r-bloggers.com/common-r-programming-errors-faced-by-beginners/

# 3. Where can I find help?
# There’s lots of information out there to help you decode your warning and error messages. 
# Here are some that I use all the time:
# Typing ? or ?? and the name of the function that’s going wrong in the console will give you help within R itself.
# Googling the error message, warning or package is often very useful
# Stack Overflow or the RStudio community forums can be searched for other people’s (solved!) problems
# Email us with questions if none of the above works!
