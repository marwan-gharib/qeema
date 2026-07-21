import 'package:get_it/get_it.dart';
import 'package:qeema/features/settings/presentation/cubits/settings_cubit/settings_cubit.dart';

void initSettingsModule(GetIt getIt) {
  getIt.registerFactory<SettingsCubit>(() => SettingsCubit(getIt(), getIt()));
}
