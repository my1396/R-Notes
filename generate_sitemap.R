# generate_sitemap.R
# Generates docs/sitemap.xml for https://my1396.github.io/R-Notes/
# Run after building the bookdown project.
# in RStudio
# source("generate_sitemap.R")
# or in terminal
# Rscript generate_sitemap.R

base_url  <- "https://my1396.github.io/R-Notes/"
# Works both from RStudio (Source button) and Rscript on the command line
docs_dir  <- tryCatch(
  file.path(dirname(rstudioapi::getSourceEditorContext()$path), "docs"),
  error = function(e) file.path(getwd(), "docs")
)

# Use search_index.json as the authoritative list of pages for the current build.
# This avoids including stale HTML files left over from older builds.
search_index_path <- file.path(docs_dir, "search_index.json")
search_index      <- jsonlite::fromJSON(search_index_path)
# search_index is a matrix/list where column 1 is the filename
page_filenames    <- unique(search_index[, 1])

html_files <- file.path(docs_dir, page_filenames)

# Build sitemap entries
build_url_entry <- function(path) {
  filename  <- basename(path)
  loc       <- paste0(base_url, filename)
  lastmod   <- format(file.mtime(path), "%Y-%m-%d")
  # Give index.html the highest priority
  priority  <- if (filename == "index.html") "1.0" else "0.8"
  changefreq <- "monthly"

  paste0(
    "  <url>\n",
    "    <loc>", loc, "</loc>\n",
    "    <lastmod>", lastmod, "</lastmod>\n",
    "    <changefreq>", changefreq, "</changefreq>\n",
    "    <priority>", priority, "</priority>\n",
    "  </url>"
  )
}

entries <- vapply(sort(html_files), build_url_entry, character(1))

sitemap <- paste0(
  '<?xml version="1.0" encoding="UTF-8"?>\n',
  '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">\n',
  paste(entries, collapse = "\n"),
  "\n</urlset>\n"
)

out_path <- file.path(docs_dir, "sitemap.xml")
writeLines(sitemap, out_path, useBytes = TRUE)
message("Sitemap written to: ", out_path, " (", length(entries), " URLs)")
