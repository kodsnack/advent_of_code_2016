// Open input file
var file = process.argv[2];

// Valid input?
if(file != undefined) {
  var fs = require("fs");
  var data = fs.readFileSync(file);

  var decompressedVer1 = decompressVer1(data.toString());
  var decompressedVer2 = decompressVer2(data.toString());

  console.log(decompressedVer1.length - 1); // Adjust for carrage return at eof
  console.log(decompressedVer2);

} else {
  console.log("Undefined input, exiting...");
  process.exit();
}

function decompressVer1(input) {
  var result = "";
  var start = 0;

  while((start = input.search(/\(\d+x\d+\)/)) != - 1) {
    result += input.substring(0, start);
    input = input.substring(start + 1);
    var end = input.search(/\)/);
    code = input.substring(0, end);
    code = code.split("x");
    repeated = input.substring(end + 1, end + 1 + parseInt(code[0]));

    for(var j = 0; j < parseInt(code[1]); j++) {
      result += repeated;
    }
    input = input.substring(end + 1 + parseInt(code[0]));
  }
  result += input;

  return result;
}

function decompressVer21(input) {
  var result = 0;
  var start = 0;

  while((start = input.search(/\(\d+x\d+\)/)) != - 1) {
    result += input.substring(0, start).length;
    input = input.substring(start + 1);
    var end = input.search(/\)/);
    code = input.substring(0, end);
    code = code.split("x");
    var repeated = input.substring(end + 1, end + 1 + parseInt(code[0]));
    var fixedRepeated = "";
    

  }
}

function decompressVer2(input) {
  var result = 0;
  var start = 0;

  while((start = input.search(/\(\d+x\d+\)/)) != - 1) {
    result += input.substring(0, start).length;
    input = input.substring(start + 1);
    var end = input.search(/\)/);
    code = input.substring(0, end);
    code = code.split("x");
    var repeated = input.substring(end + 1, end + 1 + parseInt(code[0]));
    var rep = "";

    for(var j = 0; j < parseInt(code[1]) - 1; j++) {
      rep += repeated;
    }

    input = rep + input.substring(end + 1);
  }
  result += input.length;

  return result;
}
