import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class GalleryPage extends StatefulWidget {
  @override
  _GalleryPageState createState() => _GalleryPageState();
}

class _GalleryPageState extends State<GalleryPage> {
  List<String> imageUrls = [];
  final databaseRef = FirebaseDatabase.instance.ref(); // Reference to the database
  final picker = ImagePicker();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadImages();
  }

  Future<void> _loadImages() async {
    databaseRef.child('gallery').onValue.listen((event) {
      final data = Map<String, dynamic>.from(event.snapshot.value as Map);
      final List<String> loadedUrls = [];
      data.forEach((key, value) {
        loadedUrls.add(value['url']);
      });

      setState(() {
        imageUrls = loadedUrls;
        isLoading = false;
      });
    });
  }

  Future<void> _pickAndUploadImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      File file = File(pickedFile.path);
      try {
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance.ref().child('gallery/$fileName');

        await ref.putFile(file);
        String downloadUrl = await ref.getDownloadURL();

        // Save the download URL to the database
        await databaseRef.child('gallery').push().set({'url': downloadUrl});
      } catch (e) {
        print(e); // Handle errors
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Gallery'),
        automaticallyImplyLeading: false,
        elevation: 2.0,
        backgroundColor: Color(0xFFFFE6E6),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : Container(
            color: Colors.white,
            padding: const EdgeInsets.all(4.0),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
              ),
              itemCount: imageUrls.length,
              itemBuilder: (context, index) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: GridTile(
                  child: Image.network(imageUrls[index], fit: BoxFit.cover),
              ),
            );
          },
        ),
      ),
    );
  }
}
