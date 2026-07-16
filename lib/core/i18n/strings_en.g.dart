///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsEn = Translations; // ignore: unused_element
class Translations with BaseTranslations<AppLocale, Translations> {
	/// Returns the current translations of the given [context].
	///
	/// Usage:
	/// final t = Translations.of(context);
	static Translations of(BuildContext context) => InheritedLocaleData.of<AppLocale, Translations>(context).translations;

	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	Translations({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	dynamic operator[](String key) => $meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final Translations$core$en core = Translations$core$en.internal(_root);
	late final Translations$auth$en auth = Translations$auth$en.internal(_root);
	late final Translations$navigation$en navigation = Translations$navigation$en.internal(_root);
}

// Path: core
class Translations$core$en {
	Translations$core$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$core$error$en error = Translations$core$error$en.internal(_root);
	late final Translations$core$empty$en empty = Translations$core$empty$en.internal(_root);
	late final Translations$core$loading$en loading = Translations$core$loading$en.internal(_root);
	late final Translations$core$search$en search = Translations$core$search$en.internal(_root);
}

// Path: auth
class Translations$auth$en {
	Translations$auth$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Login'
	String get login => 'Login';

	/// en: 'Sign Up'
	String get signUp => 'Sign Up';

	/// en: 'Forgot Password'
	String get forgotPassword => 'Forgot Password';

	/// en: 'Logout'
	String get logout => 'Logout';

	/// en: 'Email'
	String get email => 'Email';

	/// en: 'Password'
	String get password => 'Password';
}

// Path: navigation
class Translations$navigation$en {
	Translations$navigation$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Home'
	String get home => 'Home';

	/// en: 'Assets'
	String get assets => 'Assets';

	/// en: 'Insights'
	String get insights => 'Insights';

	/// en: 'Goals'
	String get goals => 'Goals';

	/// en: 'Market Prices'
	String get marketPrices => 'Market Prices';

	/// en: 'Notifications'
	String get notifications => 'Notifications';

	/// en: 'Profile'
	String get profile => 'Profile';

	/// en: 'Settings'
	String get settings => 'Settings';
}

// Path: core.error
class Translations$core$error$en {
	Translations$core$error$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Something went wrong'
	String get title => 'Something went wrong';

	/// en: 'Something went wrong on our end.'
	String get body => 'Something went wrong on our end.';

	/// en: 'Try Again'
	String get tryAgain => 'Try Again';
}

// Path: core.empty
class Translations$core$empty$en {
	Translations$core$empty$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No data yet'
	String get title => 'No data yet';

	/// en: 'There's nothing here yet.'
	String get body => 'There\'s nothing here yet.';
}

// Path: core.loading
class Translations$core$loading$en {
	Translations$core$loading$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Loading...'
	String get message => 'Loading...';
}

// Path: core.search
class Translations$core$search$en {
	Translations$core$search$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Search...'
	String get hint => 'Search...';

	/// en: 'No results found.'
	String get noResults => 'No results found.';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'core.error.title' => 'Something went wrong',
			'core.error.body' => 'Something went wrong on our end.',
			'core.error.tryAgain' => 'Try Again',
			'core.empty.title' => 'No data yet',
			'core.empty.body' => 'There\'s nothing here yet.',
			'core.loading.message' => 'Loading...',
			'core.search.hint' => 'Search...',
			'core.search.noResults' => 'No results found.',
			'auth.login' => 'Login',
			'auth.signUp' => 'Sign Up',
			'auth.forgotPassword' => 'Forgot Password',
			'auth.logout' => 'Logout',
			'auth.email' => 'Email',
			'auth.password' => 'Password',
			'navigation.home' => 'Home',
			'navigation.assets' => 'Assets',
			'navigation.insights' => 'Insights',
			'navigation.goals' => 'Goals',
			'navigation.marketPrices' => 'Market Prices',
			'navigation.notifications' => 'Notifications',
			'navigation.profile' => 'Profile',
			'navigation.settings' => 'Settings',
			_ => null,
		};
	}
}
