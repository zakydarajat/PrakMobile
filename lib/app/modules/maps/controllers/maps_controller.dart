import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class MapsController extends GetxController {
  Rx<Position?> currentPosition =
      Rx<Position?>(null); // Lokasi pengguna saat ini
  Rx<GoogleMapController?> mapController = Rx<GoogleMapController?>(null);
  RxSet<Marker> markers = <Marker>{}.obs; // Marker untuk peta
  RxString latitude = ''.obs; // Latitude yang ditampilkan
  RxString longitude = ''.obs; // Longitude yang ditampilkan

  @override
  void onInit() {
    super.onInit();
    checkPermissions();
    getCurrentLocation();
  }

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

      // Tambahkan marker di lokasi pengguna
      updateMarker(LatLng(position.latitude, position.longitude));

      // Pindahkan kamera ke lokasi pengguna saat ini
      mapController.value?.animateCamera(
        CameraUpdate.newLatLngZoom(
          LatLng(position.latitude, position.longitude),
          14,
        ),
      );
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to get location: $e",
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

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

      // Cek apakah input berupa koordinat (format: lat,lng)
      if (query.contains(',')) {
        final parts = query.split(',');
        if (parts.length == 2) {
          final lat = double.tryParse(parts[0].trim());
          final lng = double.tryParse(parts[1].trim());

          if (lat != null && lng != null) {
            // Update lokasi berdasarkan koordinat
            final newLatLng = LatLng(lat, lng);
            latitude.value = lat.toStringAsFixed(6);
            longitude.value = lng.toStringAsFixed(6);

            updateMarker(newLatLng);
            mapController.value?.animateCamera(
              CameraUpdate.newLatLngZoom(newLatLng, 14),
            );

            Get.snackbar(
              "Coordinates Found",
              "Moved to: $lat, $lng",
              snackPosition: SnackPosition.BOTTOM,
              backgroundColor: Colors.green,
              colorText: Colors.white,
            );
            return;
          }
        }
      }

      // Jika bukan koordinat, perlakukan sebagai alamat
      List<Location> locations = await locationFromAddress(query);
      if (locations.isNotEmpty) {
        final location = locations.first;
        final newLatLng = LatLng(location.latitude, location.longitude);

        latitude.value = location.latitude.toStringAsFixed(6);
        longitude.value = location.longitude.toStringAsFixed(6);

        updateMarker(newLatLng);
        mapController.value?.animateCamera(
          CameraUpdate.newLatLngZoom(newLatLng, 14),
        );

        Get.snackbar(
          "Location Found",
          "Moved to: $query",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
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

  void updateMarker(LatLng location) {
    markers.clear();
    final newMarker = Marker(
      markerId: MarkerId(location.toString()),
      position: location,
      infoWindow: InfoWindow(
        title: "Selected Location",
        snippet: "Lat: ${location.latitude}, Lng: ${location.longitude}",
      ),
    );
    markers.add(newMarker);
  }

  Future<void> openGoogleMaps(LatLng destination) async {
    final googleMapsUrl =
        "https://www.google.com/maps/search/?api=1&query=${destination.latitude},${destination.longitude}";
    if (await canLaunch(googleMapsUrl)) {
      await launch(googleMapsUrl);
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

  Future<void> openGoogleMapsRoute(LatLng destination) async {
    final googleMapsRouteUrl =
        "https://www.google.com/maps/dir/?api=1&destination=${destination.latitude},${destination.longitude}";
    if (await canLaunch(googleMapsRouteUrl)) {
      await launch(googleMapsRouteUrl);
    } else {
      Get.snackbar(
        "Error",
        "Could not open Google Maps for route",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
