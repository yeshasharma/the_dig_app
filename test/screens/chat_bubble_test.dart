import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:the_dig_app/screens/chat_bubble.dart';

void main() {
  testWidgets('ChatBubble widget', (WidgetTester tester) async {
    // Create a MaterialApp to test ChatBubble
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: ChatBubble(
            text: 'Hello',
            isCurrentUser: true,
          ),
        ),
      ),
    );

    // Check that the widget has been built
    expect(find.byType(ChatBubble), findsOneWidget);

    // Check that the decoration has been set correctly
    final decoration = tester.widget<DecoratedBox>(find.descendant(
        of: find.byType(ChatBubble), matching: find.byType(DecoratedBox)));
    expect(
        decoration.decoration,
        const BoxDecoration(
          color: Colors.blue,
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ));

    // Check that the text has been set correctly
    final text = tester.widget<Text>(find.descendant(
        of: find.byType(ChatBubble), matching: find.byType(Text)));
    expect(text.data, 'Hello');
    expect(text.style!.color, Colors.white);
  });

  testWidgets('ChatBubble constructor sets properties correctly',
      (WidgetTester tester) async {
    // Build a ChatBubble widget
    const text = 'Hello';
    const isCurrentUser = true;
    const key = Key('chat_bubble_key');
    const widget =
        ChatBubble(key: key, text: text, isCurrentUser: isCurrentUser);

    // Rebuild the widget
    await tester.pumpWidget(const MaterialApp(home: widget));

    // Verify that the properties are set correctly
    final chatBubbleFinder = find.byKey(key);
    expect(chatBubbleFinder, findsOneWidget);
    final chatBubble = tester.widget(chatBubbleFinder) as ChatBubble;
    expect(chatBubble.text, equals(text));
    expect(chatBubble.isCurrentUser, equals(isCurrentUser));
  });
}
