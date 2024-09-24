const mongoose = require('mongoose');
require('dotenv').config();  

// Example schema
const userSchema = new mongoose.Schema({
  name: String,
  age: Number
});

const User = mongoose.model('User', userSchema);

class MongoDB {
    constructor() {

    };

    initDatabase() {
      // Connect to MongoDB
      mongoose.connect(mongoURI, { useNewUrlParser: true, useUnifiedTopology: true })
      .then(() => console.log('Connected to MongoDB'))
      .catch(err => console.error('Failed to connect to MongoDB:', err));
    }
}


// Create a new user
const createUser = async () => {
    const newUser = new User({ name: 'Alice', age: 25 });
    await newUser.save();
    console.log('User created:', newUser);
};

createUser();
