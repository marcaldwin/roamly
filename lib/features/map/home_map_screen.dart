import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:maplibre_gl/maplibre_gl.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeMapScreen extends StatefulWidget {
  const HomeMapScreen({super.key});

  @override
  State<HomeMapScreen> createState() => _HomeMapScreenState();
}

class _HomeMapScreenState extends State<HomeMapScreen> {
  static const LatLng kidapawanCenter = LatLng(7.0106, 125.0911);

  static const String osmRasterStyle = '''
{
  "version": 8,
  "sources": {
    "osm": {
      "type": "raster",
      "tiles": [
        "https://tile.openstreetmap.org/{z}/{x}/{y}.png"
      ],
      "tileSize": 256,
      "attribution": "© OpenStreetMap contributors"
    }
  },
  "layers": [
    {
      "id": "osm-raster-layer",
      "type": "raster",
      "source": "osm"
    }
  ]
}
''';

  final supabase = Supabase.instance.client;

  MapLibreMapController? mapController;

  bool isLoading = true;
  bool hasLocationPermission = false;
  String? errorMessage;

  Position? currentPosition;
  List<Map<String, dynamic>> places = [];

  @override
  void initState() {
    super.initState();
    initializeMapData();
  }

  Future<void> initializeMapData() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    await requestLocationPermission();
    await loadPlaces();

    setState(() {
      isLoading = false;
    });
  }

  Future<void> requestLocationPermission() async {
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        setState(() {
          hasLocationPermission = false;
          errorMessage = 'Location service is disabled.';
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        setState(() {
          hasLocationPermission = false;
          errorMessage = 'Location permission denied.';
        });
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          hasLocationPermission = false;
          errorMessage =
              'Location permission permanently denied. Enable it in app settings.';
        });
        return;
      }

      final position = await Geolocator.getCurrentPosition();

      setState(() {
        hasLocationPermission = true;
        currentPosition = position;
      });
    } catch (error) {
      setState(() {
        hasLocationPermission = false;
        errorMessage = 'Failed to get location: $error';
      });
    }
  }

  Future<void> loadPlaces() async {
    try {
      final response = await supabase
          .from('places')
          .select(
            'id, name, description, latitude, longitude, unlock_radius_meters, status',
          )
          .eq('status', 'approved')
          .order('name');

      places = List<Map<String, dynamic>>.from(response);
    } catch (error) {
      setState(() {
        errorMessage = 'Failed to load places: $error';
      });
    }
  }

  Future<void> onMapCreated(MapLibreMapController controller) async {
    mapController = controller;
  }

  Future<void> onStyleLoaded() async {
    await addPlaceMarkers();
  }

  Future<void> addPlaceMarkers() async {
    final controller = mapController;

    if (controller == null) {
      return;
    }

    for (final place in places) {
      final latitude = toDouble(place['latitude']);
      final longitude = toDouble(place['longitude']);

      if (latitude == null || longitude == null) {
        continue;
      }

      await controller.addCircle(
        CircleOptions(
          geometry: LatLng(latitude, longitude),
          circleRadius: 8,
          circleColor: '#F97316',
          circleStrokeWidth: 2,
          circleStrokeColor: '#FFFFFF',
        ),
      );
    }
  }

  Future<void> moveToMyLocation() async {
    await requestLocationPermission();

    if (currentPosition == null || mapController == null) {
      return;
    }

    await mapController!.animateCamera(
      CameraUpdate.newLatLngZoom(
        LatLng(currentPosition!.latitude, currentPosition!.longitude),
        15,
      ),
    );
  }

  Future<void> moveToKidapawan() async {
    if (mapController == null) {
      return;
    }

    await mapController!.animateCamera(
      CameraUpdate.newLatLngZoom(kidapawanCenter, 13),
    );
  }

  double? toDouble(dynamic value) {
    if (value == null) {
      return null;
    }

    if (value is double) {
      return value;
    }

    if (value is int) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value);
    }

    return null;
  }

  Future<void> logout() async {
    await supabase.auth.signOut();
  }

  void showPlacesSheet() {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      builder: (context) {
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: places.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final place = places[index];

            return ListTile(
              leading: const Icon(Icons.place),
              title: Text(place['name']?.toString() ?? 'Unnamed place'),
              subtitle: Text(
                'Unlock radius: ${place['unlock_radius_meters']} meters',
              ),
              onTap: () async {
                Navigator.of(context).pop();

                final latitude = toDouble(place['latitude']);
                final longitude = toDouble(place['longitude']);

                if (latitude == null || longitude == null) {
                  return;
                }

                await mapController?.animateCamera(
                  CameraUpdate.newLatLngZoom(LatLng(latitude, longitude), 16),
                );
              },
            );
          },
        );
      },
    );
  }

  Widget buildLoadingOverlay() {
    if (!isLoading) {
      return const SizedBox.shrink();
    }

    return Container(
      color: Colors.black.withValues(alpha: 0.2),
      child: const Center(child: CircularProgressIndicator()),
    );
  }

  Widget buildErrorBanner() {
    if (errorMessage == null) {
      return const SizedBox.shrink();
    }

    return Positioned(
      left: 16,
      right: 16,
      top: 16,
      child: Material(
        borderRadius: BorderRadius.circular(12),
        color: Colors.red.shade100,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Text(errorMessage!, style: const TextStyle(color: Colors.red)),
        ),
      ),
    );
  }

  Widget buildFloatingButtons() {
    return Positioned(
      right: 16,
      bottom: 24,
      child: Column(
        children: [
          FloatingActionButton.small(
            heroTag: 'my_location',
            onPressed: moveToMyLocation,
            child: const Icon(Icons.my_location),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.small(
            heroTag: 'kidapawan',
            onPressed: moveToKidapawan,
            child: const Icon(Icons.explore),
          ),
          const SizedBox(height: 12),
          FloatingActionButton.small(
            heroTag: 'places',
            onPressed: showPlacesSheet,
            child: const Icon(Icons.list),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = supabase.auth.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Roamly Map'),
        actions: [
          IconButton(onPressed: logout, icon: const Icon(Icons.logout)),
        ],
      ),
      body: Stack(
        children: [
          MapLibreMap(
            styleString: osmRasterStyle,
            initialCameraPosition: const CameraPosition(
              target: kidapawanCenter,
              zoom: 13,
              tilt: 0,
            ),
            onMapCreated: onMapCreated,
            onStyleLoadedCallback: onStyleLoaded,
            myLocationEnabled: hasLocationPermission,
            myLocationTrackingMode: MyLocationTrackingMode.none,
          ),

          Positioned(
            left: 16,
            right: 16,
            bottom: 24,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  'Logged in: ${user?.email ?? 'Unknown'}\n'
                  'Loaded places: ${places.length}',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),

          buildErrorBanner(),
          buildFloatingButtons(),
          buildLoadingOverlay(),
        ],
      ),
    );
  }
}
