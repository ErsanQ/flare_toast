import 'package:flare_toast/flare_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  // ─────────────────────────────────────────────────────────────────────────
  // Unit tests
  // ─────────────────────────────────────────────────────────────────────────

  group('FlareToastController', () {
    test('dismiss() is a no-op when no state is attached', () {
      final controller = FlareToastController();
      // Should not throw.
      expect(controller.dismiss, returnsNormally);
    });
  });

  group('FlareToastPosition enum', () {
    test('has top and bottom values', () {
      expect(FlareToastPosition.values, containsAll([
        FlareToastPosition.top,
        FlareToastPosition.bottom,
      ]));
    });
  });

  // ─────────────────────────────────────────────────────────────────────────
  // Widget tests
  // ─────────────────────────────────────────────────────────────────────────

  group('FlareToastWrapper', () {
    testWidgets('renders child widget', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FlareToastWrapper(
            child: Scaffold(body: Text('hello')),
          ),
        ),
      );
      expect(find.text('hello'), findsOneWidget);
    });
  });

  group('FlareToast.show()', () {
    testWidgets('inserts overlay entry with message text', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FlareToastWrapper(
            child: _ToastTrigger(),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('trigger')));
      await tester.pump(); // start animation frame
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Test message'), findsOneWidget);
    });

    testWidgets('toast disappears after duration + exit animation',
        (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: FlareToastWrapper(
            child: _ToastTrigger(),
          ),
        ),
      );

      await tester.tap(find.byKey(const Key('trigger')));
      await tester.pump(); // kick off animation

      // Advance past the 1 s visible duration and the 350 ms exit animation.
      await tester.pump(const Duration(milliseconds: 1350));
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Test message'), findsNothing);
    });
  });
}

// ─────────────────────────────────────────────────────────────────────────────
// Helper widget used in widget tests
// ─────────────────────────────────────────────────────────────────────────────

class _ToastTrigger extends StatelessWidget {
  const _ToastTrigger();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          key: const Key('trigger'),
          onPressed: () => FlareToast.show(
            context,
            message: 'Test message',
            duration: const Duration(seconds: 1),
          ),
          child: const Text('Show'),
        ),
      ),
    );
  }
}
