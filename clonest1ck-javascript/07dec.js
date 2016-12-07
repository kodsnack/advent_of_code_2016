// Open input file
var file = process.argv[2];

// Valid input?
if(file != undefined) {
  var fs = require("fs");
  var data = fs.readFileSync(file);

  validIPs(data.toString());

} else {
  console.log("Undefined input, exiting...");
  process.exit();
}
function validIPs(data) {
  var ok = 0;
  data = data.split("\n");

  for(var d of data) {
    var s = d.split(/[\[\]]/);
    var isOK = true;
    var foundInvalid = false;
    var foundValid = false;

    if(d[0] === "[") {
      isOK = !isOK;
    }

    for(var i = 0; i < s.length; i++) {
      if(isOK && contains(s[i])) {
        foundValid = foundValid || true;
      } else if (!isOK && contains(s[i])) {
        foundInvalid = foundInvalid || true;
      }
      isOK = !isOK;
    }

    if(foundValid && !foundInvalid) {
      ok++;
    }
  }
  console.log(ok);
}

function contains(str) {
  var mat = str.match(/(.)(.)\2\1/);
  if(mat != null && mat[0].match(/(.)\1\1\1/) == null) {
    return true;
  } else {
    return false;
  }
}
