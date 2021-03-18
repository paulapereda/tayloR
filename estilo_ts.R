library(ggplot2)

estilo_ts <- function() {
  theme_minimal(base_family = "Gotham-Book",
                base_size = 16) +
    theme(axis.line = element_blank(), 
          panel.grid.minor = element_blank(), 
          panel.background = element_blank(), 
          plot.title = element_text(hjust = .5, 
                                    family = "Gotham-Bold"),
          plot.subtitle = element_text(hjust = .5),
          plot.caption = element_text(family = "Gotham-Light", hjust = 1, 
                                      margin = margin(t = 10)),
          # panel.grid.major.x = element_blank(),
          # panel.grid.minor.x = element_blank(),
          # axis.line.x = element_line(),
          # axis.ticks.x = element_line(),
          legend.position = "bottom")
}

theme_set(estilo_ts())
update_geom_defaults("text", list(family = theme_get()$text$family))

lover1 <- "#F2C9D4"
lover2 <- "#F2AED4"
lover3 <- "#71BBD9"
lover4 <- "#F2E8C9"
lover5 <- "#F2C1AE"

evermore1 <- "#F2E8DC"
evermore2 <- "#A67153"
evermore3 <- "#D99F7E"
evermore4 <- "#592D1D"
evermore5 <- "#260401"

rosado <- "#D4AFB9"
lila <- "#D4AFB9"
violeta <- "#D4AFB9"
verdeagua <- "#7EC4CF"
azul <- "#7EC4CF"

color1 <- "#503E51"
color2 <- "#8A6A76"
color3 <- "#857069"
color4 <- "#D4957F"
color5 <- "#E1B5A0"
color6 <- "#DCCD94"
color7 <- "#A3CFB3"
color8 <- "#55B1C1"
color9 <- "#337DA4"
color10 <- "#222848"