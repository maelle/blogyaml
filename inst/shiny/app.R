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
    verbatimTextOutput("pathtext", placeholder = TRUE),
    checkboxGroupInput("format", "Post format",
                       choices = c("*.md", "*.Rmd"),
                       selected = "*.md"),
    textInput("new", "New tags (comma separated)", "tag1, tag2, tag3"),
    actionButton("do", "Load current tags", icon = shiny::icon("upload")),
    actionButton("saveBtn", "Save edits to posts YAML", icon = shiny::icon("save"))
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
  output$pathtext <- renderText(path()[1])

  observeEvent(input$do, {
    initialtags <- blogyaml::get_tags(path()[1],
                                      format = input$format)
    initialtags <- dplyr::mutate_if(initialtags,
                                    is.logical, as.numeric)

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
      initialtags[,var] <- 0
    }

    tagsinfo <- as.data.frame(initialtags[, c("file", sort(c(newtags, tags)))])
    tagsinfo <<- tagsinfo


  if(.Platform$OS.type == "windows"){
    tagsinfo$file <- glue::glue( '<a  rel="noopener" target="_blank" href="{gsub("/", "\\\\\",
                           file.path(path()[1], tagsinfo$file), fixed = TRUE)}">{tagsinfo$file}</a>')

  }else{
    tagsinfo$file <- glue::glue( '<a  rel="noopener" target="_blank" href="file.path(path()[1], tagsinfo$file)}">{tagsinfo$file}</a>')

}

  output$tags1 = DT::renderDT(tagsinfo,
editable = TRUE,
#filter = "top",#didn't work well
extensions = c('FixedColumns',
               'ColReorder'),
options = list(
  colReorder = TRUE,
  scrollX = TRUE,
  search = list(smart = TRUE),
  fixedColumns = list(leftColumns = 2),
  pageLength = 5
),
escape = FALSE)


  })

  proxy = DT::dataTableProxy('tags1')

  observeEvent(input$tags1_cell_edit, {
    info = input$tags1_cell_edit
    i = info$row
    j = info$col
    v = info$value
    tagsinfo[i, j] <<- DT::coerceValue(v, tagsinfo[i, j])
    DT::replaceData(proxy, tagsinfo, resetPaging = FALSE)  # important
  })

  observeEvent(input$saveBtn, {
      blogyaml::inject_tags(path()[1],
                            dplyr::mutate_if(tagsinfo,
                                             is.numeric, as.logical))
    }
  )
}

shinyApp(ui, server)
