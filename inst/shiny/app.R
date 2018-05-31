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
    textInput("new", "New tags (comma separated)", "tag1, tag2, tag3"),
    actionButton("do", "Load current tags"),
    actionButton("saveBtn", "Save edits to posts YAML")
  ),
  dashboardBody(rhandsontable::rHandsontableOutput("tags"))
)

server <- function(input, output) {
  volumes <- c(home = path.expand("~"))
  shinyDirChoose(input, 'path', roots = volumes)

  path <- reactive({
    return(print(parseDirPath(volumes, input$path)))
  })

  observeEvent(input$do, {
  output$tags = rhandsontable::renderRHandsontable({
    initialtags <- blogyaml::get_tags(path()[1])

    newtags <- strsplit(input$new, ",")[[1]]
    newtags <- trimws(newtags)
    if(any(newtags == "file")){
      stop("'file' cannot be a tag")
    }
    tags <- names(initialtags)[names(initialtags) != "file"]

    # not existing tags!
    newtags <- newtags[!newtags %in% tags]

    # add nice rlang here
    for(var in newtags){
      initialtags[,var] <- FALSE
    }


    initialtags <- initialtags[,c("file", sort(c(newtags, tags)))]
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
      blogyaml::inject_tags(path()[1],
                            rhandsontable::hot_to_r(input$tags))
    }
  })})
}

shinyApp(ui, server)
