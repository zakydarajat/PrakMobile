import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart'; // Import url_launcher
import '../controllers/maps_controller.dart';

class MapsView extends GetView<MapsController> {
  final TextEditingController searchController = TextEditingController();
  final RxBool hasText = false.obs; // Untuk memantau apakah ada teks di search bar

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Maps Explorer"),
        centerTitle: true,
        backgroundColor: Colors.lightBlue.shade800,
      ),
      body: Obx(() {
        final position = controller.currentPosition.value;

        if (position == null) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        return Stack(
          children: [
            // Tampilan yang menampilkan koordinat dan lat-lng pengguna
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Current Location",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Colors.indigo,
                    ),
                  ),
                  SizedBox(height: 20),
                  Text("Latitude: ${controller.latitude.value}"),
                  Text("Longitude: ${controller.longitude.value}"),
                ],
              ),
            ),

            // Search Bar
            Positioned(
              top: 20,
              left: 20,
              right: 20,
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: searchController,
                          onSubmitted: (value) {
                            if (value.isNotEmpty) {
                              controller.searchLocation(value);
                            }
                          },
                          decoration: InputDecoration(
                            hintText: "Search location or coordinates",
                            border: InputBorder.none,
                            suffixIcon: hasText.value
                                ? IconButton(
                                    icon: Icon(Icons.clear, color: Colors.red),
                                    onPressed: () {
                                      searchController.clear();
                                      hasText.value =
                                          false; // Sembunyikan tombol X
                                    },
                                  )
                                : null,
                          ),
                          onChanged: (value) {
                            hasText.value = value
                                .isNotEmpty; // Tampilkan tombol X jika ada teks
                          },
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.search, color: Colors.orange),
                        onPressed: () {
                          final query = searchController.text;
                          if (query.isNotEmpty) {
                            controller.searchLocation(query);
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Latitude, Longitude, and Action Icons
            Positioned(
              bottom: 20,
              left: 20,
              right: 20,
              child: Card(
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Coordinates",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: Colors.indigo,
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.copy, color: Colors.blue),
                            onPressed: () {
                              final coordinates = '${controller.latitude.value}, ${controller.longitude.value}';
                              // Menyalin koordinat ke clipboard
                              // Anda bisa menggunakan package flutter/services untuk menyalin ke clipboard
                            },
                            tooltip: "Copy Coordinates",
                          ),
                        ],
                      ),
                      SizedBox(height: 5),
                      Text("Latitude: ${controller.latitude.value}"),
                      Text("Longitude: ${controller.longitude.value}"),
                      SizedBox(height: 10),

                      // Tombol untuk membuka Google Maps
                      Center(
                        child: ElevatedButton(
                          onPressed: () {
                            final lat = controller.latitude.value;
                            final lng = controller.longitude.value;
                            final url = "https://www.google.com/maps?q=$lat,$lng";
                            _openGoogleMaps(url);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: Text(
                            "Open in Google Maps",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  // Fungsi untuk membuka Google Maps dengan URL
  void _openGoogleMaps(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
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
