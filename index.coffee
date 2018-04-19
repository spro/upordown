sendMessage = require './send-message'
upOrDown = require './up-or-down'

exports.handler = (event, context, cb) ->
    console.log '[event]', event
    body = event['body-json']
    if body.challenge
        cb null, {challenge: body.challenge}
    else
        if body.event?.text? and body.event?.user?
            upOrDown (err, up_or_down) ->
                if !err?
                    sendMessage body.event.channel, up_or_down
        cb null
