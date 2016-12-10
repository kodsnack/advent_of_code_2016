const fs = require("fs");

const decompress = (string) => {
    let output = "";
    let i = 0;
    while (i < string.length) {
        const char = string[i];

        if (char !== "(") {
            output += char;
            i++;
            continue;
        }

        const markerString = string.substring(i + 1, string.indexOf(")", i));
        const markerMatch = markerString.match(/(\d+)x(\d+)/);
        let nextChar = string.indexOf(")", i) + 1;

        const repeatedString = string.substring(nextChar, nextChar + parseInt(markerMatch[1], 10));
        const repeats = parseInt(markerMatch[2], 10);
        output += repeatedString.repeat(repeats);
        i = nextChar + repeatedString.length;
    }

    return output;
};

const input = fs.readFileSync(process.argv[2], "utf8").replace("\n", "").replace(" ", "");
console.log(decompress(input).trim().length);
