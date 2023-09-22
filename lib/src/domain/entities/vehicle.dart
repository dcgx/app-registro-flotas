enum VehicleType {
  car,
  bike,
  truck,
  bus,
  van,
  other,
}

enum VehicleStatus {
  active,
  inactive,
  inMaintenance,
}

class Vehicle {
  final String id;
  final String name;
  final String model;
  final String vin;
  final String vinType;
  final VehicleType type;
  final VehicleStatus status;
  final String acquiredAt;

  Vehicle({
    required this.id,
    required this.name,
    required this.model,
    required this.vin,
    required this.vinType,
    required this.type,
    required this.status,
    required this.acquiredAt,
  });

  factory Vehicle.fromMap(Map<String, dynamic> data) {
    return Vehicle(
      id: data['id'],
      name: data['name'],
      model: data['model'],
      vin: data['vin'],
      vinType: data['vinType'],
      type: data['type'],
      status: data['status'],
      acquiredAt: data['acquiredAt'],
    );
  }
}