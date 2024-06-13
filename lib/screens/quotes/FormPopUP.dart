import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

List<Map<String, String>> quotesCategories = [
  {
    'category': 'Motivational',
    'destination_id': '1',
    'image': 'images/quotes/motivation_1.jpg',
  },
  {
    'category': 'Attitude',
    'destination_id': '2',
    'image': 'images/quotes/attitude.PNG',
  },
  {
    'category': 'Friendship',
    'destination_id': '3',
    'image': 'images/quotes/friendship.jpg',
  },
  {
    'category': 'Positive',
    'destination_id': '4',
    'image': 'images/quotes/positive.png',
  },
  {
    'category': 'Health and Fitness',
    'destination_id': '5',
    'image': 'images/quotes/healthandfiness.png',
  },
  {
    'category': 'Affirmations',
    'destination_id': '6',
    'image': 'images/quotes/affirmation.png',
  },
  {
    'category': 'Study',
    'destination_id': '7',
    'image': 'images/quotes/study.png',
  },
  {
    'category': 'Happiness',
    'destination_id': '8',
    'image': 'images/quotes/happy.png',
  },
];

class FormPopup extends StatefulWidget {
  @override
  _FormPopupState createState() => _FormPopupState();
}

class _FormPopupState extends State<FormPopup> {
  final TextEditingController _titleController = TextEditingController();
  Map<String, String>? _selectedCategory = quotesCategories[0];
  XFile? _selectedImage;
  var fileName = 'Select Image';
  String imageUrl = '';

  ImagePicker imagePicker = ImagePicker();
  Reference referenceRoot = FirebaseStorage.instance.ref();

  bool isUploading = true;

  Uuid uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Quote',
          style: TextStyle(fontSize: 20, color: Colors.black)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            DropdownButton<Map<String, String>>(
              value: _selectedCategory,
              onChanged: (Map<String, String>? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
              items: quotesCategories.map((Map<String, String> category) {
                return DropdownMenuItem<Map<String, String>>(
                  value: category,
                  child: Text(
                    category['category']!,
                    style: const TextStyle(
                        color: Colors.black, fontWeight: FontWeight.normal),
                  ),
                );
              }).toList(),
            ),
            TextField(
              controller: _titleController,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                TextButton(
                  onPressed: () async {
                    // Add onPressed code for selecting an image
                    XFile? file =
                        await imagePicker.pickImage(source: ImageSource.gallery);
                    setState(() {
                      _selectedImage = file;
                      fileName = _selectedImage!.name;
                    });
                  },
                  child: const Icon(Icons.image),
                ),
                const SizedBox(width: 10),
                Text(
                  fileName == null ? 'Select Image' : (fileName.length > 30 ? "${fileName.substring(0, 30)}..." : fileName),
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
        
            Text(
              isUploading ? '' : 'Uploading...',
            )
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            if (_selectedCategory == null ||
                _titleController.text.isEmpty ||
                _selectedImage == null) {
              return;
            }

            if (isUploading) {
              setState(() {
                isUploading = false;
              });

              Reference referenceDirQuote = referenceRoot.child('Quotes');
              Reference referenceDirCategory =
                  referenceDirQuote.child(_selectedCategory!['category']!);
              Reference imageToUpload =
                  referenceDirCategory.child(_selectedImage!.name);

              try {
                await imageToUpload.putFile(File(_selectedImage!.path));

                await imageToUpload.getDownloadURL().then((value) {
                  imageUrl = value;
                });
              } catch (e) {
                print(e);
              }

              // Add code to upload the article to Firebase

              FirebaseFirestore.instance
                  .collection('quotes-${_selectedCategory!['category']}')
                  .add({
                'category': _selectedCategory!['category'],
                'title': _titleController.text,
                'image': imageUrl,
              });

              Navigator.of(context).pop();
            }
          },
          child: const Text('Upload'),
        ),
      ],
    );
  }
}
