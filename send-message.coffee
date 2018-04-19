request = require 'request'
{token, chat_url} = require './config.json'

module.exports = sendMessage = (channel, text) ->

    options = {
        url: chat_url
        method: 'post'
        headers: {
            'Authorization': "Bearer #{token}"
            'Content-Type': 'application/json'
        }
        json: {channel, text}
    }

    request options, (err, res, response) ->
        console.log '[err]', err
        console.log '[response]', response

