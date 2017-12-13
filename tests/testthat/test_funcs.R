# Test the internal function - make_filename
test_that('make_filename', {
  expect_that(make_filename(2013), is_a("character"))
})

# Test the internal function - fars_read
test_that('fars_read', {
  expect_that(fars_read(make_filename(2013)), is_a("tbl"))
})

# Test the internal function - fars_read_years
test_that('fars_read_years', {
  expect_that(fars_read_years(c(2013, 2014)), is_a("list"))
})

# Test the external function - fars_summarize_years
test_that('fars_summarize_years', {
  expect_that(fars_summarize_years(c(2013, 2014)), is_a("tbl"))
})

# Test the external function - fars_map_state
test_that('fars_map_state', {
  expect_that(fars_map_state(4, 2013), is_identical_to(NULL))
})
