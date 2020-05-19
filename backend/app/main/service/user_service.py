from ..model.user_model import User 
from bson import json_util  

def get_user_by_username(username):
	try:
		user = User.objects.get(username=username)
		fav_trucks = get_fav_trucks_username(user)
		# TODO: find a better way to impl getting truck usernames from truck ids and add it to return result. 
		ret = json_util.loads(user.to_json())
		ret['fav_trucks'] = fav_trucks
		return ret 
	except User.DoesNotExist:
		return None

def get_fav_trucks_username(user):
	return list(map(lambda t: t.fetch().username, user.fav_trucks))

def add_user(user):
	try:
		user = User(
			username=user['username'],
			fav_trucks=user.get('fav_trucks', [])
			)
		user.save()
		return get_user_by_username(user['username'])
	except:
		return None
