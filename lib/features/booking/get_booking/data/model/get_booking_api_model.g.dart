// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'get_booking_api_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BookingApiModel _$BookingApiModelFromJson(Map<String, dynamic> json) =>
    BookingApiModel(
      id: json['_id'] as String?,
      userId: json['userId'] as String,
      vehcleId:
          VehicleApiModel.fromJson(json['vehicleId'] as Map<String, dynamic>),
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      pickupLocation: json['pickupLocation'] as String,
      dropLocation: json['dropLocation'] as String,
      totalPrice: (json['totalPrice'] as num).toDouble(),
      status: json['status'] as String?,
    );

Map<String, dynamic> _$BookingApiModelToJson(BookingApiModel instance) =>
    <String, dynamic>{
      '_id': instance.id,
      'userId': instance.userId,
      'vehicleId': instance.vehcleId.toJson(),
      'startDate': instance.startDate,
      'endDate': instance.endDate,
      'pickupLocation': instance.pickupLocation,
      'dropLocation': instance.dropLocation,
      'totalPrice': instance.totalPrice,
      'status': instance.status,
    };
