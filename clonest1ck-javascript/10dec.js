class Robot {
  constructor() {
    this.instruction = [];
    this.chips = 0;
  }

  check() {
    if(this.lower == 17 && this.higher == 61) {
      var found = true;
    } else {
      var found = false;
    }

    var ins = this.instruction.pop();
    var low = "value " + this.lower  + " goes to " + ins[2] + " " + ins[3];
    var high = "value " + this.higher + " goes to " + ins[7] + " " + ins[8];
    var res = [];
    res.push(low);
    res.push(high);


    this.lower = null;
    this.higher = null;
    this.chips = 0;
    return [this, found, res];
  }

  giveChip(value) {
    if(this.chips == 0) {
      this.lower = value;
      this.chips++;
      return [this, false, null];
    } else {
      if(this.lower > value) {
        this.higher = this.lower;
        this.lower = value;
      } else {
        this.higher = value;
      }
      this.chips++;
      if(this.instruction.length > 0 && this.chips == 2) {
        return this.check();
      } else {
        return [this, false, null];
      }
    }
  }

  giveInstruction(instruction) {
    this.instruction.push(instruction.split(" ").slice(3));

    if(this.chips == 2) {
      return this.check();
    } else {
      return [this, false, null];
    }
  }
}


// Open input file
var file = process.argv[2];

// Valid input?
if(file != undefined) {
  var fs = require("fs");
  var data = fs.readFileSync(file);

  var result1 = extracter1(data.toString());

  console.log(result1["output 0"] * result1["output 1"] * result1["output 2"]);

} else {
  console.log("Undefined input, exiting...");
  process.exit();
}

function extracter1(input) {
  var input = input.split("\n");
  var bots = {};

  for(var i = 0; i < input.length; i++) {
    bots = processInstr(bots, input[i]);
  }
  return bots;
}

function processInstr(bots, instr) {
  var ins = instr.split(" ");

  if(ins[0] === "value") {
    var to = ins[4] + " " + ins[5];
    var val = parseInt(ins[1]);
    var res;

    if(ins[4] === "output") {
      bots[to] = bots[to] + val || val;
      res = [false, null];
    } else {
      if(bots[to]) {
        var res = bots[to].giveChip(val);
        bots[to] = res[0];
      } else {
        var robot = new Robot();
        res = robot.giveChip(val);
        robot = res[0];
        bots[to] = robot;
      }
    }
  } else {
    var to = ins[0] + " " + ins[1];

    if(bots[to]) {
      var res = bots[to].giveInstruction(instr);
      bots[to] = res[0];
    } else {
      var robot = new Robot();
      res = robot.giveInstruction(instr);
      robot = res[0];
      bots[to] = robot;
    }
  }

  if(res[1]) {
    console.log("THE WINNER IS: " + to);
  }
  if(res[2] != null) {
    bots = processInstr(bots, res[2][0]);
    bots = processInstr(bots, res[2][1]);
  }

  return bots;
}
