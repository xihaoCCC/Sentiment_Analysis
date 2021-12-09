library(janeaustenr)
library(dplyr)
library(stringr)

detectAllCap <- function(line) {
  line <- trimws(line)
  lline <- toupper(line)
  return (line == lline)
}
detectChapter <- function(line) {
  return (startsWith(toupper(line), "CHAPTER"))
}

detectVolume <- function(line) {
  return (startsWith(line, "VOLUME "))
}

detectBreak <- function(line) {
  if (line == "")
    return(TRUE)
  if (trimws(line) == "by")
    return(TRUE)
  if (stringr::str_detect(tolower(line), "jane austen"))
    return(TRUE)
  if (stringr::str_detect(line, "[(]\\d\\d\\d\\d[)]"))
    return(TRUE)
  return(FALSE)
}


#' Title Truenumbers from books
#'
#' @param books as returned by tidytext
#'
#' @export
#'
tnBooksFromLines <- function(books) {
  curbook <- ""

  chapter <- ""
  volume <- ""
  sentence <- ""
  sentencenum <- 0
  paragraph <- 0
  curline <- 0

  state <- "header"
  blanks <- FALSE
  bks <- as.matrix(books)
  bklen <- length(books$text)
  tn <- list()
  for (j in 1:bklen) {
    bookrow <- bks[j, ]
    line <- bookrow[[1]]
    bk <- bookrow[[2]]
    if (bk != curbook) {
      curbook <- bk
      volume <- ""
      chapter <- ""
      sentence <- ""
      paragraph <- 0
      sentencenum <- 0
    }
    bk <- stringr::str_replace_all(bk, " ", "_")
    bk <- stringr::str_replace_all(bk, "&", "and")
    curline <- curline + 1
    line <- trimws(line)
    lline <- toupper(line)
    if (detectBreak(line)) {
      if (blanks == FALSE) {
        sentencenum <- 0
        sentence <- ""
        paragraph <- paragraph + 1
        blanks <- TRUE
      }
    } else
      if (detectChapter(line)) {
        chapter <- line
        paragraph <- 0

      } else
        if (detectVolume(line)) {
          volume <- paste0("/",stringr::str_replace_all(trimws(tolower(line)), " ", "-"))
          paragraph <- 0

        }

    else {
      blanks <- FALSE
      # process text (headers eliminated above)
      ln <- str_replace_all(line, "Mrs.", "Mrs")
      ln <- str_replace_all(ln, "Mr.", "Mr")
      ln <- str_replace_all(ln, "Esq.", "Esq")
      if (stringr::str_detect(ln, "\\.")) {
        matchs <- stringr::str_locate_all(pattern = '\\.', ln)
        beg <- 0
        for (i in matchs[[1]][, 1]) {
          sentence <- paste0(sentence, substr(ln, beg, i), collapse = "")
          beg <- i
          subj <-
            paste0(
              "austen:jane:",
              tolower(bk),volume,
              "/",

              tolower(str_replace(chapter, "\\s+", "-")),
              "/paragraph-",
              paragraph + 1,
              "/sentence-",
              sentencenum + 1,
              collapse = ''
            )
          sentence <- str_replace_all(sentence, "\"", "/iQ/")
          tn[[length(tn) + 1]] <-
            tnum.makeObject(subj, "text", trimws(sentence), "")

          if (length(tn) == 30) {
            res <- tnum.postObjects(tn)
            tn <- list()
          }
          sentencenum <- sentencenum + 1
        }
        sentence <- paste0(substr(ln, beg + 1, nchar(ln)), " ")
      } else {
        sentence <- paste0(sentence, ln, " ", collapse = "")
      }
    }
  }
}
