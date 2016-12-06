// Open input file
var file = process.argv[2];

// Valid input?
if(file != undefined) {
  var fs = require("fs");
  var data = fs.readFileSync(file);

  recover(data.toString());

} else {
  console.log("Undefined input, exiting...");
  process.exit();
}

function recover(data) {
  var messageMost = "";
  var messageLeast = "";
  data = data.split("\n");

  for(var c = 0; c < data[0].length; c++) {
    var dict = {};
    var most = "";
    dict[most] = 0;

    for(var r = 0; r < data.length - 1; r++) {
      var char = data[r][c];
      dict[char] = dict[char] + 1 | 1;

      if(dict[most] < dict[char]) {
        most = char;
      }
    }
    var least = most;

    for(key of Object.keys(dict)) {
      if(key != "") {
        if(dict[least] > dict[key]) {
          least = key;
        }
      }
    }
    messageMost += most;
    messageLeast += least;
  }
  console.log("Message with most: " + messageMost);
  console.log("Message with least: " + messageLeast);
}
