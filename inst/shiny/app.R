## app.R ##
library("shiny")
library("shinydashboard")
library("magrittr")
library("shinyFiles")

ui <- dashboardPage(
  dashboardHeader(title = "Batch tag editing"),
  dashboardSidebar(
    shinyDirButton(id = "path",
              label = "path to posts",
              title = "path to posts"),
    actionButton("saveBtn", "Save edits to posts YAML")
  ),
  dashboardBody(rhandsontable::rHandsontableOutput("tags"))
)

server <- function(input, output) {
  volumes <- c(home = path.expand("~"),
               here = getwd())
  shinyDirChoose(input, 'path', roots = volumes)
  output$directorypath <- renderPrint({parseDirPath(volumes, input$directory)})

  output$tags = rhandsontable::renderRHandsontable({
    initialtags <- blogyaml::get_tags(input$path)
  rhandsontable::rhandsontable(initialtags,
                               readOnly = FALSE,
                               search = TRUE)%>%
    rhandsontable::hot_cols(fixedColumnsLeft = 1)
})

  observe({
    # remove button and isolate to update file automatically
    # after each table change
    input$saveBtn
    tags = isolate(input$tags)
    if (!is.null(tags)) {
      blogyaml::inject_tags(input$path,
                            rhandsontable::hot_to_r(input$tags))
    }
  })
}

shinyApp(ui, server)
