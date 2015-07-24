var curl = require('curlrequest');
require('shelljs/global');
var fs = require('fs');
exec('echo "" > /Users/tuannvm/nodejs/personal/tools/a.txt');
exec('echo "" > /Users/tuannvm/nodejs/personal/tools/b.txt');
var options = { url: encodeURI('nhaccuatui.com/tim-kiem/bai-hat?q='+process.argv[2]), include: false };

curl.request(options, function (err, parts) {
    parts = parts.split('\r\n');
    var data = parts.pop(),
    head = parts.pop();
  //console.log(data);


  data.to('/Users/tuannvm/nodejs/personal/tools/a.txt');
  result = grep('name_song','/Users/tuannvm/nodejs/personal/tools/a.txt');

  var encodeName = result.split('.')[3];
  var temp = result.split('.')[10];

  if(temp.indexOf('TOP 20') > -1) {
    console.log('no song found!');
    exit();
}

  var optionsDownload = { url: 'http://www.nhaccuatui.com/download/song/'+encodeName, include: false };
  curl.request(optionsDownload, function (err, parts) {
      parts = parts.split('\r\n');
      var data = parts.pop(),
      head = parts.pop();
      data.to('/Users/tuannvm/nodejs/personal/tools/b.txt');
      result = grep('stream_url','/Users/tuannvm/nodejs/personal/tools/b.txt');
      var link = JSON.parse(result).data.stream_url;
      var linkName = link.split('/')[6];
      console.log(linkName);
      var optionsLink = {
    url: link,
    'limit-rate': '500k',
    encoding: null
};

curl.request(optionsLink, function (err, file) {
  fs.writeFile("/Users/tuannvm/nodejs/personal/tools/"+linkName, file, function(err) {
  if(err) {
      return console.log(err);
  }

  console.log("The file was saved!");
});
});

});
});
