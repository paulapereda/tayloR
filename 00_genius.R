library(tidyverse) 
library(genius) 
library(tidytext) 

# (1) Downloading the lyrics with the Genius package

## (a) First, downloading each TS album

## Taylor Swift 

ts1 <- genius_album(artist = "Taylor Swift", album = "Taylor Swift") %>%
  mutate(album = "Taylor Swift")

ttwas <- genius_url("https://genius.com/Taylor-swift-tied-together-with-a-smile-lyrics") %>%
  mutate(album = "Taylor Swift",
         track_n = 7)

iomwiwy <- genius_url("https://genius.com/Taylor-swift-im-only-me-when-im-with-you-lyrics") %>%
  mutate(album = "Taylor Swift",
         track_n = 12)

ts1 <- rbind(ts1, ttwas, iomwiwy)

write_rds(ts1, "data/ts1.rds")

## Fearless

ts2 <- genius_album(artist = "Taylor Swift", album = "Fearless") %>%
  mutate(album = "Fearless") 

f <- genius_url("https://genius.com/Taylor-swift-fearless-lyrics") %>%
  mutate(album = "Fearless",
         track_n = 1)

ls <- genius_url("https://genius.com/Taylor-swift-love-story-lyrics") %>%
  mutate(album = "Fearless",
         track_n = 3)

ybwm <- genius_url("https://genius.com/Taylor-swift-you-belong-with-me-lyrics") %>%
  mutate(album = "Fearless",
         track_n = 6)

b <- genius_url("https://genius.com/Taylor-swift-breathe-lyrics") %>%
  mutate(album = "Fearless",
         track_n = 7)

tmw <- genius_url("https://genius.com/Taylor-swift-tell-me-why-lyrics") %>%
  mutate(album = "Fearless",
         track_n = 8)

yns <- genius_url("https://genius.com/Taylor-swift-youre-not-sorry-lyrics") %>%
  mutate(album = "Fearless",
         track_n = 9)

fna <- genius_url("https://genius.com/Taylor-swift-forever-and-always-lyrics") %>%
  mutate(album = "Fearless",
         track_n = 11)

ts2 <- rbind(ts2, f, ls, ybwm, b, tmw, yns, fna)

write_rds(ts2, "data/ts2.rds")

## Speak Now

ts3 <- genius_album(artist = "Taylor Swift", album = "Speak Now") %>%
  mutate(album = "Speak Now")

dj <- genius_url("https://genius.com/Taylor-swift-dear-john-lyrics") %>%
  mutate(album = "Speak Now",
         track_n = 5)

m <- genius_url("https://genius.com/Taylor-swift-mean-lyrics") %>%
  mutate(album = "Speak Now",
         track_n = 6)

ngu <- genius_url("https://genius.com/Taylor-swift-never-grow-up-lyrics") %>%
  mutate(album = "Speak Now",
         track_n = 8)

e <- genius_url("https://genius.com/Taylor-swift-enchanted-lyrics") %>%
  mutate(album = "Speak Now",
         track_n = 9)

btr <- genius_url("https://genius.com/Taylor-swift-better-than-revenge-lyrics") %>%
  mutate(album = "Speak Now",
         track_n = 10)

o <- genius_url("https://genius.com/Taylor-swift-ours-lyrics") %>%
  mutate(album = "Speak Now",
         track_n = 15)

itwam <- genius_url("https://genius.com/Taylor-swift-if-this-was-a-movie-lyrics") %>%
  mutate(album = "Speak Now",
         track_n = 16)

s <- genius_url("https://genius.com/Taylor-swift-superman-lyrics") %>%
  mutate(album = "Speak Now",
         track_n = 17)

ts3 <- rbind(ts3, dj, m, ngu, e, btr, o, itwam, s)

write_rds(ts3, "data/ts3.rds")

## Red

ts4 <- genius_album(artist = "Taylor Swift", album = "Red") %>%
  mutate(album = "Red")

t <- genius_url("https://genius.com/Taylor-swift-treacherous-lyrics") %>%
  mutate(album = "Red",
         track_n = 3)

atw <- genius_url("https://genius.com/Taylor-swift-all-too-well-lyrics") %>%
  mutate(album = "Red",
         track_n = 5)

iad <- genius_url("https://genius.com/Taylor-swift-i-almost-do-lyrics") %>%
  mutate(album = "Red",
         track_n = 7)

sss <- genius_url("https://genius.com/Taylor-swift-stay-stay-stay-lyrics") %>%
  mutate(album = "Red",
         track_n = 9)

hg <- genius_url("https://genius.com/Taylor-swift-holy-ground-lyrics") %>%
  mutate(album = "Red",
         track_n = 11)

tlo <- genius_url("https://genius.com/Taylor-swift-the-lucky-one-lyrics") %>%
  mutate(album = "Red",
         track_n = 13)

ba <- genius_url("https://genius.com/Taylor-swift-begin-again-lyrics") %>%
  mutate(album = "Red",
         track_n = 16)

ts4 <- rbind(ts4, t, atw, iad, sss, hg, tlo, ba)

write_rds(ts4, "data/ts4.rds")

## 1989

ts5 <- genius_album(artist = "Taylor Swift", album =  "1989") %>%
  mutate(album = "1989")

s <- genius_url("https://genius.com/Taylor-swift-style-lyrics") %>%
  mutate(album = "1989",
         track_n = 3)

sog <- genius_url("https://genius.com/Taylor-swift-i-wish-you-would-lyrics") %>%
  mutate(album = "1989",
         track_n = 7)

iad <- genius_url("https://genius.com/Taylor-swift-clean-lyrics") %>%
  mutate(album = "1989",
         track_n = 13)

tlo <- genius_url("https://genius.com/Taylor-swift-wonderland-lyrics") %>%
  mutate(album = "1989",
         track_n = 14)

ba <- genius_url("https://genius.com/Taylor-swift-you-are-in-love-lyrics") %>%
  mutate(album = "1989",
         track_n = 15)

ts5 <- rbind(ts5, ba)

write_rds(ts5, "data/ts5.rds")

## Reputation

ts6 <- genius_album(artist = "Taylor Swift", album = "Reputation") %>%
  mutate(album = "Reputation")

rfi <- genius_url("https://genius.com/Taylor-swift-ready-for-it-lyrics") %>%
  mutate(album = "Reputation",
         track_n = 1)

idsb <- genius_url("https://genius.com/Taylor-swift-i-did-something-bad-lyrics") %>%
  mutate(album = "Reputation",
         track_n = 3)

dbm <- genius_url("https://genius.com/Taylor-swift-dont-blame-me-lyrics") %>%
  mutate(album = "Reputation",
         track_n = 4)

lwymd <- genius_url("https://genius.com/Taylor-swift-look-what-you-made-me-do-lyrics") %>%
  mutate(album = "Reputation",
         track_n = 6)

ciwyw <- genius_url("https://genius.com/Taylor-swift-call-it-what-you-want-lyrics") %>%
  mutate(album = "Reputation",
         track_n = 14)

ts6 <- rbind(ts6, rfi, idsb, dbm, lwymd, ciwyw)

write_rds(ts6, "data/ts6.rds")

## Lover

ts7 <- genius_album(artist = "Taylor Swift", album = "Lover") %>%
  mutate(album = "Lover")

iftye <- genius_url("https://genius.com/Taylor-swift-i-forgot-that-you-existed-lyrics") %>%
  mutate(album = "Lover",
         track_n = 1)

ithk <- genius_url("https://genius.com/Taylor-swift-i-think-he-knows-lyrics") %>%
  mutate(album = "Lover",
         track_n = 6)

cs <- genius_url("https://genius.com/Taylor-swift-cornelia-street-lyrics") %>%
  mutate(album = "Lover",
         track_n = 9)

fg <- genius_url("https://genius.com/Taylor-swift-false-god-lyrics") %>%
  mutate(album = "Lover",
         track_n = 13)

d <- genius_url("https://genius.com/Taylor-swift-daylight-lyrics") %>%
  mutate(album = "Lover",
         track_n = 18)

ts7 <- rbind(ts7, iftye, ithk, cs, fg, d)

write_rds(ts7, "data/ts7.rds")

## folklore

ts8 <- genius_album(artist = "Taylor Swift", album = "folklore") %>%
  mutate(album = "folklore")

c <- genius_url("https://genius.com/Taylor-swift-cardigan-lyrics") %>%
  mutate(album = "folklore",
         track_n = 2)

m <- genius_url("https://genius.com/Taylor-swift-mirrorball-lyrics") %>%
  mutate(album = "folklore",
         track_n = 6)

s <- genius_url("https://genius.com/Taylor-swift-seven-lyrics") %>%
  mutate(album = "folklore",
         track_n = 7)

timt <- genius_url("https://genius.com/Taylor-swift-this-is-me-trying-lyrics") %>%
  mutate(album = "folklore",
         track_n = 9)

ia <- genius_url("https://genius.com/Taylor-swift-illicit-affairs-lyrics") %>%
  mutate(album = "folklore",
         track_n = 10)

h <- genius_url("https://genius.com/Taylor-swift-hoax-lyrics") %>%
  mutate(album = "folklore",
         track_n = 16)

tl <- genius_url("https://genius.com/Taylor-swift-the-lakes-lyrics") %>%
  mutate(album = "folklore",
         track_n = 17)

ts8 <- rbind(ts8, c, m, s, timt, ia, h, tl)

write_rds(ts8, "data/ts8.rds")

## evermore

ts9 <- genius_album(artist = "Taylor Swift", album = "evermore") %>%
  mutate(album = "evermore")

w <- genius_url("https://genius.com/Taylor-swift-willow-lyrics") %>%
  mutate(album = "evermore",
         track_n = 1)

gr <- genius_url("https://genius.com/Taylor-swift-gold-rush-lyrics") %>%
  mutate(album = "evermore",
         track_n = 3)

i <- genius_url("https://genius.com/Taylor-swift-ivy-lyrics") %>%
  mutate(album = "evermore",
         track_n = 10)

lss <- genius_url("https://genius.com/Taylor-swift-long-story-short-lyrics") %>%
  mutate(album = "evermore",
         track_n = 12)

c <- genius_url("https://genius.com/Taylor-swift-closure-lyrics") %>%
  mutate(album = "evermore",
         track_n = 14)

e <- genius_url("https://genius.com/Taylor-swift-evermore-lyrics") %>%
  mutate(album = "evermore",
         track_n = 15)


ts9 <- rbind(ts9, w, gr, i, lss, c, e)

write_rds(ts9, "data/ts9.rds")

## (b) Putting all together in the same df

ts <- rbind(ts1, ts2, ts3, ts4, ts5, ts6, ts7, ts8, ts9)

## (c) Patterns to be removed from the data

remove.list <- paste(c("Demo Recording", "Voice Memo", "Pop Version", "Acoustic Version"), collapse = '|')

## (d) Applying the changes

ts <- ts %>%
  filter(!grepl(remove.list, track_title)) 

## (e) Just in case: save!

write_rds(ts, "data/ts_genius.rds")

# (2) Tidying up the lyrics

## (a) Tokenizing our data:

ts_tok <- ts %>%
  # word is the new column, lyric the column to retrieve the information from
  unnest_tokens(word, lyric)

ts_tok %>%
  count(word, sort = TRUE) 

## (b) Tidying our data:

tidy_taylor <- ts_tok %>%
  anti_join(stop_words) %>%
  filter(!(word %in% c("ooh", "yeah", "ah", "uh", "ha", "whoa", "eh", "hoo", "ey", "mmm", "ayy",
                      "eeh", "huh", "na", "di", "la", "da", "em", "ya", "ra", "ho", "mm", "ahh",
                      "woo", "aah", "20", "haa"))) %>% 
  filter(!is.na(word)) %>% 
  mutate(album = factor(album, levels = c("Taylor Swift", "Fearless", "Speak Now", "Red", "1989",
                                          "Reputation", "Lover", "folklore", "evermore")))

write_rds(tidy_taylor, "data/tidy_taylor.rds")

## Comentario final: el paquete 'genius' no baja todas las canciones del álbum que se le indica, por lo que
## tuve que bajar esas canciones a mano y joinearlas. El comportamiento de qué canciones no descarga, 
## parece ser aleatorio.
