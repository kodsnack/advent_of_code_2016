const fs = require("fs");
const realRooms = [];
const data = fs.readFileSync(`${__dirname}/input.txt`, "utf-8").split("\n").map((row) => {
    const name =  row.slice(0, row.lastIndexOf("-"));
    const rest = row.slice(row.lastIndexOf("-")+1);
    const parseRest = (sidChk) => {
        return {
            sectorId: parseInt(sidChk.substring(0, sidChk.indexOf("[")), 10),
            checksum: sidChk.substring(sidChk.indexOf("[")+1, sidChk.indexOf("]")),
        };
    };
    const { sectorId, checksum } = parseRest(rest);
    const calcSum = (name) => {
        let result = {};
        for (let i = 0; i < name.length; i++) {
            const ch = name[i];
            if (ch === "-") {
                continue;
            }
            if (result[ch] === undefined) {
                result[ch] = 0;
            } else {
                result[ch] = result[ch] + 1;
            }
        }
        const sorter = (a, b) => {
            if (result[a] === result[b]) {
                if (a < b) {
                    return -1;
                }
                if (a > b) {
                    return 1;
                }
                return 0;
            }
            if (result[a] < result[b]) {
                return 1;
            }
            if (result[a] > result[b]) {
                return -1;
            }
            return 0;
        }
        const chkSum = Object.keys(result).sort(sorter).join("").substr(0,5);
        return chkSum;
    };
    const realRoom = calcSum(name) === checksum;
    if (realRoom) {
        realRooms.push({ name, sectorId });
    }
    return realRoom ? sectorId : 0;
});

const shiftRoom = (room) => {
    const steps = room.sectorId % 26;
    const coded = room.name;
    let result = [];
    for (let i = 0; i < coded.length; i++) {
        let char = coded.charAt(i);
        if (char === " ") {
            continue;
        }
        if (char === "-") {
            result.push(" ");
            continue;
        }
        let code = coded.charCodeAt(i);
        if (code + steps > 122) {
            result.push(String.fromCharCode(96 + (steps - (122-code))));
        } else {
            result.push(String.fromCharCode(code + steps));
        }
    }
    return `${ room.sectorId } ${ result.join("") }`;
};

console.log(data.reduce((a, b) => a + b, 0));
console.log(realRooms.map(shiftRoom));