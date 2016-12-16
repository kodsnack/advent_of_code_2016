// Open input file
var disksize = parseInt(process.argv[2]);
var input = "10111100110001111";

while(input.length < disksize) {
  var b = input;
  b = b.split("").reverse().join("");
  var c = "0";

  for(var i = 0; i < b.length; i++) {
    if(b[i] == "1") {
      c += "0";
    } else {
      c += "1";
    }
  }

  input += c;
}

input = input.slice(0, disksize);

var checksum = "11";

while(checksum.length % 2 == 0) {
  checksum = "";

  for(var i = 0; i < input.length - 1; i += 2) {
    if(input[i] == input[i + 1]) {
      checksum += "1";
    } else {
      checksum += "0";
    }
  }
  input = checksum;
}

console.log(checksum);
