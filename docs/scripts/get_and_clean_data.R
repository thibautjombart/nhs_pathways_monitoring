# packages ---------------------------------------------------------------------
library(robotstxt)  # for checking robots.txt
library(rvest)      # for scraping web page

# set timestamp for files ------------------------------------------------------
timestamp = format(Sys.time(), "%Y%m%d_T%H%M%S")

# variables --------------------------------------------------------------------
path <- paste0(
    "https://digital.nhs.uk/",
    "data-and-information/",
    "publications/",
    "statistical/",
    "mi-potential-covid-19-symptoms-reported-through-nhs-pathways-and-111-online/",
    "latest/"
)

column_classes <- c(rep("character", 6), "integer")

new_column_names <- c(
    "site_type",
    "date",
    "sex",
    "age",
    "ccg_code",
    "ccg_name",
    "count"
)

nhs_region_lookup_path <- file.path(
    "data",
    "lookups",
    "ccg_info_april_2020.csv"
)

nhs_region_lookup_names <- c(
    ccg_name = "name",
    ccg_postcode = "postcode",
    nhs_region = "nhs_region"
)

# scraping ---------------------------------------------------------------------
is_allowed <- paths_allowed(paths = path)
if (is_allowed) {
    url <- path
    scraped_links <- read_html(url)
    scraped_links <- html_nodes(scraped_links, "a")
    scraped_links <- html_attr(scraped_links, "href")
} else {
    stop("You shouldn't really scrape this site.  Have they got an api to use?")
}

# get data ---------------------------------------------------------------------
pathway_calls <- URLencode("NHS Pathways Covid-19 data 20")
pathway_calls <- grep(pathway_calls, scraped_links, fixed=T, value = TRUE)
pathways_calls_data <- read.csv(
    url(pathway_calls),
    na.strings = c("NA", ""),
    colClasses = column_classes
)

pathways_online <- URLencode("111 Online Covid-19 data_20")
pathways_online <- grep(pathways_online, scraped_links, fixed=T, value = TRUE)
pathways_online_data <- read.csv(
    pathways_online,
    na.strings = c("NA", ""),
    colClasses = column_classes[-1]
)

# save raw data ----------------------------------------------------------------
filename <- paste(timestamp, "pathway_calls.Rds", sep = "_")
saveRDS(pathways_calls_data, file.path("data", "raw", filename))
filename <- paste(timestamp, "pathway_online.Rds", sep = "_")
saveRDS(pathways_online_data, file.path("data", "raw", filename))

# merge datasets ---------------------------------------------------------------
site_type <- rep("111_online", nrow(pathways_online_data))
pathways_online_data <- cbind(
    data.frame(site_type = site_type),
    pathways_online_data
)
pathways_calls_data <- setNames(pathways_calls_data, new_column_names)
pathways_online_data <- setNames(pathways_online_data, new_column_names)
pathways_all <- rbind(pathways_calls_data, pathways_online_data)

# clean data -------------------------------------------------------------------
pathways_all$ccg_name <- gsub(",", "", pathways_all$ccg_name)
pathways_all$ccg_name <- gsub("\\s+", "_", pathways_all$ccg_name)
pathways_all$ccg_name <- tolower(pathways_all$ccg_name)

pathways_all$date <- as.Date(
    pathways_all$date,
    format = "%d/%m/%Y"
)

pathways_all$age <- gsub(
    pattern = "70+ years",
    replacement = "70-120 years",
    x = pathways_all$age,
    fixed = TRUE
)

pathways_all$age <- gsub(" years", "", pathways_all$age)

# add nhs regions  -------------------------------------------------------------
nhs_lookup <- read.csv(nhs_region_lookup_path)[nhs_region_lookup_names]
nhs_lookup <- setNames(nhs_lookup, names(nhs_region_lookup_names))
pathways_all <- merge(pathways_all, nhs_lookup, all.x = TRUE)
pathways_all$nhs_region <- gsub("_", " ", pathways_all$nhs_region)
pathways_all$nhs_region <- tools::toTitleCase(pathways_all$nhs_region)

# save cleaned data ------------------------------------------------------------
filename <- paste(timestamp, "pathways_all.Rds", sep = "_")
saveRDS(pathways_all, file.path("data", "clean", filename))
