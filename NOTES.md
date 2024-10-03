# Notes
Welcome to the notes section. This section is to guide you through the directory and understanding of what a project typically contains. These are in no particular order.

# decorators
Python decorators are basically functions in functions. This is thanks to the behaviour of being able to pass functions as parameters into other functios. I will only be using it as needed.

# .gitkeep
.gitkeep is a common file used to temporarily hold folders that you wish to have when committing changes to the repository on GitHub. An example of this would be say I am working on the backend (server) part of the project and the client folder is empty. If I still wish to have this folder show on the GitHub repository, the .gitkeep file will be kept.

# .md
.md files are are markdown files. This file itself is a markdown file. Markdown files hold raw text and is popular for writing documentation or creating formatted content such as this.

# requirements.txt
requirements.txt is a common file that comes with many python projects. This file allows for anyone to install dependencies such as frameworks and libraries with the exact versions to run the project. If we were using a different backend such as node.js dependencies would be directly installed into the project folder. Python on the other hand acts a little differently installing these frameworks and libraries globally onto your pc/laptop env.

# run.py vs __init__.py vs main.py
Different languages typically come with different setups and structures to run their application. For java we would typically use a main.java file. However, for python the "norm" is to use "\_\_init\_\_.py". Before python 3.3, an \_\_init\_\_.py file was necessary for the directory to be classified as a "package". This allows for imports from the entire package at ease for run.py and other modules that lie outside of the package. Be careful when importing modules from within the same package. It is recommended to use the local importation notation example:
import .api_end_points rather than import app.api_end_points as the latter will cause a circular importation issue due to the package being partially initialized. Generally speaking, it is better practice to use init as it will allow the project to work with older versions. Including a \_\_init\_\_.py file will cause python to automatically add \_\_pycache\_\_ which compiles imported modules to bytecode. This bytecode is used to speed up compilation time and also shows that /app directory is now recognized as a package.

# Schemas
Schemas is something interesting I've come across while working on the project (since I've never used them before). Schemas are basically blueprints for data objects (kinda similar to classes) except they are used to validate, serialize and deserialize data. You can replicate the exact same effect of a schema manually by writing your own logic. Normally when you receive data from client or server it is formatted in json string which is to be converted to a python dictionary and vice versa, schemas do these tasks for you. We will be using the marshmallow library to create the schemas. 

The primary difference between load() and dump() for schemas is what happens internally. On the surface, load() and dump() both take data and serialize/deserialize and return json-compatible output data. The main different is that load() is designed for untrusted data and dump() is designed for trusted data. This means that load() acts as a filter and cleaning function that will look for missing fields and fill them in as it's expected to receive input data which can have missing fields. On the other hand, dump() assumes all the data fields exists and will clean the remaining data to ensure it can be returned to the client.

# .env
.env files are files that store sensitive information. This type of information should not be shared publicly henced it is stored in .env files. Data in these files must be accessed through the dot-env library and the .getenv from os. It should be noted that there could be multiple .env files in a project depending on the structure. If the .env file is in the same directory as a .py file, load it explicitly through directory/parent_directory/.env.

# .gitignore
the .gitignore file lists files that should be ignored when committing changes. This includes the .env file because this information is sensitive and should not be shared.

# enums and classes
In python, when constructing a class the first parameter of the class allows you to pass another class for the current class to inherit. This is how enums are worked with in python. 

# MongoDB
Every language has their own libraries and methods to communicate with databases. In this scenario, to communicate with MongoDB using python, you'd have to use pymongo library. MongoDB offers a free "cluster" which is basically free cloud stoarge. Although it's not much for our purposes it'll suffice as it is expandable if there was a scenario in which we were to expand. It is good practice to shutdown the database client on app close. Additionally, it should be noted that it is good practice to open a connection only when needed. This indicates we need to set up a connection before each http request and close it afterwards. Keeping a connection open during the app uptime is bad practice.

# Flask
Flask is the framework we are using to set up end points. Unfortunantely, Flask only operates on HTTP which means data isn't fully secure. Securing this data would require us to push the project into a reverse proxy such as Apache. For the purpose of this assignment we will be using HTTP.

# BCrypt
BCrypt is used as a one way hash for passwords. BCrypt does this by having it's own one way algorithim and then applying a "salt" to the password. This salt is then hashed with the password and when comparing the password the salt is automatically retrieved allowing us to not store the salt. It's great to have secure password as part of the project. 