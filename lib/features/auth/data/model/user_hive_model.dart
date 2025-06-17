import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:finalyearproject/app/constant/hive/hive_table_constant.dart';
import 'package:finalyearproject/features/auth/domain/entity/user_entity.dart';

part 'user_hive_model.g.dart';

@HiveType(typeId: HiveTableConstant.userTableId)
class UserHiveModel extends Equatable {
  @HiveField(0)
  final String? userId;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String email;

  @HiveField(3)
  final String password;

  UserHiveModel({
    this.userId,
    required this.name,
    required this.email,
    required this.password,
  });

  // From Entity
  factory UserHiveModel.fromEntity(UserEntity entity) {
    return UserHiveModel(
      userId: entity.userId,
      name: entity.name,
      email: entity.email,
      password: entity.password,
    );
  }

  // To Entity
  UserEntity toEntity() {
    return UserEntity(
      userId: userId,
      name: name,
      email: email,
      password: password,
    );
  }

  @override
  List<Object?> get props => [
    userId,
    name,
    email,
    password,
  ];
}