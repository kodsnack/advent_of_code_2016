// Open input file
var file = process.argv[2];

// Valid input?
if(file != undefined) {
  var fs = require("fs");
  var data = fs.readFileSync(file);

  return walk(data.toString());

} else {
  console.log("Undefined input, exiting...");
  process.exit();
}

function walk(instr) {
  var direction = false ; // False if y-axis, true if x-axis
  var multiple = 1;      // Increment or decrement
  var locations = {}
  var hq = undefined;
  var hqx = 0;
  var hqy = 0;
  var hqdist = 0;

  var x = 0;
  var y = 0;

  input = instr.split(", ");

  for(var i = 0; i < input.length; i++) {
    var dx = 0;
    var dy = 0;
    if(input[i][0] == "R") {
      if(direction) {
        multiple *= -1;
      }
    } else if (input[i][0] == "L") {
        if(!direction) {
          multiple *= -1;
        }
    }
    direction = !direction;

    if(direction) {
      dx = x + multiple * parseInt(input[i].substring(1));

      for(x; x != dx; x += multiple) {
        current = x + "," + y;
        if(!(current in locations)) { // New location
          locations[current] = 1;
        } else { // Been there!
          locations[current]++;
          if(hq == undefined) {
            hq = current;
            hqx = x;
            hqy = y;
          }
        }
      }
    } else {
      dy = y + multiple * parseInt(input[i].substring(1));

      for(y; y != dy; y += multiple) {
        current = x + "," + y;
        if(!(current in locations)) { // New location
          locations[current] = 1;
        } else { // Been there!
          locations[current]++;
          if(hq == undefined) {
            hq = current;
            hqx = x;
            hqy = y;
          }
        }
      }
    }
  }
  hqdist = Math.abs(hqx) + Math.abs(hqy);
  console.log("Location: " + x + "," + y + " distance " + (Math.abs(x) + Math.abs(y)) + ". HQ: " + hq + " distance " + hqdist);
}
