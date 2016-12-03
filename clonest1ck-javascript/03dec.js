// Open input file
var file = process.argv[2];

// Valid input?
if(file != undefined) {
  var fs = require("fs");
  var data = fs.readFileSync(file);

  count(data.toString());
  countColumn(data.toString());

} else {
  console.log("Undefined input, exiting...");
  process.exit();
}

function count(input) {
  var list = parse(input)
  var triangles = 0;

  for(var i = 0; i < list.length - 1; i++) {
    var dim = list[i].sort(sortNum)
    if(dim[0] + dim[1] > dim[2]) {
      triangles++;
    }
  }
  console.log(triangles);
}

function countColumn(input) {
  var list = parse(input);
  var triangles = 0;

  for(var i = 0; i < list.length - 1; i += 3) {
    for(var j = 0; j < 3; j++) {
      var trie = [];
      for(var k = 0; k < 3; k++) {
        trie.push(list[i+k][j]);
      }
      trie = trie.sort(sortNum);
      if(trie[0] + trie[1] > trie[2]) {
        triangles++;
      }
    }
  }
  console.log(triangles);
}

function parse(str) {
  var list = str.split("\n");
  var res = /\s+/;
  var rer = /^\s+|\s+$/g;

  for(var i = 0; i < list.length - 1; i++) {
    var dim = list[i].replace(rer, '').split(res);
    list[i] = dim.map(function( num ){ return parseInt( num, 10 ) });
  }
  return list;
}

function sortNum(a, b) {
  return a - b;
}
