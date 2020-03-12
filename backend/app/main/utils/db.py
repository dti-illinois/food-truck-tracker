from flask import current_app, g
from mongoengine import connect 

# def get_db():
#     if 'dbclient' not in g:
#         if current_app.config['DBTYPE'] == 'mongoDB':
#             try:
#                 g.dbclient = pymongo.MongoClient(current_app.config['MONGODB_CONNECTION_STRING'])
#             except PyMongoError:
#                 print("MongoDB connection failed.")
#                 if 'dbclient' in g:
#                     g.pop('dbclient', None)
#                 return None
#             g.db = g.dbclient.get_database(name=current_app.config['MONGODB_DATABASE_NAME'])
#     return g.db

######################################################################
### copied from https://github.com/rokwire/events-manager/blob/develop/db.py
### Basic DB query and insert functions
######################################################################
def find_one(co_or_ta, condition=None, *args, **kwargs):
    db = get_db()
    dbType = current_app.config['DBTYPE']
    if co_or_ta is None or db is None:
        return {}

    if dbType == "mongoDB":
        try:
            collection = db.get_collection(co_or_ta)
            result = collection.find_one(filter=condition, *args, **kwargs)
            if not result:
                return {}
            return result
        except TypeError:
            print("Invalid arguments inserted using find_one")
            return {}
        except Exception:
            traceback.print_exc()
            return {}


def find_one_and_update(co_or_ta, condition=None, update=None, **kwargs):
    db = get_db()
    dbType = current_app.config['DBTYPE']

    if co_or_ta is None or condition is None or update is None or db is None:
        return {}

    if dbType == "mongoDB":
        try:
            collection = db.get_collection(co_or_ta)
            result = collection.find_one_and_update(condition, update, **kwargs)
            if not result:
                return {}
            return result
        except TypeError:
            print("Invalid arguments inserted using find_one_and_update")
            return {}
        except Exception:
            traceback.print_exc()
            return {}


def find_all(co_or_ta, **kwarg):
    db = get_db()
    dbType = current_app.config['DBTYPE']

    if co_or_ta is None or db is None:
        return []

    if dbType == "mongoDB":
        try:
            collection = db.get_collection(co_or_ta)
            result = collection.find(**kwarg)
            if not result:
                return []
            return list(result)
        except TypeError:
            print("Invalid arguments inserted using find_all")
            return []
        except Exception:
            traceback.print_exc()
            return []

def find_all_previous_event_ids(co_or_ta, **kwarg):
    db = get_db()
    dbType = current_app.config['DBTYPE']
    if co_or_ta is None or db is None:
        return []

    if dbType == "mongoDB":
        try:
            collection = db.get_collection(co_or_ta)
            projection = {'_id':1,'dataSourceEventId':1}
            result = collection.find(projection=projection, **kwarg)
            if not result:
                return []

            ids_object_list = list()
            for data_pair in result:
                ids_object_list.append(data_pair)
            return ids_object_list

        except TypeError:
            print("Invalid arguments inserted using find_all_event_ids")
            return []
        except Exception:
            traceback.print_exc()
            return []


def find_all_event_ids(co_or_ta, **kwarg):
    db = get_db()
    dbType = current_app.config['DBTYPE']

    if co_or_ta is None or db is None:
        return []

    if dbType == "mongoDB":
        try:
            collection = db.get_collection(co_or_ta)
            projection = {'_id':0,'dataSourceEventId':1}
            result = collection.find(projection=projection, **kwarg)
            if not result:
                return []
            id_object_list = list(result)
            eventId_list = []
            for ele in id_object_list:
                eventId_list += [ele['dataSourceEventId']]
            return eventId_list

        except TypeError:
            return []
        except Exception:
            traceback.print_exc()
            return []


def insert_one(co_or_ta, document=None, **kwargs):
    db = get_db()
    dbType = current_app.config['DBTYPE']

    if document is None or co_or_ta is None or db is None:
        return InsertOneResult()

    if dbType == "mongoDB":
        try:
            collection = db.get_collection(co_or_ta)
            result = collection.insert_one(document=document, **kwargs)
            if not result:
                return InsertOneResult()
            return result
        except Exception:
            traceback.print_exc()
            return InsertOneResult()


def update_one(co_or_ta, condition=None, update=None, **kwargs):
    db = get_db()
    dbType = current_app.config['DBTYPE']

    if update is None or co_or_ta is None or condition is None or db is None:
        return UpdateResult()

    if dbType == "mongoDB":
        try:
            collection = db.get_collection(co_or_ta)
            result = collection.update_one(condition, update, **kwargs)
            if not result:
                return UpdateResult()
            return result
        except Exception:
            traceback.print_exc()
            return UpdateResult()

def update_many(co_or_ta, condition=None, update=None, **kwargs):
    db = get_db()
    dbType = current_app.config['DBTYPE']

    if update is None or co_or_ta is None or condition is None or db is None:
        return UpdateResult()

    if dbType == "mongoDB":
        try:
            collection = db.get_collection(co_or_ta)
            result = collection.update_many(condition, update, **kwargs)
            if not result:
                return UpdateResult()
            return result
        except Exception:
            traceback.print_exc()
            return UpdateResult()


def find_distinct(co_or_ta, key=None, condition=None, **kwargs):
    db = get_db()
    dbType = current_app.config['DBTYPE']

    if key is None or co_or_ta is None:
        return []

    if dbType == "mongoDB":
        try:
            collection = db.get_collection(co_or_ta)
            result = collection.distinct(key, filter=condition, **kwargs)
            if not result:
                return []
            return list(result)
        except Exception:
            traceback.print_exc()
            return []

def get_count(co_or_ta, filter, **kwargs):
    db = get_db()
    dbType = current_app.config['DBTYPE']

    if co_or_ta is None:
        return 0

    if dbType == "mongoDB":
        try:
            collection = db.get_collection(co_or_ta)
            result = collection.count_documents(filter, **kwargs)
            if not result:
                return 0
            return result
        except Exception:
            traceback.print_exc()
            return 0

#parameter: collection name, *objectId* list to delete
def delete_events_in_list(co_or_ta, objectId_list_to_delete, **kwargs):
    db = get_db()
    dbType = current_app.config['DBTYPE']

    if co_or_ta is None or db is None:
        return []

    if dbType == "mongoDB":
        try:
            collection = db.get_collection(co_or_ta)
            query = {'_id':{'$in': objectId_list_to_delete}}
            result = collection.remove(query)
            if not result:
                return []
            return objectId_list_to_delete

        except TypeError:
            return []
        except Exception:
            return []