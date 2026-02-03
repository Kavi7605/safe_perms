import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import '../lib/main.dart';

void main() {
  testWidgets('SafePerms app launches', (tester) async {
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => AppState(),
        child: const SafePermsApp(),
      ),
    );
    expect(find.text('SafePerms'), findsOneWidget);  // AppBar title
    expect(find.byType(Card), findsNWidgets(2));     // 2 summary cards
  });
}
