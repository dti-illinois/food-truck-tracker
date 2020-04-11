from datetime import datetime
from bson import json_util
import dateutil.parser

ISO_FORMAT = '%Y-%m-%dT%H:%M:%S.000'

def parse_string_to_datetime(timestamp):
	# return dateutil.parser.isoparse(timestamp)
	return datetime.strptime(timestamp, ISO_FORMAT)

def objects_to_json(object):
	return json_util.loads(object.to_json())