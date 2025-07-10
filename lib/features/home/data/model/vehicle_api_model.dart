import 'package:equatable/equatable.dart';
import 'package:finalyearproject/features/home/domain/entity/vehicle.dart';
import 'package:json_annotation/json_annotation.dart';

part 'vehicle_api_model.g.dart';

@JsonSerializable()
class VehicleApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String vehicleName;
  final String vehicleType;
  final int fuelCapacityLitres;
  final int loadCapacityKg;
  final String passengerCapacity;
  final double pricePerTrip;
  final String filepath;
  final String? vehicleDescription;

  const VehicleApiModel({
    this.id,
    required this.vehicleName,
    required this.vehicleType,
    required this.fuelCapacityLitres,
    required this.loadCapacityKg,
    required this.passengerCapacity,
    required this.pricePerTrip,
    required this.filepath,
    this.vehicleDescription,
  });

  factory VehicleApiModel.fromJson(Map<String, dynamic> json) =>
      _$VehicleApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$VehicleApiModelToJson(this);

  VehicleEntity toEntity() {
    return VehicleEntity(
      id: id,
      vehicleName: vehicleName,
      vehicleType: vehicleType,
      fuelCapacityLitres: fuelCapacityLitres,
      loadCapacityKg: loadCapacityKg,
      passengerCapacity: passengerCapacity,
      pricePerTrip: pricePerTrip,
      filepath: filepath,
      vehicleDescription: vehicleDescription,
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
