// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_vechile_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SavedVehicleApiModel _$SavedVehicleApiModelFromJson(
        Map<String, dynamic> json) =>
    SavedVehicleApiModel(
      id: json['_id'] as String?,
      userId: json['userId'] as String,
      vehicle:
          VehicleApiModel.fromJson(json['vehicleId'] as Map<String, dynamic>),
      createdAt: json['createdAt'] as String?,
    );

Map<String, dynamic> _$SavedVehicleApiModelToJson(
        SavedVehicleApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'userId': instance.userId,
      'vehicleId': instance.vehicle.toJson(),
      'createdAt': instance.createdAt,
    };
