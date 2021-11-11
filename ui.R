library(markdown)
library(ggplot2)
library(shiny)
library(plotly)
library(DT)
library(rworldmap)
library(rworldxtra)
library(shinythemes)
library(leaflet)
navbarPage("ShinyApp",theme = shinytheme("spacelab"),
           tabPanel("Introduction",
                    h3("Context"),
                    h5("The", a("National Earthquake Information Center",
                                href="https://earthquake.usgs.gov/"),"(NEIC) determines the
                       location and size of all significant earthquakes that occur worldwide
                       and disseminates this information immediately to national and
                       international agencies, scientists, critical facilities, and the 
                       general public. The NEIC compiles and provides to scientists and to 
                       the public an extensive seismic database that serves as a foundation 
                       for scientific research through the operation of modern digital
                       national and global seismograph networks and cooperative international
                       agreements. The NEIC is the national data center and archive for
                       earthquake information."),
                    h5("The word earthquake is used to describe any seismic event - whether
                       natural or caused by humans - that generates seismic waves. Earthquakes
                       are caused mostly by rupture of geological faults, but also by other
                       events such as volcanic activity, landslides, mine blasts, and
                       nuclear tests."),
                    h3("Content"),
                    h5("This dataset includes a record of the date (by year), location (by
                         latitude and longitude), depth and magnitude of every earthquake
                         reported with magnitude 5.5 or higher since 1965."),
                    h5("For more information about the earthquakes, can visit",
                       a("Wikipedia", href="https://en.wikipedia.org/wiki/Earthquake"),
                       "and learn more about this topic."),
                    h3("Created by"),
                    h5("Aldo Franco Comas"),
                    h5("100355330@alumnos.uc3m.es"),
                    img(src = 'Aldo.png',height = 150)
                    ),
           tabPanel("Table",
                    sliderInput("year_table","Select a year:",min = 1965,
                                max=2016,value = 2016,animate = T,sep = ""),
                    mainPanel(
                      DT::dataTableOutput("table")
                              )  
                    ),
           tabPanel("Summary",
                    sliderInput("year_summary","Select a year:",min = 1965,
                                max=2016,value = 2016,animate = T,sep = ""),
                    mainPanel(
                      verbatimTextOutput("summary1"),
                      verbatimTextOutput("summary2")
                              )
                    ),
           tabPanel("BoxPlot",
                    sliderInput("year_boxplot","Select a year:",min = 1965,
                                max=2016,value = 2016,animate = T,sep = ""),
                    mainPanel(
                      plotlyOutput("BPlot1")
                             )
                    ),
           tabPanel("ScatterPlot",
                    sliderInput("year_scatter","Select a year:",min = 1965,
                                max=2016,value = 2016,animate = T,sep = ""),
                    mainPanel(
                      plotOutput("depth_magnitude",
                                 brush = brushOpts(id = "plot1_brush")
                      ),
                      helpText("You can select some points of the graph and
                               observe the individual information."),
                      verbatimTextOutput("brush_info")
                    )
           ),
           tabPanel("Map",
                    sliderInput("year_map","Select a year:",min = 1965,
                                max=2016,value = 2016,animate = T,sep = ""),
                    mainPanel(
                      leafletOutput("MapPlot")
                              )
                    )
           )
           
                                 
                             