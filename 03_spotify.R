library(tidyverse)
library(spotifyr)

source("estilo_ts.R")
# source("token.R")
# 
# ts_spotify <- get_artist_audio_features('taylor swift') %>% 
#   filter(album_id %in% c("7mzrIsaAjnXihW3InKjlC3", "1rwH2628RIOVM3WMwwO418", "5MfAxS5zz8MlfROjGQVXhy", 
#                          "1EoDsNmgTLtmwe1BDAVxV5", "2QJmrSgbdM35R67eoGQo4j", "6DEjYFkNZh67HP7R9PSZvv", 
#                          "1NAmidJlEaVgA3MpcPFYGq", "2fenSS68JI1h4Fo296JfGr", "2Xoteh7uEpea4TohMxjtaq")) %>% 
#   select(artist_name, album_release_year, danceability, energy, key, loudness, mode, speechiness, 
#            acousticness, instrumentalness, liveness, valence, tempo, duration_ms, explicit, track_name,
#            track_number, album_name, key_name, mode_name) %>% 
#   filter(track_name != "Teardrops on My Guitar - Pop Version") %>% 
#   mutate(track_name = ifelse(track_name == "Teardrops On My Guitar - Radio Single Remix", 
#                                            "Teardrops On My Guitar", track_name),
#          album_name = factor(album_name, levels = c("Taylor Swift", "Fearless", "Speak Now", "Red", 
#                                                     "1989", "reputation", "Lover", "folklore", "evermore")))
# 
# write_rds(ts_spotify, "data/ts_spotify.rds"

ts_spotify <- read_rds("data/ts_spotify.rds")

# (1) Average length of a song on the album

taylor_mean_length <- ts_spotify %>% 
  group_by(album_name) %>% 
  select(album_name, duration_ms) %>% 
  summarise(length1 = mean(duration_ms)) %>% 
  mutate(length2 = length1/1000) %>% 
  mutate(length = round(length2/60, 2)) %>% 
  select(length, album_name) %>% 
  arrange(desc(-length)) %>% 
  mutate(album_name = factor(album_name, levels = c("Taylor Swift", "Fearless", "Speak Now", "Red", 
                                                    "1989", "reputation", "Lover", "folklore", 
                                                    "evermore")))

taylor_mean_length %>%
  ggplot(aes(reorder(album_name, length), length, fill = album_name)) +
  geom_col() +
  coord_flip() +
  scale_fill_manual(values = c(color1, color2, color3, color4, color5, color6, color7, color8, color9)) +
  scale_y_continuous(expand = expansion(mult = c(0, 0))) +
  theme(legend.position = "none",
        axis.title.y = element_blank()) + 
  labs(x = "Álbum", 
       y = "", 
       title = "Duración promedio de las canciones de Taylor Swift",
       caption = "Fuente: elaboración propia en base a Spotify
                  Paula Pereda - @paubgood - paulapereda.com") +
  ggsave("plots/08_length.png", dpi = 300, width = 12, height = 7)

# (2) Danceability of albums

ggplot(ts_spotify, aes(danceability, y = album_name)) +
  ggjoy::geom_joy_gradient(scale = 1, fill = color2, alpha = .8) +
  theme(legend.position = "none",
        axis.title.y = element_blank()) +
  xlim(0, 1) +
  scale_x_continuous(expand = expansion(mult = c(0, 0))) +
  scale_y_discrete(expand = expansion(mult = c(0, .1))) +
  labs(x = "Bailabilidad",
       y = "Álbum",
       title = "Bailabilidad de las canciones de Taylor Swift",
       caption = "Fuente: elaboración propia en base a Spotify
                  Paula Pereda - @paubgood - paulapereda.com") +
  ggsave("plots/09_danceability.png", dpi = 300, width = 12, height = 7)

ts_spotify %>% 
  group_by(album_name) %>% 
  select(album_name, danceability) %>% 
  summarise(DanceAbility = mean(danceability)) %>% 
  arrange(desc(DanceAbility))

ts_spotify %>% 
  group_by(album_name) %>% 
  summarise(mean(valence)) %>% 
  arrange(desc(`mean(valence)`))

ggplot(ts_spotify, aes(x = valence, y = album_name)) + 
  ggjoy::geom_joy_gradient(scale = 1, fill = color2, alpha = .8) +
  theme(legend.position = "none",
        axis.title.y = element_blank()) +
  scale_x_continuous(limits = c(0, 1),
                     expand = expansion(mult = c(0, 0))) +
  scale_y_discrete(expand = expansion(mult = c(0, 0))) +
  labs(x = "Valencia",
       y = "Álbum",
       title = "Valencia de las canciones de Taylor Swift",
       caption = "Fuente: elaboración propia en base a Spotify
                  Paula Pereda - @paubgood - paulapereda.com") +
  ggsave("plots/09_valencia.png", dpi = 300, width = 13, height = 7)
