loadBreach <- function(file,year)
{
  
  library(tidyr)
  tbl <- read.table(file, header=FALSE, fill=TRUE, sep="~", col.name=c("ID","Company","State","Date","Type","Category","RR","Number"), comment.char="", quote="")
  tbl <- tbl %>% separate(Date,c('Month','Day','Year'),'/')
  tbl$Month <- as.numeric(tbl$Month);
  tbl$Day <- as.numeric(tbl$Day);
  tbl$Year <- as.numeric(tbl$Year);
  tbl$Year[which(is.na(tbl$Year))] <- year
  tbl$RR <- as.character(tbl$RR)
  return(tbl)
}

loadBreaches <- function(files,years)
{
  if(length(files)==length(years)){
    t <- loadBreach(files[1],years[1])
    if(length(files)>1)
      for(i in 2:length(files))
      {
        t <- rbind(t,loadBreach(files[i],years[i]))
      }
    t <- t[-which(duplicated(t$ID)),]
    return(t[-which(duplicated(t$Company)==duplicated(t$Year)),])
  }else{
    print('Error: Argument length mismatch')
    return(NA)
  }
}

cleanBreaches <- function(table)
{
  table$Number[which(table$RR=='Yes - Unknown #')] <- NA
  table$Number[which(table$Number=='Unknown')] <- NA
  table$Number <- as.numeric(table$Number)
  if(length(which(table$Year==1009)>0)){
    table[which(table$Year==1009),]$Year <- 2009
  }
  table$RR[grep('yes',tolower(table$RR))] <- 'YES'
  table$RR[-grep('yes',tolower(table$RR))] <- 'NO'
  table$RR <- as.factor(table$RR)
  return(table)
}

getSearchPop <- function(query)
{
  library(XML)
  library(stringr)
  #Sys.sleep(15)
  query <- gsub(' ','+',query)
  htmlr <- htmlParse(paste("http://google.com/search?q=",query))
  #res <- getNodeSet(htmlr,"//div[@id='resultStats']")
  res <- xpathSApply(htmlr,"//*/div[@id=\"resultStats\"]",xmlValue)
  num <- gsub(',','',str_split(res,' ')[[1]][2])
  return(as.numeric(num))
}

getGoogPD <- function(query){
  library(XML)
  library(stringr)
  #Sys.sleep(15)
  query <- gsub(' ','+',query)
  htmlr <- htmlParse(paste("http://google.com/search?q=",query,'+population'))
  #res <- getNodeSet(htmlr,"//div[@id='resultStats']")
  res <- xpathSApply(htmlr,"//*/div[@id=\"_vBb\"]",xmlValue)
  num <- gsub(',','',str_split(res,' ')[[1]][1])
  return(as.numeric(num))
}