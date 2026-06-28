import 'package:delifit_mobile/app/app_widget.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('renderiza home inicial', (tester) async {
    await tester.pumpWidget(const AppWidget());
    await tester.pumpAndSettle();

    expect(find.text('Delifit Mobile'), findsOneWidget);
    expect(find.text('Base pronta para evoluir'), findsOneWidget);
  });
}
