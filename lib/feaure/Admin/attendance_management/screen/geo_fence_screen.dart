import 'package:flutter/material.dart';

class GeoFenceLocation {
  final String branchName;
  final String branchCode;
  final String status;
  final String locationStr;
  final bool isConfigured;
  final double? lat;
  final double? lng;
  final double? radius;

  GeoFenceLocation({
    required this.branchName,
    required this.branchCode,
    required this.status,
    required this.locationStr,
    required this.isConfigured,
    this.lat,
    this.lng,
    this.radius,
  });
}

class GeoFenceScreen extends StatefulWidget {
  const GeoFenceScreen({super.key});

  @override
  State<GeoFenceScreen> createState() => _GeoFenceScreenState();
}

class _GeoFenceScreenState extends State<GeoFenceScreen> {
  final List<GeoFenceLocation> _locations = [
    GeoFenceLocation(
      branchName: 'Bangalore Branch',
      branchCode: 'BLR',
      status: 'Active',
      locationStr: 'Bangalore, Karnataka',
      isConfigured: true,
      lat: 26.85203119,
      lng: 81.05541845,
      radius: 100.00,
    ),
    GeoFenceLocation(
      branchName: 'Chennai Branch',
      branchCode: 'CHN',
      status: 'Active',
      locationStr: 'Chennai, Tamil Nadu',
      isConfigured: false,
    ),
    GeoFenceLocation(
      branchName: 'Delhi HQ',
      branchCode: 'DEL',
      status: 'Active',
      locationStr: 'New Delhi, Delhi',
      isConfigured: false,
    ),
    GeoFenceLocation(
      branchName: 'Hyderabad Branch',
      branchCode: 'HYD',
      status: 'Active',
      locationStr: 'Hyderabad, Telangana',
      isConfigured: false,
    ),
    GeoFenceLocation(
      branchName: 'Mumbai Branch',
      branchCode: 'MUM',
      status: 'Active',
      locationStr: 'Mumbai, Maharashtra',
      isConfigured: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: const Text('Geo Fence Management', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18)),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 1,
        shadowColor: Colors.black12,
        actions: [
          IconButton(icon: const Icon(Icons.add, color: Colors.indigo), onPressed: () {}),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            color: Colors.white,
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search branches...',
                hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 14),
                prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
                filled: true,
                fillColor: Colors.grey.shade50,
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 0),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey.shade200)),
                focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Colors.indigo)),
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _locations.length,
              itemBuilder: (context, index) {
                return _buildLocationCard(_locations[index]);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocationCard(GeoFenceLocation location) {
    bool isActive = location.status.toLowerCase() == 'active';

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(Icons.business, color: Colors.indigo.shade400, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              location.branchName,
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.black87),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: isActive ? Colors.green.shade50 : Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              location.status.toUpperCase(),
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                                color: isActive ? Colors.green.shade700 : Colors.grey.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade100,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              location.branchCode,
                              style: TextStyle(color: Colors.grey.shade700, fontSize: 11, fontWeight: FontWeight.w600),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Icon(Icons.location_on, size: 12, color: Colors.grey.shade400),
                          const SizedBox(width: 4),
                          Expanded(
                            child: Text(
                              location.locationStr,
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: location.isConfigured ? Colors.indigo.shade50.withOpacity(0.3) : Colors.grey.shade50,
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16)),
            ),
            child: location.isConfigured
                ? Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.green.shade50, shape: BoxShape.circle),
                        child: Icon(Icons.my_location, color: Colors.green.shade500, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('Geo-Fence Active', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.black87)),
                            const SizedBox(height: 4),
                            Text(
                              'Lat: ${location.lat}  |  Lng: ${location.lng}',
                              style: TextStyle(color: Colors.grey.shade700, fontSize: 11),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              'Radius: ${location.radius}m',
                              style: TextStyle(color: Colors.grey.shade700, fontSize: 11),
                            ),
                          ],
                        ),
                      ),
                      OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.indigo,
                          side: BorderSide(color: Colors.indigo.shade200),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          minimumSize: const Size(0, 32),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ),
                        child: const Text('Edit Map', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.grey.shade200, shape: BoxShape.circle),
                        child: Icon(Icons.location_disabled, color: Colors.grey.shade500, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('No geo-fence configured', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: Colors.black54)),
                            const SizedBox(height: 2),
                            Text('Setup perimeter to track attendance', style: TextStyle(color: Colors.grey.shade500, fontSize: 11)),
                          ],
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {},
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.indigo,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          minimumSize: const Size(0, 32),
                          elevation: 0,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                        ),
                        child: const Text('Setup', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}
