import 'package:equatable/equatable.dart';
import 'package:finalyearproject/features/home/data/model/vehicle_api_model.dart';
import 'package:finalyearproject/features/saved_vechile/domain/entity/saved_vechile_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'saved_vechile_api_model.g.dart';

@JsonSerializable(explicitToJson: true)
class SavedVehicleApiModel extends Equatable {
  @JsonKey(name: '_id')
  final String? id;
  final String userId;
  

  @JsonKey(name: 'vehicleId')
  final VehicleApiModel vehicle; 

  final String? createdAt; // Timestamps from API are usually strings

  const SavedVehicleApiModel({
    this.id,
    required this.userId,
    required this.vehicle,
    this.createdAt,
  });

  // Connects to the generated file for JSON conversion
  factory SavedVehicleApiModel.fromJson(Map<String, dynamic> json) =>
      _$SavedVehicleApiModelFromJson(json);

  // Function to convert the object to JSON
  Map<String, dynamic> toJson() => _$SavedVehicleApiModelToJson(this);

  SavedVehicleEntity toEntity() {
    return SavedVehicleEntity(
      id: id,
      userId: userId,
      vehicle: vehicle.toEntity(), // Convert the nested model to an entity
      createdAt: createdAt != null ? DateTime.parse(createdAt!) : null,
    );
  }

  @override
  List<Object?> get props => [id, userId, vehicle, createdAt];
}