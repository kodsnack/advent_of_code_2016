// Open input file
var file = process.argv[2];

// Valid input?
if(file != undefined) {
  var fs = require("fs");
  var data = fs.readFileSync(file);

  getCodeSquarePad(data.toString());
  getCodeRombPad(data.toString());

} else {
  console.log("Undefined input, exiting...");
  process.exit();
}

function getCodeSquarePad(instr) {
  var location = 5;
  var change = 0;
  var code = "";

  var lines = instr.split("\n");

  for(line of lines) {
    for(var i = 0; i < line.length; i++) {
      if(line[i] == "U") {
        change = -3;
      } else if (line[i] == "D") {
        change = 3;
      } else if (line[i] == "R") {
        if(location % 3 == 0) {
          change = 10;
        } else {
          change = 1;
        }
      } else if (line[i] == "L") {
        if (location % 3 == 1) {
          change = 10;
        } else {
          change = -1;
        }
      }

      if(!((location + change) < 1 || (location + change) > 9)) {
        location += change;
      }

      if(i == line.length - 1) {
        code += location.toString();
      }
    }
  }
  console.log(code);
}

function getCodeRombPad(instr) {
  var x = 0;
  var y = 2;

  var pad = [[null, null, "1", null, null],
             [null,  "2", "3",  "4", null],
             [ "5",  "6", "7",  "8",  "9"],
             [null,  "A", "B", "C",  null],
             [null, null, "D", null, null]];

  var code = "";

  var lines = instr.split("\n");

  for(line of lines) {
    for(var i = 0; i < line.length; i++) {
      var dx = x;
      var dy = y;

      if(line[i] == "U") {
        dy += -1;
      } else if(line[i] == "D") {
        dy += 1;
      } else if (line[i] == "L") {
        dx += -1;
      } else if (line[i] == "R") {
        dx += 1;
      }

      if((dx == 2 && dy >= 0 && dy < 5)
          || (dy == 2 && dx >= 0 && dx < 5)
          || (dy > 0  && dy < 4 && dx > 0 && dx < 4)) {
        x = dx;
        y = dy;
      }
      if(i == line.length - 1) {
        code += pad[y][x];
      }
    }
  }
  console.log(code);
}
