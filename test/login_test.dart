import 'package:authentication_repository/authentication_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:p2p_chat/authentication/authentication.dart';
import 'package:p2p_chat/login/login.dart';

import 'package:user_repository/user_repository.dart';

class MockAuthenticationRepository extends Mock implements AuthenticationRepository {}

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  testWidgets('Given user in login page', (WidgetTester tester) async {
    final _mockAuthenticationRepository = MockAuthenticationRepository();
    final _mockUserRepository = MockUserRepository();
    // Build our app and trigger a frame.
    await tester.pumpWidget(RepositoryProvider.value(
      value: _mockAuthenticationRepository,
      child: BlocProvider(
        create: (_) => AuthenticationBloc(
          authenticationRepository: _mockAuthenticationRepository,
          userRepository: _mockUserRepository,
        ),
        child: MaterialApp(
          home: LoginPage(),
        ),
      ),
    ));

    expect(find.widgetWithText(ElevatedButton, "Login"), findsOneWidget);

    // Verify that our counter starts at 0.
    // expect(find.text('0'), findsOneWidget);
    // expect(find.text('1'), findsNothing);

    // // Tap the '+' icon and trigger a frame.
    // await tester.tap(find.byIcon(Icons.add));
    // await tester.pump();

    // // Verify that our counter has incremented.
    // expect(find.text('0'), findsNothing);
    // expect(find.text('1'), findsOneWidget);
  });
}
