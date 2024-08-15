import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

class Orphanage {
  String orphanageName;
  String bio;
  String imageUrl;
  String location;
  String post;

  Orphanage({
    required this.orphanageName,
    required this.bio,
    required this.imageUrl,
    required this.location,
    required this.post,
  });

  // Convert a Orphanage object into a map
  Map<String, dynamic> toMap() {
    return {
      'orphanageName': orphanageName,
      'bio': bio,
      'imageUrl': imageUrl,
      'location': location,
      'posts': post,
    };
  }

  // Convert JSON to Orphanage object
  factory Orphanage.fromJson(Map<String, dynamic> json) {
    return Orphanage(
      orphanageName: json['orphanageName'],
      bio: json['bio'],
      imageUrl: json['imageUrl'],
      location: json['location'],
      post: json['posts'],
    );
  }

  // Convert Orphanage object to JSON
  Map<String, dynamic> toJson() {
    return {
      'orphanageName': orphanageName,
      'bio': bio,
      'imageUrl': imageUrl,
      'location': location,
      'posts': post,
    };
  }
}
Future<void> insertHistoryData(String jsonString) async {
  try {
    // Parse the JSON string
    List<dynamic> data = json.decode(jsonString);

    // Convert each record to a Map<String, dynamic> and update the date field
    List<Map<String, dynamic>> historyRecords = data.map((item) {
      // Convert the date string to a Timestamp
      DateTime dateTime = DateTime.parse(item['date']);
      Timestamp timestamp = Timestamp.fromDate(dateTime);

      return {
        "amount": item['amount'],
        "date": timestamp,
        "email": item['email'],
        "orphanageName": item['orphanageName'],
        "profile_image": item['profile_image']
      };
    }).toList();

    // Insert each history record
    for (var record in historyRecords) {
      await FirebaseFirestore.instance.collection('history').add(record);
    }

    print('History data inserted successfully');
  } catch (e) {
    print('Error inserting history data: $e');
  }
}

Future<void> insertOrphanagesData(String jsonString) async {
  try {
    List<dynamic> orphanagesList = jsonDecode(jsonString);

    for (var orphanageData in orphanagesList) {
      await FirebaseFirestore.instance.collection('orphanages').add(
          orphanageData as Map<String, dynamic>);
    }

    print('Orphanage data inserted successfully');
  } catch (e) {
    print('Error inserting orphanage data: $e');
  }
}