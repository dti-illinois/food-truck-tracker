from ..model.vendor_model import *
from ..model.user_model import User 
from datetime import date, datetime, timezone
from bson import json_util

ISO_FORMAT = '%Y-%m-%dT%H:%M:%S'

def get_all_vendors():
	ret = json_util.loads(Vendor.objects().to_json())
	return list(map(add_vendor_info, ret))

def get_vendor_by_username(username):
	try:
		ret = json_util.loads(Vendor.objects.get(username=username).to_json())
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
			schedule = Schedule(end=datetime.strptime(vendor['schedule']['end'], ISO_FORMAT), start=datetime.strptime(vendor['schedule']['start'], ISO_FORMAT))
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