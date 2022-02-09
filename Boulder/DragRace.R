

# ------------ rtweet Boulder

#  #DragRace tweets

library(rtweet)     # needed for Twitter API
library(tidyverse)  # for data manipulation
library(ggplot2)    # for plotting 
library(tidytext)   # for text analysis
library(ggraph)     # graphing words
library(showtext)   # for font styling
library(widyr)

# give your search_tweets() a variable

# DragRace_tweets = search_tweets2(
#   "#DragRace",         # hashtag we are interested in
#   n= 18000,            # max amount of tweets in 1 API request
#   lang = "en",         # English
#   include_rts = FALSE  # no retweets
# )

# --- save
# DragRace_tweets = write_as_csv(
#   DragRace_tweets,               # variable name used
#   file_name = "DragRace_tweets", # new variable name for CSV file
#   prepend_ids = TRUE,            # set to true 
#   na = "",
#   fileEncoding = "UTF-8"         # save file in UTF-8 
# )


# -- read 
DragRace_tweets = read_twitter_csv(file ="DragRace_tweets.csv" , unflatten = FALSE)


head(DragRace_tweets$text)


# ======== remove URLs
library(lexicon)
library(textclean)

# DragRace_tweets$stripped_text = replace_non_ascii2(DragRace_tweets$text)
# DragRace_tweets$stripped_text = gsub("http.*","", DragRace_tweets$text)

#  winning combo !
DragRace_tweets$stripped_text = replace_non_ascii2(DragRace_tweets$stripped_text)
DragRace_tweets$stripped_text = gsub("https*","", DragRace_tweets$stripped_text)

# head(DragRace_tweets$text)
head(DragRace_tweets$stripped_text)








# ===== tidytext::unnest_tokens()
clean_DragRace_tweets = DragRace_tweets %>% 
  select(stripped_text) %>% 
  unnest_tokens(word, stripped_text) # tokens

head(clean_DragRace_tweets)


# == plot, word counts of clean text  (stopwords included)
clean_DragRace_tweets %>% 
  count(word, sort= T) %>% 
  top_n(10) %>% 
  mutate(word= reorder(word, n))


clean_DragRace_tweets %>% 
  count(word, sort= T) %>% 
  top_n(20) %>% 
  mutate(word= reorder(word, n)) %>% 
  ggplot( aes(x= word, y= n))+
  geom_col(fill= "#d534eb")+
  # ggdark::dark_mode()+
  theme_light() +
  coord_flip()+
  labs(title = "Twitter tweet word counts for #DragRace",
       x="unique words",
       y= "Count")+
  theme(text = element_text(family = 'Poppins', size = 12))




# ========== tidytext stop_words + anti_join
clean_DragRace_words = clean_DragRace_tweets %>% 
  anti_join(stop_words)

clean_DragRace_words %>% 
  count(word, sort= T) %>% 
  top_n(10) %>%
  filter(word > 10)



# Tweet Word Counts - 1.3

clean_DragRace_words %>% 
  count(word, sort= T) %>% 
  top_n(40) %>%
  filter(word > 10) %>% 
  # filter(!word == c('s4','2',"i' \tm",'phi','e1','s4','2','e1','el','s2',"i'm")) %>%
  mutate(word = as_factor(word),
         word= reorder(word, n)) %>% 
  ggplot( aes(x= word, y= n))+
  geom_text( aes(label= n, vjust= .5, hjust= -1), color= 'black')+
  geom_col(fill= "#d534eb")+
  # ggdark::dark_mode()+
  theme_light() +
  coord_flip()+
  labs(title = "Twitter tweet word counts for #DragRace",
       subtitle = "top 40 words. Retweets excluded. N = 85,994",
       x="unique words",
       y= "Count",
  )+ 
  theme(
    text =  element_text(family = 'Poppins'),
    plot.title = element_text(size = 15, 
                              face = 'bold',
                              color ="#e757fa" ),
    axis.title = element_text(size = 13),
    axis.text = element_text(size = 12),
    plot.caption = element_text(color = 'grey40', hjust = 0)
  )



# bigram and n-grams

# ============= NETWORK OF WORDS !
library(widyr)

# bigrams. n-grams
DragRace_tweets_paired_words = DragRace_tweets %>% 
  select(stripped_text) %>% 
  unnest_tokens(paired_words, 
                stripped_text, 
                token= "ngrams",
                n = 2) # 2 for bigram pairing

DragRace_tweets_paired_words %>% 
  count(paired_words, sort = T) %>% 
  top_n(5)




# word pair splitting

# we now split the bigrams into n-gram

# ======== word pair splitting
library(tidyr)

DragRace_tweets_word_splits = DragRace_tweets_paired_words %>% 
  separate(paired_words, c('word1','word2'), sep = " ")

DragRace_tweets_filtered <- DragRace_tweets_word_splits %>%
  filter(!word1 %in% stop_words$word) %>%
  filter(!word2 %in% stop_words$word)

# new bigram counts:
DragRace_tweets_words_counts <- DragRace_tweets_filtered %>%
  count(word1, word2, sort = TRUE)

head(DragRace_tweets_words_counts)






DragRace_tweets_words_counts %>% 
  # words > 24
  filter(n >= 10) %>% 
  # graph_from_data_frame() %>% 
  ggraph(layout = "fr")+
  # ggdark::dark_mode()+
  theme_light()+
  geom_node_point(color="#e757fa", size=3)+
  geom_node_text( aes(label= name), vjust= 1.8, size= 4)+
  labs(title = "Twitter word network for #DragRace",
       subtitle = "Text Mining:  N= 22296 tweets, word counts >= 10",
       x="",
       y="",
  )+
  theme(text = element_text(family = 'Poppins', color='black'),
        plot.title = element_text(color = '#e757fa', size = 14),
        plot.caption = element_text(color = 'grey60', hjust = 0, size = 10)
  )




# pacman::p_load_gh(
#   "trinker/lexicon",    
#   "trinker/textclean"
# )












