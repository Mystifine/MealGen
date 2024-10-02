from flask import Flask, jsonify;

class APIEndPoints:
    app : Flask;

    """
    Creates the flask app to be used.
    """
    def __init__(self) -> None:
        self.app = Flask(__name__);

    """
    Main handles the setup of end points
    """
    def main(self):
        self.app.run(port=8080, debug=True);
                
        @self.app.route('/api/data', methods=['GET'])
        def get_data():
            return jsonify({'key': 'value'})
