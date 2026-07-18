///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:slang/generated.dart';
import 'strings.g.dart';

// Path: <root>
class TranslationsAr extends Translations with BaseTranslations<AppLocale, Translations> {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsAr({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ar,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		super.$meta.setFlatMapFunction($meta.getTranslation); // copy base translations to super.$meta
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ar>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key) ?? super.$meta.getTranslation(key);

	late final TranslationsAr _root = this; // ignore: unused_field

	@override 
	TranslationsAr $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsAr(meta: meta ?? this.$meta);

	// Translations
	@override late final _Translations$app$ar app = _Translations$app$ar._(_root);
	@override late final _Translations$core$ar core = _Translations$core$ar._(_root);
	@override late final _Translations$auth$ar auth = _Translations$auth$ar._(_root);
	@override late final _Translations$onboarding$ar onboarding = _Translations$onboarding$ar._(_root);
	@override late final _Translations$navigation$ar navigation = _Translations$navigation$ar._(_root);
	@override late final _Translations$insights$ar insights = _Translations$insights$ar._(_root);
}

// Path: app
class _Translations$app$ar extends Translations$app$en {
	_Translations$app$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get name => 'قيّمة';
	@override String get tagline => 'قيمة';
}

// Path: core
class _Translations$core$ar extends Translations$core$en {
	_Translations$core$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override late final _Translations$core$error$ar error = _Translations$core$error$ar._(_root);
	@override late final _Translations$core$failure$ar failure = _Translations$core$failure$ar._(_root);
	@override late final _Translations$core$empty$ar empty = _Translations$core$empty$ar._(_root);
	@override late final _Translations$core$loading$ar loading = _Translations$core$loading$ar._(_root);
	@override late final _Translations$core$search$ar search = _Translations$core$search$ar._(_root);
	@override late final _Translations$core$validation$ar validation = _Translations$core$validation$ar._(_root);
	@override late final _Translations$core$dates$ar dates = _Translations$core$dates$ar._(_root);
	@override late final _Translations$core$auth$ar auth = _Translations$core$auth$ar._(_root);
	@override late final _Translations$core$notification$ar notification = _Translations$core$notification$ar._(_root);
}

// Path: auth
class _Translations$auth$ar extends Translations$auth$en {
	_Translations$auth$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get login => 'تسجيل الدخول';
	@override String get signUp => 'إنشاء حساب';
	@override String get forgotPassword => 'نسيت كلمة المرور';
	@override String get logout => 'تسجيل الخروج';
	@override String get email => 'البريد الإلكتروني';
	@override String get password => 'كلمة المرور';
}

// Path: onboarding
class _Translations$onboarding$ar extends Translations$onboarding$en {
	_Translations$onboarding$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get skip => 'تخطي';
	@override String get next => 'التالي';
	@override String get getStarted => 'ابدأ الآن';
	@override String get slide1Headline => 'أموالك لها رقم.\nهل لا تزال لها نفس القيمة؟';
	@override String get slide1Body => 'الفجوة بين ما تملكه وما يساويه تتسع كل يوم. شاهدها تحدث لأموالك الخاصة.';
	@override String get slide2Headline => 'تتبع ما تملكه فعلاً';
	@override String get slide2Body => 'نقداً، دولاراً، ذهباً — سجّل في ثوانٍ واطّلع عليه دائماً. اعرف أين أموالك بنظرة واحدة.';
	@override String get slide3Headline => 'شاهد التضخم يحدث،\nلا تسمع عنه فقط';
	@override String get slide3Body => 'راقب كيف تتحرك قيمتك الحقيقية مقابل الرقم الاسمي عبر الوقت — بشكل شخصي، ليس نظرياً.';
	@override String get slide4Headline => 'لنرَ أين تقف';
	@override String get slide4Body => 'لا رابط بنكي، ولا تحويلات — فقط وضوح حول القيمة الحقيقية لمدخراتك.';
	@override late final _Translations$onboarding$assetType$ar assetType = _Translations$onboarding$assetType$ar._(_root);
}

// Path: navigation
class _Translations$navigation$ar extends Translations$navigation$en {
	_Translations$navigation$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get splash => 'شاشة البداية';
	@override String get welcome => 'مرحباً';
	@override String get home => 'الرئيسية';
	@override String get assets => 'الأصول';
	@override String get insights => 'التوصيات';
	@override String get goals => 'الأهداف';
	@override String get marketPrices => 'أسعار السوق';
	@override String get notifications => 'الإشعارات';
	@override String get profile => 'الملف الشخصي';
	@override String get settings => 'الإعدادات';
	@override String get biometricSetup => 'إعداد التحقق البيومتري';
	@override String get addAsset => 'إضافة أصل';
	@override String get assetDetail => 'الأصل {id}';
	@override String get editAsset => 'تعديل الأصل {id}';
	@override String get addGoal => 'إضافة هدف';
	@override String get goalDetail => 'الهدف {id}';
	@override String get notificationSettings => 'إعدادات الإشعارات';
}

// Path: insights
class _Translations$insights$ar extends Translations$insights$en {
	_Translations$insights$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override late final _Translations$insights$assetPerformance$ar assetPerformance = _Translations$insights$assetPerformance$ar._(_root);
	@override late final _Translations$insights$concentrationRisk$ar concentrationRisk = _Translations$insights$concentrationRisk$ar._(_root);
	@override late final _Translations$insights$inflationLoss$ar inflationLoss = _Translations$insights$inflationLoss$ar._(_root);
	@override late final _Translations$insights$goalFeasibility$ar goalFeasibility = _Translations$insights$goalFeasibility$ar._(_root);
}

// Path: core.error
class _Translations$core$error$ar extends Translations$core$error$en {
	_Translations$core$error$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'حدث خطأ ما';
	@override String get body => 'حدث خطأ ما من جانبنا.';
	@override String get tryAgain => 'حاول مرة أخرى';
	@override String get serverError => 'خطأ في الخادم';
	@override String get cacheError => 'خطأ في التخزين المؤقت';
	@override String get authError => 'خطأ في المصادقة';
	@override String get syncFailed => 'فشلت المزامنة';
	@override String get connectionTimeout => 'انتهت مهلة الاتصال';
	@override String get serverNotResponding => 'الخادم لم يستجب';
	@override String get couldNotConnect => 'تعذر الاتصال بالخادم';
	@override String get requestFailed => 'فشل الطلب';
}

// Path: core.failure
class _Translations$core$failure$ar extends Translations$core$failure$en {
	_Translations$core$failure$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get networkFailure => 'لا يوجد اتصال بالإنترنت.';
	@override String get cacheFailure => 'تعذر قراءة البيانات المحلية.';
	@override String get unknownFailure => 'حدث خطأ غير متوقع.';
	@override String get priceFetchFailure => 'تعذر جلب السعر لـ {assetTypeCode}';
	@override String get inflationDataMissing => 'بيانات التضخم مفقودة لـ {count} شهر';
	@override String get calculationFailed => 'فشل الحساب: {reason}';
}

// Path: core.empty
class _Translations$core$empty$ar extends Translations$core$empty$en {
	_Translations$core$empty$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'لا توجد بيانات بعد';
	@override String get body => 'لا يوجد شيء هنا بعد.';
}

// Path: core.loading
class _Translations$core$loading$ar extends Translations$core$loading$en {
	_Translations$core$loading$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get message => 'جارٍ التحميل...';
}

// Path: core.search
class _Translations$core$search$ar extends Translations$core$search$en {
	_Translations$core$search$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get hint => 'بحث...';
	@override String get noResults => 'لم يتم العثور على نتائج.';
}

// Path: core.validation
class _Translations$core$validation$ar extends Translations$core$validation$en {
	_Translations$core$validation$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get emailRequired => 'البريد الإلكتروني مطلوب';
	@override String get emailInvalid => 'أدخل عنوان بريد إلكتروني صالح';
	@override String get passwordRequired => 'كلمة المرور مطلوبة';
	@override String get passwordMinLength => 'يجب أن تكون كلمة المرور 8 أحرف على الأقل';
	@override String get amountRequired => 'المبلغ مطلوب';
	@override String get amountInvalid => 'أدخل مبلغاً إيجابياً صالحاً';
}

// Path: core.dates
class _Translations$core$dates$ar extends Translations$core$dates$en {
	_Translations$core$dates$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get justNow => 'الآن';
	@override String get minutesAgo => 'منذ {minutes} دقيقة';
	@override String get hoursAgo => 'منذ {hours} ساعة';
	@override String get daysAgo => 'منذ {days} يوم';
}

// Path: core.auth
class _Translations$core$auth$ar extends Translations$core$auth$en {
	_Translations$core$auth$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get unlockReason => 'افتح قيّمة لعرض أموالك';
	@override String get biometricFailed => 'فشل التحقق البيومتري';
}

// Path: core.notification
class _Translations$core$notification$ar extends Translations$core$notification$en {
	_Translations$core$notification$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get channelName => 'تنبيهات الأسعار';
	@override String get channelDescription => 'إشعارات حول تغيرات الأسعار';
}

// Path: onboarding.assetType
class _Translations$onboarding$assetType$ar extends Translations$onboarding$assetType$en {
	_Translations$onboarding$assetType$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get egp => 'جنيه';
	@override String get usd => 'دولار';
	@override String get gold => 'ذهب';
}

// Path: insights.assetPerformance
class _Translations$insights$assetPerformance$ar extends Translations$insights$assetPerformance$en {
	_Translations$insights$assetPerformance$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'أفضل أصل أداءً';
	@override String get body => 'الأصل {id} يتصدر محفظتك بقيمة {value} جنيه.';
}

// Path: insights.concentrationRisk
class _Translations$insights$concentrationRisk$ar extends Translations$insights$concentrationRisk$en {
	_Translations$insights$concentrationRisk$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'مخاطر التركيز العالي';
	@override String get body => 'أكثر من 80% من محفظتك في نوع أصل واحد. فكّر في التنويع لتقليل المخاطر.';
}

// Path: insights.inflationLoss
class _Translations$insights$inflationLoss$ar extends Translations$insights$inflationLoss$en {
	_Translations$insights$inflationLoss$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'تم اكتشاف تآكل تضخمي';
	@override String get body => 'فقدت أموالك {erosion}% من قوتها الشرائية منذ أن بدأت التتبع.';
}

// Path: insights.goalFeasibility
class _Translations$insights$goalFeasibility$ar extends Translations$insights$goalFeasibility$en {
	_Translations$insights$goalFeasibility$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'فحص هدف الادخار';
	@override String get body => 'بالمعدل الحالي للتضخم، قد تحتاج أهداف الادخار الخاصة بك إلى المراجعة upward للحفاظ على قيمتها الحقيقية.';
}

/// The flat map containing all translations for locale <ar>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsAr {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'app.name' => 'قيّمة',
			'app.tagline' => 'قيمة',
			'core.error.title' => 'حدث خطأ ما',
			'core.error.body' => 'حدث خطأ ما من جانبنا.',
			'core.error.tryAgain' => 'حاول مرة أخرى',
			'core.error.serverError' => 'خطأ في الخادم',
			'core.error.cacheError' => 'خطأ في التخزين المؤقت',
			'core.error.authError' => 'خطأ في المصادقة',
			'core.error.syncFailed' => 'فشلت المزامنة',
			'core.error.connectionTimeout' => 'انتهت مهلة الاتصال',
			'core.error.serverNotResponding' => 'الخادم لم يستجب',
			'core.error.couldNotConnect' => 'تعذر الاتصال بالخادم',
			'core.error.requestFailed' => 'فشل الطلب',
			'core.failure.networkFailure' => 'لا يوجد اتصال بالإنترنت.',
			'core.failure.cacheFailure' => 'تعذر قراءة البيانات المحلية.',
			'core.failure.unknownFailure' => 'حدث خطأ غير متوقع.',
			'core.failure.priceFetchFailure' => 'تعذر جلب السعر لـ {assetTypeCode}',
			'core.failure.inflationDataMissing' => 'بيانات التضخم مفقودة لـ {count} شهر',
			'core.failure.calculationFailed' => 'فشل الحساب: {reason}',
			'core.empty.title' => 'لا توجد بيانات بعد',
			'core.empty.body' => 'لا يوجد شيء هنا بعد.',
			'core.loading.message' => 'جارٍ التحميل...',
			'core.search.hint' => 'بحث...',
			'core.search.noResults' => 'لم يتم العثور على نتائج.',
			'core.validation.emailRequired' => 'البريد الإلكتروني مطلوب',
			'core.validation.emailInvalid' => 'أدخل عنوان بريد إلكتروني صالح',
			'core.validation.passwordRequired' => 'كلمة المرور مطلوبة',
			'core.validation.passwordMinLength' => 'يجب أن تكون كلمة المرور 8 أحرف على الأقل',
			'core.validation.amountRequired' => 'المبلغ مطلوب',
			'core.validation.amountInvalid' => 'أدخل مبلغاً إيجابياً صالحاً',
			'core.dates.justNow' => 'الآن',
			'core.dates.minutesAgo' => 'منذ {minutes} دقيقة',
			'core.dates.hoursAgo' => 'منذ {hours} ساعة',
			'core.dates.daysAgo' => 'منذ {days} يوم',
			'core.auth.unlockReason' => 'افتح قيّمة لعرض أموالك',
			'core.auth.biometricFailed' => 'فشل التحقق البيومتري',
			'core.notification.channelName' => 'تنبيهات الأسعار',
			'core.notification.channelDescription' => 'إشعارات حول تغيرات الأسعار',
			'auth.login' => 'تسجيل الدخول',
			'auth.signUp' => 'إنشاء حساب',
			'auth.forgotPassword' => 'نسيت كلمة المرور',
			'auth.logout' => 'تسجيل الخروج',
			'auth.email' => 'البريد الإلكتروني',
			'auth.password' => 'كلمة المرور',
			'onboarding.skip' => 'تخطي',
			'onboarding.next' => 'التالي',
			'onboarding.getStarted' => 'ابدأ الآن',
			'onboarding.slide1Headline' => 'أموالك لها رقم.\nهل لا تزال لها نفس القيمة؟',
			'onboarding.slide1Body' => 'الفجوة بين ما تملكه وما يساويه تتسع كل يوم. شاهدها تحدث لأموالك الخاصة.',
			'onboarding.slide2Headline' => 'تتبع ما تملكه فعلاً',
			'onboarding.slide2Body' => 'نقداً، دولاراً، ذهباً — سجّل في ثوانٍ واطّلع عليه دائماً. اعرف أين أموالك بنظرة واحدة.',
			'onboarding.slide3Headline' => 'شاهد التضخم يحدث،\nلا تسمع عنه فقط',
			'onboarding.slide3Body' => 'راقب كيف تتحرك قيمتك الحقيقية مقابل الرقم الاسمي عبر الوقت — بشكل شخصي، ليس نظرياً.',
			'onboarding.slide4Headline' => 'لنرَ أين تقف',
			'onboarding.slide4Body' => 'لا رابط بنكي، ولا تحويلات — فقط وضوح حول القيمة الحقيقية لمدخراتك.',
			'onboarding.assetType.egp' => 'جنيه',
			'onboarding.assetType.usd' => 'دولار',
			'onboarding.assetType.gold' => 'ذهب',
			'navigation.splash' => 'شاشة البداية',
			'navigation.welcome' => 'مرحباً',
			'navigation.home' => 'الرئيسية',
			'navigation.assets' => 'الأصول',
			'navigation.insights' => 'التوصيات',
			'navigation.goals' => 'الأهداف',
			'navigation.marketPrices' => 'أسعار السوق',
			'navigation.notifications' => 'الإشعارات',
			'navigation.profile' => 'الملف الشخصي',
			'navigation.settings' => 'الإعدادات',
			'navigation.biometricSetup' => 'إعداد التحقق البيومتري',
			'navigation.addAsset' => 'إضافة أصل',
			'navigation.assetDetail' => 'الأصل {id}',
			'navigation.editAsset' => 'تعديل الأصل {id}',
			'navigation.addGoal' => 'إضافة هدف',
			'navigation.goalDetail' => 'الهدف {id}',
			'navigation.notificationSettings' => 'إعدادات الإشعارات',
			'insights.assetPerformance.title' => 'أفضل أصل أداءً',
			'insights.assetPerformance.body' => 'الأصل {id} يتصدر محفظتك بقيمة {value} جنيه.',
			'insights.concentrationRisk.title' => 'مخاطر التركيز العالي',
			'insights.concentrationRisk.body' => 'أكثر من 80% من محفظتك في نوع أصل واحد. فكّر في التنويع لتقليل المخاطر.',
			'insights.inflationLoss.title' => 'تم اكتشاف تآكل تضخمي',
			'insights.inflationLoss.body' => 'فقدت أموالك {erosion}% من قوتها الشرائية منذ أن بدأت التتبع.',
			'insights.goalFeasibility.title' => 'فحص هدف الادخار',
			'insights.goalFeasibility.body' => 'بالمعدل الحالي للتضخم، قد تحتاج أهداف الادخار الخاصة بك إلى المراجعة upward للحفاظ على قيمتها الحقيقية.',
			_ => null,
		};
	}
}
