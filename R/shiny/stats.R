##
#stats.R - Misc. functions
#Author: Paul Demange
##

#returns number of breaches for year
sumbreaches <- function(year){
  return(sum(breachdata$Number[which(breachdata$Year == year)], na.rm=TRUE))
}

#Returns info about a company
getCompanyAnalytics <- function(company){
  indices <- which(grepl(tolower(company), tolower(as.character(breachdata$Company))) == TRUE)
  compvar <- data.frame(breachdata$ID[indices], breachdata$Company[indices], breachdata$State[indices],
                        breachdata$Month[indices], breachdata$Day[indices],breachdata$Year[indices]
                        , breachdata$Type[indices], breachdata$Category[indices], breachdata$RR[indices],
                        breachdata$Number[indices])
  colnames(compvar) <- c("ID","Company", "State", "Month", "Day", "Year", "Type", "Category", "RR", "Number")
  return(compvar)
}

#Returns info about a state
getStateInfo <- function(state){
  indices <- which(tolower(as.character(breachdata$State)) == tolower(state))
  compvar <- data.frame(breachdata$ID[indices], breachdata$Company[indices], breachdata$State[indices],
                        breachdata$Month[indices], breachdata$Day[indices],breachdata$Year[indices]
                        , breachdata$Type[indices], breachdata$Category[indices], breachdata$RR[indices],
                        breachdata$Number[indices])
  colnames(compvar) <- c("ID","Company", "State", "Month", "Day", "Year", "Type", "Category", "RR", "Number")
  return(compvar)
}

#Returns info about a month
getbyMonth <- function(month){
  indices <- which(breachdata$Month == month)
  compvar <- data.frame(breachdata$ID[indices], breachdata$Company[indices], breachdata$State[indices],
                        breachdata$Month[indices], breachdata$Day[indices],breachdata$Year[indices]
                        , breachdata$Type[indices], breachdata$Category[indices], breachdata$RR[indices],
                        breachdata$Number[indices])
  colnames(compvar) <- c("ID","Company", "State", "Month", "Day", "Year", "Type", "Category", "RR", "Number")
  return(compvar)
}

#Returns info about a year
getbyYear <- function(year){
  indices <- which(breachdata$Year == year)
  compvar <- data.frame(breachdata$ID[indices], breachdata$Company[indices], breachdata$State[indices],
                        breachdata$Month[indices], breachdata$Day[indices],breachdata$Year[indices]
                        , breachdata$Type[indices], breachdata$Category[indices], breachdata$RR[indices],
                        breachdata$Number[indices])
  colnames(compvar) <- c("ID","Company", "State", "Month", "Day", "Year", "Type", "Category", "RR", "Number")
  return(compvar)
}