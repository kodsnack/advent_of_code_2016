// Open input file
var file = process.argv[2];

// Valid input?
if(file != undefined) {
  var fs = require("fs");
  var data = fs.readFileSync(file);

  var lit = decodeDisp(data.toString());
  console.log("Lit: " + lit);

} else {
  console.log("Undefined input, exiting...");
  process.exit();
}

function decodeDisp(inp) {
  var disp = createDisp(6, 50);
  inp = inp.split("\n");

  for(var i = 0; i < inp.length - 1; i++) {
    var instr = inp[i].split(" ");
    if(instr[0] === "rect") {
      var dim = instr[1].split("x");
      disp = rect(disp, parseInt(dim[0]), parseInt(dim[1]));
      //printDisp(disp);
    } else {
      var subject = parseInt(instr[2].split("=")[1]);
      var times = parseInt(instr[4]);

      if(instr[1] === "row") {
        disp = rotateRow(disp, subject, times);
      } else {
        disp = rotateColumn(disp, subject, times);
      }
    }
  }
  return printDisp(disp);
}

function printDisp(disp) {
  console.log("Display:");
  var out = "";
  var lit = 0;

  for(row of disp) {
    for(col of row) {
      out += col;
      if(col == "#") {
        lit++;
      }
    }
    out += "\n";
  }
  console.log(out);
  return lit;
}

function createDisp(rows, cols) {
  var disp = [];
  for(var i = 0; i < rows; i++) {
    var col = []
    for(var j = 0; j < cols; j++) {
      col.push(" ");
    }
    disp.push(col);
  }
  return disp;
}

function rect(disp, A, B) {
  for(var r = 0; r < B; r++) {
    for(var c = 0; c < A; c++) {
      disp[r][c] = "#";
    }
  }
  return disp;
}

function rotateRow(disp, row, times) {
  disp[row] = disp[row].slice(disp[row].length - times, disp[row].length)
            .concat(disp[row].slice(0, disp[row].length - times));
  return disp;
}

function rotateColumn(disp, column, times) {
  var newcol = [];

  for(var i = disp.length - times; i < disp.length; i++) {
    newcol.push(disp[i][column]);
  }

  for(var i = 0; i < disp.length - times; i++) {
    newcol.push(disp[i][column]);
  }

  for(var i = 0; i < disp.length; i++) {
    disp[i][column] = newcol[i];
  }
  return disp;
}
