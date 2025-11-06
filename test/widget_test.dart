// This is a Flutter widget test for the Neon Tic Tac Toe app.
// It replaces the default "counter" test.

import 'package.flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';

// Make sure the 'tik_tak' part matches your project's package name
import 'package:tik_tak/main.dart';
import 'package:tik_tak/providers/game_provider.dart';
import 'package:tik_tak/providers/settings_provider.dart';
import 'package:tik_tak/screens/home_screen.dart';
import 'package:tik_tak/screens/settings_screen.dart';

void main() {
  // Helper function to build the app with all necessary providers
  // This mimics the setup in your main.dart
  Widget buildTestApp() {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => SettingsProvider()),
        ChangeNotifierProvider(create: (_) => GameProvider()),
      ],
      child: const NeonTicTacToeApp(),
    );
  }

  testWidgets('HomeScreen Renders Correctly (Smoke Test)', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(buildTestApp());

    // Verify that the main title is present.
    expect(find.text("TIC TAC\nTOE NEO"), findsOneWidget);

    // Verify the main buttons are present.
    expect(find.text('PLAY VS AI'), findsOneWidget);
    expect(find.text('LOCAL MULTIPLAYER'), findsOneWidget);
    expect(find.text('SETTINGS'), findsOneWidget);

    // Verify no counter text is present
    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsNothing);
  });

  testWidgets('Tapping Settings button navigates to SettingsScreen', (WidgetTester tester) async {
    // Build our app
    await tester.pumpWidget(buildTestApp());

    // Verify we are on the HomeScreen
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.byType(SettingsScreen), findsNothing);

    // Find and tap the 'SETTINGS' button
    await tester.tap(find.text('SETTINGS'));
    
    // pumpAndSettle waits for all animations (like page navigation) to complete
    await tester.pumpAndSettle();

    // Verify we have navigated to the SettingsScreen
    expect(find.byType(HomeScreen), findsNothing);
    expect(find.byType(SettingsScreen), findsOneWidget);

    // As a final check, find a widget unique to the SettingsScreen
    expect(find.text('AI DIFFICULTY'), findsOneWidget);
  });
}