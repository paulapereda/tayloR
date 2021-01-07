library(widyr)
library(igraph)
library(ggraph)
library(scales)
library(tidytext) 
library(tidyverse)

tidy_taylor <- read_rds("data/tidy_taylor.rds")

tay_cors <- tidy_taylor %>%
  pairwise_cor(track_title, word, sort = TRUE) %>% 
  mutate(abs_corr = abs(correlation))

set.seed(1989)

tay_cors %>%
  filter(abs_corr > .13) %>%
  graph_from_data_frame() %>%
  ggraph(layout = "fr") +
  geom_edge_link(show.legend = FALSE, aes(edge_alpha = correlation)) +
  geom_node_point(color = color2, size = 5) +
  geom_node_text(aes(label = name), repel = TRUE, size = 3.5, color = "grey40") +
  theme(plot.title = element_text(hjust = .5),
        plot.subtitle = element_text(hjust = .5),
        plot.caption = element_text(hjust = 1)) +
  labs(title = "Análisis de redes entre canciones de Taylor Swift",
       caption = "Fuente: elaboración propia en base a Genius.
                  Paula Pereda - @paubgood") +
  ggsave("plots/07_graphs.png", dpi = 300, width = 12, height = 7)
