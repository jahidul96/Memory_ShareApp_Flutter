// ignore_for_file: must_be_immutable, use_build_context_synchronously

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:memoryapp/utils/app_colors.dart';
import 'package:memoryapp/widgets/confirmation_dialoge_model.dart';
import 'package:memoryapp/widgets/text_comp.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

class FileDownloadScreen extends StatefulWidget {
  String url;
  FileDownloadScreen({super.key, required this.url});

  @override
  State<FileDownloadScreen> createState() => _FileDownloadScreenState();
}

class _FileDownloadScreenState extends State<FileDownloadScreen> {
  bool isDownloading = false;
  bool completed = false;
  double _scale = 1.0;
  double _previousScale = 1.0;

  downloadFile() async {
    var dio = Dio();
    final baseStorage = await getExternalStorageDirectory();
    final status = await Permission.storage.request();
    if (status.isGranted) {
      setState(() {
        isDownloading = true;
      });

      try {
        final response = await dio.get(
          widget.url,
          options: Options(responseType: ResponseType.bytes),
        );
        final savedDir = baseStorage!.path;

        final file = File('$savedDir/${DateTime.now()}.png');
        await file.writeAsBytes(response.data);

        // Save the file to the gallery
        // await GallerySaver.saveVideo(file.path);
        await GallerySaver.saveImage(file.path);

        setState(() {
          isDownloading = false;
          completed = true;
        });
      } catch (e) {
        setState(() {
          isDownloading = false;
        });
      }
    } else {
      return alertUser(
          context: context,
          alertText: "You have to give permision ro download something");
    }
  }

  void _zoom() {
    setState(() {
      _scale = (_scale == 1.0) ? 2.0 : 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.appbarColor,
      appBar: AppBar(
        backgroundColor: AppColors.appbarColor,
        elevation: 0,
      ),
      body: Stack(
        children: [
          Center(
            child: GestureDetector(
              onDoubleTap: _zoom,
              onScaleStart: (ScaleStartDetails details) {
                _previousScale = _scale;
              },
              onScaleUpdate: (ScaleUpdateDetails details) {
                setState(() {
                  _scale = _previousScale * details.scale;
                });
              },
              child: InteractiveViewer(
                minScale: 1.0,
                maxScale: 5.0,
                scaleEnabled: true,
                panEnabled: true,
                child: Image.network(
                  widget.url,
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height / 2,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 30,
            left: 50,
            child: isDownloading
                ? TextComp(
                    text: "downloading...",
                    color: AppColors.whiteColor,
                    fontweight: FontWeight.normal,
                  )
                : completed
                    ? TextComp(
                        text: "saved to gallery",
                        color: AppColors.whiteColor,
                        fontweight: FontWeight.normal,
                      )
                    : Container(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.greyColor,
        onPressed: downloadFile,
        child: isDownloading
            ? spiner()
            : completed
                ? const Icon(Icons.done)
                : const Icon(Icons.download),
      ),
    );
  }

  Widget spiner() => Center(
        child: LoadingAnimationWidget.dotsTriangle(
          color: AppColors.whiteColor,
          size: 25,
        ),
      );
}
