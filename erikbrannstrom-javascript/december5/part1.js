const crypto = require('crypto');

const createMD5Hash = (string) => {
    return crypto.createHash("md5").update(string).digest("hex");
};

const findPassword = (input) => {
    let password = [];
    let count = 0;
    while (password.length < 8) {
        const hash = createMD5Hash(input + count);
        if (hash.startsWith("00000")) {
            password.push(hash.charAt(5));
        }
        count++;
    }
    return password.join("");
};

console.log(findPassword(process.argv[2]));
