import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class FormPopup extends StatefulWidget {
  @override
  _FormPopupState createState() => _FormPopupState();
}

class _FormPopupState extends State<FormPopup> {

  final TextEditingController _titleController = TextEditingController();
  XFile? _selectedVideo;
  var fileName;
  String audioUrl = '';

  Reference referenceRoot = FirebaseStorage.instance.ref();
  late Reference referenceDirImages;
  late Reference uploadTask;

  bool isUploading = true;

  Uuid uuid = const Uuid();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Music',
          style: TextStyle(fontSize: 20, color: Colors.black)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[

          TextField(
            controller: _titleController,
            decoration: const InputDecoration(labelText: 'Title'),
          ),

          const SizedBox(height: 20),

          TextButton(
            onPressed: () async {
              // Add onPressed code for selecting an image
              FilePickerResult? result = await FilePicker.platform.pickFiles();

              if (result != null) {
                setState(() {
                  File file = File(result.files.single.path!);
                  _selectedVideo = XFile(file.path);
                  fileName = _selectedVideo!.name;
                });
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.audio_file_outlined),
                const SizedBox(width: 5),
                Text(
                  fileName == null ? 'Select Audio' : (fileName!.length > 30 ? fileName!.substring(0, 30) + "..." : fileName!),
                  style: const TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),

          Text(
            isUploading ? '.' : 'Uploading...',
            style: const TextStyle(
              color: Colors.black,
            )
          )
        ],
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
            if(_titleController.text.isEmpty|| _selectedVideo == null){
              return;
            }

            if(isUploading){
              setState(() {
                isUploading = false;
              });

            referenceDirImages = referenceRoot.child('music');

            uploadTask = referenceDirImages.child(_selectedVideo!.name);

            try {
              await uploadTask.putFile(File(_selectedVideo!.path));

              await uploadTask.getDownloadURL().then((value) {
                audioUrl = value;
              });
            } catch (e) {
              print(e);
            }

            // Add code to upload the article to Firebase

            FirebaseFirestore.instance.collection('music').add({
              'title': _titleController.text,
              'src': audioUrl,
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
