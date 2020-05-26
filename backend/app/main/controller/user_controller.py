from flask import request
from flask_restx import Resource

from ..utils.dto import UserDto
from ..service.user_service import *

api = UserDto.api
_user_detail = UserDto.user_detail

@api.route('/<user_username>')
@api.param('user_username', 'The User identifier')
@api.response(404, 'User not found.')
class User(Resource):
    @api.doc('get a user')
    @api.marshal_with(_user_detail)
    def get(self, user_username):
        """get a user with its identifier"""
        user = get_user_by_username(user_username)
        if not user:
            api.abort(404)
        else:
            return user
