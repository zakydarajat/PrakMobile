import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../controllers/maps_controller.dart';

class MapsView extends GetView<MapsController> {
  final TextEditingController searchController = TextEditingController();
  final RxBool hasText =
      false.obs; // Untuk memantau apakah ada teks di search bar

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
            // Google Map
            GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(position.latitude, position.longitude),
                zoom: 14,
              ),
              onMapCreated: (GoogleMapController googleMapController) {
                controller.mapController.value = googleMapController;

                // Pindahkan kamera ke lokasi pengguna
                googleMapController.animateCamera(
                  CameraUpdate.newLatLngZoom(
                    LatLng(position.latitude, position.longitude),
                    14,
                  ),
                );
              },
              markers: controller.markers,
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
                      Text(
                        "Coordinates",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: Colors.indigo,
                        ),
                      ),
                      SizedBox(height: 5),
                      Text("Latitude: ${controller.latitude.value}"),
                      Text("Longitude: ${controller.longitude.value}"),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          IconButton(
                            icon: Icon(Icons.map, color: Colors.blue),
                            onPressed: () {
                              if (controller.markers.isNotEmpty) {
                                final marker =
                                    controller.markers.first.position;
                                controller.openGoogleMaps(marker);
                              }
                            },
                            tooltip: "Open in Google Maps",
                          ),
                          IconButton(
                            icon: Icon(Icons.directions, color: Colors.green),
                            onPressed: () {
                              if (controller.markers.isNotEmpty) {
                                final marker =
                                    controller.markers.first.position;
                                controller.openGoogleMapsRoute(marker);
                              }
                            },
                            tooltip: "Get Directions",
                          ),
                        ],
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
}
