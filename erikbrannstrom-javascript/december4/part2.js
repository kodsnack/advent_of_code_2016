const Room = require("./Room");

const getRooms = (input) => {
    return input.split("\n").map(Room.parse);
};

const decryptCharacter = (char, key) => {
    if (char === "-") {
        return " ";
    }

    const NUM_CHARS = 26;
    const CHAR_CODE_OFFSET = 97; // Letter A
    const charCode = char.charCodeAt(0);
    const decryptedCharCode = ((charCode - CHAR_CODE_OFFSET + key) % NUM_CHARS) + CHAR_CODE_OFFSET;
    return String.fromCharCode(decryptedCharCode);
};

const getDecryptedRoom = (room) => {
    const name = room.name.split("").map(char => decryptCharacter(char, room.sector)).join("");
    return Object.assign({}, room, { name });
};

const getDecryptedRooms = (rooms) => {
    const validRooms = rooms.filter(Room.verifyChecksum);
    return validRooms.map(getDecryptedRoom);
};

const rooms = getRooms(process.argv[2]);
console.log(getDecryptedRooms(rooms).filter(room => room.name.indexOf("north") > -1));
