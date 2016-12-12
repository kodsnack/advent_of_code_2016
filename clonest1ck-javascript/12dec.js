// Open input file
var file = process.argv[2];
var part = process.argv[3];

// Valid input?
if(file != undefined) {
  var fs = require("fs");
  var data = fs.readFileSync(file);

  if(part === "1") {
    var cone = false;
  } else {
    var cone = true;
  }

  var regA = simulate(data.toString(), cone);
  console.log("Register A: " + regA);
  //console.log(result1["output 0"] * result1["output 1"] * result1["output 2"]);

} else {
  console.log("Undefined input, exiting...");
  process.exit();
}

function simulate(prgrm, cone) {
  prgrm = prgrm.split("\n");
  var regs = {};
  regs["a"] = 0;
  regs["b"] = 0;
  regs["d"] = 0;

  if(cone) {
    regs["c"] = 1;
  } else {
    regs["c"] = 0;
  }

  var step = 1;

  for(var sp = 0; sp < prgrm.length; sp += step) {
    step = 1;
    var ins = prgrm[sp].split(" ");

    switch(ins[0]) {
      case "cpy":
          regs = cpy(regs, ins[1], ins[2]);
        break;
      case "inc":
          regs = inc(regs, ins[1]);
        break;
      case "dec":
          regs = dec(regs, ins[1]);
        break;
      case "jnz":
          [regs, step] = jnz(regs, ins[1], ins[2], step);
        break;
    }
  }
  return regs["a"];
}

function cpy(regs, x, y) {
  var xi = parseInt(x);

  if(isNaN(xi)) {
    regs[y] = regs[x];
  } else {
    regs[y] = xi;
  }

  return regs;
}

function inc(regs, x) {
  regs[x]++;

  return regs;
}

function dec(regs, x) {
  regs[x]--;
  return regs;
}

function jnz(regs, x, y, step) {
  if(regs[x] !== 0) {
    step = parseInt(y);
  }

  return [regs, step];
}
