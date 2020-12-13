

# Load required R packages
mypackages = c("shiny", "shinydashboard", "recommenderlab", "data.table", "ShinyRatingInput", "shinyjs", "dplyr", "tidyr")
tmp = setdiff(mypackages, rownames(installed.packages()))  # packages need to be installed
if (length(tmp) > 0) install.packages(tmp)
lapply(mypackages, require, character.only = TRUE)
#install.packages("devtools")
#devtools::install_github("stefanwilhelm/ShinyRatingInput")

## ui.R
library(shiny)
library(shinydashboard)
library(recommenderlab)
library(data.table)
library(ShinyRatingInput)
library(shinyjs)
library(dplyr)
library(tidyr)

source('functions/helpers.R')

all_genres = c("Action", "Adventure", "Animation", "Children", 
               "Comedy", "Crime","Documentary", "Drama", "Fantasy", "Film-Noir",
               "Horror", "Musical", "Mystery","Romance", "Sci-Fi", "Thriller", "War", "Western")

shinyUI(
  dashboardPage(skin = "yellow",
                dashboardHeader(title = "Movie Recommender"),
                dashboardSidebar(
                  tags$head(
                    tags$link(rel = "stylesheet", type = "text/css", href = "css/books.css")
                  ),
                  sidebarMenu(
                    menuItem("System I", tabName="first",  icon=icon("star")),
                    menuItem("System II", tabName = "second",  icon=icon("star"))
                  )
                ),
                dashboardBody(
                  tabItems(
                    tabItem(tabName = "first",
                            fluidRow(
                              box(width = 12,title = "Step 1: Select Your Favorite Genre", status = "info", solidHeader = TRUE, collapsible = TRUE,
                                  div(class = "genres",
                                        selectInput("selected_genre", "Select a Genre ", all_genres),
                                  )
                              )
                            ),
                            fluidRow(
                              useShinyjs(),
                              
                              box(
                                width = 12, status = "info", solidHeader = TRUE,
                                title = "Step 2: Get Recommmended Movies For Selected Favorite Genre",
                                br(),
                                withBusyIndicatorUI(
                                  actionButton("btn_genre_movies", "Click to get your recommendations!!", class = "btn-warning")
                                 
                                ),
                                h4("Note: For the selected genre, highly rated movies are recommended here. These movies have 4 or 5 stars."),
                                br(),
                                tableOutput("selectedGenreMovies")
                              )
                            )
                    ),
                    
                    tabItem(tabName = "second",
                            fluidRow(
                              box(width = 12, title = "Step 1: Rate as many movies as possible", status = "info", solidHeader = TRUE, collapsible = TRUE,
                                  div(class = "rateitems",
                                      uiOutput('ratings')
                                  ))
                            ),
                            fluidRow(
                              useShinyjs(),
                              box(
                                width = 12, status = "info", solidHeader = TRUE,
                                title = "Step 2: Discover Movies you might like",
                                br(),
                                withBusyIndicatorUI(
                                  actionButton("btn_rated_movies", "Click here to get your recommendations", class = "btn-warning")
                                ),
                                h4("Note: User-based collaborative filtering algorithm is used to recommend the movies."),
                                br(),
                                tableOutput("results")
                              )
                            )
                    )
                  )
                )
  )
) 