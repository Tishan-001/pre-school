import 'dart:io';
import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:image_picker/image_picker.dart';

class GalleryTeacherPage extends StatefulWidget {
  @override
  _GalleryTeacherPageState createState() => _GalleryTeacherPageState();
}

class _GalleryTeacherPageState extends State<GalleryTeacherPage> {
  final ImagePicker _picker = ImagePicker();
  final databaseRef = FirebaseDatabase.instance.ref(); // Reference to the database

  // Function to upload selected image to Firebase Storage and save URL to Realtime Database
  Future<void> _uploadImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;

    final file = File(image.path);
    String fileName = 'gallery/${DateTime.now().millisecondsSinceEpoch.toString()}';

    try {
      // Upload image to Firebase Storage
      await FirebaseStorage.instance.ref(fileName).putFile(file);
      String downloadURL = await FirebaseStorage.instance.ref(fileName).getDownloadURL();

      // Save image URL to Realtime Database
      await databaseRef.child('gallery').push().set({'url': downloadURL});
    } catch (e) {
      print(e); // Handle errors
    }
  }

  // Function to delete image from Firebase Storage and Realtime Database
  Future<void> _deleteImage(String key, String fileUrl) async {
    try {
      // Delete image from Realtime Database
      await databaseRef.child('gallery/$key').remove();

      // Extract file name from fileUrl and delete from Firebase Storage
      String fileName = fileUrl.split('/').last.split('?').first;
      await FirebaseStorage.instance.ref('gallery/$fileName').delete();
    } catch (e) {
      print(e); // Handle errors
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
        actions: [
          IconButton(
            icon: Icon(Icons.add_photo_alternate),
            onPressed: _uploadImage,
          ),
        ],
      ),
      body: Container(
        color: Colors.white,
        child: StreamBuilder(
          stream: databaseRef.child('gallery').onValue,
          builder: (context, AsyncSnapshot<DatabaseEvent> snapshot) {
            if (!snapshot.hasData) return CircularProgressIndicator();
            // Adjusting this part to handle potential Object or null values
            final data = snapshot.data!.snapshot.value;
            if (data == null) {
              return Center(child: Text("No Images Found"));
            }
            final Map<dynamic, dynamic> values = data is Map ? data : {};
            List<String> keys = values.keys.cast<String>().toList(); // Casting keys to List<String>

            if (values.isEmpty) return Center(child: Text("No Images Found"));
            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.0,
                mainAxisSpacing: 4.0,
                crossAxisSpacing: 4.0,
              ),
              itemCount: values.length,
              itemBuilder: (context, index) {
                var key = keys[index];
                var url = values[key]['url'];

                return ClipRRect(
                  borderRadius: BorderRadius.circular(15.0),
                  child: GridTile(
                    footer: GridTileBar(
                      backgroundColor: Colors.black45,
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () => _deleteImage(key, url),
                      ),
                    ),
                    child: Image.network(url, fit: BoxFit.cover),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
