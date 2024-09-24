const Server = require("./server");
const MongoDB = require("./mongodb");

class Main {
    constructor() {
        this.server = new Server();
        this.server.initServer();
        this.database = new MongoDB();
        this.database.initDatabase();
    };
}

new Main();