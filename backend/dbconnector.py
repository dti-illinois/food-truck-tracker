from pymongo import MongoClient

client = MongoClient('mongodb+srv://user1:rokwiredatabase@cluster0-fnqs2.mongodb.net/test?retryWrites=true&w=majority')

db = client['foodtrucktracker']

vendors = db['vendors']
vendors.delete_many({})
sample_data = [ \
	{'name': 'Cracked', 'cuisine': ['american'], 'isOpen': 'false', 'foodServed': ['burrito']}, 
	{'name': 'DragonFire', 'cuisine': ['american'], 'isOpen': 'true', 'foodServed': ['pizza']}
]
new_vendors = vendors.insert_many(sample_data)
print(new_vendors.inserted_ids)
for x in vendors.find({}, {'name'}):
	print(x['name'])
query = {'isOpen': 'true'}
doc = vendors.find(query)
for x in doc:
	print(x['name'])
myquery = { "name": "DragonFire" }
newvalues = { "$set": { "isOpen": "false" } }
for x in vendors.find(query):
	print(x['name'])
