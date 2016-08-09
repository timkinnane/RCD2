_ = require 'underscore'

# find best crossover times from a group of
getBestTimes = (utcOffsets, options = {}) ->

  # acceptable score/range for meeting times
  config = _.defaults options, {
    earliest: 8,
    latest: 20,
    minPercent: .8
  }

  # fing the minimum score based on
  participants = _.size utcOffsets
  minScore = Math.round participants * config.minPercent

  # matrix of relative hours for all zones
  offsetHours = _.map utcOffsets, (offset, name) ->
    _.map _.range(24), (hour) ->
      # TODO: replace date calcs with momentjs - can rule out sat/sun meetings
      offsetHour = hour + offset
      if offsetHour > 24
        offsetHour = offsetHour - 24
      else if offsetHour < 0
        offsetHour = 24 + offsetHour
      return offsetHour

  # score the number of acceptable hours in crossover
  scores = _.map _.range(24), (utcHour) ->
    _.reduce offsetHours, (score, offsetHour) ->
      if offsetHour[utcHour] < config.earliest or offsetHour[utcHour] > config.latest
        score++
      return score
    , 0

  # filter out all but the best crossover hours
  scoresMax = _.max scores
  utcHours = _.filter _.range(24), (utcHour) -> scores[utcHour] is scoresMax

  # redefine offset times for best hours matched to names
  names = _.keys utcOffsets
  offsetHours = _.map utcOffsets, (offset) ->
    _.map utcHours, (hour) -> hour+offset
  offsetHours = _.object names, offsetHours

  return {
    score: scoresMax,
    utc: utcHours,
    offset: offsetHours,
  }

console.log getBestTimes({
  'Tim': -3,
  'Tom': 1,
  'Tan': 10,
  'Tin': -3,
  'Tam': 3
})
