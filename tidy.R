library(gutenbergr)
library(magrittr)
library(tidyverse)
library(tnum)
library(tidytext)
library(RColorBrewer)
library(wordcloud)
library(sentimentr)
library(grid)
library(gtable)
library(gridExtra)
library(reshape2)


data <- gutenberg_download(c(244))

# make the text tidy (have excluded stop words)
scarlet <- data %>%
  mutate(linenumber = row_number(),
         chapter = cumsum(str_detect(text, regex("^chapter [\\divxlc]",
                                                 ignore_case = TRUE)))) %>%
  unnest_tokens(word, text) %>%
  anti_join(stop_words)


# graph the frequencies of words which shows up more than 30 times
count <- scarlet %>% count(word, sort=T) %>% mutate(word = reorder(word, n))
count30 <- filter(count, n > 30)
count30 %>% ggplot(mapping=aes(n, word)) + geom_col(aes(fill = word), show.legend = F) +
  labs(y = NULL, x = 'count', title = 'words with the top occurrence') + geom_text(aes(label=n))


# make a cloud graph for word occurrence frequency
cloud1 <- count30 %>% with(wordcloud(word, n, max.words = 1000, random.order = F))

# make a cloud graph for sentiments occurrence frequency using bing lexicon
cloud2 <- scarlet %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE) %>%
  acast(word ~ sentiment, value.var = "n", fill = 0) %>%
  comparison.cloud(colors = c("gray20", "gray80"),
                   max.words = 30)




# do the sentiment analysis using NRC lexicon
nrc <- get_sentiments('nrc')
scarlet_nrc <- inner_join(scarlet, nrc) %>% mutate(index = linenumber %/% 80)
count_nrc <- scarlet_nrc %>% count(sentiment, sort=T) %>% mutate(sentiment = reorder(sentiment, n))
c1 <- count_nrc %>% ggplot(mapping=aes(x = n, y = sentiment)) + geom_col(aes(fill = sentiment)) + labs(y = NULL) +
  geom_text(aes(label=n)) + labs(y = 'sentiment categories' , x = 'count', title = 'nrc lexicon')

index_nrc <- scarlet_nrc %>% group_by(index)
s1 <- ggplot(data = index_nrc, mapping = aes(x=index)) + geom_bar(aes(fill = sentiment)) +
  labs(title='the nrc lexicon sentiment contents across the article', x = 'chunks', y = 'count')

# do the sentiment analysis using Bing lexicon
bing <- get_sentiments('bing')
scarlet_bing <- inner_join(scarlet, bing) %>% mutate(index = linenumber %/% 80)
count_bing <- scarlet_bing %>% count(sentiment, sort=T) %>% mutate(sentiment = reorder(sentiment, n))
c2 <- count_bing %>% ggplot(mapping=aes(x = sentiment, y = n)) + geom_col(aes(fill = sentiment)) + labs(y = NULL) +
  geom_text(aes(label=n)) + labs(y = 'count', x = NULL, title = 'bing lexicon')

index_bing <- scarlet_bing %>% group_by(index) %>%
              mutate(whether = ifelse(sentiment == 'positive', 1, -1)) %>% 
              summarize(value = sum(whether))
s2 <- ggplot(data = index_bing, mapping = aes(x=index, y=value)) + geom_col(aes(fill=index), show.legend = F) +
  labs(title='the bing lexicon sentiment scores across the article', x = 'chunks', y = 'score') +
  geom_smooth(se = F, color='orange', size = 1.5)


# do the sentiment analysis using afinn
afinn <- get_sentiments('afinn')
scarlet_afinn <- inner_join(scarlet, afinn) %>% mutate(index = linenumber %/% 80)
count_afinn <- scarlet_afinn %>% count(value, sort=T) %>% mutate(value = reorder(value, n))
c3 <- count_afinn %>% ggplot(mapping=aes(x = n, y = value)) + geom_col(aes(fill = value)) + labs(y = NULL) +
  geom_text(aes(label=n)) + labs(x = 'count', y = 'sentiment score', title = 'afinn lexicon')

index_afinn <- scarlet_afinn %>% group_by(index) %>% summarize(value = sum(value))
s3 <- ggplot(data = index_afinn, mapping = aes(x=index, y=value)) + geom_col(aes(fill=index), show.legend = F) +
  labs(title='the afinn lexicon sentiment scores across the article', x = 'chunks', y = 'score') + 
  geom_smooth(se = F, color='orange', size = 1.5)



#put the three lexicon count graph together
grid.arrange(c1, c2, c3, ncol = 2)
# put the three lexicon sentiments flows across the article
grid.arrange(s1, s2, s3, ncol = 2)

# Part three
## first create my own branch for the text into the mssp server
source('Book2TN-v6A-1.R')
tnum.authorize('mssp1.bu.edu') # get the access of the server
tnum.setSpace("test2") # use the test2 space of the server
scarlet_txt <- readLines("a_study_in_scarlet.txt")
tnBooksFromLines(scarlet_txt, 'xihao/hw4_v2')  # use the Book2Tn to digest
tnum.getDBPathList(taxonomy = 'subject', level = 1) # check the branch in server

tqury <- function(word, n) {
  q1 <- tnum.query(query = word, max = n)
  return(tnum.objectsToDf(q1))
}

# query the data in sentence level
all_ord <- tqury("xihao/hw4_v2/# has ordinal", 15000)
all_text <- tqury("xihao/hw4_v2/# has text", 15000)
all_head <- tqury("xihao/hw4_v2/heading# has text", 15000)

all_comb <- left_join(select(all_text, subject, string.value), 
                      select(all_ord, subject, numeric.value))

all_sent_score <- get_sentences(all_comb)
all_sent_score <- sentiment(all_sent_score)

all_sent_score <- all_sent_score %>% mutate(index = numeric.value %/% 10)

all_sent_score %>% group_by(index) %>% summarize(score = sum(sentiment, na.rm = T)) %>% 
  ggplot(aes(x = index, y = score)) + geom_col(aes(fill = index), show.legend = F) +
  labs(x = NULL, y = 'sentiment score', title = 'sentiment score across the article')


test1 <- tqury("xihao/hw4_v2/section:# has *", 150)

q1 <- tnum.query("xihao/hw4_v2/# has *", max = 15)
q2 <- tnum.objectsToDf(q1)




