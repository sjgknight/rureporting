## This function converts docx files to pdf and creates a labelled chunk title for them...the labelling doesn't work so is being manually set at the moment

#By setting is_embed to FALSE, hopefully the PDF will link to the local copy of the embed
# Ideally this would be set via a parameter globally, so you can easily output a whole doc without (with overrides at chunk level)

#, echo=FALSE, fig.cap="(ref:sample-local-pdf)"
#(ref:sample-local-pdf) Explore the [sample PDF](data/example_2.pdf).
#include_docs <- function(my_file="data/example_2.docx",title="example file") {
include_docs <- function(my_file,title=paste0(my_file),is_embed=TRUE) {
  pacman::p_load("downloadthis")
  pacman::p_load("doconv","pdftools")

  #my_file <- "data/example_2.docx"
  #input <- "data/00-misc/01-2021-06-21-iYarn-Final-Proposal.pptx"

  input <- my_file
  title <- title

  # Get the chunk label to add to the includepdf latex
  chunk_lab <- knitr::opts_current$get()$label

  # Check if the file is already a PDF. If so, embed/include as is. Else convert.
  ftypepdf <- tools::file_ext(input)=="pdf"

  if (ftypepdf==TRUE) {

    if (knitr::is_html_output()) {
      knitr::include_url(input, height = "800px")
    } else {
      chunk_lab <- knitr::opts_current$get()$label
      knitr::raw_latex(paste0("\n\n\\includepdf[pages=-,noautoscale, width=205mm, height = 240mm, pagecommand={}]{",input,"}\\label{fig:",chunk_lab,"}\n\n"))
    }
  } else {


  ##only create the PDF if the base file has been updated more recently
  input_mod <- fs::file_info(input)$modification_time
  output_mod <- fs::file_info(gsub("\\.(docx|pptx)$", ".pdf", input))$modification_time


  if(input_mod > output_mod) {

    conv <- doconv::to_pdf(input, output = gsub("\\.(docx|pptx)$", ".pdf", input))
    #docx2pdf(input, output = gsub("\\.docx$", ".pdf", input))

  } else {
    conv <- gsub("\\.(docx|pptx)$", ".pdf", input)
  }

  pages <- pdf_info(conv)$pages

  #knitr::opts_chunk$set(out.extra=paste("page=",pages,sep=""), out.width="75%", fig.cap=paste("[",title,"](",conv,")"))
  #https://stackoverflow.com/questions/27155853/set-fig-cap-to-optionslabel
  #this doesn't work at the moment

  ##out.extra=paste("page=",pages,sep=""),  out.height="5cm", fig.cap=paste("This PDF has",pages,"pages")

  if (knitr::is_html_output()) {
    knitr::include_url(conv, height = "800px")
  } else {

    if (is_embed=FALSE) {
      knitr::raw_latex(paste0("\href{",conv,"}{",chunk_lab,"}\\label{fig:",chunk_lab,"}\n\n"))
    } else {

    knitr::raw_latex(paste0("\n\n\\includepdf[pages=-,noautoscale, width=205mm, height = 240mm, pagecommand={}]{",conv,"}\\label{fig:",chunk_lab,"}\n\n"))

    #pdf_render_page(conv)
    #knitr::include_graphics(conv)

    #chunk_cap <- if(nchar(knitr::opts_current$get("fig.cap"))>0) {
    #  knitr::opts_current$get("fig.cap")} else {
    #     chunk_lab}

    #BELOW is wrong, we can set a label (possibly also caption) in includepdf as above, and take the chunk option as var for this
    #knitr::opts_chunk$set(fig.topcaption=TRUE) #only works for html at the moment, so we're going to use this instead in the header:
    #- \usepackage{floatrow}
    #- \floatsetup[figure]{capposition=top}

    #this is a stupid dumb hack but to actually get the chunk label linked and caption showing the chunk needs a plot...so we're going to add an empty plot to every relevant chunk.
    #plot(NULL, xlim=c(0,1), ylim=c(0,1), ylab="y label", xlab="x lablel")
    #plot.new()
    #knitr::opts_chunk$set(fig.env='figure')
    #knitr::opts_chunk$set(fig.align='center')
    #cat("\n\\captionof{figure}{Here is a figure caption.}\n")
    #knitr::include_graphics(here::here('data/00-misc/sigh.png'))
    #knitr::raw_latex("\\begin{{figure}}")
    #fml

    # knitr::opts_chunk$set(results='asis', echo=FALSE)
    #
    # txt <- paste0("```{r ",chunk_lab,chunk_cap,", echo=FALSE}\n",
    #   plot(cars),
    #   "\n\n```","\n\n```{r ",chunk_lab,"-doc, echo=FALSE}\n",
    #   "knitr::raw_latex(paste0('\\includepdf[pages=-,noautoscale, width=205mm, height = 240mm, pagecommand={}]{'",conv,"'}'))")
    # pander::pander(txt)

    #knitr::raw_latex(paste0("\n\n\\includepdf[pages=-,noautoscale, width=205mm, height = 240mm, pagecommand={}]{",conv,"}\n\n"))

    #knitr::raw_latex("\\end{{figure}}")
    }
  }
  }
}

#noautoscale, width=205mm, height = 240mm
# \geometry{scale=0.8}

#templatesize={⟨205mm⟩}{⟨240mm⟩},
#templatesize={⟨width⟩}{⟨height⟩} might be replaceable with scale=.8
