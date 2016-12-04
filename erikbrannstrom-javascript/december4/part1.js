const Room = require("./Room");

const getRooms = (input) => {
    return input.split("\n").map(Room.parse);
};

const getSectorSum = (rooms) => {
    return rooms.reduce((sum, room) => sum + room.sector, 0);
};

const validRooms = getRooms(process.argv[2]).filter(Room.verifyChecksum);
console.log(getSectorSum(validRooms));
