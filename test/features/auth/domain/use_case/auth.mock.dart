
import 'package:finalyearproject/app/shared_pref/token_shared_prefs.dart';
import 'package:finalyearproject/features/auth/domain/repository/user_repository.dart';
import 'package:mocktail/mocktail.dart';


class MockAuthRepository extends Mock implements IUserRepository {}

class MockTokenSharedPrefs extends Mock implements TokenSharedPrefs {}