import 'package:ejc_frontend_dashboard/app/data/exceptions/exceptions.dart';
import 'package:ejc_frontend_dashboard/app/data/repositories/auth/auth_repository.dart';
import 'package:ejc_frontend_dashboard/app/data/repositories/auth/remote_auth_repository.dart';
import 'package:ejc_frontend_dashboard/app/data/services/supabase_service.dart';
import 'package:ejc_frontend_dashboard/app/domains/dtos/credentials.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:result_dart/result_dart.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class MockSupabaseService extends Mock implements SupabaseService {}

class MockAuthResponse extends Mock implements AuthResponse {}

void main() {
  late MockSupabaseService mockSupabaseService;
  late AuthRepository authRepository;
  final credentials = Credentials(
    email: 'email@email.com',
    password: 'password',
  );
  final mockResponse = MockAuthResponse();
  final fakeSession = Session(
    accessToken: 'accessToken',
    tokenType: 'tokenType',
    user: const User(
      id: '123321abc',
      appMetadata: {},
      userMetadata: {},
      aud: 'aud',
      createdAt: 'createdAt',
    ),
  );
  setUp(() {
    mockSupabaseService = MockSupabaseService();
    authRepository = RemoteAuthRepository(mockSupabaseService);
  });

  setUpAll(() {
    registerFallbackValue(
      Credentials(
        email: 'email@email.com',
        password: 'password',
      ),
    );
  });

  group(
    'Test RemoteAuthRepository implementation...',
    () {
      test(
        'should singin and return '
        'Success(<auth_reponse_instance>) when login is successful ',
        () async {
          when(() => mockResponse.session) //
              .thenReturn(fakeSession);

          when(() => mockSupabaseService.login(any())) //
              .thenAnswer(
            (_) async => //
                Success(mockResponse),
          );

          final result = await authRepository.login(credentials);

          expect(result, Success(mockResponse));

          expect(result.getOrThrow(), mockResponse);

          verify(() => mockSupabaseService.login(any())).called(1);
        },
      );
    },
  );
}
