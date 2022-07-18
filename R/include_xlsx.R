# include_xlsx <- function(my_file,title=paste0(my_file)) {
#
# pacman::p_load(htmltools)
# pacman::p_load(reactable)
# pacman::p_load(magrittr)
#
# resource_map <- my_file
# #"data/file.xlsx"
# #openxlsx::getSheetNames(resource_map)
#
# map <- lapply(seq(2,7), function(x){
#   y <- openxlsx::read.xlsx(resource_map, fillMergedCells = TRUE, sheet=x, startRow=2, skipEmptyCols = T)
#   y$segment <- openxlsx::getSheetNames(resource_map)[x]
#   y
# })
#
# #map <- do.call("rbind", map)
# map <- plyr::rbind.fill(map)
#
# map_colour <- tibble::tibble(
#   segment = unique(map$segment),
#   shade = c("185,220,255","255,189,222","255,191,159","72,254,167","211,181,233","255,227,139") #blue, pink, orange, mint, purple, yellow
# )
#
# map <- dplyr::left_join(map,map_colour,by=c("segment"))
#
# #sapply(strsplit(map$shade, ","), rgb_2_hex)
# map$shade <- rgb(read.table(text=map$shade,sep=',',strip.white = TRUE,col.names=c("r","g","b")),maxColorValue=255)
#
# map <- map %>% dplyr::relocate(Description, .after = segment) %>% dplyr::relocate(segment, .before = "Sub-Segment")
#
#
# if (knitr::is_html_output()) {
#
#   pacman::p_load(tippy)
#   render_tippy <- function(text, tooltip){
#     div(style = "text-decoration: underline;
#                 text-decoration-style: dotted;
#                 text-decoration-color: #FF6B00;
#                 cursor: info;
#                 white-space: nowrap;
#                 overflow: hidden;
#                 text-overflow: ellipsis;",
#         tippy(text = text, tooltip = tooltip)
#     )
#   }
#
#   show_map <- reactable(map,
#                         wrap = FALSE,
#                         style = list(fontFamily = "Work Sans, sans-serif", fontSize = "10px"),
#                         compact = TRUE,
#                         filterable = TRUE,
#                         minRows = 10,
#                         searchable = TRUE,
#                         defaultSorted = c("segment"),
#                         highlight = TRUE,
#                         bordered = TRUE,
#                         resizable = TRUE,
#                         defaultColDef = colDef(
#                           header = function(value)
#                             gsub(".", " ", value, fixed = TRUE),
#                           headerStyle = list(background = "#f7f7f8")
#                         ),
#                         columns = list(
#                           shade = colDef(show = F),
#                           URL = colDef(style = list(fontsize = "0.5rem")),
#                           Description = colDef(
#                             html = TRUE,
#                             cell = function(value, index, name) {
#                               render_tippy(text = value, tooltip = value)
#                             }
#                           )
#                         ),
#                         rowStyle = function(index) {
#                           list(background = map[index,"shade"])
#                         }
#   )
#   show_map
# } else {
#
#   #
#   # show_map_all <- reactable(
#   #   map,
#   #   wrap = FALSE,
#   #   style = list(fontFamily = "Work Sans, sans-serif", fontSize = "10px"),
#   #   minRows = 10,
#   #   defaultSorted = c("segment"),
#   #   bordered = TRUE,
#   #   defaultColDef = colDef(
#   #     header = function(value)
#   #       gsub(".", " ", value, fixed = TRUE),
#   #     headerStyle = list(background = "#f7f7f8")
#   #   ),
#   #   columns = list(shade = colDef(show = F)),
#   #   rowStyle = function(index) {
#   #     list(background = map[index, "shade"])
#   #   }
#   #   #pagination = FALSE
#   # )
#   # pacman::p_load(htmlwidgets)
#   # pacman::p_load(webshot2)
#   # html <- "data/rtable.html"
#   # saveWidget(show_map_all, html)
#   #
#   # webshot2::webshot(html, "file.pdf")
#   #
#   # # you can also export to pdf
#   #
#   chunk_lab <- knitr::opts_current$get()$label
#
#   knitr::raw_latex(paste0("\n\n\\includepdf[pages=-,noautoscale, width=205mm, height = 240mm, pagecommand={}]{data/05-intervention-files/wellbeing_mapping2.pdf}\\label{fig:",chunk_lab,"}\n\n"))
# }
#
# }
