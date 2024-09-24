const express = require('express');
require('dotenv').config();

// Purpose of the server class object is to create an active server with HTTPS responses.
class Server {
    constructor() {
        this.app = express();
        this.port = process.env.PORT;
    };

    initServer() {
        this.app.get('/json', (req, res) => {
            const data = { name: 'John', age: 30 };
            res.json(data);  // Return JSON response
        });

        this.app.listen(this.port, () => {
            console.log(`Server running at http://localhost:${this.port}`);
        });
    }
}

module.exports = Server;
