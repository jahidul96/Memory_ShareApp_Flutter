// ignore_for_file: must_be_immutable

import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:memoryapp/utils/app_colors.dart';
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
  downloadFile() async {
    var dio = Dio();
    final baseStorage = await getExternalStorageDirectory();
    final status = await Permission.storage.request();
    if (status.isGranted) {
      // var response = await dio.download(
      //     "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4",
      //     "${baseStorage!.path}/${DateTime.now()}.mp4");

      // print(response.statusCode);

      setState(() {
        isDownloading = true;
      });

      try {
        final response = await Dio().get(
          widget.url,
          options: Options(responseType: ResponseType.bytes),
        );

        final directory = await getApplicationDocumentsDirectory();
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

        print('File downloaded successfully and saved to the gallery');
      } catch (e) {
        print('Error occurred while downloading file: $e');

        setState(() {
          isDownloading = false;
        });
      }
    } else {
      print("no permision");
    }
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
            child: Image.network(
              widget.url,
              width: double.infinity,
              height: MediaQuery.of(context).size.height / 2.5,
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            bottom: 30,
            left: 50,
            child: isDownloading
                ? Container(
                    child: TextComp(
                      text: "downloading...",
                      color: AppColors.whiteColor,
                      fontweight: FontWeight.normal,
                    ),
                  )
                : completed
                    ? Container(
                        child: TextComp(
                          text: "saved to gallery",
                          color: AppColors.whiteColor,
                          fontweight: FontWeight.normal,
                        ),
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
          size: 30,
        ),
      );
}
