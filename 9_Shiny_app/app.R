library(shiny)
library(tidyverse)
library(readr)
library(rsconnect)

rsconnect::setAccountInfo(name='charles-zhang',
                          token='890F803ACBC5DEE28D543C5A1082EE7B',
                          secret='K+48LSVwcRAMrEn3NIbv69Gwtd3QhCrsynwFscoo')

board_games <- readr::read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/master/data/2019/2019-03-12/board_games.csv")

ui <- fluidPage(
  sliderInput(inputId = "year", label = "Year Published",
              min = 1950, max = 2019, value = c(1950,2019),sep = ""),
  textInput("max_players", "Max Players", value = "", placeholder = "1"),
  selectInput("minage", "Min age", choices = board_games$min_age),
  submitButton(text = "Create my plot!"),
  plotOutput(outputId = "timeplot")
)

server <- function(input, output) {
  output$timeplot <- renderPlot({
    board_games %>% 
      arrange(min_age) %>% 
      filter(max_players == input$max_players, min_age == input$minage) %>% 
      ggplot(aes(x = year_published, y = average_rating, color=min_playtime, label = name))+
      geom_point()+
      geom_text()+
      scale_x_continuous(limits = input$year) +
      theme_classic()
  })
}

shinyApp(ui, server)












