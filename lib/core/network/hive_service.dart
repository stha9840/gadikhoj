import 'package:finalyearproject/app/constant/hive/hive_table_constant.dart';
import 'package:finalyearproject/features/auth/data/model/user_hive_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    Hive.init(directory.path);

    // Register the adapter
    Hive.registerAdapter(UserHiveModelAdapter());
  }

  // Register a new user
  Future<void> registerUser(UserHiveModel user) async {
    final box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await box.put(user.email, user);
  }

  // Login with email and password
  Future<UserHiveModel?> login(String email, String password) async {
    final box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);

    final user = box.get(email);
    if (user == null) return null;
    if (user.password != password) return null;

    return user;
  }

  // Get all registered users
  Future<List<UserHiveModel>> getAllUsers() async {
    final box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    return box.values.toList();
  }

  // Delete a user by email
  Future<void> deleteUser(String email) async {
    final box = await Hive.openBox<UserHiveModel>(HiveTableConstant.userBox);
    await box.delete(email);
  }

  // Clear all user data
  Future<void> clearAll() async {
    await Hive.deleteBoxFromDisk(HiveTableConstant.userBox);
  }

  Future<void> close() async {
    await Hive.close();
  }
}
