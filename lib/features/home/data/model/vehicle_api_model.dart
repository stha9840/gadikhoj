import 'package:equatable/equatable.dart';
import 'package:finalyearproject/features/home/domain/entity/vehicle.dart'; // Ensure this path is correct
import 'package:json_annotation/json_annotation.dart';

part 'vehicle_api_model.g.dart';

/// Data model representing a Vehicle from the API.
///
/// This model is designed to be robust against incomplete API data. All fields
/// are nullable to prevent parsing errors if the server sends a null value.
@JsonSerializable()
class VehicleApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;

  // FIX: All fields are made nullable to prevent crashes.
  final String? vehicleName;
  final String? vehicleType;
  final String? passengerCapacity;
  final String? filepath;
  final String? vehicleDescription;
  final int? fuelCapacityLitres;
  final int? loadCapacityKg;
  final double? pricePerTrip;

  const VehicleApiModel({
    this.id,
    this.vehicleName,
    this.vehicleType,
    this.fuelCapacityLitres,
    this.loadCapacityKg,
    this.passengerCapacity,
    this.pricePerTrip,
    this.filepath,
    this.vehicleDescription,
  });

  factory VehicleApiModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleApiModelToJson(this);

  /// Converts this data model into a clean, non-nullable domain entity.
  /// Default values are provided for any null fields from the API.
  VehicleEntity toEntity() {
    return VehicleEntity(
      // Use the null-coalescing operator (??) to provide defaults.
      id: id ?? '',
      vehicleName: vehicleName ?? 'Unnamed Vehicle',
      vehicleType: vehicleType ?? 'N/A',
      filepath: filepath ?? '',
      vehicleDescription: vehicleDescription ?? 'No description available.',
      fuelCapacityLitres: fuelCapacityLitres ?? 0,
      loadCapacityKg: loadCapacityKg ?? 0,
      passengerCapacity: passengerCapacity ?? '0',
      // FIX: Use 0.0 for double default value.
      pricePerTrip: pricePerTrip ?? 0.0,
    );
  }

  factory VehicleApiModel.fromEntity(VehicleEntity entity) {
    return VehicleApiModel(
      id: entity.id,
      vehicleName: entity.vehicleName,
      vehicleType: entity.vehicleType,
      fuelCapacityLitres: entity.fuelCapacityLitres,
      loadCapacityKg: entity.loadCapacityKg,
      passengerCapacity: entity.passengerCapacity,
      pricePerTrip: entity.pricePerTrip,
      filepath: entity.filepath,
      vehicleDescription: entity.vehicleDescription,
    );
  }

  /// Converts a list of API models to a list of domain entities.
  static List<VehicleEntity> toEntityList(List<VehicleApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }

  @override
  List<Object?> get props => [
        id,
        vehicleName,
        vehicleType,
        fuelCapacityLitres,
        loadCapacityKg,
        passengerCapacity,
        pricePerTrip,
        filepath,
        vehicleDescription,
      ];
}