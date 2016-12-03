// Open input file
var file = process.argv[2];

// Valid input?
if(file != undefined) {
  var fs = require("fs");
  var data = fs.readFileSync(file);

  count(data.toString());

} else {
  console.log("Undefined input, exiting...");
  process.exit();
}

function count(input) {
  var list = input.split("\n");
  var triangles = 0;

  for(var i = 0; i < list.length - 1; i++) {
    var dim = list[i].split(" ").sort();
    dim = dim.splice(dim.length - 3, 3).map(function( num ){ return parseInt( num, 10 ) });
    dim = dim.sort(function(a, b){return a - b})
    if(dim[0] + dim[1] > dim[2]) {
      triangles++;
    }
  }
  console.log(triangles);
}
