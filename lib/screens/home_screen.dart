import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fancy_bottom_navigation_2/fancy_bottom_navigation.dart';
import 'package:flutter_application_1/screens/orphanagescreen.dart';
import 'package:flutter_application_1/screens/welcome_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_application_1/screens/profile_screen.dart';
import 'package:flutter_application_1/screens/search_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart'; // Add this import for date formatting

class HomeScreen extends StatefulWidget {
  final String useremail;
  const HomeScreen({super.key, required this.useremail});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RxInt _selectedIndex = 0.obs;
  late PageController pageController;
  String _profileimage = "";
  late Future<Map<String, String>> _orphanageDataFuture;

  void _onItemTapped(int index) {
    _selectedIndex.value = index;
    pageController.jumpToPage(index);
  }

  @override
  void initState() {
    super.initState();
    pageController = PageController(initialPage: _selectedIndex.value);
  }

  Future<Map<String, String>> _fetchOrphanageData(String email) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('orphanages')
        .where('email', isEqualTo: email)
        .get();
    // print(email);
    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data();
      print(data['orphanageName']);
      return {
        'orphanageName': data['orphanageName'] ?? 'Unknown',
        'profileImage': data['profileImage'] ?? ''
      };
    }

    return {'orphanageName': 'Unknown', 'profileImage': ''};
  }

  Widget _buildPost(BuildContext context) {
    final DateFormat dateFormat = DateFormat('yyyy-MM-dd');
    final Color borderColor = Colors.blue;

    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection('posts').snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data?.docs.isEmpty == true) {
          return Center(child: Text('No posts available.'));
        }

        final posts = snapshot.data!.docs;

        return ListView.builder(
          itemCount: posts.length,
          itemBuilder: (context, index) {
            final post = posts[index].data() as Map<String, dynamic>;
            final imageUrl = post['postImageUrl'] ?? '';
            final date = (post['date'] as Timestamp).toDate();
            final postContent = post['postContent'] ?? '';
            final orphanageEmail = post['orphanage_email'] ?? '';

            return FutureBuilder<Map<String, String>>(
              future: _fetchOrphanageData(orphanageEmail),
              builder: (context, orphanageSnapshot) {
                if (orphanageSnapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (!orphanageSnapshot.hasData) {
                  return Center(child: Text('Error fetching orphanage data.'));
                }

                final orphanageData = orphanageSnapshot.data!;
                final orphanageName = orphanageData['orphanageName']!;
                final profileImage = orphanageData['profileImage']!;

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
      },
    );
  }

  Future<void> _logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut();
      Navigator.push( context, MaterialPageRoute(builder: (context) => WelcomeScreen() ),);
    } catch (e) {
      // Handle any errors during logout
      print('Error logging out: $e');
    }
  }

  Future<void> updateUserNameByEmail(String email, String newName) async {
    try {
      // Reference to the 'users' collection
      CollectionReference users = FirebaseFirestore.instance.collection('users');

      // Query to find the user document by email
      QuerySnapshot querySnapshot = await users.where('email', isEqualTo: email).get();

      if (querySnapshot.docs.isNotEmpty) {
        // Document reference
        DocumentReference userDocRef = querySnapshot.docs.first.reference;

        // Update the name field
        await userDocRef.update({'name': newName});

        print('User name updated successfully.');
      } else {
        print('No user found with the provided email.');
      }
    } catch (e) {
      print('Error updating user name: $e');
      // Handle any errors
    }
  }

  void _showTextInputDialog() {
    final TextEditingController _NewNameController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Name'),
          content: TextField(
            controller: _NewNameController,
            decoration: InputDecoration(hintText: 'Enter your Name'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                String enteredText = _NewNameController.text;
                if (enteredText.isNotEmpty) {
                  // Handle the entered text
                  print('Entered Text: $enteredText');
                  updateUserNameByEmail(widget.useremail, enteredText);
                }
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Submit'),
            ),
          ],
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
        actions: [
          PopupMenuButton<int>(
            onSelected: (value) {
              // Handle the selected menu option here
              if (value == 1) {
                // updateUserNameByEmail(widget.useremail, )
                _showTextInputDialog();
              }else if(value ==2){
                _logout(context);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 1,
                child: Text('Edit Name'),
              ),
              PopupMenuItem(
                  value:2,
                  child: Text('Logout'))
            ],
            icon: Icon(Icons.more_vert), // 3-dot icon
          ),
        ],
      ),
      body: Container(
        color: Colors.grey[200], // Set your desired background color here
        child: PageView(
          controller: pageController,
          onPageChanged: (index) {
            _selectedIndex.value = index;
          },
          children: [
            _buildPost(context),
            SearchScreen(useremail: widget.useremail,),
            // HistoryScreen(),
            ProfileScreen(useremail: widget.useremail,),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
            () => FancyBottomNavigation(
          tabs: [
            TabData(iconData: Icons.home, title: 'Home'),
            TabData(iconData: Icons.search, title: 'Search'),
            // TabData(iconData: Icons.attach_money, title: 'Donation'),
            TabData(iconData: Icons.person, title: 'Profile'),
          ],
          onTabChangedListener: _onItemTapped,
          initialSelection: _selectedIndex.value,
        ),
      ),
    );
  }
}
