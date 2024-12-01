# MealGen (CP317 Project)
MealGen is a Software Engineering Project developed using Python Flask for the server and Flutter Dart framework for the client. The software relies on MongoDB clusters for it's database. This mobile application is designed to be used as a form of community hub for individuals to share food recipes and receive feedback from others. This consists of uploading your own recipes with a title, description and a attached image and letting others view it and provide feedback by liking the recipe.

# Database Layout
The database is laid out and designed in such a way that it can be used like a relational database with 3 collections: users, likes and recipes.

# Features
- Login/Signup (encrypted using bcrypt)
- Authentication (using JWT)
- Navigation menu using routes
- Dynamic list of recipes with sorting
- API endpoints for retrieving recipes, uploading recipes, liking and unliking recipes

> [!IMPORTANT]
> The application has been coded with maintainability and simplicity in mind. Some elements may hint towards features that are not implemented as it was not planned in project requirements however could be potentially implemented in the future. 