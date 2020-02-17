library(dplyr)
datasets <- data.frame("Dataset Name" = character(),
                       "organization" = character(),
                          "URL" = character(),
                          "Format" = factor(),
                          "Delim" = character())
datasets <- datasets %>% add_row(Dataset.Name = "süüteod üle-eelmise viie aasta kohta", organization = "Politsei- ja Piirivalveamet (PPA)", URL = "https://opendata.smit.ee/ppa/csv/avalik_3.csv", Format = "CSV", Delim = "Tab")
datasets <- datasets %>% add_row(Dataset.Name = "apteegireform_XLSX", organization =   "Ravimiamet", URL = "https://opendata.riik.ee/downloads/apteegid.xlsx", Format = "XLSX", Delim = "NA")
datasets <- datasets %>% add_row(Dataset.Name = "apteegireform_CSV",  organization =   "Ravimiamet", URL = "https://opendata.riik.ee/downloads/apteegid.csv", Format = "CSV", Delim = ";")
datasets <- datasets %>% add_row(Dataset.Name = "LOIS", organization = "Lennuamet", URL = "https://lois.ecaa.ee/avaandmed/aa.xml", Format = "XML", Delim = "NA")


avaandmed <- data.frame()
getDataset <- function(dataset_name)({
  library(data.table)
  library(readxl)
  library(xml2)
  library(curl)
  library(RCurl)
  
  if(dataset_name %in% datasets$Dataset.Name) {
    dataset <- filter(datasets, Dataset.Name == dataset_name)
    if (dataset$Format == "CSV") {
      avaandmed <<- as.data.frame(fread(as.character(dataset$URL), encoding = "UTF-8"))
    }
    if(dataset$Format == "XLSX") {
      filename <- paste0(tempfile(), ".xlsx")
      url <- as.character(dataset$URL)
      download.file(url, filename, method="curl")
      avaandmed <<- as.data.frame(read_xlsx(filename))
    }
    if(dataset$Format == "XML") {
      filename <- paste0(tempfile(), ".xml")
      url <- as.character(dataset$URL)
      download.file(url, filename, method="curl")
      avaandmed <<- xmlToDataFrame(filename)

    }
  }
  else {
    cat("We could not find that dataset, please check the spelling, if you want to check available datasets, try getDatasets()")
  }
  return(avaandmed)
  
    })

getDatasets <- function(){
  return(datasets)
}

organization_datasets <- data.frame()
getDatasetsByOrganization <- function(organization_name){
  organization_datasets <<- filter(datasets, organization == organization_name)
  return(organization_datasets)
  
}


getDatasets()
getDatasetsByOrganization("Ravimiamet")
getDataset("LOIS")
