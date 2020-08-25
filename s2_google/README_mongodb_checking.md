# Quickly check database already running with `mongod`

``` mongo
    > mongo
    > show dbs
    > use DBNAME
    > show collections
    $ Connect to a collection and do counting or print
    > db["integer_collection_name"].count
    > db["integer_collection_name"].estimatedDocumentCount()
    > db["integer_collection_name"].find().pretty()
    $ Method to retrive collections in a list
    > db.getCollectionNames()
    $ Now, to count all record in all collections
    > db.getCollectionNames().forEach(function(collname){ print(db[collname].count()) })

```
