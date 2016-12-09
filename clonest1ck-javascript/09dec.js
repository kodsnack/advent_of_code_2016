// Open input file
var file = process.argv[2];

// Valid input?
if(file != undefined) {
  var fs = require("fs");
  var data = fs.readFileSync(file);

  var decompressed = decompress(data.toString());

  console.log(decompressed.length - 1); // Adjust for carrage return at eof

} else {
  console.log("Undefined input, exiting...");
  process.exit();
}

function decompress(input) {
  var result = "";
  var start = 0;

  while((start = input.search(/\(\d+x\d+\)/)) != - 1) {
    result += input.substring(0, start);
    input = input.substring(start + 1);
    var end = input.search(/\)/);
    code = input.substring(0, end);
    code = code.split("x")
    repeated = input.substring(end + 1, end + 1 + parseInt(code[0]));

    for(var j = 0; j < parseInt(code[1]); j++) {
      result += repeated;
    }
    input = input.substring(end + 1 + parseInt(code[0]));
  }
  result += input;

  return result;
}
