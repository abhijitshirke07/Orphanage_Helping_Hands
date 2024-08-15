import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class OrphanagePostformScreen extends StatefulWidget {
  final String email;
  const OrphanagePostformScreen({super.key, required this.email});

  @override
  State<OrphanagePostformScreen> createState() => _OrphanagePostformScreenState();
}

class _OrphanagePostformScreenState extends State<OrphanagePostformScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _orphanageEmailController = TextEditingController();
  final TextEditingController _postContentController = TextEditingController();
  final TextEditingController _postImageUrlController = TextEditingController();

  XFile? _imageFile;
  String? imgUrl;

  Future<void> _uploadImage(XFile imageFile) async {
    try {
      String uniqueFilename = DateTime.now().microsecondsSinceEpoch.toString();
      Reference storageRef = FirebaseStorage.instance.ref().child('posts').child(uniqueFilename);

      await storageRef.putFile(File(imageFile.path));
      imgUrl = await storageRef.getDownloadURL();

      // Update Firestore user document with new image URL (if needed)
      // await _updateUserDocumentByEmail({'profileImage': imgUrl});

      setState(() {
        _imageFile = imageFile;
        _postImageUrlController.text = imgUrl ?? '';
      });
    } catch (e) {
      print('Error uploading image: $e');
      // Handle error
    }
  }

  Future<void> _selectImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      await _uploadImage(pickedFile);
    }
  }

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      try {
        await FirebaseFirestore.instance.collection('posts').add({
          'date': Timestamp.now(), // Current timestamp
          'orphanage_email': widget.email,
          'postContent': _postContentController.text,
          'postImageUrl': _postImageUrlController.text,
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Post added successfully')),
        );
        // Optionally, clear the form after submission
        _orphanageEmailController.clear();
        _postContentController.clear();
        _postImageUrlController.clear();
        setState(() {
          _imageFile = null;
        });
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Post'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _postContentController,
                decoration: InputDecoration(labelText: 'Post Content'),
                maxLines: 3, // Multiple lines for longer content
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter content';
                  }
                  return null;
                },
              ),
              if (_imageFile != null)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.file(
                    File(_imageFile!.path),
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              Container(
                child: IconButton(
                  onPressed: _selectImage,
                  icon: const Icon(Icons.add_a_photo),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Submit'),
              ),

            ],
          ),
        ),
      ),
    );
  }
}
