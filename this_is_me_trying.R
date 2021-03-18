# library
library(tidyverse)
source("estilo_ts.R")

# Create dataset
data <- read_rds("data/ts_spotify.rds") %>% 
  filter(album_name %in% c("folklore", "evermore")) %>% 
  select(album_name, track_name, track_number, key_name, mode_name, duration_ms) %>% 
  mutate(album_name = factor(album_name, levels = c("folklore", "evermore")),
         key_name = factor(key_name, 
                           levels = c("A", "A#", "B", "C", "C#","D", "D#", "E", "F", "F#", "G", "G#"),
                           labels = c("LA", "LA#", "SI", "DO", "DO#","RE", "RE#", "MI", "FA", "FA#",
                                      "SOL", "SOL#")),
         mode_name = factor(mode_name, levels = c("major", "minor"), labels = c("Mayor", "Menor")),
         duration_ms = duration_ms/1000/60, 
         track_name = case_when(
           track_name == "evermore (feat. Bon Iver)" ~ "evermore",
           track_name == "exile (feat. Bon Iver)" ~ "exile",
           track_name == "no body, no crime (feat. HAIM)" ~ "no body, no crime",
           track_name == "coney island (feat. The National)" ~ "coney island",
           T ~ track_name)) %>% 
  arrange(album_name, track_name) %>% 
  select(- album_name, - track_number)

# Set a number of 'empty bar' to add at the end of each group
empty_bar <- 3
to_add <- data.frame(matrix(NA, empty_bar*nlevels(data$key_name), ncol(data)))
colnames(to_add) <- colnames(data)
to_add$key_name <- rep(levels(data$key_name), each = empty_bar)
data <- rbind(data, to_add)
data <- data %>% arrange(key_name)
data$id <- seq(1, nrow(data))

# Get the name and the y position of each label
label_data <- data
number_of_bar <- nrow(label_data)
angle <- 90 - 360 * (label_data$id-0.5) /number_of_bar     # I substract 0.5 because the letter must have the angle of the center of the bars. Not extreme right(1) or extreme left (0)
label_data$hjust <- ifelse( angle < -90, 1, 0)
label_data$angle <- ifelse(angle < -90, angle+180, angle)

# prepare a data frame for base lines
base_data <- data %>% 
  group_by(key_name) %>% 
  summarize(start = min(id), 
            end = max(id) - empty_bar) %>% 
  rowwise() %>% 
  mutate(title = mean(c(start, end)))

# prepare a data frame for grid (scales)
grid_data <- base_data
grid_data$end <- grid_data$end[c( nrow(grid_data), 1:nrow(grid_data)-1)] + 1
grid_data$start <- grid_data$start - 1
grid_data <- grid_data[-1,]

# Make the plot
ggplot(data, aes(as.factor(id), duration_ms, fill = key_name)) +       
  # Note that id is a factor. If x is numeric, there is some space between the first bar
       geom_bar(aes(as.factor(id), duration_ms, fill = key_name), stat = "identity", alpha = .5) +
  # Add a val=1/2/3/4/5 lines. I do it at the beginning to make sur barplots are OVER it.
       geom_segment(data = grid_data, aes(x = end, y = 5, xend = start, yend = 5), colour = "grey", alpha = 1, size = .3, 
                    inherit.aes = F) +
       geom_segment(data = grid_data, aes(x = end, y = 4, xend = start, yend = 4), colour = "grey", alpha = 1, size = .3, 
                    inherit.aes = F) +
       geom_segment(data = grid_data, aes(x = end, y = 3, xend = start, yend = 3), colour = "grey", alpha = 1, size = .3, 
                    inherit.aes = F) +
       geom_segment(data = grid_data, aes(x = end, y = 2, xend = start, yend = 2), colour = "grey", alpha = 1, size = .3, 
                    inherit.aes = F) +
       geom_segment(data = grid_data, aes(x = end, y = 1, xend = start, yend = 1), colour = "grey", alpha = 1, size = .3, 
                    inherit.aes = F) +
  # Add text showing the value of each 1/2/3/4/5 lines
  annotate("text", x = rep(max(data$id), 5), y = c(1, 2, 3, 4, 5), label = c("1", "2", "3", "4", "5"), color = "grey", 
           size = 3 , angle = 0, fontface = "bold", hjust = 1) +
  geom_bar(aes(as.factor(id), duration_ms, fill = key_name), stat = "identity", alpha = .5) +
  ylim(-2, 10) +
  theme(legend.position = "none",
        axis.text = element_blank(),
        axis.title = element_blank(),
        panel.grid = element_blank(),
        plot.margin = unit(rep(-1, 4), "cm")) +
  coord_polar() + 
  geom_text(data = label_data, 
            aes(id, duration_ms+4, label = track_name), 
            color = "black", fontface = "bold", 
            size = 3.1, angle = label_data$angle, inherit.aes = F) +
  # labs(title = "Tonalidades de las canciones de folklore y evermore",
  #      caption = "Fuente: elaboración propia en base a Genius.
  #                 Paula Pereda - @paubgood - paulapereda.com") +
  ggsave("plots/acordes.png", dpi = 300, width = 13, height = 7)

# ejemplo_1 <- read_rds("data/ts_genius.rds") %>% 
#   filter(album == "evermore" & track_n == 10) %>% 
#   filter(!is.na(line)) %>% 
#   select(track_n, line, lyric, track_title, album) %>% 
#   slice(1:10) %>% 
#   write_csv("ejemplo_1.csv")
# 
# ejemplo_2 <- read_rds("data/tidy_taylor.rds") %>% 
#   filter(album == "evermore" & track_n == 10) %>% 
#   select(line, word, track_title, album) %>% 
#   slice(1:15) %>% 
#   write_csv("ejemplo_2.csv")
