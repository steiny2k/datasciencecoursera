best <- function(state, outcome) {
  ## Read outcome data
  dat <- loadAssignmentData()
  
  ## Check that state and outcome are valid
  checkState(state, dat)
  outcome <- checkOutcome(outcome)
  
  ## Return hospital name in that state with lowest 30-day death
  ## rate
  bestHospitals <- dynRank(state, outcome, dat)
  bestHospitals$Hospital.Name[1]
}

dynRank <- function(state, outcome, dat) {
  stateSubset <- dat[ dat$State == state, ]
  bestHospitals <- stateSubset[ order(stateSubset[[outcome]], stateSubset$Hospital.Name, na.last=NA), ]
}

checkState <- function(state, dat) {
  if (! (state %in% dat$State)) {
    stop("invalid state")
  }
}

checkOutcome <- function(outcome) {
  if (outcome == "heart attack")
    return("Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack")
  else if (outcome == "heart failure")
    return("Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure")
  else if (outcome == "pneumonia")
    return("Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia")
  else
    stop("invalid outcome")
}