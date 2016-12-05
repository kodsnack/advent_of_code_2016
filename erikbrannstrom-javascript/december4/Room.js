const getChecksum = (name) => {
    const letters = name.replace(/\-/g, "").split("");
    const letterCount = letters.reduce((map, letter) => {
        if (map[letter] === undefined) {
            return Object.assign({}, map, { [letter]: 1 });
        }
        return Object.assign({}, map, { [letter]: map[letter] + 1 });
    }, {});

    const uniqueLetters = Array.from(new Set(letters));
    uniqueLetters.sort((a, b) => {
        if (letterCount[a] !== letterCount[b]) {
            return letterCount[b] - letterCount[a];
        }
        return a < b ? -1 : 1;
    });

    return uniqueLetters.slice(0, 5).join("");
};

const verifyChecksum = (room) => {
    return room.checksum === getChecksum(room.name);
}

const parse = (input) => {
    const matches = input.match(/^([a-z\-]+)\-(\d+)\[([a-z]+)\]$/);
    return {
        name: matches[1],
        sector: parseInt(matches[2], 10),
        checksum: matches[3],
    };
};


module.exports = { parse, getChecksum, verifyChecksum };
