class BranchModel {
  final int id;
  final String? name;
  final String? code;
  final String? address;
  final String? city;
  final String? state;
  final String? country;
  final String? phone;
  final String? email;
  final String? geoLat;
  final String? geoLng;
  final String? geoRadiusMeters;
  final int? managerId;
  final bool isActive;
  final String? createdAt;
  final Map<String, dynamic>? manager;

  BranchModel({
    required this.id,
    this.name,
    this.code,
    this.address,
    this.city,
    this.state,
    this.country,
    this.phone,
    this.email,
    this.geoLat,
    this.geoLng,
    this.geoRadiusMeters,
    this.managerId,
    required this.isActive,
    this.createdAt,
    this.manager,
  });

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id'].toString()) ?? 0,
      name: json['name'],
      code: json['code'],
      address: json['address'],
      city: json['city'],
      state: json['state'],
      country: json['country'],
      phone: json['phone'],
      email: json['email'],
      geoLat: json['geo_lat'],
      geoLng: json['geo_lng'],
      geoRadiusMeters: json['geo_radius_meters']?.toString(), // Handle if radius passed as number
      managerId: json['manager_id'] is int ? json['manager_id'] : (json['manager_id'] != null ? int.tryParse(json['manager_id'].toString()) : null),
      isActive: json['is_active'] == 1 || json['is_active'] == '1' || json['is_active'] == true,
      createdAt: json['created_at'],
      manager: json['manager'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'address': address,
      'city': city,
      'state': state,
      'country': country,
      'phone': phone,
      'email': email,
      'geo_lat': geoLat,
      'geo_lng': geoLng,
      'geo_radius_meters': geoRadiusMeters,
      'manager_id': managerId,
      'is_active': isActive,
      'created_at': createdAt,
      'manager': manager,
    };
  }
}
