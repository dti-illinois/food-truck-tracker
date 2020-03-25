from ..model.vendor_model import *
from datetime import date, datetime, timezone
from bson import json_util

ISO_FORMAT = 'YYYY-MM-DDTHH:MM:SS'
STRPTIME_FORMAT = '%Y-%m-%dT%H:%M:%S'

def get_all_vendors():
	ret = json_util.loads(Vendor.objects().to_json())
	return list(map(add_vendor_info, ret))

def get_vendor_by_username(username):
	ret = json_util.loads(Vendor.objects.get(username=username).to_json())
	return add_vendor_info(ret)

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
	vendor_document = Vendor()
	vendor_document.username = vendor['username']
	vendor_document.displayed_name = vendor['displayed_name']
	vendor_document.location = Location()
	vendor_document.location.lat = vendor['location']['lat']
	vendor_document.location.lng = vendor['location']['lng']
	vendor_document.schedule = Schedule()
	vendor_document.schedule.end = datetime.strptime(vendor['schedule']['end'], STRPTIME_FORMAT)
	vendor_document.schedule.start = datetime.strptime(vendor['schedule']['start'], STRPTIME_FORMAT)
	vendor_document.description = vendor['description']
	vendor_document.tags = vendor['tags']
	vendor_document = vendor_document.save()
	return json_util.loads(vendor_document.to_json())
