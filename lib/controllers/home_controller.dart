// home_controller.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:open_file_safe_plus/open_file_safe_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:lottie/lottie.dart';
import '../services/api_service.dart';

class HomeController extends GetxController {
  final PexelsApiService _apiService = PexelsApiService();

  // Reactive variables
  var photos = <dynamic>[].obs;
  var isLoading = true.obs;
  var isSearching = false.obs;
  var downloadProgress = <int, double>{}.obs;
  var isGridView = false.obs;

  // Search TextField controller
  final TextEditingController searchController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadPhotos();
  }

  Future<void> loadPhotos() async {
    try {
      isLoading.value = true;
      var fetchedPhotos = await _apiService.fetchPhotos(30);
      photos.assignAll(fetchedPhotos);
    } catch (e) {
      showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void toggleViewMode() {
    isGridView.value = !isGridView.value;
  }

  Future<void> loadRandomPhotos() async {
    try {
      isLoading.value = true;
      var fetchedPhotos = await _apiService.fetchPhotos(30);
      photos.assignAll(fetchedPhotos);
    } catch (e) {
      showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> searchPhotos(String query) async {
    if (query.isEmpty) {
      loadPhotos();
      return;
    }
    try {
      isLoading.value = true;
      var results = await _apiService.searchPhotos(query, 30);
      photos.assignAll(results);
    } catch (e) {
      showError(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void toggleSearch() {
    if (isSearching.value) {
      isSearching.value = false;
      searchController.clear();
      loadPhotos();
    } else {
      isSearching.value = true;
    }
  }

  Future<void> downloadFile(String url, String fileName, int photoId) async {
    if (url.isEmpty) {
      showError("Invalid URL provided.");
      return;
    }

    var status = await Permission.storage.request();
    if (!status.isGranted) return;

    try {
      final dir = await getDownloadsDirectory();
      if (dir == null) {
        showError("Unable to get downloads directory.");
        return;
      }
      final savePath = '${dir.path}/$fileName.jpg';

      await Dio().download(
        url,
        savePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            downloadProgress[photoId] = received / total;
            downloadProgress.refresh();
          }
        },
      );

      downloadProgress.remove(photoId);
      downloadProgress.refresh();
      showDownloadCompleteDialog(savePath);
    } catch (e) {
      showError('Download failed: ${e.toString()}');
    }
  }

  void showDownloadCompleteDialog(String filePath) {
    Get.dialog(
      Center(
        child: Container(
          width: 300,
          padding: const EdgeInsets.all(16),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Download Complete!',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
              ),
              const SizedBox(height: 12),
              Text(
                'File saved to:',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              const SizedBox(height: 4),
              Text(
                filePath,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 12, color: Colors.blueAccent),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      OpenFileSafePlus.open(filePath);
                    },
                    icon: const Icon(Icons.open_in_new),
                    label: const Text('Open File'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blueAccent,
                    ),
                  ),
                  ElevatedButton.icon(
                    onPressed: () {
                      Get.back();
                    },
                    icon: const Icon(Icons.close),
                    label: const Text('Close'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      barrierDismissible: true,
    );
  }

  void showError(String message) {
    // Delay the snackbar until the current frame is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.context != null) {
        Get.snackbar(
          'Error',
          message,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      } else {
        // Fallback: print the error if no context is available.
        print("Snackbar could not be shown. Error: $message");
      }
    });
  }
}
