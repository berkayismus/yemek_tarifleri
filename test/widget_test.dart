import 'package:flutter_test/flutter_test.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';

import 'package:cookmark/app.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    HydratedBloc.storage = await HydratedStorage.build(
      storageDirectory: HydratedStorageDirectory(
        (await getTemporaryDirectory()).path,
      ),
    );
  });

  testWidgets('app smoke test', (tester) async {
    await tester.pumpWidget(const App());
    expect(find.text('Keşfet'), findsOneWidget);
    expect(find.text('Kaydedilenler'), findsOneWidget);
  });
}
