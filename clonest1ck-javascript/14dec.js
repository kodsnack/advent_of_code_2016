var hasher    = require("crypto-js/md5");
var hex       = require("crypto-js/enc-hex");
var key       = "ngcjuoqr";
var i         = 0;
var hashes    = 0;
var hashed    = {};

while(hashes < 64) {
  while(!isKey(key, i)) {
    i++;
  }
  hashes++;
  if(hashes < 64) {
    i++;
  }
}

console.log("First run: " + i);

i = 0;
hashes = 0;
hashed = {};

while(hashes < 64) {
  while(!isStrethcedKey(key, i)) {
    i++;
  }
  hashes++;
  if(hashes < 64) {
    i++;
  }
}

console.log("Stretched hashes: " + i);


function isKey(key, i) {
  var hash = MD5(key, i);
  var index;
  if((index = hash.search(/(.)(\1)(\1)/)) != -1) {
    var char = hash[index];
    char += char + char + char + char;

    for(var j = i + 1; j < i + 1001; j++) {
      hash = MD5(key, j);
      if(hash.search(char) != -1) {
        return true;
      }
    }
  }
  return false;
}

function MD5(str, index) {
  str += index.toString();

  if(!hashed[str]) {
    hashed[str] = hasher(str).toString(hex);
  }

  return hashed[str];
}

function MD5Stretch(str, index) {
  str += index.toString();

  if(!hashed[str]) {
    var hash = hasher(str).toString(hex);

    for(var j = 0; j < 2016; j++) {
      hash = hasher(hash).toString(hex);
    }

    hashed[str] = hash;
  }

  return hashed[str];
}

function isStrethcedKey(key, i) {
  var hash = MD5Stretch(key, i);

  var index;
  if((index = hash.search(/(.)(\1)(\1)/)) != -1) {
    var char = hash[index];
    char += char + char + char + char;

    for(var j = i + 1; j < i + 1001; j++) {
      hash = MD5Stretch(key, j);
      if(hash.search(char) != -1) {
        return true;
      }
    }
  }
  return false;
}
