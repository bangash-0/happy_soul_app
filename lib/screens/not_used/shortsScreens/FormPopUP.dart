import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

List<Map<String, String>> articleCategories = [
  {
    'category': 'MOTIVATIONAL AND INSPIRATIONAL',
    'id': '1',
  },
  {
    'category': 'SELF CARE AND WELLNESS',
    'id': '2',
  },
  {
    'category': 'ART AND CREATIVITY',
    'id': '3',
  },
  {
    'category': 'NATURE AND RELAXATION',
    'id': '4',
  },
  {
    'category': 'EDUCATIONAL AND INFORMATIVE',
    'id': '5',
  },
  {
    'category': 'COMEDY AND ENTERTAINMENT',
    'id': '6',
  },
];

class FormPopup extends StatefulWidget {
  @override
  _FormPopupState createState() => _FormPopupState();
}

class _FormPopupState extends State<FormPopup> {
  final TextEditingController _titleController = TextEditingController();
  Map<String, String>? _selectedCategory = articleCategories[0];
  XFile? _selectedVideo;
  var fileName = 'Select Video';
  String videoUrl = '';

  bool uploading = true;

  ImagePicker imagePicker = ImagePicker();
  Reference referenceRoot = FirebaseStorage.instance.ref();
  late Reference referenceDirVideo;
  late Reference uploadTask;

  Uuid uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Short',
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
                        color: Colors.black, fontWeight: FontWeight.normal, fontSize: 14),
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
                    XFile? file = await imagePicker.pickVideo(
                        source: ImageSource.gallery);
                    setState(() {
                      _selectedVideo = file;
                      fileName = _selectedVideo!.name;
                    });
                  },
                  child: const Icon(Icons.video_collection_outlined),
                ),
                const SizedBox(width: 10),
                Text(
                  fileName == null ? 'Select Video' : (fileName.length > 30 ? "${fileName.substring(0, 30)}..." : fileName) ,
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
            Text(
              uploading ? "" : "Uploading...",
              style: const TextStyle(color: Colors.black),
            ),
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
                _selectedVideo == null) {
              return;
            }

            if (uploading) {
              setState(() {
                uploading = false;
              });
              referenceDirVideo = referenceRoot.child('shorts');

              uploadTask = referenceDirVideo.child(_selectedVideo!.name);

              try {
                await uploadTask.putFile(File(_selectedVideo!.path));
                await uploadTask.getDownloadURL().then((value) {
                  videoUrl = value;
                });
              } catch (e) {
                print(e);
              }

              // Add code to upload the article to Firebase

              FirebaseFirestore.instance.collection('shorts').add({
                'category': _selectedCategory!['category'],
                'title': _titleController.text,
                'src': videoUrl,
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
