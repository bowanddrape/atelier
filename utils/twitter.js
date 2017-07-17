
var fs = require('fs');
var http = require('http');
var https = require('https');
var spawn = require('child_process').spawn;
var EventEmitter = require('events');
var Twitter = require('twitter');

var twitterSearch = function(hashtag, callback) {
  if (!hashtag) return;

  this.twitter = new Twitter({
    consumer_key: "bgnqdRZzOG3VIyz9mxAmw",
    consumer_secret: "GgAqAOWqrDkZB2Z5rDLZJI5l3QYSRONTbtXu02yg",
    access_token_key: "288533562-OdrXxX4QAMYQTrZr3z4huVD0afGinoNZiNaEljPy",
    access_token_secret: "H1bhOVI9nKiAeYkC3u6cEFFbLu68lX4s3zjHTl0M",
  });

  console.log("initiating twitter stream reader for "+hashtag);
  this.twitter.stream('statuses/filter', {track: hashtag},  function(stream) {
    stream.on('data', function(tweet) {
      callback(null, tweet);
    });

    stream.on('error', function(error) {
      callback(error);
    });
  });

}

twitterSearch("bowanddrape", function(err, tweet) {
  if (err) {
    return console.log(err);
  }

  // ignore spammy campaigns here
  if (/@bartaile @bowanddrape/i.test(tweet.text)) {
    return;
  }

  let req = https.request({
    protocol: "https:",
    hostname: "hooks.slack.com",
    path: "/services/T0928RSGP/B2TUE537X/mko0Fs5coag6qzjCtc0T28VW",
    method: "POST"
  });
  req.write(JSON.stringify({
    as_user: false,
    username: "social",
    text: "<https://twitter.com/"+tweet.user.screen_name+"/status/"+tweet.id_str+"|tweet> "+tweet.text
  }));
  req.end();
});

