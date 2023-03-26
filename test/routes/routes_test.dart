import 'package:flutter_test/flutter_test.dart';
import 'package:the_dig_app/routes/routes.dart';

void main() {
  group('routes', () {
    test('should have the correct number of routes', () {
      expect(routes.length, equals(11));
    });

    test('should have the correct path for /register', () {
      final registerRoute =
          routes.firstWhere((route) => route.path == '/register');

      expect(registerRoute, isNotNull);
      expect(registerRoute.builder, isA<Function>());
    });

    test('should have the correct path for /login', () {
      final loginRoute = routes.firstWhere((route) => route.path == '/login');

      expect(loginRoute, isNotNull);
      expect(loginRoute.builder, isA<Function>());
    });

    test('should have the correct path for /profiles', () {
      final profilesRoute =
          routes.firstWhere((route) => route.path == '/profiles');

      expect(profilesRoute, isNotNull);
      expect(profilesRoute.builder, isA<Function>());
    });

    test('should have the correct path for /add/owner/profile', () {
      final addOwnerProfileRoute =
          routes.firstWhere((route) => route.path == '/add/owner/profile');

      expect(addOwnerProfileRoute, isNotNull);
      expect(addOwnerProfileRoute.builder, isA<Function>());
    });

    test('should have the correct path for /edit/profile', () {
      final editProfileRoute =
          routes.firstWhere((route) => route.path == '/edit/profile');

      expect(editProfileRoute, isNotNull);
      expect(editProfileRoute.builder, isA<Function>());
    });

    test('should have the correct path for /chats', () {
      final chatsRoute = routes.firstWhere((route) => route.path == '/chats');

      expect(chatsRoute, isNotNull);
      expect(chatsRoute.builder, isA<Function>());
    });

    test('should have the correct path for /settings', () {
      final settingsRoute =
          routes.firstWhere((route) => route.path == '/settings');

      expect(settingsRoute, isNotNull);
      expect(settingsRoute.builder, isA<Function>());
    });

    test('should have the correct path for /swipes', () {
      final swipesRoute = routes.firstWhere((route) => route.path == '/swipes');

      expect(swipesRoute, isNotNull);
      expect(swipesRoute.builder, isA<Function>());
    });
    test('should have the correct path for /incoming/swipes', () {
      final incomingSwipesRoute =
          routes.firstWhere((route) => route.path == '/incoming/swipes');
      expect(incomingSwipesRoute, isNotNull);
    });

    test('should have the correct path for /contacts', () {
      final contactsRoute =
          routes.firstWhere((route) => route.path == '/contacts');

      expect(contactsRoute, isNotNull);
      expect(contactsRoute.builder, isA<Function>());
    });

    test('should have the correct path for /chat_screen', () {
      final chatScreenRoute =
          routes.firstWhere((route) => route.path == '/chat_screen');

      expect(chatScreenRoute, isNotNull);
      expect(chatScreenRoute.builder, isA<Function>());
    });
  });
}
