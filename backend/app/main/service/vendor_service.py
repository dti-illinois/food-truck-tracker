from ..model.vendor_model import Vendor
from flask import json 
from bson import json_util  

def get_all_vendors():
    ret = json_util.loads(Vendor.objects().to_json())
    return ret

def get_vendor_by_username(username):
    return json_util.loads(Vendor.objects(username=username).to_json())
