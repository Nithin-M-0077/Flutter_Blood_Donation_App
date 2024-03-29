import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final CollectionReference donor =
  FirebaseFirestore.instance.collection('donor');

  TextEditingController searchController = TextEditingController();
  late Stream<QuerySnapshot> _stream;

  void deleteDonor(docId) {
    donor.doc(docId).delete();
  }

  void updateSearchResults(String query) {
    setState(() {
      _stream = donor
          .where('name', isGreaterThanOrEqualTo: query)
          .where('name', isLessThan: query + 'z')
          .snapshots();
    });
  }

  @override
  void initState() {
    super.initState();
    _stream = donor.snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "- Blood Donor's \n   Database",
          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 30),
        ),
        elevation: 0,
        toolbarHeight: MediaQuery.of(context).size.height * 0.25,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.red,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add');
        },
        backgroundColor: Colors.red,
        child: Icon(
          Icons.add,
          size: 45,
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              style: TextStyle(
                fontSize: 13,
                color: Colors.white,
                fontWeight: FontWeight.w800,
              ),
              cursorColor: Colors.red,
              controller: searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                hintStyle: TextStyle(
                  fontSize: 13,
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                suffixIcon: IconButton(
                  icon: Icon(
                    Icons.clear,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    searchController.clear();
                    updateSearchResults('');
                  },
                ),
                filled: true,
                fillColor: Colors.red,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
              onChanged: (value) {
                updateSearchResults(value);
              },
            ),
          ),
          Expanded(
            child: StreamBuilder(
              stream: _stream,
              builder: (context, AsyncSnapshot snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(color: Colors.red),
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                } else if (snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        final DocumentSnapshot donorSnap =
                        snapshot.data.docs[index];
                        return Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Container(
                            height: 100,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black12,
                                    blurRadius: 20,
                                    spreadRadius: 10)
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: CircleAvatar(
                                    backgroundColor: Colors.red,
                                    radius: 30,
                                    child: Text(
                                      donorSnap['group'],
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 30,
                                          fontWeight: FontWeight.w900),
                                    ),
                                  ),
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      donorSnap['name'],
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w700),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      donorSnap['phone'].toString(),
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pushNamed(context, '/update',
                                            arguments: {
                                              'name': donorSnap['name'],
                                              'phone':
                                              donorSnap['phone'].toString(),
                                              'group': donorSnap['group'],
                                              'id': donorSnap.id,
                                            });
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        size: 20,
                                      ),
                                      iconSize: 30,
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        deleteDonor(donorSnap.id);
                                      },
                                      icon: Icon(Icons.delete),
                                      iconSize: 20,
                                      color: Colors.deepOrange,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  );
                } else {
                  return Container();
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
