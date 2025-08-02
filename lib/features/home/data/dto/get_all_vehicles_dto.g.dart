// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_all_vehicles_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GetAllVehiclesDto _$GetAllVehiclesDtoFromJson(Map<String, dynamic> json) =>
    GetAllVehiclesDto(
      success: json['success'] as bool,
      count: (json['count'] as num?)?.toInt(),
      data: (json['data'] as List<dynamic>)
          .map((e) => VehicleApiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$GetAllVehiclesDtoToJson(GetAllVehiclesDto instance) =>
    <String, dynamic>{
      'success': instance.success,
      'count': instance.count,
      'data': instance.data,
    };
