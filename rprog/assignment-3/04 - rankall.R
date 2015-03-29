rankall <- function(outcome, num = "best") {
  ## Read outcome data
  dat <- loadAssignmentData()
  
  ## Check that outcome is valid
  outcome <- checkOutcome(outcome)
  
  ## For each state, find the hospital of the given rank
  if (num == "best")
    num = 1
  
  rankAll <- dynRank(outcome, dat)
  splitByState <- split(rankAll, rankAll$State)
  listOfRanked <- lapply(splitByState, 
                         function(X) if (num=="worst")
                           c(hospital=tail(X$Hospital.Name, n=1))
                         else c(hospital=X$Hospital.Name[num]))
  
  ## Return a data frame with the hospital names and the
  ## (abbreviated) state name
  listOfHospitals <- as.data.frame(do.call(rbind, listOfRanked))
  listOfHospitals$state <- rownames(listOfHospitals)
  listOfHospitals
}


dynRank <- function(outcome, dat) {
  bestHospitals <- dat[ order(dat$State, dat[[outcome]], dat$Hospital.Name, na.last=NA), ]
}