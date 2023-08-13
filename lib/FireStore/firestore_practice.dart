import 'package:flutter/material.dart';

class FireStore extends StatefulWidget {
  const FireStore({
    super.key,
  });

  @override
  State<FireStore> createState() => _FireStoreState();
}

class _FireStoreState extends State<FireStore> {
  // var akRef = db.collection(userCollection).doc('AK');
  // akRef.snapshots(includeMetadataChanges: false).listen((event) {
  //   print('data has written: ${event.data()}');
  // });
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Firestore Demo'),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          ElevatedButton(
              onPressed: () async {
                // var db = FirebaseFirestore.instance;
                //     final cities = db.collection("cities");
                // final myCities = db.collection('MyCities');

                // var docRef =
                //     db.collection(userCollection).doc('uXgbKRNn9fo4JreZK4Sx');
                // docRef
                //     .collection('user')
                //     .add({'name': 'AKkkkkkkkkk', 'fee': 1200});
                //     docRef.get()
                // var docRef =
                //     db.collection(userCollection).doc('uXgbKRNn9fo4JreZK4Sx');
                // var newUserDocRef =
                //     docRef.collection('newUser').doc('newUserDoc');
                // newUserDocRef
                //     .collection('innerUSer')
                //     .doc('innerDoc')
                //     .set({'inner': 'innerName', 'innerId': 12});

                // var ref =
                //     db.collection(userCollection).doc('uXgbKRNn9fo4JreZK4Sx');
                // // ref.set({'newDox': 'doc', 'newId': 1});
                // ref
                //     .collection('user')
                //     .doc('77ZarKRFKlVDmrbR2gH1')
                //     .collection('innerUser')
                //     .doc('data')
                //     .set({'data': 5151});
                // var ref =
                //     db.collection('/user3/uXgbKRNn9fo4JreZK4Sx/newUser');

                // db
                //     .collection(userCollection)
                //     .withConverter(
                //       fromFirestore: (snapshot, options) {
                //         final data = snapshot.data();
                //         return City(
                //             postalNo: data?['postalNo'],
                //             cityName: data?['cityName']);
                //       },
                //       toFirestore: (student, options) => {
                //         'postalNo': student.postalNo,
                //         'cityName': student.cityName
                //       },
                //     )
                //     .doc('jSkeJ9GiiNfG18VTtiml')
                //     .set(City(postalNo: 12, cityName: 'Bahawalpur'),
                //         SetOptions(merge: true));

                // db.collection(userCollection).doc('AK').set({
                //   'name': 'AK',
                //   'id': 12,
                //   'tryToDo': {
                //     'programming': true,
                //     'trySelfMotivation': true,
                //     'someTimeDemotivated': false
                //   }
                // });

                // akRef.update({'listenerr': true});

                // akRef.set({
                //   'Quiet': false,
                // }, SetOptions(merge: true)).then(
                //     (value) => akRef.update({'done': true}),
                //     onError: (error) => akRef.update({'done': false}));

                // akRef.update({
                //   'consistency': FieldValue.delete(),
                //   'hardWork': FieldValue.delete()
                // });

                // console.log("Frank created")

                // akRef.update({'id': FieldValue.increment(-1)});

                // Get a new write batch

                // final batch = db.batch();

                // // Set the value of 'NYC'
                // var nycRef = db.collection("cities").doc("NYC");
                // batch.set(nycRef, {"name": "New York City"});

                // // Update the population of 'SF'
                // var sfRef = db.collection("cities").doc("SF");
                // batch.update(sfRef, {"population": 1000000});

                // // Delete the city 'LA'
                // var laRef = db.collection("cities").doc("LA");
                // batch.delete(laRef);

                // // Commit the batch
                // batch.commit().then((_) {
                //   // ...
                // });

                // A batched write can contain up to 500 operations.
                //Each operation in the batch counts separately towards your Cloud Firestore usage.

                // Queries: Simple and compound

                // final data1 = <String, dynamic>{
                //   "name": "San Francisco",
                //   "state": "CA",
                //   "country": "USA",
                //   "capital": false,
                //   "population": 860000,
                //   "regions": ["west_coast", "norcal"],
                //   'array': ['d', 'e', 'c']
                // };
                // cities.doc("SF").set(data1);

                // final data2 = <String, dynamic>{
                //   "name": "Los Angeles",
                //   "state": "CA",
                //   "country": "USA",
                //   "capital": false,
                //   "population": 3900000,
                //   "regions": ["west_coast", "socal"],
                //   'array': ['a', 'b', 'c']
                // };
                // cities.doc("LA").set(data2);

                // final data3 = <String, dynamic>{
                //   "name": "Washington D.C.",
                //   "state": null,
                //   "country": "USA",
                //   "capital": true,
                //   "population": 680000,
                //   "regions": ["east_coast"],
                //   'array': ['f', 'a', 'e']
                // };
                // cities.doc("DC").set(data3);

                // final data4 = <String, dynamic>{
                //   "name": "Tokyo",
                //   "state": null,
                //   "country": "Japan",
                //   "capital": true,
                //   "population": 9000000,
                //   "regions": [
                //     "kanto",
                //     "honshu",
                //   ],
                //   'array': ['b', 'c', 'f']
                // };
                // cities.doc("TOK").set(data4);

                // final data5 = <String, dynamic>{
                //   "name": "Beijing",
                //   "state": null,
                //   "country": "China",
                //   "capital": true,
                //   "population": 21500000,
                //   "regions": ["jingjinji", "hebei"],
                //   'array': ['a', 'b', 'c']
                // };
                // cities.doc("BJ").set(data5);

                // Group Collection

                // myCities
                //     .doc('City 1')
                //     .collection('landMark')
                //     .add({'name': 'firstSubDoc1', 'id': 1});
                // myCities
                //     .doc('City 1')
                //     .collection('landMark')
                //     .add({'name': 'secondSubDoc1', 'id': 2});

                // myCities
                //     .doc('City 2')
                //     .collection('landMark')
                //     .add({'name': 'secondSubDoc2', 'id': 1});
                // myCities
                //     .doc('City 2')
                //     .collection('landMark')
                //     .add({'name': 'secondSubDoc2', 'id': 1});

                // myCities
                //     .doc('City 3')
                //     .collection('landMark')
                //     .add({'name': 'secondSubDoc3', 'id': 3});
                // myCities
                //     .doc('City 3')
                //     .collection('landMark')
                //     .add({'name': 'secondSubDoc3', 'id': 2});
              },
              child: const Text('ADD')),
          ElevatedButton(
              onPressed: () async {
                // var query = cities.where('country', isEqualTo: 'USA');
                // var query = cities.where('population', isEqualTo: 680000);

                // var query = cities.where('state', isNull: true);
                // var query = cities.where('regions', whereIn: [
                //   ["jingjinji", "hebei"],
                //   ["kanto", "honshu"]
                // ]);

                // var query =
                //     cities.where('array', arrayContainsAny: ['e', 'b']);

                // Compound Queries:
                // var query = cities
                //     .where('population', isGreaterThan: 10)
                //     .where('population', isLessThan: 690000);

                // var query = cities
                //     .where("state", isGreaterThanOrEqualTo: "CA")
                //     .where("state", isLessThanOrEqualTo: "IN");
                // query
                //     .get(const GetOptions(source: Source.server))
                //     .then((value) {
                //   for (var doc in value.docs) {
                //     print(doc.data());
                //   }
                // });

                // Group collection query

                // db
                //     .collectionGroup('landMark')
                //     .where('id', isEqualTo: 1)
                //     .get()
                //     .then((value) {
                //   for (var doc in value.docs) {
                //     print('${doc.data()}');
                //   }
                // });
              },
              child: const Text('Fetch')),
        ],
      )),
    );
  }
}

class City {
  int postalNo;
  String cityName;
  City({required this.postalNo, required this.cityName});
}
