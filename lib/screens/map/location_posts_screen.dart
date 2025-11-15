import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../models/location_model.dart';
import '../../models/post_model.dart';
import '../../providers/post_provider.dart';
import '../../widgets/post_grid_item.dart';

class LocationPostsScreen extends StatefulWidget {
  final LocationModel location;
  final String? postId; // Optional - if coming from a specific post

  const LocationPostsScreen({
    super.key,
    required this.location,
    this.postId,
  });

  @override
  State<LocationPostsScreen> createState() => _LocationPostsScreenState();
}

class _LocationPostsScreenState extends State<LocationPostsScreen> {
  GoogleMapController? _mapController;
  List<PostModel> _locationPosts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadLocationPosts();
  }

  Future<void> _loadLocationPosts() async {
    final postProvider = Provider.of<PostProvider>(context, listen: false);
    await postProvider.loadAllPosts();

    // Filter posts by location (within ~100 meters)
    final allPosts = postProvider.posts;
    final locationPosts = allPosts.where((post) {
      final distance = _calculateDistance(
        widget.location.latitude,
        widget.location.longitude,
        post.location.latitude,
        post.location.longitude,
      );
      return distance < 0.1; // Within 100 meters
    }).toList();

    setState(() {
      _locationPosts = locationPosts;
      _isLoading = false;
    });
  }

  double _calculateDistance(double lat1, double lon1, double lat2, double lon2) {
    // Simple distance calculation (not accurate for long distances)
    const p = 0.017453292519943295; // Math.PI / 180
    final a = 0.5 -
        0.5 * math.cos((lat2 - lat1) * p) +
        (math.cos(lat1 * p) * math.cos(lat2 * p) * 0.5 * (1 - math.cos((lon2 - lon1) * p)));
    return 12742 * math.asin(math.sqrt(a)); // 2 * R; R = 6371 km
  }

  @override
  Widget build(BuildContext context) {
    final marker = Marker(
      markerId: MarkerId(widget.location.displayName),
      position: LatLng(widget.location.latitude, widget.location.longitude),
      icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
      infoWindow: InfoWindow(
        title: widget.location.displayName,
        snippet: '${_locationPosts.length} posts',
      ),
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.location.displayName),
      ),
      body: Column(
        children: [
          // Map Section
          SizedBox(
            height: 250,
            child: GoogleMap(
              initialCameraPosition: CameraPosition(
                target: LatLng(
                  widget.location.latitude,
                  widget.location.longitude,
                ),
                zoom: 15,
              ),
              markers: {marker},
              onMapCreated: (controller) {
                _mapController = controller;
              },
              myLocationEnabled: false,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
            ),
          ),

          // Posts Section
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _locationPosts.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.photo_library_outlined,
                              size: 80,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No posts at this location',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              '${_locationPosts.length} ${_locationPosts.length == 1 ? 'post' : 'posts'} at this location',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          Expanded(
                            child: GridView.builder(
                              padding: const EdgeInsets.all(2.0),
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                mainAxisSpacing: 2,
                                crossAxisSpacing: 2,
                              ),
                              itemCount: _locationPosts.length,
                              itemBuilder: (context, index) {
                                return PostGridItem(
                                  post: _locationPosts[index],
                                );
                              },
                            ),
                          ),
                        ],
                      ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}
