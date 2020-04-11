from ..model.vendor_model import *
from ..model.user_model import User 
from datetime import date, datetime, timezone
from bson import json_util
from ..utils.utils import parse_string_to_datetime, objects_to_json

def get_all_vendors():
	ret = objects_to_json(Vendor.objects())
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
	start, end = vendor['schedule']['start'].time(), vendor['schedule']['end'].time()
	now = datetime.now(timezone.utc).time()
	if start <= now <= end:
		vendor['is_open'] = True
	else:
		vendor['is_open'] = False
	return vendor

def post_vendor(vendor):
	try:
		location = Location()
		if 'location' in vendor:
			location = Location(lat=vendor['location']['lat'], lng=vendor['location']['lng'])
		schedule = Schedule()
		if 'schedule' in vendor:
			schedule = Schedule(end=parse_string_to_datetime(vendor['schedule']['end']), start=parse_string_to_datetime(vendor['schedule']['start']))
		print("schedule is done!")
		vendor_document = Vendor(
			username = vendor['username'],
			displayed_name = vendor['displayed_name'],
			location = location,
			schedule = schedule,
			description = vendor.get('description', ''),
			tags = vendor.get('tags', ''),
		)
		vendor_document = vendor_document.save()
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
			vendor.update(location = Location(lat=update_vendor['location']['lat'], lng=update_vendor['location']['lng']))
		if 'schedule' in update_vendor:
			vendor.update(schedule = Schedule(end=parse_string_to_datetime(update_vendor['schedule']['end']), start=parse_string_to_datetime(update_vendor['schedule']['start'])))
		if 'description' in update_vendor:
			vendor.update(description = update_vendor['description'])
		vendor.save()
		return add_vendor_info(objects_to_json(vendor))
	except Vendor.DoesNotExist:
		return "contain invalid truck usernames"
