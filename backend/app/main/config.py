import os
import urllib
from dotenv import load_dotenv
load_dotenv()

# uncomment the line below for postgres database url from environment variable
mongo_host = os.environ['MONGODB_HOSTNAME']
mongo_username = os.environ['MONGODB_USERNAME']
mongo_password = os.environ['MONGODB_PASSWORD']
mongo_dbname = os.environ['MONGODB_DATABASE']
mongo_param = os.environ['MONGODB_PARAMS']
basedir = os.path.abspath(os.path.dirname(__file__))

class Config:
    DEBUG = False

class DevelopmentConfig(Config):
    # uncomment the line below to use postgres
    DEBUG = True
    DBTYPE = 'mongoDB'
    MONGODB_SETTINGS = {
        "db": mongo_dbname,
        "username": mongo_username,
        "password": mongo_password, 
        "host": 'mongodb://{}:{}@{}/{}?{}'.format(mongo_username, mongo_password, mongo_host, mongo_dbname, mongo_param)
    }

class TestingConfig(Config):
    DEBUG = True
    TESTING = True
    # MONGODB_CONNECTION_STRING = ''


class ProductionConfig(Config):
    DEBUG = False
    # MONGODB_CONNECTION_STRING = ''


config_by_name = dict(
    dev=DevelopmentConfig,
    test=TestingConfig,
    prod=ProductionConfig
)

