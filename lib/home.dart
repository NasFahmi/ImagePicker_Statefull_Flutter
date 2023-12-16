import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:testkamera_statefull/image_helper.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

final imageHelper = ImageHelper();

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<File> _images = [];
  File? singleImage;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () async {
                // final XFile? file =
                //     await ImagePicker().pickImage(source: ImageSource.camera);
                // if (file != null) {
                //   final CroppedFile? croppedFile = await imageHelper.crop(
                //     file: file,
                //     cropStyle: CropStyle.rectangle,
                //   );

                // }
                final file = await imageHelper.pickCamera();
                if (file != null) {
                  final croppedFile = await imageHelper.crop(
                    file: file,
                    cropStyle: CropStyle.rectangle,
                  );
                  if (croppedFile != null) {
                    setState(() {
                      singleImage = File(croppedFile.path);
                      _images.add(singleImage!);
                    });
                  }
                }
              },
              child: Text('Select Photo from Camera'),
            ),
            SizedBox(
              height: 20,
            ),
            ElevatedButton(
              onPressed: () async {
                final List<XFile> files =
                    await imageHelper.pickImage(multiple: true);

                setState(() {
                  // Menggabungkan file yang baru dipilih dengan list _images
                  _images.addAll(files.map((e) => File(e.path)).toList());
                });
              },
              child: Text('Select Photo form Gallery'),
            ),
            SizedBox(
              height: 20,
            ),
            Wrap(
              spacing: 4,
              runSpacing: 4,
              children: _images
                  .map(
                    (e) => Image.file(
                      e,
                      height: 100,
                      width: 100,
                      fit: BoxFit.cover,
                    ),
                  )
                  .toList(),
            )
          ],
        ),
      )),
    );
  }
}
