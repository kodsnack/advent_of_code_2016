let input = "L3, R1, L4, L1, L2, R4, L3, L3, R2, R3, L5, R1, R3, L4, L1, L2, R2, R1, L4, L4, R2, L5, R3, R2, R1, L1, L2, R2, R2, L1, L1, R2, R1, L3, L5, R4, L3, R3, R3, L5, L190, L4, R4, R51, L4, R5, R5, R2, L1, L3, R1, R4, L3, R1, R3, L5, L4, R2, R5, R2, L1, L5, L1, L1, R78, L3, R2, L3, R5, L2, R2, R4, L1, L4, R1, R185, R3, L4, L1, L1, L3, R4, L4, L1, R5, L5, L1, R5, L1, R2, L5, L2, R4, R3, L2, R3, R1, L3, L5, L4, R3, L2, L4, L5, L4, R1, L1, R5, L2, R4, R2, R3, L1, L1, L4, L3, R4, L3, L5, R2, L5, L1, L1, R2, R3, L5, L3, L2, L1, L4, R4, R4, L2, R3, R1, L2, R1, L2, L2, R3, R3, L1, R4, L5, L3, R4, R4, R1, L2, L5, L3, R1, R4, L2, R5, R4, R2, L5, L3, R4, R1, L1, R5, L3, R1, R5, L2, R1, L5, L2, R2, L2, L3, R3, R3, R1";
input = input.split(", ").reverse();
const DIRECTIONS = { N: 0, E: 1, S: 2, W: 3 };

const updateFacing = (currentFacing, turn) => {
    let newFacing = turn === "R" ? currentFacing + 1: currentFacing - 1;
    if (newFacing > DIRECTIONS.W) {
        newFacing = DIRECTIONS.N;
    }
    if (newFacing < DIRECTIONS.N) {
        newFacing = DIRECTIONS.W;
    }
    return newFacing;
}

const move = (startPosition, direction, steps) => {
    let x = startPosition.x, y = startPosition.y;
    if (direction === DIRECTIONS.N) {
        y = startPosition.y + steps;
    }
    if (direction === DIRECTIONS.S) {
        y = startPosition.y - steps;
    }
    if (direction === DIRECTIONS.E) {
        x = startPosition.x + steps;
    }
    if (direction === DIRECTIONS.W) {
        x = startPosition.x - steps;
    }
    return { x, y, facing: direction }
}

const updatePosition = (position, cmd, rest) => {
    let turn = cmd.slice(0,1);
    let steps = parseInt(cmd.slice(1), 10);
    let newFacing = updateFacing(position.facing, turn);
    let newPosition = move(position, newFacing, steps);
    if (rest.length === 0) {
        return newPosition;
    }
    return updatePosition(newPosition, rest.pop(), rest);
}

const distanceFromOrigin = (position) => {
    return position.x + position.y;
}

console.log(distanceFromOrigin(updatePosition({ x: 0, y: 0, facing: DIRECTIONS.N }, input.pop(), input)));