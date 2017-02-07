sumbreaches <- function(year){
  return(sum(breachdata$Number[which(breachdata$Year == year)], na.rm=TRUE))
}
getCompanyAnalytics <- function(company){
  indices <- which(grepl(tolower(company), tolower(as.character(breachdata$Company))) == TRUE)
  compvar <- data.frame(breachdata$ID[indices], breachdata$Company[indices], breachdata$State[indices],
                        breachdata$Month[indices], breachdata$Day[indices],breachdata$Year[indices]
                        , breachdata$Type[indices], breachdata$Category[indices], breachdata$RR[indices],
                        breachdata$Number[indices])
  colnames(compvar) <- c("ID","Company", "State", "Month", "Day", "Year", "Type", "Category", "RR", "Number")
  return(compvar)
}
getStateInfo <- function(state){
  indices <- which(tolower(as.character(breachdata$State)) == tolower(state))
  compvar <- data.frame(breachdata$ID[indices], breachdata$Company[indices], breachdata$State[indices],
                        breachdata$Month[indices], breachdata$Day[indices],breachdata$Year[indices]
                        , breachdata$Type[indices], breachdata$Category[indices], breachdata$RR[indices],
                        breachdata$Number[indices])
  colnames(compvar) <- c("ID","Company", "State", "Month", "Day", "Year", "Type", "Category", "RR", "Number")
  return(compvar)
}
getbyMonth <- function(month){
  indices <- which(breachdata$Month == month)
  compvar <- data.frame(breachdata$ID[indices], breachdata$Company[indices], breachdata$State[indices],
                        breachdata$Month[indices], breachdata$Day[indices],breachdata$Year[indices]
                        , breachdata$Type[indices], breachdata$Category[indices], breachdata$RR[indices],
                        breachdata$Number[indices])
  colnames(compvar) <- c("ID","Company", "State", "Month", "Day", "Year", "Type", "Category", "RR", "Number")
  return(compvar)
}
getbyYear <- function(year){
  indices <- which(breachdata$Year == year)
  compvar <- data.frame(breachdata$ID[indices], breachdata$Company[indices], breachdata$State[indices],
                        breachdata$Month[indices], breachdata$Day[indices],breachdata$Year[indices]
                        , breachdata$Type[indices], breachdata$Category[indices], breachdata$RR[indices],
                        breachdata$Number[indices])
  colnames(compvar) <- c("ID","Company", "State", "Month", "Day", "Year", "Type", "Category", "RR", "Number")
  return(compvar)
}