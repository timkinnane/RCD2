# Description:
#   Testing listeners that use the rocketchat:bot-helpers package to query users.
#
# Notes:
#   Requires use with rocketchat adaptor and rocketchat:bot-helpers enabled.
#   Scripting documentation: https://github.com/github/hubot/blob/master/docs/scripting.md

module.exports = (robot) ->
  
  # Check who's online
  robot.hear /who is online/i, (res) ->
    promise = robot.adapter.callMethod('botRequest', 'onlineNames')
    promise.then (result) ->
      if result.length > 0
        names = result.join(', ').replace(/,(?=[^,]*$)/, ' and ') # convert last comma to 'and'
        res.send "#{ names } #{ if result.length == 1 then 'is' else 'are' } currently online"
      else
        res.send "Nobody is currently online... \*cricket sound\*"
      return
    , (error) ->
      res.send "Uh, sorry I don't know, something's not working"
      return
