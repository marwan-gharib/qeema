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
	late final Translations$nav$en nav = Translations$nav$en.internal(_root);
	late final Translations$appLock$en appLock = Translations$appLock$en.internal(_root);
	late final Translations$assets$en assets = Translations$assets$en.internal(_root);
	late final Translations$settings$en settings = Translations$settings$en.internal(_root);
	late final Translations$home$en home = Translations$home$en.internal(_root);
	late final Translations$insights$en insights = Translations$insights$en.internal(_root);
	late final Translations$marketPrices$en marketPrices = Translations$marketPrices$en.internal(_root);
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
	late final Translations$core$actions$en actions = Translations$core$actions$en.internal(_root);
	late final Translations$core$notification$en notification = Translations$core$notification$en.internal(_root);
}

// Path: auth
class Translations$auth$en {
	Translations$auth$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$auth$welcome$en welcome = Translations$auth$welcome$en.internal(_root);
	late final Translations$auth$error$en error = Translations$auth$error$en.internal(_root);
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

// Path: nav
class Translations$nav$en {
	Translations$nav$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Home'
	String get home => 'Home';

	/// en: 'Assets'
	String get assets => 'Assets';

	/// en: 'Market Prices'
	String get marketPrices => 'Market Prices';

	/// en: 'Settings'
	String get settings => 'Settings';
}

// Path: appLock
class Translations$appLock$en {
	Translations$appLock$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Too many attempts. Try again later.'
	String get tooManyAttempts => 'Too many attempts. Try again later.';

	/// en: 'No device lock set up. Set up a screen lock in your device settings.'
	String get noCredentials => 'No device lock set up. Set up a screen lock in your device settings.';

	/// en: 'Device authentication is not available on this device.'
	String get unavailable => 'Device authentication is not available on this device.';
}

// Path: assets
class Translations$assets$en {
	Translations$assets$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations
	late final Translations$assets$list$en list = Translations$assets$list$en.internal(_root);
	late final Translations$assets$add$en add = Translations$assets$add$en.internal(_root);
	late final Translations$assets$edit$en edit = Translations$assets$edit$en.internal(_root);
	late final Translations$assets$detail$en detail = Translations$assets$detail$en.internal(_root);
	late final Translations$assets$sort$en sort = Translations$assets$sort$en.internal(_root);
	late final Translations$assets$filter$en filter = Translations$assets$filter$en.internal(_root);
	late final Translations$assets$chart$en chart = Translations$assets$chart$en.internal(_root);
	late final Translations$assets$history$en history = Translations$assets$history$en.internal(_root);
	late final Translations$assets$delete$en delete = Translations$assets$delete$en.internal(_root);
	late final Translations$assets$failure$en failure = Translations$assets$failure$en.internal(_root);
}

// Path: settings
class Translations$settings$en {
	Translations$settings$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Settings'
	String get title => 'Settings';

	/// en: 'Security'
	String get securitySection => 'Security';

	/// en: 'Preferences'
	String get preferencesSection => 'Preferences';

	/// en: 'About'
	String get aboutSection => 'About';

	/// en: 'Danger Zone'
	String get dangerZoneSection => 'Danger Zone';

	/// en: 'Require device unlock to open Qeema'
	String get requireUnlock => 'Require device unlock to open Qeema';

	/// en: 'Your device doesn't have a screen lock set up. Set one up in your device settings to use this feature.'
	String get noDeviceLock => 'Your device doesn\'t have a screen lock set up. Set one up in your device settings to use this feature.';

	/// en: 'Authentication was cancelled.'
	String get authCancelled => 'Authentication was cancelled.';

	/// en: 'Language'
	String get language => 'Language';

	/// en: 'Choose Language'
	String get languageSheetTitle => 'Choose Language';

	/// en: 'English'
	String get languageEnglish => 'English';

	/// en: 'العربية'
	String get languageArabic => 'العربية';

	/// en: 'Theme'
	String get theme => 'Theme';

	/// en: 'Choose Theme'
	String get themeSheetTitle => 'Choose Theme';

	/// en: 'Light'
	String get themeLight => 'Light';

	/// en: 'Dark'
	String get themeDark => 'Dark';

	/// en: 'System'
	String get themeSystem => 'System';

	/// en: 'App Version'
	String get appVersion => 'App Version';

	/// en: 'Data & Methodology'
	String get dataMethodology => 'Data & Methodology';

	/// en: 'Prices are based on international spot rates and official exchange rates — local market or goldsmith prices may differ. Inflation figures are manually curated from CAPMAS and CBE data. Qeema is a portfolio and demo project: the figures are for tracking and awareness, not financial advice.'
	String get dataMethodologyNote => 'Prices are based on international spot rates and official exchange rates — local market or goldsmith prices may differ. Inflation figures are manually curated from CAPMAS and CBE data. Qeema is a portfolio and demo project: the figures are for tracking and awareness, not financial advice.';

	/// en: 'Delete Account'
	String get deleteAccount => 'Delete Account';

	/// en: 'Delete Account?'
	String get deleteDialogTitle => 'Delete Account?';

	/// en: 'This permanently erases all of your assets, history, and this account. There is no recovery — and since Qeema uses anonymous sign-in, there is no email or password to log back in with if you change your mind. Type DELETE to confirm.'
	String get deleteDialogBody => 'This permanently erases all of your assets, history, and this account. There is no recovery — and since Qeema uses anonymous sign-in, there is no email or password to log back in with if you change your mind. Type DELETE to confirm.';

	/// en: 'Type DELETE to confirm'
	String get deleteConfirmHint => 'Type DELETE to confirm';

	/// en: 'Delete Forever'
	String get deleteForever => 'Delete Forever';

	/// en: 'Could not delete your account. Please try again.'
	String get deleteFailed => 'Could not delete your account. Please try again.';

	/// en: 'Your data was deleted but your account could not be fully removed. Please try again or contact support.'
	String get deletePartialFailure => 'Your data was deleted but your account could not be fully removed. Please try again or contact support.';
}

// Path: home
class Translations$home$en {
	Translations$home$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Qeema'
	String get title => 'Qeema';

	/// en: 'Total Savings'
	String get totalSavingsNominal => 'Total Savings';

	/// en: 'Adjusted for Inflation'
	String get totalSavingsReal => 'Adjusted for Inflation';

	/// en: 'of your money's value has eroded since you started'
	String get erosionCaption => 'of your money\'s value has eroded since you started';

	/// en: 'Real Value — Last 30 Days'
	String get trendSectionTitle => 'Real Value — Last 30 Days';

	/// en: 'Prices moved significantly today — check your assets.'
	String get priceMoveBanner => 'Prices moved significantly today — check your assets.';

	/// en: 'Something went wrong'
	String get errorTitle => 'Something went wrong';

	/// en: 'Try Again'
	String get retry => 'Try Again';

	/// en: 'Not enough data yet'
	String get notEnoughTrendData => 'Not enough data yet';
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

// Path: marketPrices
class Translations$marketPrices$en {
	Translations$marketPrices$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Market Prices'
	String get title => 'Market Prices';

	/// en: 'Prices are based on international spot rates and official exchange rates — local market or goldsmith prices may differ.'
	String get dataSourceDisclosure => 'Prices are based on international spot rates and official exchange rates — local market or goldsmith prices may differ.';

	/// en: 'Updated {when}'
	String get lastUpdated => 'Updated {when}';

	/// en: 'Not enough history yet'
	String get notEnoughHistory => 'Not enough history yet';

	/// en: 'Showing available data ({days} days)'
	String get showingAvailableData => 'Showing available data ({days} days)';

	/// en: 'No market prices yet'
	String get emptyTitle => 'No market prices yet';

	/// en: 'Market price data will appear here once it becomes available.'
	String get emptyBody => 'Market price data will appear here once it becomes available.';

	late final Translations$marketPrices$range$en range = Translations$marketPrices$range$en.internal(_root);
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

// Path: core.actions
class Translations$core$actions$en {
	Translations$core$actions$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Cancel'
	String get cancel => 'Cancel';

	/// en: 'Delete'
	String get delete => 'Delete';
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

// Path: auth.welcome
class Translations$auth$welcome$en {
	Translations$auth$welcome$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Know what your money is really worth'
	String get headline => 'Know what your money is really worth';

	/// en: 'Track your savings against inflation and see your real purchasing power over time.'
	String get subtext => 'Track your savings against inflation and see your real purchasing power over time.';

	/// en: 'Start Tracking Your Savings'
	String get primaryCta => 'Start Tracking Your Savings';

	/// en: 'No account needed. You can create one later.'
	String get guestDisclosure => 'No account needed. You can create one later.';
}

// Path: auth.error
class Translations$auth$error$en {
	Translations$auth$error$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'No internet connection. Please check your network and try again.'
	String get networkError => 'No internet connection. Please check your network and try again.';

	/// en: 'Too many attempts. Please wait a moment and try again.'
	String get tooManyRequests => 'Too many attempts. Please wait a moment and try again.';

	/// en: 'Something went wrong. Please try again.'
	String get unknownError => 'Something went wrong. Please try again.';

	/// en: 'Guest sign-in is currently unavailable. Please try again later.'
	String get anonymousSignInDisabled => 'Guest sign-in is currently unavailable. Please try again later.';
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

// Path: assets.list
class Translations$assets$list$en {
	Translations$assets$list$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Assets'
	String get title => 'Assets';

	/// en: 'EGP Cash'
	String get tabEgp => 'EGP Cash';

	/// en: 'USD'
	String get tabUsd => 'USD';

	/// en: 'Gold 21K'
	String get tabGold21 => 'Gold 21K';

	/// en: 'Gold 24K'
	String get tabGold24 => 'Gold 24K';

	/// en: 'Sort & Filter'
	String get sortFilter => 'Sort & Filter';

	/// en: 'Newest first'
	String get sortDateNewest => 'Newest first';

	/// en: 'Oldest first'
	String get sortDateOldest => 'Oldest first';

	/// en: 'Highest value'
	String get sortValueHighest => 'Highest value';

	/// en: 'Lowest value'
	String get sortValueLowest => 'Lowest value';

	/// en: 'No assets yet'
	String get emptyNoAssets => 'No assets yet';

	/// en: 'Add your first asset to start tracking'
	String get emptyNoAssetsSubtitle => 'Add your first asset to start tracking';

	/// en: 'No holdings of this type'
	String get emptyNoFiltered => 'No holdings of this type';

	/// en: 'Try a different filter'
	String get emptyNoFilteredSubtitle => 'Try a different filter';

	/// en: 'Add Asset'
	String get addFirst => 'Add Asset';
}

// Path: assets.add
class Translations$assets$add$en {
	Translations$assets$add$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Add Asset'
	String get title => 'Add Asset';

	/// en: 'Select Asset Type'
	String get selectType => 'Select Asset Type';

	/// en: 'Amount'
	String get amount => 'Amount';

	/// en: 'Amount (grams)'
	String get amountGrams => 'Amount (grams)';

	/// en: 'Amount (EGP)'
	String get amountEgp => 'Amount (EGP)';

	/// en: 'Amount (USD)'
	String get amountUsd => 'Amount (USD)';

	/// en: 'Price at entry'
	String get priceAtEntry => 'Price at entry';

	/// en: 'Price per gram at entry'
	String get pricePerGram => 'Price per gram at entry';

	/// en: 'Price per unit at entry'
	String get pricePerUnit => 'Price per unit at entry';

	/// en: 'Entry Date'
	String get entryDate => 'Entry Date';

	/// en: 'Select date'
	String get selectDate => 'Select date';

	/// en: 'Note (optional)'
	String get note => 'Note (optional)';

	/// en: 'Add a note...'
	String get noteHint => 'Add a note...';

	/// en: 'Add Asset'
	String get submit => 'Add Asset';

	/// en: 'Amount is required'
	String get amountRequired => 'Amount is required';

	/// en: 'Enter a valid positive amount'
	String get amountInvalid => 'Enter a valid positive amount';

	/// en: 'Price is required'
	String get priceRequired => 'Price is required';

	/// en: 'Enter a valid positive price'
	String get priceInvalid => 'Enter a valid positive price';

	/// en: 'Select an asset type first'
	String get selectTypeFirst => 'Select an asset type first';
}

// Path: assets.edit
class Translations$assets$edit$en {
	Translations$assets$edit$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Edit {type}'
	String get title => 'Edit {type}';

	/// en: 'Save Changes'
	String get submit => 'Save Changes';

	/// en: 'Asset Type'
	String get assetTypeLabel => 'Asset Type';
}

// Path: assets.detail
class Translations$assets$detail$en {
	Translations$assets$detail$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Entry: {price} EGP per unit'
	String get entryPrice => 'Entry: {price} EGP per unit';

	/// en: 'Value Trend'
	String get valueTrend => 'Value Trend';

	/// en: 'Edit History'
	String get editHistory => 'Edit History';

	/// en: 'No edit history yet'
	String get noHistory => 'No edit history yet';

	/// en: 'Cash assets maintain a constant value'
	String get cashFlatValue => 'Cash assets maintain a constant value';

	/// en: 'Asset not found'
	String get notFoundTitle => 'Asset not found';

	/// en: 'This asset is no longer available.'
	String get notFoundBody => 'This asset is no longer available.';

	/// en: 'Edit'
	String get edit => 'Edit';

	/// en: 'Note'
	String get note => 'Note';
}

// Path: assets.sort
class Translations$assets$sort$en {
	Translations$assets$sort$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Sort by'
	String get title => 'Sort by';

	/// en: 'Date'
	String get date => 'Date';

	/// en: 'Value'
	String get value => 'Value';

	/// en: 'Type'
	String get type => 'Type';
}

// Path: assets.filter
class Translations$assets$filter$en {
	Translations$assets$filter$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'All'
	String get all => 'All';
}

// Path: assets.chart
class Translations$assets$chart$en {
	Translations$assets$chart$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Cash assets maintain a constant value'
	String get cashPlaceholder => 'Cash assets maintain a constant value';

	/// en: 'Not enough price history yet'
	String get noDataTitle => 'Not enough price history yet';

	/// en: 'Historical prices will appear here once market data is available.'
	String get noDataSubtitle => 'Historical prices will appear here once market data is available.';
}

// Path: assets.history
class Translations$assets$history$en {
	Translations$assets$history$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Created'
	String get created => 'Created';

	/// en: 'Updated'
	String get updated => 'Updated';

	/// en: 'Deleted'
	String get deleted => 'Deleted';
}

// Path: assets.delete
class Translations$assets$delete$en {
	Translations$assets$delete$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Delete Asset?'
	String get confirmTitle => 'Delete Asset?';

	/// en: 'This will permanently delete this asset record.'
	String get confirmBody => 'This will permanently delete this asset record.';
}

// Path: assets.failure
class Translations$assets$failure$en {
	Translations$assets$failure$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: 'Asset not found.'
	String get assetNotFound => 'Asset not found.';

	/// en: 'Amount must be greater than zero.'
	String get invalidAmount => 'Amount must be greater than zero.';
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

// Path: marketPrices.range
class Translations$marketPrices$range$en {
	Translations$marketPrices$range$en.internal(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// en: '1W'
	String get oneWeek => '1W';

	/// en: '1M'
	String get oneMonth => '1M';

	/// en: '3M'
	String get threeMonths => '3M';
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
			'core.actions.cancel' => 'Cancel',
			'core.actions.delete' => 'Delete',
			'core.notification.channelName' => 'Price Alerts',
			'core.notification.channelDescription' => 'Notifications about price changes',
			'auth.welcome.headline' => 'Know what your money is really worth',
			'auth.welcome.subtext' => 'Track your savings against inflation and see your real purchasing power over time.',
			'auth.welcome.primaryCta' => 'Start Tracking Your Savings',
			'auth.welcome.guestDisclosure' => 'No account needed. You can create one later.',
			'auth.error.networkError' => 'No internet connection. Please check your network and try again.',
			'auth.error.tooManyRequests' => 'Too many attempts. Please wait a moment and try again.',
			'auth.error.unknownError' => 'Something went wrong. Please try again.',
			'auth.error.anonymousSignInDisabled' => 'Guest sign-in is currently unavailable. Please try again later.',
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
			'nav.home' => 'Home',
			'nav.assets' => 'Assets',
			'nav.marketPrices' => 'Market Prices',
			'nav.settings' => 'Settings',
			'appLock.tooManyAttempts' => 'Too many attempts. Try again later.',
			'appLock.noCredentials' => 'No device lock set up. Set up a screen lock in your device settings.',
			'appLock.unavailable' => 'Device authentication is not available on this device.',
			'assets.list.title' => 'Assets',
			'assets.list.tabEgp' => 'EGP Cash',
			'assets.list.tabUsd' => 'USD',
			'assets.list.tabGold21' => 'Gold 21K',
			'assets.list.tabGold24' => 'Gold 24K',
			'assets.list.sortFilter' => 'Sort & Filter',
			'assets.list.sortDateNewest' => 'Newest first',
			'assets.list.sortDateOldest' => 'Oldest first',
			'assets.list.sortValueHighest' => 'Highest value',
			'assets.list.sortValueLowest' => 'Lowest value',
			'assets.list.emptyNoAssets' => 'No assets yet',
			'assets.list.emptyNoAssetsSubtitle' => 'Add your first asset to start tracking',
			'assets.list.emptyNoFiltered' => 'No holdings of this type',
			'assets.list.emptyNoFilteredSubtitle' => 'Try a different filter',
			'assets.list.addFirst' => 'Add Asset',
			'assets.add.title' => 'Add Asset',
			'assets.add.selectType' => 'Select Asset Type',
			'assets.add.amount' => 'Amount',
			'assets.add.amountGrams' => 'Amount (grams)',
			'assets.add.amountEgp' => 'Amount (EGP)',
			'assets.add.amountUsd' => 'Amount (USD)',
			'assets.add.priceAtEntry' => 'Price at entry',
			'assets.add.pricePerGram' => 'Price per gram at entry',
			'assets.add.pricePerUnit' => 'Price per unit at entry',
			'assets.add.entryDate' => 'Entry Date',
			'assets.add.selectDate' => 'Select date',
			'assets.add.note' => 'Note (optional)',
			'assets.add.noteHint' => 'Add a note...',
			'assets.add.submit' => 'Add Asset',
			'assets.add.amountRequired' => 'Amount is required',
			'assets.add.amountInvalid' => 'Enter a valid positive amount',
			'assets.add.priceRequired' => 'Price is required',
			'assets.add.priceInvalid' => 'Enter a valid positive price',
			'assets.add.selectTypeFirst' => 'Select an asset type first',
			'assets.edit.title' => 'Edit {type}',
			'assets.edit.submit' => 'Save Changes',
			'assets.edit.assetTypeLabel' => 'Asset Type',
			'assets.detail.entryPrice' => 'Entry: {price} EGP per unit',
			'assets.detail.valueTrend' => 'Value Trend',
			'assets.detail.editHistory' => 'Edit History',
			'assets.detail.noHistory' => 'No edit history yet',
			'assets.detail.cashFlatValue' => 'Cash assets maintain a constant value',
			'assets.detail.notFoundTitle' => 'Asset not found',
			'assets.detail.notFoundBody' => 'This asset is no longer available.',
			'assets.detail.edit' => 'Edit',
			'assets.detail.note' => 'Note',
			'assets.sort.title' => 'Sort by',
			'assets.sort.date' => 'Date',
			'assets.sort.value' => 'Value',
			'assets.sort.type' => 'Type',
			'assets.filter.all' => 'All',
			'assets.chart.cashPlaceholder' => 'Cash assets maintain a constant value',
			'assets.chart.noDataTitle' => 'Not enough price history yet',
			'assets.chart.noDataSubtitle' => 'Historical prices will appear here once market data is available.',
			'assets.history.created' => 'Created',
			'assets.history.updated' => 'Updated',
			'assets.history.deleted' => 'Deleted',
			'assets.delete.confirmTitle' => 'Delete Asset?',
			'assets.delete.confirmBody' => 'This will permanently delete this asset record.',
			'assets.failure.assetNotFound' => 'Asset not found.',
			'assets.failure.invalidAmount' => 'Amount must be greater than zero.',
			'settings.title' => 'Settings',
			'settings.securitySection' => 'Security',
			'settings.preferencesSection' => 'Preferences',
			'settings.aboutSection' => 'About',
			'settings.dangerZoneSection' => 'Danger Zone',
			'settings.requireUnlock' => 'Require device unlock to open Qeema',
			'settings.noDeviceLock' => 'Your device doesn\'t have a screen lock set up. Set one up in your device settings to use this feature.',
			'settings.authCancelled' => 'Authentication was cancelled.',
			'settings.language' => 'Language',
			'settings.languageSheetTitle' => 'Choose Language',
			'settings.languageEnglish' => 'English',
			'settings.languageArabic' => 'العربية',
			'settings.theme' => 'Theme',
			'settings.themeSheetTitle' => 'Choose Theme',
			'settings.themeLight' => 'Light',
			'settings.themeDark' => 'Dark',
			'settings.themeSystem' => 'System',
			'settings.appVersion' => 'App Version',
			'settings.dataMethodology' => 'Data & Methodology',
			'settings.dataMethodologyNote' => 'Prices are based on international spot rates and official exchange rates — local market or goldsmith prices may differ. Inflation figures are manually curated from CAPMAS and CBE data. Qeema is a portfolio and demo project: the figures are for tracking and awareness, not financial advice.',
			'settings.deleteAccount' => 'Delete Account',
			'settings.deleteDialogTitle' => 'Delete Account?',
			'settings.deleteDialogBody' => 'This permanently erases all of your assets, history, and this account. There is no recovery — and since Qeema uses anonymous sign-in, there is no email or password to log back in with if you change your mind. Type DELETE to confirm.',
			'settings.deleteConfirmHint' => 'Type DELETE to confirm',
			'settings.deleteForever' => 'Delete Forever',
			'settings.deleteFailed' => 'Could not delete your account. Please try again.',
			'settings.deletePartialFailure' => 'Your data was deleted but your account could not be fully removed. Please try again or contact support.',
			'home.title' => 'Qeema',
			'home.totalSavingsNominal' => 'Total Savings',
			'home.totalSavingsReal' => 'Adjusted for Inflation',
			'home.erosionCaption' => 'of your money\'s value has eroded since you started',
			'home.trendSectionTitle' => 'Real Value — Last 30 Days',
			'home.priceMoveBanner' => 'Prices moved significantly today — check your assets.',
			'home.errorTitle' => 'Something went wrong',
			'home.retry' => 'Try Again',
			'home.notEnoughTrendData' => 'Not enough data yet',
			'insights.assetPerformance.title' => 'Best performing asset',
			'insights.assetPerformance.body' => 'Asset {id} leads your portfolio with a value of {value} EGP.',
			'insights.concentrationRisk.title' => 'High concentration risk',
			'insights.concentrationRisk.body' => 'Over 80% of your portfolio is in one asset type. Consider diversifying to reduce risk.',
			'insights.inflationLoss.title' => 'Inflation erosion detected',
			'insights.inflationLoss.body' => 'Your money has lost {erosion}% of its purchasing power since you started tracking.',
			'insights.goalFeasibility.title' => 'Savings goal check',
			'insights.goalFeasibility.body' => 'At the current pace of inflation, your savings goals may need to be revised upward to maintain their real value.',
			'marketPrices.title' => 'Market Prices',
			'marketPrices.dataSourceDisclosure' => 'Prices are based on international spot rates and official exchange rates — local market or goldsmith prices may differ.',
			'marketPrices.lastUpdated' => 'Updated {when}',
			'marketPrices.notEnoughHistory' => 'Not enough history yet',
			'marketPrices.showingAvailableData' => 'Showing available data ({days} days)',
			'marketPrices.emptyTitle' => 'No market prices yet',
			'marketPrices.emptyBody' => 'Market price data will appear here once it becomes available.',
			'marketPrices.range.oneWeek' => '1W',
			'marketPrices.range.oneMonth' => '1M',
			'marketPrices.range.threeMonths' => '3M',
			_ => null,
		};
	}
}
