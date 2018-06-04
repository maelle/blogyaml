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
    checkboxGroupInput("format", "Post format",
                       choices = c("*.md", "*.Rmd"),
                       selected = "*.md"),
    textInput("new", "New tags (comma separated)", "tag1, tag2, tag3"),
    actionButton("do", "Load current tags"),
    actionButton("saveBtn", "Save edits to posts YAML")
  ),
  dashboardBody(DT::dataTableOutput("tags1"))
)

server <- function(input, output) {
  volumes <- c(here = .posts.path,
               home = path.expand("~"))
  shinyDirChoose(input, 'path', roots = volumes)

  path <- reactive({
    return(print(parseDirPath(volumes, input$path)))
  })

  observeEvent(input$do, {
    initialtags <- blogyaml::get_tags(path()[1],
                                      format = input$format)

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


    tags <- initialtags[,c("file", sort(c(newtags, tags)))]

  output$tags1 = DT::renderDT(tags,
editable = TRUE,
extensions = 'ColReorder',
options = list(
  colReorder = TRUE,
  search = list(smart = TRUE)
))


  })

  proxy = DT::dataTableProxy('tags1')

  observeEvent(input$tags1_cell_edit, {
    info = input$tags1_cell_edit
    print(info)
    i = info$row
    j = info$col
    v = info$value
    print(tags[i, j])
    tags[i, j] <<- DT::coerceValue(v, tags[i, j])
    DT::replaceData(proxy, tags, resetPaging = FALSE)  # important
  })

  observeEvent(input$saveBtn, {
      blogyaml::inject_tags(path()[1],
                            tags)
    }
  )
}

shinyApp(ui, server)
