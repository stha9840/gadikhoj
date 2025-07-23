import 'package:equatable/equatable.dart';
import 'package:finalyearproject/features/booking/get_booking/domain/entity/booking.dart';
import 'package:finalyearproject/features/home/data/model/vehicle_api_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_booking_api_model.g.dart';

@JsonSerializable(explicitToJson: true)
class BookingApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String userId;
  
  // FIX: Tell the parser the correct JSON key name
  @JsonKey(name: 'vehicleId') 
  final VehicleApiModel vehcleId; 

  final String startDate;
  final String endDate;
  final String pickupLocation;
  final String dropLocation;
  final double totalPrice;
  final String? status;

  const BookingApiModel({
    this.id,
    required this.userId,
    required this.vehcleId,
    required this.startDate,
    required this.endDate,
    required this.pickupLocation,
    required this.dropLocation,
    required this.totalPrice,
    this.status,
  });

  factory BookingApiModel.fromJson(Map<String, dynamic> json) =>
      _$BookingApiModelFromJson(json);

  Map<String, dynamic> toJson() => _$BookingApiModelToJson(this);

  // Update toEntity to correctly map all the data
  BookingEntity toEntity() {
    return BookingEntity(
      id: id,
      userId: userId,
      vehicleId: vehcleId.id, // IMPROVEMENT: Populate the String vehicleId
      vehicle: vehcleId.toEntity(), 
      startDate: DateTime.parse(startDate),
      endDate: DateTime.parse(endDate),
      pickupLocation: pickupLocation,
      dropLocation: dropLocation,
      totalPrice: totalPrice,
      status: status,
    );
  }

  @override
  List<Object?> get props => [
    id,
    userId,
    vehcleId, // Add vehcleId back to props for proper equality checking
    startDate,
    endDate,
    pickupLocation,
    dropLocation,
    totalPrice,
    status,
  ];
}