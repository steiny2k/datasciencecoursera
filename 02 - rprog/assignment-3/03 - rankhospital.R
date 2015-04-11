rankhospital <- function(state, outcome, num = "best") {
  ## Read outcome data
  dat <- loadAssignmentData()
  
  ## Check that state and outcome are valid
  checkState(state, dat)
  outcome <- checkOutcome(outcome)
  
  ## Return hospital name in that state with the given rank
  ## 30-day death rate
  bestHospitals <- dynRank(state, outcome, dat)
  if (num == "best") {
    return(bestHospitals$Hospital.Name[1])
  } else if (num == "worst") {
    return(tail(bestHospitals$Hospital.Name, n=1))
  } else if (is.numeric(num)) {
    return(bestHospitals$Hospital.Name[num])
  } else {
    stop("invalid num")
  }
}