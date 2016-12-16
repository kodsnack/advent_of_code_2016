// Open input file
var file = process.argv[2];
var part = process.argv[3];

// Valid input?
if(file != undefined) {
  var fs = require("fs");
  var data = fs.readFileSync(file);

  var finalRow = false;

  if(part != "1") {
    finalRow = true;
  }

  var result = calculate(data.toString(), finalRow);
  console.log(result);


} else {
  console.log("Undefined input, exiting...");
  process.exit();
}

function calculate(data, row) {
  data = data.split("\n");
  var discs = [];

  for(var i = 0; i < data.length - 1; i++) {
    var line = data[i].split(" ");
    discs.push([parseInt(line[3]),
                parseInt(line[11])]);
  }

  if(row) {
    discs.push([11, 0]);
  }

  var time = 0;

  while(!freeFall(discs, time)){
    time++;
  }

  return time;
}

function freeFall(discs, time) {
  var res = true;

  for(var i = 0; i < discs.length; i++) {
    res &= ((discs[i][1] + time + i + 1) % discs[i][0] == 0);
  }

  return res;
}
