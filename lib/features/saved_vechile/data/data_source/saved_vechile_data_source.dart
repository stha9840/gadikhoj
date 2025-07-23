import 'package:finalyearproject/features/saved_vechile/data/model/saved_vechile_api_model.dart';

abstract interface class ISavedVechileDataSource {
  Future<void> addSavedVehicle(String vehicleId , String? token);
  Future<void> removeSavedVehicle(String vehicleId, String? token);
  Future<List<SavedVehicleApiModel>> getSavedVehicles(String? token);
}