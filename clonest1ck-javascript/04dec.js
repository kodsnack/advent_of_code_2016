// Open input file
var file = process.argv[2];

// Valid input?
if(file != undefined) {
  var fs = require("fs");
  var data = fs.readFileSync(file);

  realID(data.toString());

} else {
  console.log("Undefined input, exiting...");
  process.exit();
}

function realID(inp) {
  var encr = inp.replace(/-/g, "").split("\n");
  encr.splice(encr.length - 1, 1);
  var sum = 0;

  for(var str of encr) {
    if(isReal(str)) {
      sum += getID(str);
    }
  }
  console.log(sum);
}

function isReal(str) {
  var checksum = str.slice(str.indexOf("["), str.length);
  var dict = {};
  var i = 0;
  var s = "";
  var max = 0;

  while(isNaN(s = str[i])) {
    dict[s] = dict[s] + 1 || 1;
    i++;
    if(max < dict[s]) {
      max = dict[s];
    }
  }

  var old = dict[checksum[1]];
  if(max > old) {
    return false;
  }
  
  for(i = 1; i < 6; i++) {
    if(old > dict[checksum[i]] || (old == dict[checksum[i]] && checksum[i - 1] < checksum[i])) {
      old = dict[checksum[i]];
    } else {
      return false;
    }
  }
  return true;
}

function getID(str) {
  return parseInt(str.match(/\d+/));
}
