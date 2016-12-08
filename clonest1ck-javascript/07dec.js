// Open input file
var file = process.argv[2];

// Valid input?
if(file != undefined) {
  var fs = require("fs");
  var data = fs.readFileSync(file);

  var tls = tls(data.toString());
  var ssl = ssl(data.toString());

  console.log("TLS: " + tls + ". SSL: " + ssl);

} else {
  console.log("Undefined input, exiting...");
  process.exit();
}
function tls(data) {
  var ok = 0;
  data = data.split("\n");

  for(var d of data) {
    if(validTLS(d)) {
      ok++;
    }
  }
  return ok;
}

function ssl(data) {
  var ok = 0;

  data = data.split("\n");

  for(var d of data) {
    if(validSSL(d)) {
      ok++;
    }
  }
  return ok;
}

function validTLS(str) {
  var reval   = /(.)(?!\1)(.)\2\1/;
  var reinval = /\[[^\]\[]*?(.)(?!\1)(.)\2\1[^\]\[]*?\]/;

  if(str.match(reval) != null && str.match(reinval) == null) {
    return true;
  }
  return false;
}

function validSSL(str) {
  var withinBrackets = false;
  var aba = [];
  var bab = [];

  for(var i = 0; i < str.length - 2; i++) {
    if(str[i] === "[") {
      withinBrackets = true;
    } else if (str[i] === "]") {
      withinBrackets = false;
    } else if (str[i] === str[i + 2] && str[i] !== str[i + 1] &&
                (str[i + 1] !== "]" && str[i + 1] !== "[")) {
      if(withinBrackets) {
        bab.push(str[i]+str[i+1]+str[i]);
      } else {
        aba.push(str[i+1]+str[i]+str[i+1]); // Invert for faster comparison
      }
    }
  }

  if(aba.length != 0 && bab.length != 0) {
    for(var i = 0; i < aba.length; i++) {
      for(var j = 0; j < bab.length; j++) {
        if(aba[i] === bab[j]) {
          return true;
        }
      }
    }
  }

  return false;
}
