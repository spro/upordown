request = require 'request'
querystring = require 'querystring'
nalgene = require 'nalgene'
grammar = nalgene.parse 'include/grammar.nlg'

averages_url = 'http://api.bitcoincharts.com/v1/weighted_prices.json'
markets_url = 'http://api.bitcoincharts.com/v1/markets.json'

formatPrice = (n) -> '$' + n.toFixed(2)

responsePhrase = (long_up, mid_up, short_up) ->
    phrase = [long_up, mid_up, short_up].map((up) -> if up then 'u' else 'd').join('')
    return phrase

templateResponse = (current, averages) ->
    short_up = current > averages['USD']['24h']
    mid_up = averages['USD']['24h'] > averages['USD']['7d']
    long_up = averages['USD']['7d'] > averages['USD']['30d']
    phrase = responsePhrase long_up, mid_up, short_up
    values = {current}
    formatters = {price: formatPrice}
    nalgene.generate grammar, {values, formatters}, phrase

module.exports = upOrDown = (cb) ->
    request {url: averages_url, json: true}, (err, res, averages) ->
        return cb err if err?
        return cb "Unknown response from bitcoincharts averages API" if not averages?['USD']?

        request {url: markets_url, json: true}, (err, res, body) ->
            return cb err if err?
            coinbase_market = body.find (market) -> market.symbol == 'coinbaseUSD'
            return cb "Unknown response from bitcoincharts markets API" if not coinbase_market
            current = coinbase_market.bid

            cb null, templateResponse current, averages
