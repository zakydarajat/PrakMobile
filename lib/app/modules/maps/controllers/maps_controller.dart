import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:url_launcher/url_launcher.dart'; // Menambahkan url_launcher

class MapsController extends GetxController {
  Rx<Position?> currentPosition = Rx<Position?>(null); // Lokasi pengguna saat ini
  RxString latitude = ''.obs; // Latitude yang ditampilkan
  RxString longitude = ''.obs; // Longitude yang ditampilkan

  @override
  void onInit() {
    super.onInit();
    checkPermissions();
    getCurrentLocation();
  }

  // Cek izin lokasi
  Future<void> checkPermissions() async {
    final status = await Permission.location.request();
    if (status.isGranted) {
      print("Permission granted");
    } else if (status.isPermanentlyDenied) {
      openAppSettings();
    } else {
      Get.snackbar(
        "Permission Denied",
        "Location permission is required to use this app",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Mendapatkan lokasi saat ini
  Future<void> getCurrentLocation() async {
    try {
      bool isLocationEnabled = await Geolocator.isLocationServiceEnabled();
      if (!isLocationEnabled) {
        Get.snackbar(
          "Location Disabled",
          "Please enable location services",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      currentPosition.value = position;
      latitude.value = position.latitude.toStringAsFixed(6);
      longitude.value = position.longitude.toStringAsFixed(6);

      // Menampilkan snackbar dengan posisi terkini
      Get.snackbar(
        "Current Location",
        "Lat: ${position.latitude}, Lng: ${position.longitude}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to get location: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  // Mencari lokasi berdasarkan nama (alamat)
  Future<void> searchLocation(String query) async {
    try {
      if (query.isEmpty) {
        Get.snackbar(
          "Error",
          "Please enter a location",
          snackPosition: SnackPosition.BOTTOM,
        );
        return;
      }

      // Jika input berupa koordinat (lat,lng)
      if (query.contains(',')) {
        final parts = query.split(',');
        if (parts.length == 2) {
          final lat = double.tryParse(parts[0].trim());
          final lng = double.tryParse(parts[1].trim());

          if (lat != null && lng != null) {
            // Update lokasi berdasarkan koordinat
            latitude.value = lat.toStringAsFixed(6);
            longitude.value = lng.toStringAsFixed(6);

            // Menampilkan snackbar dengan lokasi baru
            Get.snackbar(
              "Coordinates Found",
              "Moved to: $lat, $lng",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );

            // Menambahkan fungsi untuk membuka Google Maps
            openGoogleMaps(lat, lng);

            return;
          }
        }
      }

      // Jika bukan koordinat, perlakukan sebagai alamat
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final location = locations.first;
        latitude.value = location.latitude.toStringAsFixed(6);
        longitude.value = location.longitude.toStringAsFixed(6);

        Get.snackbar(
          "Location Found",
          "Moved to: $query",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );

        // Menambahkan fungsi untuk membuka Google Maps
        openGoogleMaps(location.latitude, location.longitude);
      } else {
        Get.snackbar(
          "Error",
          "Location not found",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to search location: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Membuka Google Maps menggunakan koordinat
  Future<void> openGoogleMaps(double lat, double lng) async {
    final url = "https://www.google.com/maps?q=$lat,$lng";
    if (await canLaunch(url)) {
      await launch(url); // Membuka Google Maps
    } else {
      Get.snackbar(
        "Error",
        "Could not open Google Maps",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
