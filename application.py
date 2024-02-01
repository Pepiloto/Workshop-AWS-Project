import os
import sys
import json

import flask
from flask import request, Response

print("Configue the application")
THEME = 'default' if os.environ.get('THEME') is None else os.environ.get('THEME')
FLASK_DEBUG = 'false' if os.environ.get('FLASK_DEBUG') is None else os.environ.get('FLASK_DEBUG')

application = flask.Flask(__name__)
application.config.from_object(__name__)
application.config.from_pyfile('application.config', silent=True)
application.debug = application.config['FLASK_DEBUG'] in ['true', 'True']


@application.route('/')
def welcome():
    theme = application.config['THEME']
    return flask.render_template('index.html', theme=theme, flask_debug=application.debug)

if __name__ == '__main__':
    init_db()
    application.run(host='0.0.0.0')
