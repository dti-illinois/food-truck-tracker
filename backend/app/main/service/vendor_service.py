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

# The function takes in vendor as a json object 
def add_vendor_info(vendor):
	start, end = vendor['schedule']['start'].time(), vendor['schedule']['end'].time()
	now = datetime.now(timezone.utc).time()
	if now >= start and now <= end:
		vendor['is_open'] = True
	else:
		vendor['is_open'] = False
	return vendor 
