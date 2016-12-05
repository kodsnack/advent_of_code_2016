const crypto = require('crypto');

const createMD5Hash = (string) => {
    return crypto.createHash("md5").update(string).digest("hex");
};

const findPassword = (input) => {
    let password = Array(8).fill(null);
    let count = 0;
    let foundCharacters = 0;
    while (foundCharacters < password.length) {
        const hash = createMD5Hash(input + count);
        if (hash.startsWith("00000")) {
            const position = parseInt(hash.charAt(5), 10);
            if (!isNaN(position) && position <= 7 && password[position] === null) {
                console.log("Found a character!");
                password[position] = hash.charAt(6);
                foundCharacters++;
            }
        }
        count++;
    }
    return password.join("");
};

console.log(findPassword(process.argv[2]));
