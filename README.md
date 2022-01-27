<img height="150" align="right" src="https://user-images.githubusercontent.com/55933131/143092473-835ce619-0b18-438f-b235-aee57209d52f.png">


# rtweet tutorial
Beginner intro to the R package rtweet for scraping the Twitter API for tweets

## RLadies Coventry meetup
- January 26, 2022
- [the RLadies meetup description](https://www.meetup.com/rladies-coventry/events/282268890/?rv=me1&_xtd=gatlbWFpbF9jbGlja9oAJGNhZTNiMGNkLTk0Y2UtNDM2Yy1iOTJkLWQwNjI3ODI1YTEwOA&_af=event&_af_eid=282268890)
- the Twitter datasets have been removed on Jan 27, 2022.

The link to my rtweet guide is [here](https://rtweetguide.netlify.app) which was the `learnr` file documentation/

## Quick rtweet guide

Here are some of the functions for getting started.

### Libraries
```
library(rtweet)
library(tidytext)  # text analysis and cleaning
library(ggplot2)   # plot your data
```

### Search Twitter

Give your search functions variables, avoid **rate limit** errors.
Maximum amount of tweets is 18,000 in a single API request and returns
tweets <= 9 days old.
```
searched_tweets = search_tweets(
 "rstats OR RStats",    # the #hashtag or phrase you want to search
 n = 4000,              # number of tweets to capture
 type = "recent",       # recent | mixed | popular
 include_rts = FALSE,   # no retweets
 verbose = TRUE,
 retryonratelimit = FALSE,    # set to true if you want it to run again
 lang = "en"            # English language tweets
)

```


### Save your Tweets

Saving your Tweets keeps you safe from **rate limit** errors.

```
save_as_csv( 
  searched_tweets,  # the name of your Twitter dataframe
  file_name = "new_twitter_df_name",
  prepend_ids = TRUE,
  na = " ",
  fileEncoding = "UTF-8"
)
```


### Read in your Twitter dataframe

```
twitter_df = read_twitter_csv(file = "<path>", unflatten= FALSE)
```






