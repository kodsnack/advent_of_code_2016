const getNumberAtPosition = (position, pad) => {
    return pad[position.y][position.x];
};

const step = (currentPosition, instruction, pad) => {
    const updatePosition = (axis, delta) => {
        const newIndex = currentPosition[axis] + delta;
        const newPosition = Object.assign({}, currentPosition, {
            [axis]: newIndex < 0 ? 0 : Math.min(newIndex, pad.length - 1),
        });
        if (getNumberAtPosition(newPosition, pad) === null) {
            return currentPosition;
        }
        return newPosition;
    };

    if (instruction === "U") {
        return updatePosition("y", -1);
    }
    if (instruction === "D") {
        return updatePosition("y", 1);
    }
    if (instruction === "R") {
        return updatePosition("x", 1);
    }
    if (instruction === "L") {
        return updatePosition("x", -1);
    }
    throw new Error(`Invalid instruction: ${ instruction }`);
};

const followInstruction = (initialPosition, instructions, pad) => {
    return instructions.split("").reduce((currentPosition, instruction) => {
        return step(currentPosition, instruction, pad);
    }, initialPosition);
};

const follow = (initialPosition, instructionList, pad) => {
    return instructionList.reduce((positions, instructions) => {
        const lastPosition = positions.length > 0 ? positions[positions.length - 1] : initialPosition;
        return positions.concat(followInstruction(lastPosition, instructions, pad));
    }, []);
};

const getCode = (initialPosition, instructionList, pad) => {
    return follow(initialPosition, instructionList, pad).map((position) => getNumberAtPosition(position, pad));
};

module.exports = { getCode };
