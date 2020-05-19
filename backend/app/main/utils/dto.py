from flask_restx import Namespace, fields
from ..model.vendor_model import VendorTags, TimeFormat

class VendorDto:
    api = Namespace('vendor', description='vendor related operations')
    location = api.model('location', {
    	'lat': fields.Float(required=True),
    	'lng': fields.Float(required=True),
        'location_name': fields.String(default=''),
    	})
    schedule = api.model('schedule', {
    	'start': fields.DateTime(required=True),
    	'end': fields.DateTime(required=True),
    	})
    caldendarItem = api.model('schedule', {
        'start': fields.DateTime(required=True),
        'end': fields.DateTime(required=True),
        'location': fields.Nested(location),
        'week_day': fields.String(enum=TimeFormat.days),
        })
    vendor = api.model('vendor', {
        'displayed_name': fields.String(description='vendor displayed name'),
        'username': fields.String(required=True, description='vendor username'),
        'location': fields.Nested(location, description='vendor location'),
        'schedule': fields.Nested(schedule, description='vendor schedule'),
        'tags': fields.List(fields.String(enum = VendorTags.tags)),
        'is_open': fields.Boolean(readonly=True, description='is vendor open'),
    })
    vendor_detail = api.inherit('vendor_detail', vendor, {
        'description': fields.String(description='vendor description', default=''),
        'weekly_schedule': fields.List(fields.Nested(caldendarItem))
    })

class UserDto:
    api = Namespace('user', description='user related operations')
    user_detail = api.model('user', {
            'username': fields.String(description='user username'),
            'fav_trucks': fields.List(fields.String()),
        })