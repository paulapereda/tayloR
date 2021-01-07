library(stm)
library(rsvd)
library(Rtsne)
library(scales) 
library(syuzhet)
library(geometry)
library(quanteda)
library(reshape2)
library(textdata)
library(tidytext) 
library(tidyverse)
library(wordcloud)
 
source("estilo_ts.R")

tidy_taylor <- read_rds("data/tidy_taylor.rds")

# (1) Visualising popular words

tidy_taylor %>%
  count(word, sort = TRUE) %>% 
  top_n(30) %>% 
  mutate(word = fct_reorder(word, n)) %>% 
  ggplot(aes(word, n)) +
  geom_col(fill = color2) +
  scale_y_continuous(expand = expansion(mult = c(0, 0)),
                     breaks = seq(0, 300, by = 100)) +
  geom_text(aes(label = n), position = position_stack(.92), color = "white") +
  coord_flip() +
  labs(x = "Palabra",
       y = "Número de veces utilizada", 
       title = "Palabras más utilizadas en la discografía de Taylor Swift",
       caption = "Fuente: elaboración propia en base a Genius.
                  Paula Pereda - @paubgood") +
  ggsave("plots/01_counting_words.png", dpi = 300, width = 12, height = 7)

# (2) Positive & negative words (doesn't work!... yet)

negvspos <- tidy_taylor %>%
  inner_join(get_sentiments("bing")) %>%
  count(word, sentiment, sort = TRUE) %>%
  reshape2::acast(word ~ sentiment, value.var = "n", fill = 0) %>%
  wordcloud::comparison.cloud(colors = c(lover3, lover1), 
                              random.order = FALSE,
                              title.size = 1.5, 
                              max.words = 200, 
                              scale = c(5, .5))

# (3) Words important to Taylor Swift albums

tswift_tf_idf <- tidy_taylor %>%
  count(album, word, sort = TRUE) %>%
  bind_tf_idf(word, album, n) %>%
  arrange(- tf_idf) %>%
  filter(!(word %in% c("fore", "iwish"))) %>% 
  group_by(album) %>%
  top_n(10) %>%
  ungroup 

tswift_tf_idf %>%
  filter(!(word %in% c("cardigan", "hush", "lakes", "mirrorball", "serve", 
                       "tallest", "tiptoes", "flush", "double", "careless", "careful"))) %>% 
  mutate(word = reorder_within(word, tf_idf, album)) %>%
  ggplot(aes(word, tf_idf, fill = album)) +
  geom_col(show.legend = FALSE) +
  scale_fill_manual(values = c(color1, color2, color3, color4, color5, color6, color7, color8, color9)) +
  facet_wrap(~ album, scales = "free", ncol = 3) +
  scale_x_reordered() +
  scale_y_continuous(expand = expansion(mult = c(0, 0))) +
  coord_flip() +
  theme(strip.text = element_text(size = 11)) +
  labs(x = NULL, 
       y = "tf-idf",
       title = "Palabras importantes en los álbums de Taylor Swift",
       caption = "Fuente: elaboración propia en base a Genius.
                  Paula Pereda - @paubgood") +
  ggsave("plots/02_important_words.png", dpi = 300, width = 12, height = 7)


# (4) Hey kids, topic modelling is fun!

# What’s a topic model? What we’re doing here is asking R to try and group words together into ‘topics’ of
# words that it think belongs together.
# 
# On the topic_model line of code, you’ll see that I’ve set K = 9. K is the number of topics you think 
# will exist in a text - it’s very subjective. If you haven’t a clue how many topics there may be, you can
# set K = 0 and it’ll try to figure it out for you. In my experience, when I’m running lyric analysis
# K = 0 usually gives me a topic for almost every song. Since we know there are 9 albums, I’ve just set 
# K = 9. What this means is we can figure out if a particular word is associated with belonging to a 
# certain album.


tswift_dfm <- tidy_taylor %>%
  count(album, word, sort = TRUE) %>%
  cast_dfm(album, word, n)

topic_model <- stm(tswift_dfm, K = 8, verbose = FALSE, init.type = "Spectral")
summary(topic_model)

tswift_beta <- tidy(topic_model)

tswift_beta %>%
  group_by(topic) %>%
  top_n(10, beta) %>%
  ungroup() %>%
  mutate(topic = paste0("Tema ", topic),
         term = reorder_within(term, beta, topic)) %>%
  ggplot(aes(term, beta, fill = as.factor(topic))) +
  geom_col(show.legend = FALSE) +
  scale_fill_manual(values = c(color1, color2, color3, color4, color5, color6, color7, color8)) +
  facet_wrap(~ topic, scales = "free_y",  ncol = 4) +
  coord_flip() +
  scale_x_reordered() +
  labs(x = NULL, 
       y = expression(beta),
       title = "Palabras que probablemente pertenezcan a un tema",
       subtitle = "Aquí, cada tema parece representar bastante bien un álbum (o sister álbums).",
       caption = "Fuente: elaboración propia en base a Genius.
                  Paula Pereda - @paubgood") +
  ggsave("plots/03_topic_modelling.png", dpi = 300, width = 12, height = 7)

# (5) Emotions in Taylor Swift songs

lyrics <- as.character(tidy_taylor)
lyrics_sentiment <- get_nrc_sentiment((lyrics))

sentimentscores <- data.frame(colSums(lyrics_sentiment[,]))   

names(sentimentscores) <- "Score"
sentimentscores <- cbind("sentiment" = rownames(sentimentscores), sentimentscores)

ggplot(sentimentscores, aes(reorder(sentiment, Score), Score)) +
  geom_bar(aes(fill = sentiment), stat = "identity", show.legend = FALSE) +
  scale_fill_manual(values = c(color1, color2, color3, color4, color5, 
                               color6, color7, color8, color9, color10)) +
  scale_y_continuous(expand = expansion(mult = c(0, 0))) +
  labs(x = "Emociones & sentimientos", 
       y = "Puntajes", 
       title = "Emociones en la discografía de Taylor Swift",
       caption = "Fuente: elaboración propia en base a Genius.
                  Paula Pereda - @paubgood") +
  theme(panel.grid.major.x = element_blank(),
        panel.grid.minor.x = element_blank(),
        axis.line.x = element_line(),
        axis.ticks.x = element_line()) +
  ggsave("plots/04_emotions.png", dpi = 300, width = 12, height = 7)


# The highest scores are for positive and negative sentiment - not surprising because for every break-up or 
# angry song T-Swift has, she also has some great ones about friendship, memories, and love. This plot shows 
# us what we already know, which is that she covers a good range of emotions fairly equally. Though, I was 
# surprised to see that fear was the highest ranking emotion amongst her lyrics. I wanted to take a look into
# what these words were, as fear isn’t something I had thought of as a common emotion in her songs.


# (6) Songs and sentiment
## Let’s go one step further and look at which songs are associated with each emotion. Any predictions?

word_count <- tidy_taylor %>% 
  count(track_title)

lyric_counts <- tidy_taylor %>%
  left_join(word_count, by = "track_title") %>%
  rename(total_words = n)

lyric_sentiment <- tidy_taylor %>%
  inner_join(get_sentiments("nrc"), by = "word")

lyric_sentiment2 <- lyric_sentiment %>%
  count(track_title, sentiment, sort = TRUE)  %>% 
  group_by(sentiment) %>%
  top_n(5) 

lyric_sentiment2 <- lyric_sentiment2[-c(54), ]  
lyric_sentiment2 <- lyric_sentiment2[-c(54), ] 
lyric_sentiment2 <- lyric_sentiment2[-c(30), ] 
lyric_sentiment2 <- lyric_sentiment2[-c(40), ] 
lyric_sentiment2 <- lyric_sentiment2[-c(38), ] 
lyric_sentiment2 <- lyric_sentiment2[-c(45), ] 


lyric_sentiment2 %>% 
  ggplot(aes((sub(track_title, pattern = "(\\w{20}).*", replacement = "\\1.")), 
             x = reorder(track_title, n), y = n, fill = sentiment)) +
  geom_bar(stat = "identity", show.legend = FALSE) +
  scale_fill_manual(values = c(color1, color2, color3, color4, color5, 
                               color6, color7, color8, color9, color10)) +
  scale_y_continuous(expand = expansion(mult = c(0, 0))) +
  facet_wrap(~ sentiment, scales = "free", ncol = 2) +
    labs(x = "Emociones & sentimientos", 
         y = "Puntajes",
         title = "Canciones y las emociones & sentimientos con los que están asociadas",
         caption = "Fuente: elaboración propia en base a Genius.
                  Paula Pereda - @paubgood") +
  coord_flip() + 
  ggsave("plots/05_emotions_track.png", dpi = 300, width = 12, height =  9)


# (7) Sentiment and albums
# Let’s go even further and look at which albums are associated with emotions. I think this one will be 
# harder because her albums generally have a mix of emotions. Even reputation, which is supposed to be the 
# angriest and most pissed she’s ever been does have some happy songs on it.

lyric_sentiment %>%
  count(album, sentiment, sort = TRUE) %>%
  group_by(sentiment) %>%
  top_n(n = 5) %>%
  ggplot(aes((sub(album, pattern = "(\\w{20}).*", replacement = "\\1.")), 
             x = reorder(album, n), y = n, fill = sentiment)) +
  geom_bar(stat = "identity", show.legend = FALSE) +
  scale_fill_manual(values = c(color1, color2, color3, color4, color5, 
                               color6, color7, color8, color9, color10)) +
  scale_y_continuous(expand = expansion(mult = c(0, 0))) +
  facet_wrap(~ sentiment, scales = "free") +
  labs(x = "Emociones & sentimientos",
       y = "Puntaje",
       title = "Álbums y las emociones & sentimientos con los que están asociadas",
       caption = "Fuente: elaboración propia en base a Genius.
                  Paula Pereda - @paubgood") +
  coord_flip() + 
  ggsave("plots/06_emotions_albums.png", dpi = 300, width = 12.3, height =  9)

