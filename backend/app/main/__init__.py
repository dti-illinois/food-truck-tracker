from flask import Flask
from .config import config_by_name
from flask_mongoengine import MongoEngine

db = MongoEngine()

def create_app(config_name):
    app = Flask(__name__)
    app.config.from_object(config_by_name[config_name])
    print(config_by_name[config_name].MONGODB_SETTINGS["host"])
    db.init_app(app)
    return app
