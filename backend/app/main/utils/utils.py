from mongoengine import Q
from functools import reduce

def format_query(args, query):
    query_parts = []
    # multiple truck ids
    if args.get('username'):
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