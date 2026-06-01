# census2020download 2.4.0

## Bug fixes

* Reading a mix of mainland states and Island Areas in a single call no longer
  fails: the part-9 (Island Areas) data file is now read only for the Island
  Area being processed, and only when that file exists, instead of for every
  state whenever any Island Area was requested.
* `census2020_download(overwrite = FALSE)` now returns a consistent data.frame
  (with a `destfile` column) when every requested file is already present,
  instead of `NULL`, which previously caused the calling pipeline to error.
* `census2020_get_data()` and `census2020_get_data_islandareas()` now support
  `overwrite = FALSE` (the previous hard "not working yet" stop was removed) and
  derive the zip folder from `folder` rather than the download return value.
* `census2020_clean()` no longer emits a spurious warning when `cols_to_keep`
  is given using the original Census FTP column names (e.g. `"GEOCODE"`).
* The Island Areas cleaning step is guarded on `do_read` to avoid a NULL
  dereference when `do_clean = TRUE` but `do_read = FALSE`.
* Corrected two lower-case `ftpname` entries (`p0050027`, `p0050028`) in
  `census_col_names_map_mp`. Because column matching is case-sensitive, MP
  (Northern Mariana Islands) data previously dropped its `nhotheralone` and
  `nhmulti` (Some Other Race alone; Two or more races) columns. A new test
  guards every column map against lower-case ftpnames.

## New features and improvements

* New `timeout` argument on the download and `get_data` functions (default
  180 seconds) replaces the previously hard-coded download timeout.
* Downloads are now validated: a request that "succeeds" with an HTTP 200 but
  saves an empty or missing file on disk is reported as a problem.
* Input validation added to `census2020_get_data()` for `mystates` and `sumlev`.

## Robustness, packaging, and infrastructure

* `DESCRIPTION` dependencies corrected: `curl` and `vroom` are now declared in
  Imports (they were used but undeclared); `stats` added; `SearchTrees`,
  `usethis`, and `EJAM` moved to Suggests; `BugReports` added.
* `NAMESPACE` now imports only what is used; the optional `EJAM` and `usethis`
  code paths are guarded with `requireNamespace()`.
* Added a `testthat` test suite (network-free) and a GitHub Actions
  `R-CMD-check` workflow.
* `R CMD check` now passes with no errors, warnings, or notes.

# census2020download 2.3.0 and earlier

* Initial download / unzip / read / clean pipeline for 2020 Census blocks
  (states, DC, PR) and limited Island Areas (VI, GU, MP, AS) support, used to
  build the block data tables consumed by the EJAM package.
