## app.R ##
library("shiny")
library("shinydashboard")
library("magrittr")

ui <- dashboardPage(
  dashboardHeader(title = "Batch tag editing"),
  dashboardSidebar( box(
    title = "Path to posts",
    textInput(inputId = "path",
              label = "path",
              value = "C:\\Users\\Maelle\\Documents\\ropensci\\roweb2\\content\\blog"),
    actionButton("saveBtn", "Save edits to posts YAML")
  )),
  dashboardBody(rhandsontable::rHandsontableOutput("tags"))
)

server <- function(input, output) {
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
