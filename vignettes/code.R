## ----include = FALSE-----------------------------------------------------
library(tufte)
knitr::opts_chunk$set()

## ----message=FALSE-------------------------------------------------------
library(shiny)
data(movies, package="jrYr")

## ---- eval = FALSE-------------------------------------------------------
#  selectInput(inputId = "movie_type", # unique id
#              label = "Movie genre", # Text for web
#              choices = c("Romance", "Action", "Animation"),
#              selected = "Action")

## ---- eval = FALSE-------------------------------------------------------
#  sliderInput(inputId = "movie_rating",
#              label = "Movie rating",
#              min = 0, max = 10, value = 5)

## ---- eval = FALSE-------------------------------------------------------
#  numericInput(inputId = "movie_length",
#            label = "Movie length",
#            min = 1, max = 5220, value = 100)

## ---- eval = FALSE-------------------------------------------------------
#  renderText(input$movie_type)

## ----eval=FALSE----------------------------------------------------------
#  renderText({
#    type = movies[,input$movie_type] == 1
#    nrow(movies[type,])
#  })

## ----eval=FALSE----------------------------------------------------------
#  renderPlot({
#    type = movies[,input$movie_type] == 1
#    hist(movies[type,]$length)
#  })

## ----eval=FALSE----------------------------------------------------------
#  renderText({
#    type = movies[,input$movie_type] == 1
#    nrow(movies[type,])
#  })
#  renderPlot({
#    type = movies[,input$movie_type] == 1
#    hist(movies[type,]$length)
#  })

## ----eval=FALSE----------------------------------------------------------
#  sub_movies = reactive({
#    type = movies[,input$movie_type] == 1
#    movies[type,]
#  })

## ----eval=FALSE----------------------------------------------------------
#  renderText(nrow(sub_movies()))
#  renderPlot(hist(sub_movies()$length))

## ----eval=FALSE----------------------------------------------------------
#  selectInput("movie_genre", label = "Movie genre",
#              c("Romance", "Action", "Animation"))
#  
#  sub_movies = reactive({
#    type = movies[,input$movie_type] == 1
#    movies[type,]
#  })
#  #??

## ---- eval = FALSE-------------------------------------------------------
#  selectInput("movie_genre", label = "Movie genre",
#              c("Romance", "Action", "Animation"))
#  actionButton("plot", "Plot it now!!")

## ---- eval = FALSE-------------------------------------------------------
#  sub_movies1 = eventReactive(input$plot,{
#    type = movies[,input$movie_genre] == 1
#    movies[type,]
#  })
#  renderPlot(hist(sub_movies1()$length))

## ----eval=FALSE----------------------------------------------------------
#  rvs = reactiveValues(data=movies)

## ----eval=FALSE----------------------------------------------------------
#  observeEvent(input$romance, {
#      type = movies[, "Romance"] == 1
#      rvs$data = movies[type, ]
#  })
#  observeEvent(input$action, {
#      type = movies[, "Action"] == 1
#      rvs$data = movies[type, ]
#  })
#  renderPlot(hist(rvs$data[, "length"]))

## ---- eval = FALSE-------------------------------------------------------
#  sliderInput("n", "Sample size", 10, 500, 100)
#  actionButton("romance", "Romance")
#  actionButton("action", "Action")

## ----eval=FALSE----------------------------------------------------------
#  observeEvent(input$romance, {
#      m =  movies[movies[, "Romance"] == 1, ]
#      rows = sample(1:nrow(m), input$n)
#      rvs$data = m[rows, ]
#  })
#  # Similar for Action
#  renderPlot(hist(rvs$data[, "length"],
#                  main=paste("Sample size:", input$n)))

## ----eval=FALSE----------------------------------------------------------
#  renderPlot(hist(rvs$data[, "length"],
#                  main=paste("Sample size:", isolate(input$n))))

## ---- eval = FALSE, results="hide"---------------------------------------
#  data(movies, package = "jrShiny")
#  selectInput("movie_type", label = "Movie genre",
#              c("Romance", "Action", "Animation"))
#  rvs = reactiveValues(data = movies, sentence = NULL)
#  observe({
#    rvs$data = movies[movies[, input$movie_type] == 1, ]
#  })
#  
#  renderPlot(hist(rvs$data[, "length"]))

## ---- out.width="90%", message=FALSE, warning = FALSE--------------------
library("ggplot2")
data(movies, package = "jrShiny")
g = ggplot(movies, aes(x = length, y = rating)) + 
  geom_point()
g

## ---- message=FALSE, warning = FALSE-------------------------------------
library("plotly")
ggplotly(g)

## ---- eval = FALSE, message=FALSE, warning = FALSE-----------------------
#  library("ggplot2")
#  library("plotly")
#  data(movies, package = "jrShiny")
#  selectInput("movie_type", label = "Movie genre",
#              c("Romance", "Action", "Animation"))
#  rvs = reactiveValues(data = movies)
#  
#  observeEvent(input$movie_type, {
#    rvs$data = movies[movies[, input$movie_type] == 1, ]
#  })
#  renderPlotly({
#    ggplotly(ggplot(rvs$data, aes(x = length)) +
#      geom_histogram())
#  })

## ---- message=FALSE, warning = FALSE-------------------------------------
library("DT")
datatable(movies)

## ---- eval = FALSE, message=FALSE, warning = FALSE-----------------------
#  library("ggplot2")
#  library("plotly")
#  library("DT")
#  data(movies, package = "jrShiny")
#  selectInput("movie_type", label = "Movie genre",
#              c("Romance", "Action", "Animation"))
#  rvs = reactiveValues(data = movies)
#  observeEvent(input$movie_type, {
#    rvs$data = movies[movies[, input$movie_type] == 1, ]
#  })
#  renderPlotly({
#    ggplotly(ggplot(rvs$data, aes(x = length)) +
#      geom_histogram())
#  })
#  renderDataTable({
#    datatable(rvs$data[,1:5],
#              options = list(lengthMenu = c(5, 30, 50),
#                             pageLength = 5))
#  })

## ----eval=FALSE, results="hide", cache=FALSE, message=FALSE--------------
#  library("shiny")
#  fluidPage(
#    titlePanel("Shiny happy people"), #title
#    ## Sidebar with a slider input for no. of points
#    sidebarLayout(
#      sidebarPanel(
#        sliderInput("n", "Number of points:", min = 1,
#                                    max = 50, value = 30)
#      ),
#      ## Show a plot of the generated distribution
#      mainPanel(plotOutput("scatter"))
#    )
#  )

## ----eval = FALSE, results="hide", message=FALSE-------------------------
#  library("shiny")
#  # Function always has input & output
#  function(input, output) {
#    # Expression that generates a plot.
#    # A call to renderPlot indicates that:
#    #  1) It is "reactive" and therefore should
#    #   re-execute automatically when inputs change
#    #  2) Its output type is a plot
#    output$scatter = renderPlot({plot(rnorm(input$n))})
#  }

## ----eval = FALSE--------------------------------------------------------
#  fluidPage(
#    titlePanel("Title panel"),# Title
#    ## Sidebar style
#    sidebarLayout(
#      sidebarPanel("The sidebar"),
#      mainPanel("Main panel")
#    )
#  )

## ----eval = FALSE--------------------------------------------------------
#  sidebarLayout(position="right",
#    sidebarPanel("The sidebar"),
#    mainPanel("Main panel")
#  )

## ----eval = FALSE--------------------------------------------------------
#  sidebarLayout(
#    sidebarPanel("The sidebar", p("Choose an option")),
#    mainPanel("Main panel")
#  )

## ----eval = FALSE--------------------------------------------------------
#  ui = fluidPage(
#    titlePanel("I love movies"), #Title
#    fluidRow( # Define a row
#      column(4, # Two columns: width 4 & 8
#             wellPanel(
#               selectInput("movie_type", label = "Movie genre",
#                           c("Romance", "Action", "Animation"))
#             )
#      ),
#      column(8, plotOutput("scatter"))
#    )
#  )

## ---- eval=FALSE---------------------------------------------------------
#  mainPanel(
#    tabsetPanel(type = "tabs",
#      tabPanel("Plot", plotOutput("plot")),
#      tabPanel("Summary", verbatimTextOutput("summary")),
#      tabPanel("Table", tableOutput("table"))
#    )
#  )

## ---- eval = FALSE-------------------------------------------------------
#  dashboardPage(
#    dashboardHeader(title = "My first app"),
#    dashboardSidebar(),
#    dashboardBody()
#  )

## ---- eval = FALSE-------------------------------------------------------
#  dashboardPage(
#    dashboardHeader(title = "My first app"),
#    dashboardSidebar(
#      sidebarMenu(
#        menuItem("Page 1"),
#        menuItem("Page 2")
#      )
#    ),
#    dashboardBody()
#  )

## ---- eval = FALSE-------------------------------------------------------
#  dashboardPage(
#    dashboardHeader(title = "My first app"),
#    dashboardSidebar(
#      sidebarMenu(
#        menuItem("Page 1", tabName = "p1"),
#        menuItem("Page 2", tabName = "p2")
#      )
#    ),
#    dashboardBody(
#      tabItems(
#        tabItem("p1", h2("This is page 1")),
#        tabItem("p2", h2("This is page 2"))
#      )
#    )
#  )

## ---- eval = FALSE-------------------------------------------------------
#  dashboardPage(
#    dashboardHeader(title = "My first app"),
#    dashboardSidebar(
#      sidebarMenu(
#        menuItem("Page 1", tabName = "p1"),
#        menuItem("Page 2",
#                 menuSubItem("Sub page 1", tabName = "sp1"),
#                 menuSubItem("Sub page 2", tabName = "sp2"))
#      )
#    ),
#    dashboardBody(
#      tabItems(
#        tabItem("p1", h2("This is page 1")),
#        tabItem("sp1", h2("This is page 2, sub page 1")),
#        tabItem("sp2", h2("This is page 2, sub page 2"))
#      )
#    )
#  )

## ---- eval = FALSE-------------------------------------------------------
#  dashboardBody(
#    fluidRow(
#      box(plotOutput("plot"),
#          title = "This is my plot",
#          width = 8),
#      box(sliderInput("n", "slider",
#                      min = 1, max = 100, value = 10),
#          title = "This is my slider",
#          width = 4)
#    )
#  )

