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
    actionButton("do", "Load current tags"),
    actionButton("saveBtn", "Save edits to posts YAML")
  ),
  dashboardBody(rhandsontable::rHandsontableOutput("tags"))
)

server <- function(input, output) {
  volumes <- c(here = getwd(),
               home = path.expand("~"))
  shinyDirChoose(input, 'path', roots = volumes)
  path <- reactive(input$path)

  observeEvent(input$do, {
  output$tags = rhandsontable::renderRHandsontable({
    roots = c(wd='.')
    path <- parseDirPath(roots,path())
    print(class(path))
    initialtags <- blogyaml::get_tags(path())
    print("ok")
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
  })})
}

shinyApp(ui, server)
