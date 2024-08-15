import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_application_1/screens/paymentform_screen.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting
import 'dart:typed_data'; // For Uint8List

class OrphanageScreen1 extends StatefulWidget {
  final String orphanageId;
  final String useremail;
  const OrphanageScreen1({super.key, required this.orphanageId, required this.useremail});

  @override
  State<OrphanageScreen1> createState() => _OrphanageScreen1State();
}

class _OrphanageScreen1State extends State<OrphanageScreen1> {
  late Future<Map<String, dynamic>>? _orphanageData;
  late Future<List<Map<String, dynamic>>> _posts;
  Uint8List? _image;
  String _orphanageemail = '';
  String _orphanageName = '';
  String imgUrl = '';
  int no_children = 0;
  String bio = '';
  String location = '';
  String email = '';
  int contact = 0;

  @override
  void initState() {
    super.initState();
    _fetchOrphanageData(widget.orphanageId);
    // _posts = _fetchOrphanagePosts();
  }

  Future<void> _fetchOrphanageData(String id) async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance
          .collection('orphanages')
          .where('orphanageId', isEqualTo: widget.orphanageId)
          .get();
      if (snapshot.docs.isNotEmpty) {
        var userData = snapshot.docs.first.data() as Map<String, dynamic>;
        print(widget.orphanageId);
        setState(() {
          _orphanageName = userData['orphanageName'] ?? '';
          imgUrl = userData['profileImage'] ?? '';
          no_children = userData['number_of_children'] ?? 0;
          bio = userData['bio'] ?? '';
          location = userData['location'];
          email = userData['email'];
          contact = userData['contact'];
          _orphanageemail = userData['email'];

          if (imgUrl.isNotEmpty) {
            _loadNetworkImage(imgUrl);
          }
          else {
            _image = null;
          }
        });
      } else {

      }
    } catch (e) {
      print('Error fetching orphanage data: $e'); // Return empty map on error
    }
  }

  Future<void> _loadNetworkImage(String url) async {
    try {
      final ByteData imageData = await NetworkAssetBundle(Uri.parse(url)).load(
          "");
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



  Widget _buildPost(BuildContext context) {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    final Color borderColor = Colors.blue;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection('posts')
          .where('orphanage_email', isEqualTo: _orphanageemail)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
          print(_orphanageemail);
          return Center(child: Text('No posts available.'));
        }

        final posts = snapshot.data!.docs;

        return ListView.builder(
          shrinkWrap: true, // Allow ListView to shrink based on content
          physics: NeverScrollableScrollPhysics(),
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index].data() as Map<String, dynamic>;
            final imageUrl = post['postImageUrl'] ?? '';
            final date = (post['date'] as Timestamp).toDate();
            final postContent = post['postContent'] ?? '';
            final orphanageName = _orphanageName;
            final profileImage = imgUrl;

            return Card(
                  margin: const EdgeInsets.all(8.0),
                  shape: RoundedRectangleBorder(
                    side: BorderSide(color: borderColor, width: 2.0), // Set border color and width
                    borderRadius: BorderRadius.circular(10.0), // Optional: set border radius
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: <Widget>[
                            profileImage.isNotEmpty
                                ? CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(profileImage),
                            )
                                : const CircleAvatar(
                              radius: 25,
                              backgroundImage: NetworkImage(
                                  'https://t4.ftcdn.net/jpg/05/49/98/39/360_F_549983970_bRCkYfk0P6PP5fKbMhZMIb07mCJ6esXL.jpg'),
                            ),
                            SizedBox(width: 10,),
                            Text(
                              orphanageName,
                              style: const TextStyle(
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      if (imageUrl.isNotEmpty)
                        Image.network(
                          imageUrl,
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: 200.0,
                        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          postContent,
                          style: const TextStyle(
                            fontSize: 16.0,
                            color: Colors.black54,
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          dateFormat.format(date), // Format the date
                          style: const TextStyle(
                            fontSize: 14.0,
                            color: Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        title: const Text("HELPING HAND'S"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile image and name
            Row(
              children: [
                SizedBox(height: 150),
                SizedBox(width: 30,),
                CircleAvatar(
                  radius: 50.0,
                  backgroundImage: _image != null
                      ? MemoryImage(_image!)
                      : NetworkImage(
                    'https://t4.ftcdn.net/jpg/05/49/98/39/360_F_549983970_bRCkYfk0P6PP5fKbMhZMIb07mCJ6esXL.jpg',
                  ) as ImageProvider,
                ),
                SizedBox(width: 16.0),
                Text(
                  _orphanageName,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            SizedBox(height: 16.0),
            // Orphanage details box
            Container(
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.fromLTRB(55, 0, 55, 0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Icon(Icons.child_care, size: 40.0),
                  SizedBox(width: 16.0),
                  Expanded(
                    child: Text(
                      'Total Children: $no_children',
                      // Replace with actual data
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              PaymentFormScreen(
                                orphanageName: _orphanageName,
                                orphanageemail: _orphanageemail,
                                useremail: widget.useremail,
                              ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.green, // Text color
                    ),
                    child: Text('Donate'),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16.0),
            RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Motive: ',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'RobotoSlab',
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    TextSpan(
                      text: bio + '\n',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'RobotoSlab',
                        fontWeight: FontWeight.normal,
                        color: Colors.black87,
                      ),
                    ),
                    TextSpan(
                      text: 'Location: ',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'RobotoSlab',
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    TextSpan(
                      text: location + '\n',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'RobotoSlab',
                        fontWeight: FontWeight.normal,
                        color: Colors.black87,
                      ),
                    ),
                    TextSpan(
                      text: 'Email: ',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'RobotoSlab',
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    TextSpan(
                      text: email + '\n',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'RobotoSlab',
                        fontWeight: FontWeight.normal,
                        color: Colors.black87,
                      ),
                    ),
                    TextSpan(
                      text: 'Contact: ',
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'RobotoSlab',
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    TextSpan(
                      text: contact.toString(),
                      style: TextStyle(
                        fontSize: 16.0,
                        fontFamily: 'RobotoSlab',
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
            ),
            SizedBox(height: 25.0),
            Container(
              height: 2.0,
              color: Colors.black,
              width: double.infinity,
            ),
            Center(
                child: Text(
                  'POSTS',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    color:Colors.pinkAccent
                  ),
                ),
            ),
            Container(
              height: 2.0,
              color: Colors.black,
              width: double.infinity,
            ),
            SizedBox(height: 25.0,),
            _buildPost(context),
          ],
        ),
      ),
    );
  }
}