import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:finalyearproject/features/home/domain/use_case/get_all_vehicles_usecase.dart';
import 'package:finalyearproject/features/home/presentation/view_model/vehicle_event.dart';
import 'package:finalyearproject/features/home/presentation/view_model/vehicle_state.dart';
import 'package:finalyearproject/features/home/presentation/view_model/vehicle_view_model.dart';
import 'package:finalyearproject/core/error/failure.dart';

class MockGetAllVehiclesUsecase extends Mock implements GetAllVehiclesUsecase {}

void main() {
  late MockGetAllVehiclesUsecase mockUsecase;

  setUp(() {
    mockUsecase = MockGetAllVehiclesUsecase();
  });

  group('VehicleBloc Tests', () {
    blocTest<VehicleBloc, VehicleState>(
      'emits [VehicleLoading, VehicleLoaded] when FetchVehiclesEvent succeeds',
      build: () {
        when(() => mockUsecase()).thenAnswer((_) async => Right([]));
        return VehicleBloc(getAllVehiclesUsecase: mockUsecase);
      },
      act: (bloc) => bloc.add(FetchVehiclesEvent()),
      expect: () => [
        VehicleLoading(),
        VehicleLoaded([]),
      ],
    );

    blocTest<VehicleBloc, VehicleState>(
  'emits [VehicleLoading, VehicleError] when FetchVehiclesEvent fails',
  build: () {
    when(() => mockUsecase()).thenAnswer(
      (_) async => Left(ApiFailure(message: 'API request failed')),
    );
    return VehicleBloc(getAllVehiclesUsecase: mockUsecase);
  },
  act: (bloc) => bloc.add(FetchVehiclesEvent()),
  expect: () => [
    VehicleLoading(),
    VehicleError('API request failed'),
  ],
  verify: (_) => verify(() => mockUsecase()).called(1),
);

  });
}
