import werkzeug
werkzeug.cached_property = werkzeug.utils.cached_property
from flask_restx import Api
from flask import Blueprint
from .main.controller.vendor_controller import api as vendor_ns

blueprint = Blueprint('api', __name__)

api = Api(blueprint,
          title='FOOD TRUCK TRACKER API BOILER-PLATE',
          version='1.0',
          description='a boilerplate for flask restplus web service'
          )
api.add_namespace(vendor_ns, path='/vendor')
