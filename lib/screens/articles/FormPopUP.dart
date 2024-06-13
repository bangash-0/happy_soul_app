import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

List<Map<String, String>> articleCategories = [
  {
    'category': 'Introspection',
    'id': '1',
  },
  {
    'category': 'Goal Setting',
    'id': '2',
  },
  {
    'category': 'Habit Building',
    'id': '3',
  },
  {
    'category': 'Motivational',
    'id': '4',
  },
  {
    'category': 'Health & Fitness',
    'id': '5',
  },
];

class FormPopup extends StatefulWidget {
  @override
  _FormPopupState createState() => _FormPopupState();
}

class _FormPopupState extends State<FormPopup> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _linkController = TextEditingController();
  Map<String, String>? _selectedCategory = articleCategories[0];
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
      title: const Text('Add Article',
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
              items: articleCategories.map((Map<String, String> category) {
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
            TextField(
              controller: _linkController,
              decoration: const InputDecoration(labelText: 'Link'),
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
              isUploading ? '' : 'Uploading...', style: const TextStyle(color: Colors.black),
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
                _linkController.text.isEmpty ||
                _selectedImage == null) {
              return;
            }

            if (isUploading) {
              setState(() {
                isUploading = false;
              });

              Reference referenceDirImages = referenceRoot.child('Articles');
              Reference imageToUpload =
                  referenceDirImages.child(_selectedImage!.name + Uuid().v4());

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
                  .collection('articles-${_selectedCategory!['category']}')
                  .add({
                'category': _selectedCategory!['category'],
                'title': _titleController.text,
                'link': _linkController.text,
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
