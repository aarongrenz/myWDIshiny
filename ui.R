
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
#
# http://shiny.rstudio.com
#

library(shiny)
library(googleVis)

shinyUI(fluidPage(
  
  # Application title
  titlePanel("Choropleth for which indicator and time frame"),
  
  selectInput("indicator", label = h3("Indicator"), 
              choices = list("Life expectancy at birth, total (years)" = "SP.DYN.LE00.IN", 
                             "Life expectancy at birth, male (years)" = "SP.DYN.LE00.MA.IN", 
                             "Life expectancy at birth, female (years)" = "SP.DYN.LE00.FE.IN", 
                             "Child Mortality (under 5 per 1000 live births)" = "SH.DYN.MORT",
                             "Income share held by highest 10%" = "SI.DST.10TH.10", 
                             "Sex ratio at birth (males per 1000 females)" = "SP.POP.BRTH.MF"), 
              selected = "SP.DYN.LE00.IN"),
  sliderInput("Year", "Data from years:", 
              min=1980, max=2010, value=1980,  step=1,
              format="###0",animate=FALSE),
  
  htmlOutput("choroplethplot"),
  plotOutput(outputId = "lowHigh"),
  htmlOutput("motion"),
  plotOutput(outputId = "scatter")
  
))

