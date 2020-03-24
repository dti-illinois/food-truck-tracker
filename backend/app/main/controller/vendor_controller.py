from flask import request
from flask_restx import Resource

from ..utils.dto import VendorDto
from ..service.vendor_service import *

api = VendorDto.api
_vendor = VendorDto.vendor
_vendor_detail = VendorDto.vendor_detail

@api.route('/home')
class Home(Resource):
    def get(self):
        return "Hello World!"

@api.route('/')
class VendorList(Resource):
    @api.doc('list_of_registered_vendors')
    @api.marshal_list_with(_vendor)
    def get(self):
        """List all vendors"""
        return get_all_vendors()

@api.route('/<vendor_username>')
@api.param('vendor_username', 'The Vendor identifier')
@api.response(404, 'User not found.')
class Vendor(Resource):
    @api.doc('get a vendor')
    @api.marshal_with(_vendor_detail)
    def get(self, vendor_username):
        """get a vendor with its identifier"""
        vendor = get_vendor_by_username(vendor_username)
        if not vendor:
            api.abort(404)
        else:
            return vendor

@api.route('/fav_trucks/<username>')
@api.param('username', 'The User identifier')
class FavTruck(Resource):
    @api.doc('get favorite vendors of user')
    @api.marshal_list_with(_vendor)
    def get(self, username):
        """get a vendor with its identifier"""
        return get_fav_trucks(username)
