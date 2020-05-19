from bson import json_util
import dateutil.parser
from datetime import datetime
from functools import reduce
from mongoengine import Q

ISO_FORMAT = '%Y-%m-%dT%H:%M:%S.000'

def format_query(args, query):
    query_parts = []
    # multiple truck ids
    if args.get('usernames'):
    	query_parts.append(prepare_condition('username', 'in', args.get('usernames')))
    # title text query
    if args.get('displayed_name'):
    	query_parts.append(prepare_condition('displayed_name', 'icontains', args['displayed_name']))
    # TODO: filter by isOpen 
    # if args.get('isOpen'):
    #     query_parts.append({'recurrenceId': {'$eq': int(args.get('recurrenceId'))}})
    # tags query 
    if args.get('tags'):
    	query_parts.append(prepare_condition('tags', 'in', sorted(args.get('tags'))))

    if len(query_parts) != 0:
        return reduce(lambda a, b: a & b, query_parts)
    return Q()

def  prepare_condition(field, operator, value):
    field = [field, operator]
    field = (s for s in field if s)
    field = '__'.join(field)
    return Q(**{field: value})

def parse_string_to_datetime(timestamp):
	# return dateutil.parser.isoparse(timestamp)
	return datetime.strptime(timestamp, ISO_FORMAT)

def objects_to_json(object):
	return json_util.loads(object.to_json())
