import 'package:get_it/get_it.dart';

import 'core_module.dart';

final getIt = GetIt.instance;

Future<void> initDependencies() async {
  await initCoreModule(getIt);
}
