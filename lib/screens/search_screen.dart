import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'orphanagescreen.dart'; // Updated import

class SearchScreen extends StatefulWidget {
  final String useremail;
  const SearchScreen({super.key, required this.useremail});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  @override
  void initState() {
    super.initState();
    getClientStream();
  }

  TextEditingController _searchController = TextEditingController();
  List<QueryDocumentSnapshot> _allResults = [];
  List<QueryDocumentSnapshot> _filteredResults = [];

  Future<void> getClientStream() async {
    var data = await FirebaseFirestore.instance
        .collection('orphanages')
        .orderBy('orphanageName')
        .get();

    setState(() {
      _allResults = data.docs;
      _filteredResults = [];
    });
  }

  void _clearSearch() {
    _searchController.clear();
    FocusScope.of(context).unfocus();
    setState(() {
      _filteredResults = []; // Clear filtered results when search is cleared
    });
  }

  void _filterResults(String query) {
    if (query.isEmpty) {
      setState(() {
        _filteredResults = _allResults; // Show all results when query is empty
      });
    } else {
      List<QueryDocumentSnapshot> filteredList = _allResults.where((result) {
        var orphanage = result.data() as Map<String, dynamic>;
        var name = orphanage['orphanageName']?.toLowerCase() ?? '';
        return name.contains(query.toLowerCase());
      }).toList();

      setState(() {
        _filteredResults = filteredList;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search...',
                prefixIcon: Icon(Icons.search),
                suffixIcon: _searchController.text.isNotEmpty
                    ? IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: _clearSearch,
                )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                contentPadding: EdgeInsets.all(16.0),
              ),
              onChanged: _filterResults,
            ),
            Expanded(
              child: _filteredResults.isEmpty
                  ? Center(
                child: Text('No results found.'),
              )
                  : ListView.builder(
                itemCount: _filteredResults.length,
                itemBuilder: (context, index) {
                  var orphanage = _filteredResults[index].data() as Map<String, dynamic>;
                  return ListTile(
                    leading: orphanage['profileImage'] != null
                        ? CircleAvatar(
                      backgroundImage: NetworkImage(orphanage['profileImage']),
                      radius: 25,
                    )
                        : CircleAvatar(
                      radius: 25,
                      child: Icon(Icons.image),
                    ),
                    title: Text(orphanage['orphanageName'] ?? 'No Name'),
                    onTap: () {
                      _showDialog(orphanage['orphanageId'],
                          (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => OrphanageScreen1(orphanageId: orphanage['orphanageId'], useremail: widget.useremail),
                              ),
                            );
                          },
                      );
                    },
                    // subtitle: Text(orphanage['someOtherField'] ?? 'No Details'),
                    // trailing: Text(orphanage['anotherField'] ?? 'No Data'),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showDialog(String title,  VoidCallback onOkPressed) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          // content: Text(content),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
                onOkPressed();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}
