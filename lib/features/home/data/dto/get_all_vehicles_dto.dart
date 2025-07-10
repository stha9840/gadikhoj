import 'package:finalyearproject/features/home/data/model/vehicle_api_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'get_all_vehicles_dto.g.dart';

@JsonSerializable()
class GetAllVehiclesDto {
  final bool success;
  final int? count; // nullable count
  final List<VehicleApiModel> data;

  const GetAllVehiclesDto({
    required this.success,
    this.count,
    required this.data,
  });

  factory GetAllVehiclesDto.fromJson(Map<String, dynamic> json) =>
      _$GetAllVehiclesDtoFromJson(json);

  Map<String, dynamic> toJson() => _$GetAllVehiclesDtoToJson(this);
}
