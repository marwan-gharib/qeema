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
	late final Translations$app$en app = Translations$app$en.internal(_root);
	late final Translations$core$en core = Translations$core$en.internal(_root);
	late final Translations$auth$en auth = Translations$auth$en.internal(_root);
	late final Translations$onboarding$en onboarding = Translations$onboarding$en.internal(_root);
	late final Translations$navigation$en navigation = Translations$navigation$en.internal(_root);
	late final Translations$insights$en insights = Translations$insights$en.internal(_root);
}

// Path: app
class Translations$app$en {
	Translations$app$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Qeema'
	String get name => 'Qeema';

	/// en: 'Value'
	String get tagline => 'Value';
}

// Path: core
class Translations$core$en {
	Translations$core$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$core$error$en error = Translations$core$error$en.internal(_root);
	late final Translations$core$failure$en failure = Translations$core$failure$en.internal(_root);
	late final Translations$core$empty$en empty = Translations$core$empty$en.internal(_root);
	late final Translations$core$loading$en loading = Translations$core$loading$en.internal(_root);
	late final Translations$core$search$en search = Translations$core$search$en.internal(_root);
	late final Translations$core$validation$en validation = Translations$core$validation$en.internal(_root);
	late final Translations$core$dates$en dates = Translations$core$dates$en.internal(_root);
	late final Translations$core$auth$en auth = Translations$core$auth$en.internal(_root);
	late final Translations$core$notification$en notification = Translations$core$notification$en.internal(_root);
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

// Path: onboarding
class Translations$onboarding$en {
	Translations$onboarding$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Skip'
	String get skip => 'Skip';

	/// en: 'Next'
	String get next => 'Next';

	/// en: 'Get Started'
	String get getStarted => 'Get Started';

	/// en: 'Your money has a number. Does it still have the same value?'
	String get slide1Headline => 'Your money has a number.\nDoes it still have the same value?';

	/// en: 'The gap between what you have and what it's worth grows every day. See it happen to your own savings.'
	String get slide1Body => 'The gap between what you have and what it\'s worth grows every day. See it happen to your own savings.';

	/// en: 'Track what you actually hold'
	String get slide2Headline => 'Track what you actually hold';

	/// en: 'Cash, dollars, gold — logged in seconds, always in view. Know where your money is at a glance.'
	String get slide2Body => 'Cash, dollars, gold — logged in seconds, always in view. Know where your money is at a glance.';

	/// en: 'See inflation happening, not just hear about it'
	String get slide3Headline => 'See inflation happening,\nnot just hear about it';

	/// en: 'Watch how your real value moves against the nominal number over time — made personal, not abstract.'
	String get slide3Body => 'Watch how your real value moves against the nominal number over time — made personal, not abstract.';

	/// en: 'Let's see where you stand'
	String get slide4Headline => 'Let\'s see where you stand';

	/// en: 'No bank connection, no transfers — just clarity on what your savings are really worth.'
	String get slide4Body => 'No bank connection, no transfers — just clarity on what your savings are really worth.';

	late final Translations$onboarding$assetType$en assetType = Translations$onboarding$assetType$en.internal(_root);
}

// Path: navigation
class Translations$navigation$en {
	Translations$navigation$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Splash'
	String get splash => 'Splash';

	/// en: 'Welcome'
	String get welcome => 'Welcome';

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

	/// en: 'Biometric Setup'
	String get biometricSetup => 'Biometric Setup';

	/// en: 'Add Asset'
	String get addAsset => 'Add Asset';

	/// en: 'Asset {id}'
	String get assetDetail => 'Asset {id}';

	/// en: 'Edit Asset {id}'
	String get editAsset => 'Edit Asset {id}';

	/// en: 'Add Goal'
	String get addGoal => 'Add Goal';

	/// en: 'Goal {id}'
	String get goalDetail => 'Goal {id}';

	/// en: 'Notification Settings'
	String get notificationSettings => 'Notification Settings';
}

// Path: insights
class Translations$insights$en {
	Translations$insights$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$insights$assetPerformance$en assetPerformance = Translations$insights$assetPerformance$en.internal(_root);
	late final Translations$insights$concentrationRisk$en concentrationRisk = Translations$insights$concentrationRisk$en.internal(_root);
	late final Translations$insights$inflationLoss$en inflationLoss = Translations$insights$inflationLoss$en.internal(_root);
	late final Translations$insights$goalFeasibility$en goalFeasibility = Translations$insights$goalFeasibility$en.internal(_root);
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

	/// en: 'Server error'
	String get serverError => 'Server error';

	/// en: 'Cache error'
	String get cacheError => 'Cache error';

	/// en: 'Authentication error'
	String get authError => 'Authentication error';

	/// en: 'Sync failed'
	String get syncFailed => 'Sync failed';

	/// en: 'Connection timed out'
	String get connectionTimeout => 'Connection timed out';

	/// en: 'Server did not respond'
	String get serverNotResponding => 'Server did not respond';

	/// en: 'Could not connect to server'
	String get couldNotConnect => 'Could not connect to server';

	/// en: 'Request failed'
	String get requestFailed => 'Request failed';
}

// Path: core.failure
class Translations$core$failure$en {
	Translations$core$failure$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No internet connection.'
	String get networkFailure => 'No internet connection.';

	/// en: 'Could not read local data.'
	String get cacheFailure => 'Could not read local data.';

	/// en: 'An unexpected error occurred.'
	String get unknownFailure => 'An unexpected error occurred.';

	/// en: 'Could not fetch price for {assetTypeCode}'
	String get priceFetchFailure => 'Could not fetch price for {assetTypeCode}';

	/// en: 'Inflation data missing for {count} month(s)'
	String get inflationDataMissing => 'Inflation data missing for {count} month(s)';

	/// en: 'Calculation failed: {reason}'
	String get calculationFailed => 'Calculation failed: {reason}';
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

// Path: core.validation
class Translations$core$validation$en {
	Translations$core$validation$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Email is required'
	String get emailRequired => 'Email is required';

	/// en: 'Enter a valid email address'
	String get emailInvalid => 'Enter a valid email address';

	/// en: 'Password is required'
	String get passwordRequired => 'Password is required';

	/// en: 'Password must be at least 8 characters'
	String get passwordMinLength => 'Password must be at least 8 characters';

	/// en: 'Amount is required'
	String get amountRequired => 'Amount is required';

	/// en: 'Enter a valid positive amount'
	String get amountInvalid => 'Enter a valid positive amount';
}

// Path: core.dates
class Translations$core$dates$en {
	Translations$core$dates$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'just now'
	String get justNow => 'just now';

	/// en: '{minutes}m ago'
	String get minutesAgo => '{minutes}m ago';

	/// en: '{hours}h ago'
	String get hoursAgo => '{hours}h ago';

	/// en: '{days}d ago'
	String get daysAgo => '{days}d ago';
}

// Path: core.auth
class Translations$core$auth$en {
	Translations$core$auth$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Unlock Qeema to view your finances'
	String get unlockReason => 'Unlock Qeema to view your finances';

	/// en: 'Biometric authentication failed'
	String get biometricFailed => 'Biometric authentication failed';
}

// Path: core.notification
class Translations$core$notification$en {
	Translations$core$notification$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Price Alerts'
	String get channelName => 'Price Alerts';

	/// en: 'Notifications about price changes'
	String get channelDescription => 'Notifications about price changes';
}

// Path: onboarding.assetType
class Translations$onboarding$assetType$en {
	Translations$onboarding$assetType$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'EGP'
	String get egp => 'EGP';

	/// en: 'USD'
	String get usd => 'USD';

	/// en: 'Gold'
	String get gold => 'Gold';
}

// Path: insights.assetPerformance
class Translations$insights$assetPerformance$en {
	Translations$insights$assetPerformance$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Best performing asset'
	String get title => 'Best performing asset';

	/// en: 'Asset {id} leads your portfolio with a value of {value} EGP.'
	String get body => 'Asset {id} leads your portfolio with a value of {value} EGP.';
}

// Path: insights.concentrationRisk
class Translations$insights$concentrationRisk$en {
	Translations$insights$concentrationRisk$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'High concentration risk'
	String get title => 'High concentration risk';

	/// en: 'Over 80% of your portfolio is in one asset type. Consider diversifying to reduce risk.'
	String get body => 'Over 80% of your portfolio is in one asset type. Consider diversifying to reduce risk.';
}

// Path: insights.inflationLoss
class Translations$insights$inflationLoss$en {
	Translations$insights$inflationLoss$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Inflation erosion detected'
	String get title => 'Inflation erosion detected';

	/// en: 'Your money has lost {erosion}% of its purchasing power since you started tracking.'
	String get body => 'Your money has lost {erosion}% of its purchasing power since you started tracking.';
}

// Path: insights.goalFeasibility
class Translations$insights$goalFeasibility$en {
	Translations$insights$goalFeasibility$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Savings goal check'
	String get title => 'Savings goal check';

	/// en: 'At the current pace of inflation, your savings goals may need to be revised upward to maintain their real value.'
	String get body => 'At the current pace of inflation, your savings goals may need to be revised upward to maintain their real value.';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.name' => 'Qeema',
			'app.tagline' => 'Value',
			'core.error.title' => 'Something went wrong',
			'core.error.body' => 'Something went wrong on our end.',
			'core.error.tryAgain' => 'Try Again',
			'core.error.serverError' => 'Server error',
			'core.error.cacheError' => 'Cache error',
			'core.error.authError' => 'Authentication error',
			'core.error.syncFailed' => 'Sync failed',
			'core.error.connectionTimeout' => 'Connection timed out',
			'core.error.serverNotResponding' => 'Server did not respond',
			'core.error.couldNotConnect' => 'Could not connect to server',
			'core.error.requestFailed' => 'Request failed',
			'core.failure.networkFailure' => 'No internet connection.',
			'core.failure.cacheFailure' => 'Could not read local data.',
			'core.failure.unknownFailure' => 'An unexpected error occurred.',
			'core.failure.priceFetchFailure' => 'Could not fetch price for {assetTypeCode}',
			'core.failure.inflationDataMissing' => 'Inflation data missing for {count} month(s)',
			'core.failure.calculationFailed' => 'Calculation failed: {reason}',
			'core.empty.title' => 'No data yet',
			'core.empty.body' => 'There\'s nothing here yet.',
			'core.loading.message' => 'Loading...',
			'core.search.hint' => 'Search...',
			'core.search.noResults' => 'No results found.',
			'core.validation.emailRequired' => 'Email is required',
			'core.validation.emailInvalid' => 'Enter a valid email address',
			'core.validation.passwordRequired' => 'Password is required',
			'core.validation.passwordMinLength' => 'Password must be at least 8 characters',
			'core.validation.amountRequired' => 'Amount is required',
			'core.validation.amountInvalid' => 'Enter a valid positive amount',
			'core.dates.justNow' => 'just now',
			'core.dates.minutesAgo' => '{minutes}m ago',
			'core.dates.hoursAgo' => '{hours}h ago',
			'core.dates.daysAgo' => '{days}d ago',
			'core.auth.unlockReason' => 'Unlock Qeema to view your finances',
			'core.auth.biometricFailed' => 'Biometric authentication failed',
			'core.notification.channelName' => 'Price Alerts',
			'core.notification.channelDescription' => 'Notifications about price changes',
			'auth.login' => 'Login',
			'auth.signUp' => 'Sign Up',
			'auth.forgotPassword' => 'Forgot Password',
			'auth.logout' => 'Logout',
			'auth.email' => 'Email',
			'auth.password' => 'Password',
			'onboarding.skip' => 'Skip',
			'onboarding.next' => 'Next',
			'onboarding.getStarted' => 'Get Started',
			'onboarding.slide1Headline' => 'Your money has a number.\nDoes it still have the same value?',
			'onboarding.slide1Body' => 'The gap between what you have and what it\'s worth grows every day. See it happen to your own savings.',
			'onboarding.slide2Headline' => 'Track what you actually hold',
			'onboarding.slide2Body' => 'Cash, dollars, gold — logged in seconds, always in view. Know where your money is at a glance.',
			'onboarding.slide3Headline' => 'See inflation happening,\nnot just hear about it',
			'onboarding.slide3Body' => 'Watch how your real value moves against the nominal number over time — made personal, not abstract.',
			'onboarding.slide4Headline' => 'Let\'s see where you stand',
			'onboarding.slide4Body' => 'No bank connection, no transfers — just clarity on what your savings are really worth.',
			'onboarding.assetType.egp' => 'EGP',
			'onboarding.assetType.usd' => 'USD',
			'onboarding.assetType.gold' => 'Gold',
			'navigation.splash' => 'Splash',
			'navigation.welcome' => 'Welcome',
			'navigation.home' => 'Home',
			'navigation.assets' => 'Assets',
			'navigation.insights' => 'Insights',
			'navigation.goals' => 'Goals',
			'navigation.marketPrices' => 'Market Prices',
			'navigation.notifications' => 'Notifications',
			'navigation.profile' => 'Profile',
			'navigation.settings' => 'Settings',
			'navigation.biometricSetup' => 'Biometric Setup',
			'navigation.addAsset' => 'Add Asset',
			'navigation.assetDetail' => 'Asset {id}',
			'navigation.editAsset' => 'Edit Asset {id}',
			'navigation.addGoal' => 'Add Goal',
			'navigation.goalDetail' => 'Goal {id}',
			'navigation.notificationSettings' => 'Notification Settings',
			'insights.assetPerformance.title' => 'Best performing asset',
			'insights.assetPerformance.body' => 'Asset {id} leads your portfolio with a value of {value} EGP.',
			'insights.concentrationRisk.title' => 'High concentration risk',
			'insights.concentrationRisk.body' => 'Over 80% of your portfolio is in one asset type. Consider diversifying to reduce risk.',
			'insights.inflationLoss.title' => 'Inflation erosion detected',
			'insights.inflationLoss.body' => 'Your money has lost {erosion}% of its purchasing power since you started tracking.',
			'insights.goalFeasibility.title' => 'Savings goal check',
			'insights.goalFeasibility.body' => 'At the current pace of inflation, your savings goals may need to be revised upward to maintain their real value.',
			_ => null,
		};
	}
}
