from ..model.vendor_model import *
from ..model.user_model import User 
from datetime import date, datetime, timezone
from dateutil import tz
from bson import json_util
from ..utils.utils import parse_string_to_datetime, objects_to_json

def get_vendors(query={}, limit=0, skip=0):
	vendors = []
	vendors = Vendor.objects.filter(query)
	ret = json_util.loads(vendors.to_json())
	return list(map(add_vendor_info, ret))

def get_vendor_by_username(username):
	try:
		ret = objects_to_json(Vendor.objects.get(username=username))
		return add_vendor_info(ret)
	except Vendor.DoesNotExist:
		return None

def get_fav_trucks(username):
	try:
		user = User.objects.get(username=username)
		trucks = map(lambda t: add_vendor_info(json_util.loads(t.fetch().to_json())), user.fav_trucks)
		return list(map(add_vendor_info, trucks))
	except User.DoesNotExist:
		return []

def update_fav_trucks(username, truck_usernames):
	try:
		user = User.objects.get(username=username)
		trucks = Vendor.objects.filter(username__in=truck_usernames)
		user.fav_trucks = trucks 
		user.save()
		return "user {} is updated".format(username)
	except User.DoesNotExist:
		return "user {} is not found".format(username)
	except Vendor.DoesNotExist:
		return "contain invalid truck usernames"

# The function takes in vendor as a json object 
def add_vendor_info(vendor):
	if 'schedule' in vendor and vendor['schedule']['start'] and vendor['schedule']['end']:
		start, end = vendor['schedule']['start'].time(), vendor['schedule']['end'].time()
		now = datetime.now(timezone.utc).astimezone(tz.tzlocal()).time()
		if start <= now <= end:
			vendor['is_open'] = True
		else:
			vendor['is_open'] = False
	else:
		vendor['is_open'] = False
	return vendor

def post_vendor(vendor):
	try:
		location = Location()
		if 'location' in vendor:
			location = create_location(vendor['location'])
		schedule = Schedule()
		if 'schedule' in vendor:
			schedule = create_schedule(vendor['schedule'])
		weekly_schedule = []
		if 'weekly_schedule' in vendor:
			weekly_schedule = create_weekly_schedule(vendor['weekly_schedule'])
		vendor_document = Vendor(
			username = vendor['username'],
			displayed_name = vendor['displayed_name'],
			location = location,
			schedule = schedule,
			description = vendor.get('description', ''),
			tags = vendor.get('tags', []),
			weekly_schedule = weekly_schedule,
		)
		vendor_document.save()
		return get_vendor_by_username(vendor['username'])
	except:
		return "Error Occurred"

def update_vendor_by_username(username, update_vendor):
	try:
		vendor = Vendor.objects.get(username=username)
		if 'displayed_name' in update_vendor:
			vendor.update(displayed_name = update_vendor['displayed_name'])
		if 'tags' in update_vendor:
			vendor.update(tags = update_vendor['tags'])
		if 'location' in update_vendor:
			vendor.update(location = create_location(update_vendor['location']))
		if 'schedule' in update_vendor:
			vendor.update(schedule = create_schedule(update_vendor['schedule']))
		if 'description' in update_vendor:
			vendor.update(description = update_vendor['description'])
		if 'weekly_schedule' in update_vendor:
			vendor.update(weekly_schedule = create_weekly_schedule(update_vendor['weekly_schedule']))
		vendor = vendor.save()
		return get_vendor_by_username(vendor['username'])
	except Vendor.DoesNotExist:
		return "contain invalid truck usernames"

def create_location(location):
	return Location(lat=location['lat'], lng=location['lng'], location_name=location.get('location_name', ''))

def create_schedule(schedule):
	return Schedule(end=parse_string_to_datetime(schedule['end']), start=parse_string_to_datetime(schedule['start']))

def create_weekly_schedule(weekly_schedule):
	return list(map(lambda s: CalendarItem(
			end=parse_string_to_datetime(s['end']), 
			start=parse_string_to_datetime(s['start']),
			week_day=s['week_day'],
			location=create_location(s['location'])
		), weekly_schedule))
