import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:uuid/uuid.dart';

class FormPopup extends StatefulWidget {
  @override
  _FormPopupState createState() => _FormPopupState();
}

class _FormPopupState extends State<FormPopup> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _expController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _descController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Map<String, String>? _selectedCountry = countries[0];
  XFile? _selectedImage;
  String fileName = 'Select Image';
  String imageUrl = '';
  bool isUploading = false;

  final ImagePicker _imagePicker = ImagePicker();
  final Reference _referenceRoot = FirebaseStorage.instance.ref();
  final Uuid _uuid = Uuid();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Psychiatrist', style: TextStyle(fontSize: 20, color: Colors.black)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            _buildDropdownButton(),
            _buildTextField(_nameController, 'Name'),
            _buildTextField(_emailController, 'Email'),
            _buildTextField(_passwordController, 'Password'),
            _buildTextField(_expController, 'Experience'),
            _buildTextField(_locationController, 'Address'),
            _buildTextField(_descController, 'Description'),
            const SizedBox(height: 15),
            _buildImagePicker(),
            Text(
              isUploading ? "Uploading..." : "",
              style: const TextStyle(color: Colors.black),
            ),
          ],
        ),
      ),
      actions: <Widget>[
        _buildCancelButton(),
        _buildUploadButton(),
      ],
    );
  }

  DropdownButton<Map<String, String>> _buildDropdownButton() {
    return DropdownButton<Map<String, String>>(
      value: _selectedCountry,
      onChanged: (Map<String, String>? newValue) {
        setState(() {
          _selectedCountry = newValue;
        });
      },
      items: countries.map((Map<String, String> country) {
        return DropdownMenuItem<Map<String, String>>(
          value: country,
          child: Text(
            country['category']!,
            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
          ),
        );
      }).toList(),
    );
  }

  TextField _buildTextField(TextEditingController controller, String labelText) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(labelText: labelText),
    );
  }

  Row _buildImagePicker() {
    return Row(
      children: [
        TextButton(
          onPressed: _selectImage,
          child: const Icon(Icons.image),
        ),
        const SizedBox(width: 10),
        Text(
          fileName,
          style: const TextStyle(color: Colors.black),
        ),
      ],
    );
  }

  TextButton _buildCancelButton() {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pop();
      },
      child: const Text('Cancel'),
    );
  }

  TextButton _buildUploadButton() {
    return TextButton(
      onPressed: _uploadData,
      child: const Text('Upload'),
    );
  }

  Future<void> _selectImage() async {
    XFile? file = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (file != null) {
      setState(() {
        _selectedImage = file;
        fileName = _selectedImage!.name;
      });
    }
  }

  Future<void> _uploadData() async {
    if (_selectedCountry == null ||
        _nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _expController.text.isEmpty ||
        _locationController.text.isEmpty ||
        _descController.text.isEmpty ||
        _selectedImage == null) {
      return;
    }

    setState(() {
      isUploading = true;
    });

    try {
      await _uploadImage();
      await _createUser();
      await _saveDataToFirestore();
      Navigator.of(context).pop();
    } catch (e) {
      print(e);
      setState(() {
        isUploading = false;
      });
    }
  }

  Future<void> _uploadImage() async {
    Reference referenceDirImages = _referenceRoot.child('psychiatrist_data');
    Reference imageToUpload = referenceDirImages.child(_selectedImage!.name + _uuid.v4());

    await imageToUpload.putFile(File(_selectedImage!.path));
    imageUrl = await imageToUpload.getDownloadURL();
  }

  Future<void> _createUser() async {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  Future<void> _saveDataToFirestore() async {

    await FirebaseFirestore.instance.collection('users').add({
      'name': _nameController.text,
      'contact_no': '1234567890',
      'email': _emailController.text,
      'country' : _selectedCountry!['category'],
      'reset_pin': '00000',
      'password': _passwordController.text,
      'psychiatrist_id': _uuid.v4(),
      'fcm_token': '',
    });

    await FirebaseFirestore.instance
        .collection('psychiatrist_data-${_selectedCountry!['category']}')
        .add({
      'country': _selectedCountry!['category'],
      'name': _nameController.text,
      'email': _emailController.text,
      'password': _passwordController.text,
      'experience': _expController.text,
      'address': _locationController.text,
      'description': _descController.text,
      'image': imageUrl,
      'fcm_token': '',
    });
  }
}

List<Map<String, String>> countries = [
  {
    'category': 'Pakistan',
    'id': '1',
  },
  {
    'category': 'America',
    'id': '2',
  },
  {
    'category': 'Saudi Arabia',
    'id': '3',
  },
];
