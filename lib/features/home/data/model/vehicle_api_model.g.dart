// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vehicle_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VehicleApiModel _$VehicleApiModelFromJson(Map<String, dynamic> json) =>
    VehicleApiModel(
      id: json['_id'] as String?,
      vehicleName: json['vehicleName'] as String?,
      vehicleType: json['vehicleType'] as String?,
      fuelCapacityLitres: (json['fuelCapacityLitres'] as num?)?.toInt(),
      loadCapacityKg: (json['loadCapacityKg'] as num?)?.toInt(),
      passengerCapacity: json['passengerCapacity'] as String?,
      pricePerTrip: (json['pricePerTrip'] as num?)?.toDouble(),
      filepath: json['filepath'] as String?,
      vehicleDescription: json['vehicleDescription'] as String?,
    );

Map<String, dynamic> _$VehicleApiModelToJson(VehicleApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'vehicleName': instance.vehicleName,
      'vehicleType': instance.vehicleType,
      'passengerCapacity': instance.passengerCapacity,
      'filepath': instance.filepath,
      'vehicleDescription': instance.vehicleDescription,
      'fuelCapacityLitres': instance.fuelCapacityLitres,
      'loadCapacityKg': instance.loadCapacityKg,
      'pricePerTrip': instance.pricePerTrip,
    };
