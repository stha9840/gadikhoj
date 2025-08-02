import 'package:bloc_test/bloc_test.dart';
import 'package:finalyearproject/features/auth/presentation/view_model/profile_view_model/view/profile_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';

import 'package:finalyearproject/features/auth/domain/entity/user_entity.dart';
import 'package:finalyearproject/features/auth/presentation/view/login_view.dart';
import 'package:finalyearproject/features/auth/presentation/view_model/profile_view_model/view_model/profile_event.dart';
import 'package:finalyearproject/features/auth/presentation/view_model/profile_view_model/view_model/profile_state.dart';
import 'package:finalyearproject/features/auth/presentation/view_model/profile_view_model/view_model/profile_view_model.dart';

// Mock UserViewModel (Bloc)
class MockUserViewModel extends Mock implements UserViewModel {}

class FakeUserEvent extends Fake implements UserEvent {}

class FakeUserState extends Fake implements UserState {}

void main() {
  late MockUserViewModel mockUserViewModel;

  setUpAll(() {
    registerFallbackValue(FakeUserEvent());
    registerFallbackValue(FakeUserState());
  });

  setUp(() {
    mockUserViewModel = MockUserViewModel();
  });

  Widget createWidgetUnderTest() {
    return MaterialApp(
      home: BlocProvider<UserViewModel>.value(
        value: mockUserViewModel,
        child: const ProfileView(),
      ),
    );
  }

  group('ProfileView Widget Tests', () {
    testWidgets('renders loading state', (tester) async {
      when(() => mockUserViewModel.state).thenReturn(UserLoading());
      whenListen(mockUserViewModel, Stream<UserState>.empty());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.byType(CircularProgressIndicator), findsOneWidget);
      expect(find.text('Loading profile...'), findsOneWidget);
    });

    testWidgets('renders failure state with retry button', (tester) async {
      when(() => mockUserViewModel.state)
          .thenReturn(const UserFailure(message: 'Failed to load'));
      whenListen(mockUserViewModel, Stream<UserState>.empty());

      await tester.pumpWidget(createWidgetUnderTest());

      expect(find.text('Failed to load profile'), findsOneWidget);
      expect(find.text('Failed to load'), findsOneWidget);
      expect(find.byIcon(Icons.refresh), findsOneWidget);
    });

    testWidgets('renders user loaded state and toggles edit mode', (tester) async {
      final testUser = UserEntity(
        userId: 'user1',
        username: 'testuser',
        email: 'test@example.com',
      );

      when(() => mockUserViewModel.state).thenReturn(UserLoaded(user: testUser));
      whenListen(mockUserViewModel, Stream<UserState>.empty());

      await tester.pumpWidget(createWidgetUnderTest());

      // Initial UI: shows username and email, edit icon is shown
      expect(find.text('testuser'), findsOneWidget);
      expect(find.text('test@example.com'), findsOneWidget);
      expect(find.byIcon(Icons.edit), findsOneWidget);

      // Tap edit icon toggles editing mode (changes icon to close)
      await tester.tap(find.byIcon(Icons.edit));
      await tester.pump();

      expect(find.byIcon(Icons.close), findsOneWidget);

      // Tap close icon toggles editing mode back
      await tester.tap(find.byIcon(Icons.close));
      await tester.pump();

      expect(find.byIcon(Icons.edit), findsOneWidget);
    });


   
  });
}
