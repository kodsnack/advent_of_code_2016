var hasher    = require("crypto-js/md5");
var hex       = require("crypto-js/enc-hex");
var key       = "reyedfim";
var password1 = "";
var password2 = "--------";
var i         = 0;
var hash      = "";


while(password1.length < 8 || password2.indexOf("-") != -1) {
  while(!isInteresting(hash = MD5(key, i))) {
    i++;
  }
  console.log("Interesting string at: " + i + ". String: " + hash);
  if(password1.length < 8) {
    password1 += hash[5];
  }
  if(hash[5] > -1 && hash[5] < 8) {
    if(password2[hash[5]] === "-") {
      password2 = replaceAt(password2, hash[5], hash[6]);
    }
  }
  i++;
}

console.log("Password 1: " + password1);
console.log("Password 2: " + password2);

function replaceAt(str, index, char) {
  index = parseInt(index);
  return (str.substr(0, index) + char + str.substr(index + char.length, str.length));
}

function MD5(str, index) {
  str += index.toString();
  return hasher(str).toString(hex);
}

function isInteresting(hashed) {
  if(hashed.indexOf('00000') == 0) {
    return true;
  } else {
    return false;
  }
}
