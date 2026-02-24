import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class ExtractTextScreen extends StatefulWidget {
  final File file;

  const ExtractTextScreen({super.key, required this.file});

  @override
  State<ExtractTextScreen> createState() => _ExtractTextScreenState();
}

class _ExtractTextScreenState extends State<ExtractTextScreen> {

  final _controller = TextEditingController();
  bool isEditing = false;
  bool isLoading = true;
  String? errorMessage;

  Future<void> extractText() async {
    try {
      final textRecognizer = TextRecognizer(
        script: TextRecognitionScript.latin,
      );
      final inputImage = InputImage.fromFile(widget.file);
      final recognizedText = await textRecognizer.processImage(inputImage);
      await textRecognizer.close();
      if (!mounted) return;
      setState(() {
        _controller.text = recognizedText.text.isEmpty
            ? "No text found in image."
            : recognizedText.text;
        isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        isLoading = false;
        errorMessage = "Failed to extract text.";
      });
    }
  }

  @override
  void initState() {
    super.initState();
    extractText();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Extracted Text"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () {
                  setState(() {
                    isEditing = !isEditing;
                  });
                },
                child: Text(isEditing ? "Done" : "Edit"),
              ),
            ),

            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(color: Colors.blue),
                    )
                  : errorMessage != null
                  ? Center(
                      child: Text(
                        errorMessage!,
                        style: const TextStyle(color: Colors.red),
                      ),
                    )
                  : TextField(
                      controller: _controller,
                      readOnly: !isEditing,
                      maxLines: null,
                      decoration: InputDecoration(border: InputBorder.none),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
