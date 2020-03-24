from ..model.vendor_model import Vendor
from ..model.user_model import User 
from datetime import date, datetime, timezone
from flask import json 
from bson import json_util  

ISO_FORMAT = 'YYYY-MM-DDTHH:MM:SS'

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
	if now >= start and now <= end:
		vendor['is_open'] = True
	else:
		vendor['is_open'] = False
	return vendor 
