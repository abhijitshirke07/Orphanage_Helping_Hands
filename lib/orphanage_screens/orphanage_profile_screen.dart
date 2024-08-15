import 'dart:typed_data'; // Import this for Uint8List
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart'; // Import for image picking
import 'dart:io';
import 'package:intl/intl.dart';
import '../widgets/rectangular_card.dart';
import '../widgets/rectangular_card1.dart';
import '../widgets/utlis.dart';

class OrphanageProfileScreen extends StatefulWidget {
  final String email;
  const OrphanageProfileScreen({super.key, required this.email});

  @override
  State<OrphanageProfileScreen> createState() => _OrphanageProfileScreenState();
}

class _OrphanageProfileScreenState extends State<OrphanageProfileScreen> {
  File? _profileImage;
  String _userName ="";

  Map<String, List<Map<String, dynamic>>> _groupedHistoryItems = {};
  Uint8List? _image;

  final ImagePicker _picker = ImagePicker(); // Initialize ImagePicker
  CollectionReference _reference = FirebaseFirestore.instance.collection('Orphanaages');
  String imgUrl = "";

  @override
  void initState() {
    super.initState();
    _fetchUserProfile();
    _fetchHistoryData();
  }

  Future<void> _fetchUserProfile() async {
    print(widget.email);
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('orphanages')
          .where('email', isEqualTo: widget.email)
          .get();
      if (snapshot.docs.isNotEmpty) {
        var userData = snapshot.docs.first.data() as Map<String, dynamic>;
        print("a : ${widget.email}");
        setState(() {
          _userName = userData['orphanageName'] ?? '';
          imgUrl = userData['profileImage'] ?? '';
          if (imgUrl.isNotEmpty) {
            _loadNetworkImage(imgUrl);
          } else {
            _image = null;
          }
          if (_userName.isNotEmpty) {
            _loadNetworkImage(_userName);
          } else {
            _image = null;
          }
        });
      } else {
        print('No user found with the provided email');
      }
    } catch (e) {
      print('Error fetching user profile: $e');
      // Handle error
    }
  }

  Future<void> _loadNetworkImage(String url) async {
    try {
      final ByteData imageData = await NetworkAssetBundle(Uri.parse(url)).load("");
      setState(() {
        _image = imageData.buffer.asUint8List();
      });
    } catch (e) {
      print('Error loading network image: $e');
      setState(() {
        _image = null;
      });
    }
  }


  Future<void> _fetchHistoryData() async {
    try {
      // Fetch history data
      var data = await FirebaseFirestore.instance.collection('history').where('orphanage_email', isEqualTo: widget.email)
          .get();
      List<Map<String, dynamic>> historyItems = data.docs.map((doc) {
        var item = doc.data() as Map<String, dynamic>;
        // Convert Timestamp to DateTime
        if (item['date'] is Timestamp) {
          item['date'] = (item['date'] as Timestamp).toDate();
        }
        return item;
      }).toList();

      // Group items by month
      Map<String, List<Map<String, dynamic>>> groupedItems = {};
      for (var item in historyItems) {
        DateTime dateTime = item['date'] ?? DateTime.now();
        String monthYear = DateFormat('MMMM yyyy').format(dateTime);

        if (!groupedItems.containsKey(monthYear)) {
          groupedItems[monthYear] = [];
        }
        groupedItems[monthYear]!.add(item);
      }

      // Fetch profile image URL for each history item
      Map<String, String> orphanageImageUrls = {};
      for (var item in historyItems) {
        String orphanageEmail = item['orphanage_email'] ?? '';
        if (!orphanageImageUrls.containsKey(orphanageEmail)) {
          try {
            var orphanageSnapshot = await FirebaseFirestore.instance
                .collection('orphanages')
                .where('email', isEqualTo: orphanageEmail)
                .get();

            if (orphanageSnapshot.docs.isNotEmpty) {
              var orphanageData = orphanageSnapshot.docs.first.data() as Map<String, dynamic>;
              orphanageImageUrls[orphanageEmail] = orphanageData['profileImage'] ?? '';
            }
          } catch (e) {
            print('Error fetching orphanage image: $e');
          }
        }
      }

      // Add image URL to history items
      for (var item in historyItems) {
        String orphanageEmail = item['orphanage_email'] ?? '';
        item['profile_image'] = orphanageImageUrls[orphanageEmail] ?? '';
      }

      setState(() {
        _groupedHistoryItems = groupedItems;
      });
    } catch (e) {
      print('Error fetching history data: $e');
      // Handle error
    }
  }


  Future<void> _uploadImage(XFile imageFile) async {
    try {
      String uniqueFilename = DateTime.now().microsecondsSinceEpoch.toString();
      Reference storageRef = FirebaseStorage.instance.ref().child('orphanages').child(uniqueFilename);

      await storageRef.putFile(File(imageFile.path));
      imgUrl = await storageRef.getDownloadURL();

      // Update Firestore user document with new image URL
      await _updateUserDocumentByEmail({'profileImage': imgUrl});

      setState(() {
        _image = File(imageFile.path).readAsBytesSync();
      });
    } catch (e) {
      print('Error uploading image: $e');
      // Handle error
    }
  }

  Future<void> _updateUserDocumentByEmail(Map<String, dynamic> updatedFields) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('orphanages')
          .where('email', isEqualTo: widget.email)
          .get();

      if (snapshot.docs.isNotEmpty) {
        DocumentReference userDocRef = snapshot.docs.first.reference;
        await userDocRef.update(updatedFields);
        print('Document updated successfully');
      } else {
        print('No user found with the provided email');
      }
    } catch (e) {
      print('Error updating user document: $e');
      // Handle error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
              side: BorderSide(
                color: Colors.green,
                width: 2.0,
              ),
            ),
            margin: EdgeInsets.all(8.0),
            elevation: 5,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: <Widget>[
                  Stack(
                    children: [
                      _image != null
                          ? CircleAvatar(
                        radius: 64,
                        backgroundImage: MemoryImage(_image!),
                      )
                          : const CircleAvatar(
                        radius: 64,
                        backgroundImage: NetworkImage(
                            'https://t4.ftcdn.net/jpg/05/49/98/39/360_F_549983970_bRCkYfk0P6PP5fKbMhZMIb07mCJ6esXL.jpg'),
                      ),
                      Positioned(
                        child: IconButton(
                          onPressed: () async {
                            final XFile? imagefile = await _picker.pickImage(source: ImageSource.gallery);

                            if (imagefile == null) return;
                            await _uploadImage(imagefile);
                          },
                          icon: const Icon(Icons.add_a_photo),
                        ),
                        bottom: -10,
                        left: 80,
                      ),
                    ],
                  ),
                  SizedBox(width: 16), // Space between image and text

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          _userName,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 10),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(
            height: 40.0,
          ),
          Center(
            child: Text(
              "DONATIONS",
              style: TextStyle(
                color: Colors.blueAccent,
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: ListView(
              children: _groupedHistoryItems.entries.map((entry) {
                String monthYear = entry.key;
                List<Map<String, dynamic>> items = entry.value;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        monthYear,
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                    ...items.map((item) {
                      return RectangularCard1(
                        orphanageName: item['email'] ?? 'No name',
                        // upid: item['upid'] ?? 'error',
                        date: DateFormat('yyyy-MM-dd').format(
                            item['date'] ?? DateTime.now()),
                        amount: item['amount'].toString() ?? '0',
                      );
                    }).toList(),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
