include_frag <- function(my_file) {
  input <- here::here(my_file)

  out_name <- gsub("\\.docx$", ".Rmd", input)

  rmarkdown::pandoc_convert(input, to="markdown", output = out_name, options=c("--extract-media=."))


  res <- knitr::knit_child(out_name, quiet = TRUE)
  cat(res, sep = '\n')

}
