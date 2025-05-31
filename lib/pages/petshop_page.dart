import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class PetshopPage extends StatefulWidget {
  const PetshopPage({Key? key}) : super(key: key);

  @override
  _PetshopPageState createState() => _PetshopPageState();
}

class _PetshopPageState extends State<PetshopPage> {
  Position? _currentPosition;
  LatLng? _defaultLocation;
  String _locationStatus = "Getting location...";
  bool _isLoading = true;
  final Distance distance = Distance();

  final List<Map<String, dynamic>> petshops = [
    {
      'name': 'Petshop A',
      'lat': -6.200000,
      'lng': 106.816666,
      'address': 'Jl. Sudirman No.1',
    },
    {
      'name': 'Petshop B',
      'lat': -6.210000,
      'lng': 106.825000,
      'address': 'Jl. Thamrin No.10',
    },
    {
      'name': 'Petshop C',
      'lat': -6.190000,
      'lng': 106.810000,
      'address': 'Jl. Gatot Subroto No.5',
    },
  ];

  List<Map<String, dynamic>> _nearestPetshops = [];

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  Future<void> _determinePosition() async {
    try {
      setState(() {
        _locationStatus = "Checking location services...";
      });

      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _locationStatus =
              "Location services are disabled. Please enable GPS.";
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _locationStatus = "Checking permissions...";
      });

      // Check permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        setState(() {
          _locationStatus = "Requesting location permission...";
        });

        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          setState(() {
            _locationStatus =
                "Location permissions denied. Please allow location access.";
            _isLoading = false;
          });
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _locationStatus =
              "Location permissions permanently denied. Please enable in settings.";
          _isLoading = false;
        });
        return;
      }

      setState(() {
        _locationStatus = "Getting your location...";
      });

      // Get current position with timeout
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 10), // Add timeout
      );

      setState(() {
        _currentPosition = position;
        _locationStatus = "Location acquired successfully!";
        _isLoading = false;
      });

      _calculateNearestPetshops();
    } catch (e) {
      setState(() {
        _locationStatus = "Error getting location: ${e.toString()}";
        _isLoading = false;
      });

      // Fallback: Use default location (Jakarta center)
      _useDefaultLocation();
    }
  }

  void _useDefaultLocation() {
    // Use LatLng directly instead of Position for default location
    setState(() {
      _defaultLocation = LatLng(-6.2088, 106.8456);
      _locationStatus = "Using default location (Jakarta Center)";
      _isLoading = false;
    });

    _calculateNearestPetshops();
  }

  // Get current location as LatLng (works for both real and default location)
  LatLng? _getCurrentLatLng() {
    if (_currentPosition != null) {
      return LatLng(_currentPosition!.latitude, _currentPosition!.longitude);
    } else if (_defaultLocation != null) {
      return _defaultLocation;
    }
    return null;
  }

  void _calculateNearestPetshops() {
    final currentLatLng = _getCurrentLatLng();
    if (currentLatLng == null) return;

    List<Map<String, dynamic>> sorted = List.from(petshops);
    sorted.sort((a, b) {
      final distA = distance(currentLatLng, LatLng(a['lat'], a['lng']));
      final distB = distance(currentLatLng, LatLng(b['lat'], b['lng']));
      return distA.compareTo(distB);
    });

    setState(() {
      _nearestPetshops = sorted;
    });
  }

  void _retryLocation() {
    setState(() {
      _isLoading = true;
      _currentPosition = null;
      _defaultLocation = null;
      _locationStatus = "Retrying...";
      _nearestPetshops.clear();
    });
    _determinePosition();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Petshop Terdekat"),
        backgroundColor: const Color(0xffCEAB93),
        actions: [
          if (_isLoading)
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.white,
                ),
              ),
            ),
        ],
      ),
      body: _isLoading || (_currentPosition == null && _defaultLocation == null)
          ? _buildLoadingScreen()
          : _buildMapScreen(),
    );
  }

  Widget _buildLoadingScreen() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (_isLoading) ...[
              const CircularProgressIndicator(),
              const SizedBox(height: 20),
            ] else ...[
              const Icon(
                Icons.location_off,
                size: 64,
                color: Colors.grey,
              ),
              const SizedBox(height: 20),
            ],
            Text(
              _locationStatus,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
            if (!_isLoading) ...[
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton.icon(
                    onPressed: _retryLocation,
                    icon: const Icon(Icons.refresh),
                    label: const Text("Retry"),
                  ),
                  ElevatedButton.icon(
                    onPressed: _useDefaultLocation,
                    icon: const Icon(Icons.location_city),
                    label: const Text("Use Default"),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMapScreen() {
    final currentLatLng = _getCurrentLatLng()!;

    return Column(
      children: [
        // Status bar
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8.0),
          color: Colors.green.shade100,
          child: Text(
            _locationStatus,
            textAlign: TextAlign.center,
            style: const TextStyle(
                color: Colors.green, fontWeight: FontWeight.bold),
          ),
        ),

        // Map
        Expanded(
          flex: 2,
          child: FlutterMap(
            options: MapOptions(
              initialCenter: currentLatLng,
              initialZoom: 14.0, // Changed from maxZoom to initialZoom
            ),
            children: [
              TileLayer(
                urlTemplate:
                    "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                subdomains: const ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: currentLatLng,
                    width: 80,
                    height: 80,
                    child: const Icon(
                      Icons.my_location,
                      color: Colors.blue,
                      size: 40,
                    ),
                  ),
                  ..._nearestPetshops.map(
                    (petshop) => Marker(
                      point: LatLng(petshop['lat'], petshop['lng']),
                      width: 80,
                      height: 80,
                      child: const Icon(
                        Icons.store_mall_directory,
                        color: Colors.redAccent,
                        size: 40,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        // List petshops
        Expanded(
          flex: 3,
          child: _nearestPetshops.isEmpty
              ? const Center(
                  child: Text(
                    "No petshops found nearby",
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  itemCount: _nearestPetshops.length,
                  itemBuilder: (context, index) {
                    final petshop = _nearestPetshops[index];
                    final distMeters = distance(
                        currentLatLng, LatLng(petshop['lat'], petshop['lng']));
                    final distKm = (distMeters / 1000).toStringAsFixed(2);
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: ListTile(
                        leading: const CircleAvatar(
                          backgroundColor: Color(0xffCEAB93),
                          child: Icon(Icons.store, color: Colors.white),
                        ),
                        title: Text(
                          petshop['name'],
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(petshop['address']),
                            const SizedBox(height: 4),
                            Text(
                              '$distKm km away',
                              style: TextStyle(
                                color: Colors.green.shade600,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                        onTap: () {
                          // Handle petshop selection
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Selected ${petshop['name']}'),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}
