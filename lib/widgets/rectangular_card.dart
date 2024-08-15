import 'package:flutter/material.dart';

class RectangularCard extends StatelessWidget {
  final String imageUrl;
  final String orphanageName;
  final String date;
  final String amount;
  // final String upid;

  const RectangularCard({
    super.key,
    required this.imageUrl,
    required this.orphanageName,
    required this.date,
    required this.amount,
    // required this.upid,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
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
            // Image on the left
            CircleAvatar(
              radius: 30,
              backgroundImage: NetworkImage(imageUrl),
            ),
            SizedBox(width: 16), // Space between image and text

            // Expanded text area
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    orphanageName,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                  SizedBox(height: 8),
                  // Text(
                  //   'UPID: $upid',
                  //   style: TextStyle(
                  //     fontSize: 13,
                  //   ),
                  // ),
                  Text(
                    date,
                    style: TextStyle(
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            // Amount on the right
            SizedBox(width: 16),
            Text(
              amount,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
