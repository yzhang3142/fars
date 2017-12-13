#' Read data from a csv file
#'
#' This function checks the existance of a specified file in the current
#' directory and returns the data in a tibble when the file exists.
#'
#' @note This function will throw an error when the file is not found.
#'
#' @importFrom readr read_csv
#' @importFrom dplyr tbl_df
#'
#' @param filename A string specifing the file name.
#'
#' @return A tibble object containing the data from the specified input file.
#'
#' @examples
#' \dontrun{
#' fars_read("accident_2013.csv.bz2")
#' }
fars_read <- function(filename) {
        if(!file.exists(filename))
                stop("file '", filename, "' does not exist")
        data <- suppressMessages({
                readr::read_csv(filename, progress = FALSE)
        })
        dplyr::tbl_df(data)
}

#' Generate a file name in a specific convension
#'
#' This funtion serves as a template to generate a specific file name,
#' in the format of "accident_yyyy.csv.bz2", based on the input value (yyyy).
#'
#' @param year An integer of 4 digits representing a year.
#'
#' @return A string representing the coresponding file name.
#'
#' @examples
#' \dontrun{
#' make_filename(2013)
#' }
make_filename <- function(year) {
        year <- as.integer(year)
        sprintf("accident_%d.csv.bz2", year)
}

#' Read data from multiple csv files
#'
#' This function imports the data from multiple files, specified by the input
#' years, and generates a list of objects indexed by the input value. Each
#' object can be either a tibble of two columns (year and MONTH representing
#' the time of an accident), when the the file exits, or NULL, when the data
#' file is unavailable. In the latter case, a warning message will be printed
#' to the console.
#'
#' @importFrom dplyr mutate select %>%
#'
#' @param years A numeric vector specifying a selection of years in 4-digit numbers.
#'
#' @return A list of tibble objects. Each object contains the data from
#'     the corresponding file of that year.
#'
#' @examples
#' \dontrun{
#' fars_read_years(2013)
#' fars_read_years(c(2013, 2014, 2015))
#' }
fars_read_years <- function(years) {
        lapply(years, function(year) {
                file <- make_filename(year)
                tryCatch({
                        dat <- fars_read(file)
                        dplyr::mutate(dat, year = year) %>%
                                dplyr::select(MONTH, year)
                }, error = function(e) {
                        warning("invalid year: ", year)
                        return(NULL)
                })
        })
}

#' Count the number of accidents happend in each month and year
#'
#' This function imports and combines data from multiple files and counts the
#' number of accidents happend in each month and year. The first column of the
#' returned tibble represents the month index, whereas other columns represent
#' the monthly accident counts in certain years.
#'
#' @importFrom dplyr bind_rows group_by summarize %>%
#' @importFrom tidyr spread
#'
#' @param years A numeric vector of four-digit numbers representing years.
#'
#' @return A tibble of monthly accident counts.
#'
#' @examples
#' \dontrun{
#' fars_summarize_years(2013)
#' fars_summarize_years(c(2013, 2014, 2015))
#' }
#'
#' @export
fars_summarize_years <- function(years) {
        dat_list <- fars_read_years(years)
        dplyr::bind_rows(dat_list) %>%
                dplyr::group_by(year, MONTH) %>%
                dplyr::summarize(n = n()) %>%
                tidyr::spread(year, n)
}

#' Plot the locations of accidents happend in a given state and year
#'
#' This function plots a map with dots representing the locations of
#' accidents happened in a given state and year.
#'
#' @note This function will throw an error when the input \code{state.num} value
#' is not valid.
#'
#' @importFrom maps map
#' @importFrom graphics points
#' @importFrom dplyr filter
#'
#' @param state.num An integer that represents a state
#' @param year An integer of 4 digits that represents a year
#'
#' @return NULL
#'
#' @examples
#' \dontrun{
#' fars_map_state(4, 2013)
#' }
#'
#' @export
fars_map_state <- function(state.num, year) {
        filename <- make_filename(year)
        data <- fars_read(filename)
        state.num <- as.integer(state.num)

        if(!(state.num %in% unique(data$STATE)))
                stop("invalid STATE number: ", state.num)
        data.sub <- dplyr::filter(data, STATE == state.num)
        if(nrow(data.sub) == 0L) {
                message("no accidents to plot")
                return(invisible(NULL))
        }
        is.na(data.sub$LONGITUD) <- data.sub$LONGITUD > 900
        is.na(data.sub$LATITUDE) <- data.sub$LATITUDE > 90
        with(data.sub, {
                maps::map("state", ylim = range(LATITUDE, na.rm = TRUE),
                          xlim = range(LONGITUD, na.rm = TRUE))
                graphics::points(LONGITUD, LATITUDE, pch = 46)
        })
}
