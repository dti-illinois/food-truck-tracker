from datetime import datetime
from bson import json_util

ISO_FORMAT = '%Y-%m-%dT%H:%M:%S'

def parse_string_to_datetime(timestamp):
	return datetime.strptime(timestamp, ISO_FORMAT)

def objects_to_json(object):
	return json_util.loads(object.to_json())