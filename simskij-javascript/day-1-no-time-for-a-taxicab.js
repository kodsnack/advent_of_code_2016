(function () {

    const directions = [{ x: 1, y: 0 }, { x: 0, y: 1 }, { x: -1, y: 0 }, { x: 0, y: -1 }];
    const steps = "R1, L4, L5, L5, R2, R2, L1, L1, R2, L3, R4, R3, R2, L4, L2, R5, L1, R5, L5, L2, L3, L1, R1, R4, R5, L3, R2, L4, L5, R1, R2, L3, R3, L3, L1, L2, R5, R4, R5, L5, R1, L190, L3, L3, R3, R4, R47, L3, R5, R79, R5, R3, R1, L4, L3, L2, R194, L2, R1, L2, L2, R4, L5, L5, R1, R1, L1, L3, L2, R5, L3, L3, R4, R1, R5, L4, R3, R1, L1, L2, R4, R1, L2, R4, R4, L5, R3, L5, L3, R1, R1, L3, L1, L1, L3, L4, L1, L2, R1, L5, L3, R2, L5, L3, R5, R3, L4, L2, R2, R4, R4, L4, R5, L1, L3, R3, R4, R4, L5, R4, R2, L3, R4, R2, R1, R2, L4, L2, R2, L5, L5, L3, R5, L5, L1, R4, L1, R1, L1, R4, L5, L3, R4, R1, L3, R4, R1, L3, L1, R1, R2, L4, L2, R1, L5, L4, L5".split(', ');

    let direction = 0;
    let coords = { x: 0, y: 0 }
    let visited = [];
    let firstReoccurance;

    function distance(coord) {
        return Math.abs(coord.x) + Math.abs(coord.y);
    }

    function rotate(rotation) {
        if (rotation === 'R') {
            direction = direction < 3 ? direction + 1 : 0;
        }
        else if (rotation === 'L') {
            direction = direction > 0 ? direction - 1 : 3;
        }
    }

    function compareCoords(x, y) {
        for (let i = 0; i < visited.length; i++) {
            if (visited[i].x === x && visited[i].y === y) {
                return true;
            }
        }
        return false;
    }

    function handleReoccuring() {
        if (compareCoords(coords.x, coords.y)) {
            firstReoccurance = firstReoccurance || { x: coords.x, y: coords.y };
        }
        else {
            visited.push({ x: coords.x, y: coords.y });
        }
    }

    function run() {
        for (let i = 0; i < steps.length; i++) {
            rotate(steps[i].substring(0, 1));
            let stepsToTake = parseInt(steps[i].substring(1, 4));
            for (let stepsTaken = 0; stepsTaken < stepsToTake; stepsTaken++) {
                coords.x += directions[direction].x;
                coords.y += directions[direction].y;
                handleReoccuring();
            }
        }
    }

    function printOutput() {
        console.log('Part 1: ' + distance(coords));
        console.log('Part 1: ' + distance(firstReoccurance));
    }

    run();
    printOutput();

})();