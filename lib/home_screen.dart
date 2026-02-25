import 'dart:io';
import 'package:chit06/extract_text_screen.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  File? selectedMedia;
  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      selectedMedia = File(image.path);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(centerTitle: true, title: const Text('Image to Text')),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            SizedBox(height: 20),
            imageView(),
            Spacer(),
            ElevatedButton(
              onPressed: selectedMedia == null
                  ? null
                  : () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ExtractTextScreen(file: selectedMedia!),
                        ),
                      );
                    },
              child: const Text('Continue'),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: pickImage,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget imageView() => Center(
    child: Container(
      height: 200,
      width: 200,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue, width: 2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: selectedMedia == null
          ? const Center(child: Text("No Image Selected"))
          : Image.file(selectedMedia!, fit: BoxFit.cover),
    ),
  );
}
