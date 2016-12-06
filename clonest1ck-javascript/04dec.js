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
  var encr = inp.split("\n");
  encr.splice(encr.length - 1, 1);
  var sum = 0;
  var lucky = 0;

  for(var str of encr) {
    if(isReal(str)) {
      sum += getID(str);
      if(isLucky(str)) {
        lucky = getID(str);
      }
    }
  }
  console.log(sum);
  console.log(lucky);
}

function isReal(str) {
  str = str.replace(/-/g, "");
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

function isLucky(str) {
  decoded = "";

  shift = getID(str);
  for(var c of str) {
    if(c == "-") {
      decoded += " ";
    } else if (!isNaN(c)){
      break;
    } else {
      decoded += (shiftChar(c, shift));
    }
  }
  if(decoded.indexOf("northpole object storage") != -1) {
    return true;
  } else {
    //console.log(decoded);
    return false;
  }
}

function shiftChar(char, times) {
  times = times % 26;
  charCode = char.charCodeAt() + times;
  charCodeZ = 'z'.charCodeAt();
  charCodeA = 'a'.charCodeAt();

  if(charCode > charCodeZ) {
    return String.fromCharCode(charCodeA + (charCode - charCodeZ) - 1);
  }

  return String.fromCharCode(charCode);
}
