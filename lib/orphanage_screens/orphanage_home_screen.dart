import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fancy_bottom_navigation_2/fancy_bottom_navigation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_1/orphanage_screens/orphanage_postform_screen.dart';
import 'package:flutter_application_1/screens/search_screen.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';

import 'orphanage_profile_screen.dart';
import 'orphanage_welcome_screen.dart';

class OrphanageHomeScreen extends StatefulWidget {
  final String email;
  const OrphanageHomeScreen({super.key, required this.email});

  @override
  State<OrphanageHomeScreen> createState() => _OrphanageHomeScreenState();
}

class _OrphanageHomeScreenState extends State<OrphanageHomeScreen> {
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
    print(widget.email);
  }

  Future<Map<String, String>> _fetchOrphanageData(String email) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('orphanages')
        .where('email', isEqualTo: widget.email)
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
      stream: FirebaseFirestore.instance.collection('posts')
          .where('orphanage_email', isEqualTo: widget.email)
          .snapshots(),
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
                            SizedBox(width: 210,),
                            PopupMenuButton<int>(
                              onSelected: (value){
                                if (value == 1) {
                                  _deletePost(post['postImageUrl'], posts[index].id);
                                }
                              },
                              itemBuilder: (context) =>[
                                PopupMenuItem(
                                  value: 1,
                                  child: Text('Delete'),
                                )
                              ],
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
                            color: Colors.black87,
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
      Navigator.push( context, MaterialPageRoute(builder: (context) => OrphanageWelcomeScreen() ),);
    } catch (e) {
      // Handle any errors during logout
      print('Error logging out: $e');
    }
  }

  Future<void> _deletePost(String imageUrl, String postId) async {
    try {
      // Delete image from Firebase Storage
      if (imageUrl.isNotEmpty) {
        Reference storageRef = FirebaseStorage.instance.refFromURL(imageUrl);
        await storageRef.delete();
      }

      // Delete post document from Firestore
      await FirebaseFirestore.instance.collection('posts').doc(postId).delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Post deleted successfully')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete post: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[100],
        title: const Text("HELPING HAND'S"),
        centerTitle: true,
        automaticallyImplyLeading: false,
        actions: [
          PopupMenuButton<int>(
            onSelected: (value) {
              // Handle the selected menu option here
              if(value ==1){
                _logout(context);
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                  value: 1,
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
            SearchScreen(useremail: widget.email),
            OrphanagePostformScreen(email: widget.email),
            OrphanageProfileScreen(email: widget.email)
          ],
        ),
      ),
      bottomNavigationBar: Obx(
            () => FancyBottomNavigation(
          tabs: [
            TabData(iconData: Icons.home, title: 'Home'),
            TabData(iconData: Icons.search, title: 'Search'),
            TabData(iconData: Icons.add_box_outlined, title: 'Post'),
            TabData(iconData: Icons.person, title: 'Profile'),
          ],
          onTabChangedListener: _onItemTapped,
          initialSelection: _selectedIndex.value,
        ),
      ),
    );
  }
}

