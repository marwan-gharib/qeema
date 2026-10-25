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
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ar,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ),
		  super(cardinalResolver: cardinalResolver, ordinalResolver: ordinalResolver) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ar>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	@override dynamic operator[](String key) => _meta.getTranslation(key) ?? super[key];

	late final TranslationsAr _root = this; // ignore: unused_field

	@override 
	TranslationsAr $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsAr(meta: meta ?? this.$meta);

	// Translations
	@override late final _Translations$app$ar app = _Translations$app$ar._(_root);
	@override late final _Translations$core$ar core = _Translations$core$ar._(_root);
	@override late final _Translations$auth$ar auth = _Translations$auth$ar._(_root);
	@override late final _Translations$onboarding$ar onboarding = _Translations$onboarding$ar._(_root);
	@override late final _Translations$navigation$ar navigation = _Translations$navigation$ar._(_root);
	@override late final _Translations$nav$ar nav = _Translations$nav$ar._(_root);
	@override late final _Translations$assets$ar assets = _Translations$assets$ar._(_root);
	@override late final _Translations$settings$ar settings = _Translations$settings$ar._(_root);
	@override late final _Translations$home$ar home = _Translations$home$ar._(_root);
	@override late final _Translations$insights$ar insights = _Translations$insights$ar._(_root);
	@override late final _Translations$marketPrices$ar marketPrices = _Translations$marketPrices$ar._(_root);
	@override late final _Translations$charts$ar charts = _Translations$charts$ar._(_root);
	@override late final _Translations$app_lock$ar app_lock = _Translations$app_lock$ar._(_root);
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
	@override late final _Translations$core$currency$ar currency = _Translations$core$currency$ar._(_root);
	@override late final _Translations$core$unit$ar unit = _Translations$core$unit$ar._(_root);
	@override late final _Translations$core$value$ar value = _Translations$core$value$ar._(_root);
	@override String get listSeparator => '؛ ';
	@override late final _Translations$core$actions$ar actions = _Translations$core$actions$ar._(_root);
	@override late final _Translations$core$notification$ar notification = _Translations$core$notification$ar._(_root);
}

// Path: auth
class _Translations$auth$ar extends Translations$auth$en {
	_Translations$auth$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override late final _Translations$auth$welcome$ar welcome = _Translations$auth$welcome$ar._(_root);
	@override late final _Translations$auth$error$ar error = _Translations$auth$error$ar._(_root);
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
	@override String get addAsset => 'إضافة أصل';
	@override String assetDetail({required Object id}) => 'الأصل ${id}';
	@override String editAsset({required Object id}) => 'تعديل الأصل ${id}';
	@override String get addGoal => 'إضافة هدف';
	@override String goalDetail({required Object id}) => 'الهدف ${id}';
	@override String get notificationSettings => 'إعدادات الإشعارات';
}

// Path: nav
class _Translations$nav$ar extends Translations$nav$en {
	_Translations$nav$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get home => 'الرئيسية';
	@override String get assets => 'الأصول';
	@override String get marketPrices => 'أسعار السوق';
	@override String get settings => 'الإعدادات';
}

// Path: assets
class _Translations$assets$ar extends Translations$assets$en {
	_Translations$assets$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override late final _Translations$assets$list$ar list = _Translations$assets$list$ar._(_root);
	@override late final _Translations$assets$add$ar add = _Translations$assets$add$ar._(_root);
	@override late final _Translations$assets$edit$ar edit = _Translations$assets$edit$ar._(_root);
	@override late final _Translations$assets$detail$ar detail = _Translations$assets$detail$ar._(_root);
	@override late final _Translations$assets$sort$ar sort = _Translations$assets$sort$ar._(_root);
	@override late final _Translations$assets$filter$ar filter = _Translations$assets$filter$ar._(_root);
	@override late final _Translations$assets$carat$ar carat = _Translations$assets$carat$ar._(_root);
	@override late final _Translations$assets$chart$ar chart = _Translations$assets$chart$ar._(_root);
	@override late final _Translations$assets$history$ar history = _Translations$assets$history$ar._(_root);
	@override late final _Translations$assets$delete$ar delete = _Translations$assets$delete$ar._(_root);
	@override late final _Translations$assets$failure$ar failure = _Translations$assets$failure$ar._(_root);
}

// Path: settings
class _Translations$settings$ar extends Translations$settings$en {
	_Translations$settings$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'الإعدادات';
	@override late final _Translations$settings$profile$ar profile = _Translations$settings$profile$ar._(_root);
	@override String get securitySection => 'الأمان';
	@override String get preferencesSection => 'التفضيلات';
	@override String get aboutSection => 'حول';
	@override String get dangerZoneSection => 'منطقة الخطر';
	@override String get language => 'اللغة';
	@override String get languageSheetTitle => 'اختر اللغة';
	@override String get languageEnglish => 'English';
	@override String get languageArabic => 'العربية';
	@override String get theme => 'المظهر';
	@override String get themeSheetTitle => 'اختر المظهر';
	@override String get themeLight => 'فاتح';
	@override String get themeDark => 'داكن';
	@override String get themeSystem => 'النظام';
	@override String get appVersion => 'إصدار التطبيق';
	@override String get dataMethodology => 'البيانات والمنهجية';
	@override String get dataMethodologyNote => 'الأسعار مبنية على أسعار الصرف الرسمية والأسعار العالمية الفورية — وقد تختلف عن أسعار السوق المحلي أو تجار الذهب. أرقام التضخم مُجمَّعة يدوياً من بيانات الجهاز المركزي للتعبئة العامة والإحصاء والبنك المركزي المصري. قيّمة مشروع تجريبي للتعريف بالمنتج: الأرقام للتوضيح والتوعية وليست نصيحة مالية.';
	@override String get deleteAccount => 'حذف الحساب';
	@override String get deleteDialogTitle => 'حذف الحساب؟';
	@override String get deleteDialogBody => 'سيؤدي هذا إلى محو جميع أصولك وسجلّك وحسابك نهائياً. لا يوجد أي استرداد — وبما أن قيّمة تستخدم الدخول المجهول، لا يوجد بريد إلكتروني أو كلمة مرور للعودة إذا غيّرت رأيك. اكتب DELETE للتأكيد.';
	@override String get deleteConfirmHint => 'اكتب DELETE للتأكيد';
	@override String get deleteForever => 'حذف نهائياً';
	@override String get deleteFailed => 'تعذر حذف حسابك. يرجى المحاولة مرة أخرى.';
	@override String get deletePartialFailure => 'تم حذف بياناتك لكن تعذر إزالة الحساب بالكامل. يرجى المحاولة مرة أخرى أو التواصل مع الدعم.';
	@override String get logout => 'تسجيل الخروج';
	@override String get logoutDialogTitle => 'تسجيل الخروج؟';
	@override String get logoutDialogBody => 'سيتم تسجيل خروجك من قيّمة. بياناتك تبقى في حسابك — سجّل الدخول مرة أخرى في أي وقت لتكمل من حيث توقفت.';
	@override String get logoutGuestDialogBody => 'أنت تستخدم التطبيق كضيف. تسجيل الخروج يحذف هذا الحساب وجميع بياناته نهائياً. لا يوجد أي استرداد — وبما أن قيّمة تستخدم الدخول المجهول، لا يوجد بريد إلكتروني أو كلمة مرور للعودة إذا غيّرت رأيك.';
	@override String get logoutConfirm => 'تسجيل الخروج';
	@override String get logoutDeleteConfirm => 'حذف وتسجيل الخروج';
	@override String get logoutFailed => 'تعذر تسجيل الخروج. يرجى المحاولة مرة أخرى.';
}

// Path: home
class _Translations$home$ar extends Translations$home$en {
	_Translations$home$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'قيّمة';
	@override String get totalSavingsNominal => 'إجمالي المدخرات';
	@override String get totalSavingsReal => 'بعد تعديل التضخم';
	@override String get erosionCaption => 'من قيمة أموالك تآكلت منذ أن بدأت';
	@override String get trendSectionTitle => 'القيمة الحقيقية — آخر 30 يوماً';
	@override String get priceMoveBanner => 'تحركت الأسعار بشكل ملحوظ اليوم — تحقق من أصولك.';
	@override String get errorTitle => 'حدث خطأ ما';
	@override String get retry => 'حاول مرة أخرى';
	@override String get notEnoughTrendData => 'لا توجد بيانات كافية بعد';
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

// Path: marketPrices
class _Translations$marketPrices$ar extends Translations$marketPrices$en {
	_Translations$marketPrices$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'أسعار السوق';
	@override String get dataSourceDisclosure => 'الأسعار مبنية على أسعار الصرف الرسمية والأسعار العالمية الفورية — وقد تختلف عن أسعار السوق المحلي أو تجار الذهب.';
	@override String lastUpdated({required Object when}) => 'آخر تحديث ${when}';
	@override String get notEnoughHistory => 'لا يوجد تاريخ كافٍ بعد';
	@override String showingAvailableData({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ar'))(n,
		zero: 'عرض البيانات المتاحة (${n} يوم)',
		one: 'عرض البيانات المتاحة (يوم واحد)',
		two: 'عرض البيانات المتاحة (يومين)',
		few: 'عرض البيانات المتاحة (${n} أيام)',
		many: 'عرض البيانات المتاحة (${n} يوماً)',
		other: 'عرض البيانات المتاحة (${n} يوم)',
	);
	@override String get emptyTitle => 'لا توجد أسعار سوق بعد';
	@override String get emptyBody => 'ستظهر بيانات أسعار السوق هنا بمجرد توفرها.';
	@override late final _Translations$marketPrices$range$ar range = _Translations$marketPrices$range$ar._(_root);
}

// Path: charts
class _Translations$charts$ar extends Translations$charts$en {
	_Translations$charts$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override late final _Translations$charts$semantics$ar semantics = _Translations$charts$semantics$ar._(_root);
}

// Path: app_lock
class _Translations$app_lock$ar extends Translations$app_lock$en {
	_Translations$app_lock$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get promptReason => 'افتح قيّمة للمتابعة';
	@override String get disableReason => 'أكّد هويتك لإيقاف قفل التطبيق';
	@override String get title => 'قيّمة مقفلة';
	@override String get hint => 'استخدم بيانات اعتماد جهازك لفتح التطبيق';
	@override String get unlockButton => 'فتح';
	@override String get lockedOutMessage => 'محاولات كثيرة. أعد المحاولة بعد انتهاء المهلة.';
	@override String get unavailableMessage => 'تعذّر التحقق الآن. تحقق من قفل الجهاز ثم أعد المحاولة.';
	@override String get errorMessage => 'تعذّر التحقق من هويتك. حاول مرة أخرى.';
	@override String get cancelledMessage => 'تم إلغاء التحقق.';
	@override String get noCredentialsMessage => 'لا يوجد قفل شاشة على هذا الجهاز. ضع قفل شاشة لاستخدام قفل التطبيق.';
	@override String get settingsTitle => 'قفل التطبيق';
	@override String get settingsSubtitle => 'طلب فتح الجهاز عند فتح قيّمة';
	@override String get settingsNoDeviceLock => 'اضبط قفل شاشة (رمز أو نمط أو كلمة مرور) في إعدادات النظام لاستخدام قفل التطبيق';
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
	@override String priceFetchFailure({required Object assetTypeCode}) => 'تعذر جلب السعر لـ ${assetTypeCode}';
	@override String inflationDataMissing({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ar'))(n,
		zero: 'بيانات التضخم مفقودة لـ ${n} شهر.',
		one: 'بيانات التضخم مفقودة لشهر واحد.',
		two: 'بيانات التضخم مفقودة لشهرين.',
		few: 'بيانات التضخم مفقودة لـ ${n} أشهر.',
		many: 'بيانات التضخم مفقودة لـ ${n} شهراً.',
		other: 'بيانات التضخم مفقودة لـ ${n} شهراً.',
	);
	@override String get calculationFailed => 'تعذر حساب القيمة.';
	@override String get sessionExpired => 'انتهت صلاحية جلستك. سجّل الدخول مرة أخرى.';
	@override String get timeout => 'انتهت مهلة الطلب. حاول مرة أخرى.';
	@override String get forbidden => 'لا تملك صلاحية القيام بذلك.';
	@override String get notFound => 'تعذّر العثور على العنصر المطلوب.';
	@override String get validation => 'يرجى مراجعة القيم التي أدخلتها.';
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
	@override String minutesAgo({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ar'))(n,
		zero: 'منذ ${n} دقيقة',
		one: 'منذ دقيقة واحدة',
		two: 'منذ دقيقتين',
		few: 'منذ ${n} دقائق',
		many: 'منذ ${n} دقيقة',
		other: 'منذ ${n} دقيقة',
	);
	@override String hoursAgo({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ar'))(n,
		zero: 'منذ ${n} ساعة',
		one: 'منذ ساعة واحدة',
		two: 'منذ ساعتين',
		few: 'منذ ${n} ساعات',
		many: 'منذ ${n} ساعة',
		other: 'منذ ${n} ساعة',
	);
	@override String daysAgo({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ar'))(n,
		zero: 'منذ ${n} يوم',
		one: 'منذ يوم واحد',
		two: 'منذ يومين',
		few: 'منذ ${n} أيام',
		many: 'منذ ${n} يوماً',
		other: 'منذ ${n} يوم',
	);
}

// Path: core.currency
class _Translations$core$currency$ar extends Translations$core$currency$en {
	_Translations$core$currency$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get egp => 'جنيه مصري';
	@override String get usd => 'دولار أمريكي';
}

// Path: core.unit
class _Translations$core$unit$ar extends Translations$core$unit$en {
	_Translations$core$unit$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get gram => 'جرام';
}

// Path: core.value
class _Translations$core$value$ar extends Translations$core$value$en {
	_Translations$core$value$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get unavailable => '—';
}

// Path: core.actions
class _Translations$core$actions$ar extends Translations$core$actions$en {
	_Translations$core$actions$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get cancel => 'إلغاء';
	@override String get delete => 'حذف';
}

// Path: core.notification
class _Translations$core$notification$ar extends Translations$core$notification$en {
	_Translations$core$notification$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get channelName => 'تنبيهات الأسعار';
	@override String get channelDescription => 'إشعارات حول تغيرات الأسعار';
}

// Path: auth.welcome
class _Translations$auth$welcome$ar extends Translations$auth$welcome$en {
	_Translations$auth$welcome$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get headline => 'اعرف القيمة الحقيقية لأموالك';
	@override String get subtext => 'تتبع مدخراتك مقابل التضخم وشاهد قوتك الشرائية الحقيقية عبر الزمن.';
	@override String get continueAsGuestCta => 'متابعة كضيف';
	@override String get googleSignInCta => 'تسجيل الدخول باستخدام بجوجل';
	@override String get guestDisclosure => 'لا حاجة لحساب. يمكنك إنشاء واحد لاحقاً.';
}

// Path: auth.error
class _Translations$auth$error$ar extends Translations$auth$error$en {
	_Translations$auth$error$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get networkError => 'لا يوجد اتصال بالإنترنت. يرجى التحقق من شبكتك والمحاولة مرة أخرى.';
	@override String get tooManyRequests => 'محاولات كثيرة جداً. يرجى الانتظار لحظة والمحاولة مرة أخرى.';
	@override String get unknownError => 'حدث خطأ ما. يرجى المحاولة مرة أخرى.';
	@override String get anonymousSignInDisabled => 'دخول الزوار غير متاح حالياً. يرجى المحاولة لاحقاً.';
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

// Path: assets.list
class _Translations$assets$list$ar extends Translations$assets$list$en {
	_Translations$assets$list$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'الأصول';
	@override String get tabEgp => 'جنيه مصري';
	@override String get tabUsd => 'دولار أمريكي';
	@override String get tabGold21 => 'ذهب 21';
	@override String get tabGold24 => 'ذهب 24';
	@override String get sortFilter => 'ترتيب وتصفية';
	@override String get sortDateNewest => 'الأحدث أولاً';
	@override String get sortDateOldest => 'الأقدم أولاً';
	@override String get sortValueHighest => 'الأعلى قيمة';
	@override String get sortValueLowest => 'الأقل قيمة';
	@override String get emptyNoAssets => 'لا توجد أصول بعد';
	@override String get emptyNoAssetsSubtitle => 'أضف أصلَك الأول لبدء التتبع';
	@override String get emptyNoFiltered => 'لا توجد أصول من هذا النوع';
	@override String get emptyNoFilteredSubtitle => 'جرّب تصفية مختلفة';
	@override String get addFirst => 'إضافة أصل';
}

// Path: assets.add
class _Translations$assets$add$ar extends Translations$assets$add$en {
	_Translations$assets$add$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'إضافة أصل';
	@override String get selectType => 'اختر نوع الأصل';
	@override String get amount => 'الكمية';
	@override String get amountGrams => 'الكمية (جرام)';
	@override String get amountEgp => 'الكمية (جنيه مصري)';
	@override String get amountUsd => 'الكمية (دولار أمريكي)';
	@override String get priceAtEntry => 'سعر الشراء';
	@override String get pricePerGram => 'سعر الجرام عند الشراء';
	@override String get pricePerUnit => 'سعر الوحدة عند الشراء';
	@override String get entryDate => 'تاريخ الشراء';
	@override String get selectDate => 'اختر التاريخ';
	@override String get note => 'ملاحظة (اختياري)';
	@override String get noteHint => 'أضف ملاحظة...';
	@override String get submit => 'إضافة أصل';
	@override String get amountRequired => 'الكمية مطلوبة';
	@override String get amountInvalid => 'أدخل كمية موجبة صالحة';
	@override String get priceRequired => 'السعر مطلوب';
	@override String get priceInvalid => 'أدخل سعراً موجباً صالحاً';
	@override String get selectTypeFirst => 'اختر نوع الأصل أولاً';
}

// Path: assets.edit
class _Translations$assets$edit$ar extends Translations$assets$edit$en {
	_Translations$assets$edit$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String title({required Object type}) => 'تعديل ${type}';
	@override String get submit => 'حفظ التغييرات';
	@override String get assetTypeLabel => 'نوع الأصل';
}

// Path: assets.detail
class _Translations$assets$detail$ar extends Translations$assets$detail$en {
	_Translations$assets$detail$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String entryPrice({required Object price}) => 'سعر الشراء: ${price} جنيه للوحدة';
	@override String get valueTrend => 'اتجاه القيمة';
	@override String get editHistory => 'سجل التعديلات';
	@override String get noHistory => 'لا يوجد سجل تعديلات بعد';
	@override String get cashFlatValue => 'الأصول النقدية تحافظ على قيمة ثابتة';
	@override String get notFoundTitle => 'الأصل غير موجود';
	@override String get notFoundBody => 'هذا الأصل لم يعد متاحاً.';
	@override String get edit => 'تعديل';
	@override String get note => 'ملاحظة';
}

// Path: assets.sort
class _Translations$assets$sort$ar extends Translations$assets$sort$en {
	_Translations$assets$sort$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'ترتيب حسب';
	@override String get date => 'التاريخ';
	@override String get value => 'القيمة';
	@override String get type => 'النوع';
}

// Path: assets.filter
class _Translations$assets$filter$ar extends Translations$assets$filter$en {
	_Translations$assets$filter$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get all => 'الكل';
}

// Path: assets.carat
class _Translations$assets$carat$ar extends Translations$assets$carat$en {
	_Translations$assets$carat$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get k21 => '21K';
	@override String get k24 => '24K';
}

// Path: assets.chart
class _Translations$assets$chart$ar extends Translations$assets$chart$en {
	_Translations$assets$chart$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get cashPlaceholder => 'الأصول النقدية تحافظ على قيمة ثابتة';
	@override String get noDataTitle => 'لا يوجد تاريخ أسعار كافٍ بعد';
	@override String get noDataSubtitle => 'ستظهر الأسعار التاريخية هنا بمجرد توفر بيانات السوق.';
}

// Path: assets.history
class _Translations$assets$history$ar extends Translations$assets$history$en {
	_Translations$assets$history$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get created => 'تم الإنشاء';
	@override String get updated => 'تم التحديث';
	@override String get deleted => 'تم الحذف';
	@override String get assetAdded => 'تمت إضافة الأصل';
	@override String get assetDeleted => 'تم حذف الأصل';
	@override String get fieldAmount => 'الكمية';
	@override String get fieldEntryPrice => 'سعر الشراء';
	@override String get fieldEntryDate => 'تاريخ الشراء';
	@override String get fieldNote => 'ملاحظة';
	@override String get noteUpdated => 'تم تحديث الملاحظة';
	@override String get dateChanged => 'تم تغيير تاريخ الشراء';
	@override String fieldChanged({required Object field, required Object oldValue, required Object newValue}) => '${field}: ${oldValue} ← ${newValue}';
}

// Path: assets.delete
class _Translations$assets$delete$ar extends Translations$assets$delete$en {
	_Translations$assets$delete$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get confirmTitle => 'حذف الأصل؟';
	@override String get confirmBody => 'سيؤدي هذا إلى حذف سجل الأصل بشكل دائم.';
}

// Path: assets.failure
class _Translations$assets$failure$ar extends Translations$assets$failure$en {
	_Translations$assets$failure$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get assetNotFound => 'الأصل غير موجود.';
	@override String get invalidAmount => 'يجب أن تكون الكمية أكبر من الصفر.';
	@override String get priceRequiredMarket => 'السعر مطلوب للأصول المعتمدة على السوق.';
	@override String get addFailed => 'تعذّرت إضافة الأصل الآن. يرجى المحاولة مرة أخرى.';
	@override String get updateFailed => 'فشل التحديث.';
	@override String get deleteFailed => 'فشل الحذف.';
	@override String get historyLoadFailed => 'فشل تحميل السجل.';
	@override String get fetchFailed => 'تعذّر تحميل بياناتك الآن. يرجى المحاولة مرة أخرى.';
}

// Path: settings.profile
class _Translations$settings$profile$ar extends Translations$settings$profile$en {
	_Translations$settings$profile$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get guest => 'ضيف';
	@override String get signedInAsGuest => 'تم تسجيل الدخول كضيف';
	@override String get fallbackName => 'مستخدم';
	@override String semanticLabel({required Object name}) => 'تم تسجيل الدخول باسم ${name}';
}

// Path: insights.assetPerformance
class _Translations$insights$assetPerformance$ar extends Translations$insights$assetPerformance$en {
	_Translations$insights$assetPerformance$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'أفضل أصل أداءً';
	@override String body({required Object id, required Object value}) => 'الأصل ${id} يتصدر محفظتك بقيمة ${value} جنيه.';
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
	@override String body({required Object erosion}) => 'فقدت أموالك ${erosion}% من قوتها الشرائية منذ أن بدأت التتبع.';
}

// Path: insights.goalFeasibility
class _Translations$insights$goalFeasibility$ar extends Translations$insights$goalFeasibility$en {
	_Translations$insights$goalFeasibility$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'فحص هدف الادخار';
	@override String get body => 'بالمعدل الحالي للتضخم، قد تحتاج أهداف الادخار الخاصة بك إلى مراجعة بالزيادة للحفاظ على قيمتها الحقيقية.';
}

// Path: marketPrices.range
class _Translations$marketPrices$range$ar extends Translations$marketPrices$range$en {
	_Translations$marketPrices$range$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get oneWeek => 'أسبوع';
	@override String get oneMonth => 'شهر';
	@override String get threeMonths => '3 أشهر';
}

// Path: charts.semantics
class _Translations$charts$semantics$ar extends Translations$charts$semantics$en {
	_Translations$charts$semantics$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String summary({required num n, required Object title, required Object latest, required Object lowest, required Object highest}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ar'))(n,
		zero: '${title}، آخر ${n} يوم: الأحدث ${latest}، الأدنى ${lowest}، الأعلى ${highest}.',
		one: '${title}، لآخر يوم واحد: الأحدث ${latest}، الأدنى ${lowest}، الأعلى ${highest}.',
		two: '${title}، لآخر يومين: الأحدث ${latest}، الأدنى ${lowest}، الأعلى ${highest}.',
		few: '${title}، لآخر ${n} أيام: الأحدث ${latest}، الأدنى ${lowest}، الأعلى ${highest}.',
		many: '${title}، لآخر ${n} يوماً: الأحدث ${latest}، الأدنى ${lowest}، الأعلى ${highest}.',
		other: '${title}، لآخر ${n} يوم: الأحدث ${latest}، الأدنى ${lowest}، الأعلى ${highest}.',
	);
	@override String get realValue => 'القيمة الحقيقية للمحفظة';
	@override String get priceHistory => 'سجل السعر';
	@override String get recentPrices => 'الأسعار الأخيرة';
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
			'core.failure.priceFetchFailure' => ({required Object assetTypeCode}) => 'تعذر جلب السعر لـ ${assetTypeCode}',
			'core.failure.inflationDataMissing' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ar'))(n, zero: 'بيانات التضخم مفقودة لـ ${n} شهر.', one: 'بيانات التضخم مفقودة لشهر واحد.', two: 'بيانات التضخم مفقودة لشهرين.', few: 'بيانات التضخم مفقودة لـ ${n} أشهر.', many: 'بيانات التضخم مفقودة لـ ${n} شهراً.', other: 'بيانات التضخم مفقودة لـ ${n} شهراً.', ), 
			'core.failure.calculationFailed' => 'تعذر حساب القيمة.',
			'core.failure.sessionExpired' => 'انتهت صلاحية جلستك. سجّل الدخول مرة أخرى.',
			'core.failure.timeout' => 'انتهت مهلة الطلب. حاول مرة أخرى.',
			'core.failure.forbidden' => 'لا تملك صلاحية القيام بذلك.',
			'core.failure.notFound' => 'تعذّر العثور على العنصر المطلوب.',
			'core.failure.validation' => 'يرجى مراجعة القيم التي أدخلتها.',
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
			'core.dates.minutesAgo' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ar'))(n, zero: 'منذ ${n} دقيقة', one: 'منذ دقيقة واحدة', two: 'منذ دقيقتين', few: 'منذ ${n} دقائق', many: 'منذ ${n} دقيقة', other: 'منذ ${n} دقيقة', ), 
			'core.dates.hoursAgo' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ar'))(n, zero: 'منذ ${n} ساعة', one: 'منذ ساعة واحدة', two: 'منذ ساعتين', few: 'منذ ${n} ساعات', many: 'منذ ${n} ساعة', other: 'منذ ${n} ساعة', ), 
			'core.dates.daysAgo' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ar'))(n, zero: 'منذ ${n} يوم', one: 'منذ يوم واحد', two: 'منذ يومين', few: 'منذ ${n} أيام', many: 'منذ ${n} يوماً', other: 'منذ ${n} يوم', ), 
			'core.currency.egp' => 'جنيه مصري',
			'core.currency.usd' => 'دولار أمريكي',
			'core.unit.gram' => 'جرام',
			'core.value.unavailable' => '—',
			'core.listSeparator' => '؛ ',
			'core.actions.cancel' => 'إلغاء',
			'core.actions.delete' => 'حذف',
			'core.notification.channelName' => 'تنبيهات الأسعار',
			'core.notification.channelDescription' => 'إشعارات حول تغيرات الأسعار',
			'auth.welcome.headline' => 'اعرف القيمة الحقيقية لأموالك',
			'auth.welcome.subtext' => 'تتبع مدخراتك مقابل التضخم وشاهد قوتك الشرائية الحقيقية عبر الزمن.',
			'auth.welcome.continueAsGuestCta' => 'متابعة كضيف',
			'auth.welcome.googleSignInCta' => 'تسجيل الدخول باستخدام بجوجل',
			'auth.welcome.guestDisclosure' => 'لا حاجة لحساب. يمكنك إنشاء واحد لاحقاً.',
			'auth.error.networkError' => 'لا يوجد اتصال بالإنترنت. يرجى التحقق من شبكتك والمحاولة مرة أخرى.',
			'auth.error.tooManyRequests' => 'محاولات كثيرة جداً. يرجى الانتظار لحظة والمحاولة مرة أخرى.',
			'auth.error.unknownError' => 'حدث خطأ ما. يرجى المحاولة مرة أخرى.',
			'auth.error.anonymousSignInDisabled' => 'دخول الزوار غير متاح حالياً. يرجى المحاولة لاحقاً.',
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
			'navigation.addAsset' => 'إضافة أصل',
			'navigation.assetDetail' => ({required Object id}) => 'الأصل ${id}',
			'navigation.editAsset' => ({required Object id}) => 'تعديل الأصل ${id}',
			'navigation.addGoal' => 'إضافة هدف',
			'navigation.goalDetail' => ({required Object id}) => 'الهدف ${id}',
			'navigation.notificationSettings' => 'إعدادات الإشعارات',
			'nav.home' => 'الرئيسية',
			'nav.assets' => 'الأصول',
			'nav.marketPrices' => 'أسعار السوق',
			'nav.settings' => 'الإعدادات',
			'assets.list.title' => 'الأصول',
			'assets.list.tabEgp' => 'جنيه مصري',
			'assets.list.tabUsd' => 'دولار أمريكي',
			'assets.list.tabGold21' => 'ذهب 21',
			'assets.list.tabGold24' => 'ذهب 24',
			'assets.list.sortFilter' => 'ترتيب وتصفية',
			'assets.list.sortDateNewest' => 'الأحدث أولاً',
			'assets.list.sortDateOldest' => 'الأقدم أولاً',
			'assets.list.sortValueHighest' => 'الأعلى قيمة',
			'assets.list.sortValueLowest' => 'الأقل قيمة',
			'assets.list.emptyNoAssets' => 'لا توجد أصول بعد',
			'assets.list.emptyNoAssetsSubtitle' => 'أضف أصلَك الأول لبدء التتبع',
			'assets.list.emptyNoFiltered' => 'لا توجد أصول من هذا النوع',
			'assets.list.emptyNoFilteredSubtitle' => 'جرّب تصفية مختلفة',
			'assets.list.addFirst' => 'إضافة أصل',
			'assets.add.title' => 'إضافة أصل',
			'assets.add.selectType' => 'اختر نوع الأصل',
			'assets.add.amount' => 'الكمية',
			'assets.add.amountGrams' => 'الكمية (جرام)',
			'assets.add.amountEgp' => 'الكمية (جنيه مصري)',
			'assets.add.amountUsd' => 'الكمية (دولار أمريكي)',
			'assets.add.priceAtEntry' => 'سعر الشراء',
			'assets.add.pricePerGram' => 'سعر الجرام عند الشراء',
			'assets.add.pricePerUnit' => 'سعر الوحدة عند الشراء',
			'assets.add.entryDate' => 'تاريخ الشراء',
			'assets.add.selectDate' => 'اختر التاريخ',
			'assets.add.note' => 'ملاحظة (اختياري)',
			'assets.add.noteHint' => 'أضف ملاحظة...',
			'assets.add.submit' => 'إضافة أصل',
			'assets.add.amountRequired' => 'الكمية مطلوبة',
			'assets.add.amountInvalid' => 'أدخل كمية موجبة صالحة',
			'assets.add.priceRequired' => 'السعر مطلوب',
			'assets.add.priceInvalid' => 'أدخل سعراً موجباً صالحاً',
			'assets.add.selectTypeFirst' => 'اختر نوع الأصل أولاً',
			'assets.edit.title' => ({required Object type}) => 'تعديل ${type}',
			'assets.edit.submit' => 'حفظ التغييرات',
			'assets.edit.assetTypeLabel' => 'نوع الأصل',
			'assets.detail.entryPrice' => ({required Object price}) => 'سعر الشراء: ${price} جنيه للوحدة',
			'assets.detail.valueTrend' => 'اتجاه القيمة',
			'assets.detail.editHistory' => 'سجل التعديلات',
			'assets.detail.noHistory' => 'لا يوجد سجل تعديلات بعد',
			'assets.detail.cashFlatValue' => 'الأصول النقدية تحافظ على قيمة ثابتة',
			'assets.detail.notFoundTitle' => 'الأصل غير موجود',
			'assets.detail.notFoundBody' => 'هذا الأصل لم يعد متاحاً.',
			'assets.detail.edit' => 'تعديل',
			'assets.detail.note' => 'ملاحظة',
			'assets.sort.title' => 'ترتيب حسب',
			'assets.sort.date' => 'التاريخ',
			'assets.sort.value' => 'القيمة',
			'assets.sort.type' => 'النوع',
			'assets.filter.all' => 'الكل',
			'assets.carat.k21' => '21K',
			'assets.carat.k24' => '24K',
			'assets.chart.cashPlaceholder' => 'الأصول النقدية تحافظ على قيمة ثابتة',
			'assets.chart.noDataTitle' => 'لا يوجد تاريخ أسعار كافٍ بعد',
			'assets.chart.noDataSubtitle' => 'ستظهر الأسعار التاريخية هنا بمجرد توفر بيانات السوق.',
			'assets.history.created' => 'تم الإنشاء',
			'assets.history.updated' => 'تم التحديث',
			'assets.history.deleted' => 'تم الحذف',
			'assets.history.assetAdded' => 'تمت إضافة الأصل',
			'assets.history.assetDeleted' => 'تم حذف الأصل',
			'assets.history.fieldAmount' => 'الكمية',
			'assets.history.fieldEntryPrice' => 'سعر الشراء',
			'assets.history.fieldEntryDate' => 'تاريخ الشراء',
			'assets.history.fieldNote' => 'ملاحظة',
			'assets.history.noteUpdated' => 'تم تحديث الملاحظة',
			'assets.history.dateChanged' => 'تم تغيير تاريخ الشراء',
			'assets.history.fieldChanged' => ({required Object field, required Object oldValue, required Object newValue}) => '${field}: ${oldValue} ← ${newValue}',
			'assets.delete.confirmTitle' => 'حذف الأصل؟',
			'assets.delete.confirmBody' => 'سيؤدي هذا إلى حذف سجل الأصل بشكل دائم.',
			'assets.failure.assetNotFound' => 'الأصل غير موجود.',
			'assets.failure.invalidAmount' => 'يجب أن تكون الكمية أكبر من الصفر.',
			'assets.failure.priceRequiredMarket' => 'السعر مطلوب للأصول المعتمدة على السوق.',
			'assets.failure.addFailed' => 'تعذّرت إضافة الأصل الآن. يرجى المحاولة مرة أخرى.',
			'assets.failure.updateFailed' => 'فشل التحديث.',
			'assets.failure.deleteFailed' => 'فشل الحذف.',
			'assets.failure.historyLoadFailed' => 'فشل تحميل السجل.',
			'assets.failure.fetchFailed' => 'تعذّر تحميل بياناتك الآن. يرجى المحاولة مرة أخرى.',
			'settings.title' => 'الإعدادات',
			'settings.profile.guest' => 'ضيف',
			'settings.profile.signedInAsGuest' => 'تم تسجيل الدخول كضيف',
			'settings.profile.fallbackName' => 'مستخدم',
			'settings.profile.semanticLabel' => ({required Object name}) => 'تم تسجيل الدخول باسم ${name}',
			'settings.securitySection' => 'الأمان',
			'settings.preferencesSection' => 'التفضيلات',
			'settings.aboutSection' => 'حول',
			'settings.dangerZoneSection' => 'منطقة الخطر',
			'settings.language' => 'اللغة',
			'settings.languageSheetTitle' => 'اختر اللغة',
			'settings.languageEnglish' => 'English',
			'settings.languageArabic' => 'العربية',
			'settings.theme' => 'المظهر',
			'settings.themeSheetTitle' => 'اختر المظهر',
			'settings.themeLight' => 'فاتح',
			'settings.themeDark' => 'داكن',
			'settings.themeSystem' => 'النظام',
			'settings.appVersion' => 'إصدار التطبيق',
			'settings.dataMethodology' => 'البيانات والمنهجية',
			'settings.dataMethodologyNote' => 'الأسعار مبنية على أسعار الصرف الرسمية والأسعار العالمية الفورية — وقد تختلف عن أسعار السوق المحلي أو تجار الذهب. أرقام التضخم مُجمَّعة يدوياً من بيانات الجهاز المركزي للتعبئة العامة والإحصاء والبنك المركزي المصري. قيّمة مشروع تجريبي للتعريف بالمنتج: الأرقام للتوضيح والتوعية وليست نصيحة مالية.',
			'settings.deleteAccount' => 'حذف الحساب',
			'settings.deleteDialogTitle' => 'حذف الحساب؟',
			'settings.deleteDialogBody' => 'سيؤدي هذا إلى محو جميع أصولك وسجلّك وحسابك نهائياً. لا يوجد أي استرداد — وبما أن قيّمة تستخدم الدخول المجهول، لا يوجد بريد إلكتروني أو كلمة مرور للعودة إذا غيّرت رأيك. اكتب DELETE للتأكيد.',
			'settings.deleteConfirmHint' => 'اكتب DELETE للتأكيد',
			'settings.deleteForever' => 'حذف نهائياً',
			'settings.deleteFailed' => 'تعذر حذف حسابك. يرجى المحاولة مرة أخرى.',
			'settings.deletePartialFailure' => 'تم حذف بياناتك لكن تعذر إزالة الحساب بالكامل. يرجى المحاولة مرة أخرى أو التواصل مع الدعم.',
			'settings.logout' => 'تسجيل الخروج',
			'settings.logoutDialogTitle' => 'تسجيل الخروج؟',
			'settings.logoutDialogBody' => 'سيتم تسجيل خروجك من قيّمة. بياناتك تبقى في حسابك — سجّل الدخول مرة أخرى في أي وقت لتكمل من حيث توقفت.',
			'settings.logoutGuestDialogBody' => 'أنت تستخدم التطبيق كضيف. تسجيل الخروج يحذف هذا الحساب وجميع بياناته نهائياً. لا يوجد أي استرداد — وبما أن قيّمة تستخدم الدخول المجهول، لا يوجد بريد إلكتروني أو كلمة مرور للعودة إذا غيّرت رأيك.',
			'settings.logoutConfirm' => 'تسجيل الخروج',
			'settings.logoutDeleteConfirm' => 'حذف وتسجيل الخروج',
			'settings.logoutFailed' => 'تعذر تسجيل الخروج. يرجى المحاولة مرة أخرى.',
			'home.title' => 'قيّمة',
			'home.totalSavingsNominal' => 'إجمالي المدخرات',
			'home.totalSavingsReal' => 'بعد تعديل التضخم',
			'home.erosionCaption' => 'من قيمة أموالك تآكلت منذ أن بدأت',
			'home.trendSectionTitle' => 'القيمة الحقيقية — آخر 30 يوماً',
			'home.priceMoveBanner' => 'تحركت الأسعار بشكل ملحوظ اليوم — تحقق من أصولك.',
			'home.errorTitle' => 'حدث خطأ ما',
			'home.retry' => 'حاول مرة أخرى',
			'home.notEnoughTrendData' => 'لا توجد بيانات كافية بعد',
			'insights.assetPerformance.title' => 'أفضل أصل أداءً',
			'insights.assetPerformance.body' => ({required Object id, required Object value}) => 'الأصل ${id} يتصدر محفظتك بقيمة ${value} جنيه.',
			'insights.concentrationRisk.title' => 'مخاطر التركيز العالي',
			'insights.concentrationRisk.body' => 'أكثر من 80% من محفظتك في نوع أصل واحد. فكّر في التنويع لتقليل المخاطر.',
			'insights.inflationLoss.title' => 'تم اكتشاف تآكل تضخمي',
			'insights.inflationLoss.body' => ({required Object erosion}) => 'فقدت أموالك ${erosion}% من قوتها الشرائية منذ أن بدأت التتبع.',
			'insights.goalFeasibility.title' => 'فحص هدف الادخار',
			'insights.goalFeasibility.body' => 'بالمعدل الحالي للتضخم، قد تحتاج أهداف الادخار الخاصة بك إلى مراجعة بالزيادة للحفاظ على قيمتها الحقيقية.',
			'marketPrices.title' => 'أسعار السوق',
			'marketPrices.dataSourceDisclosure' => 'الأسعار مبنية على أسعار الصرف الرسمية والأسعار العالمية الفورية — وقد تختلف عن أسعار السوق المحلي أو تجار الذهب.',
			'marketPrices.lastUpdated' => ({required Object when}) => 'آخر تحديث ${when}',
			'marketPrices.notEnoughHistory' => 'لا يوجد تاريخ كافٍ بعد',
			'marketPrices.showingAvailableData' => ({required num n}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ar'))(n, zero: 'عرض البيانات المتاحة (${n} يوم)', one: 'عرض البيانات المتاحة (يوم واحد)', two: 'عرض البيانات المتاحة (يومين)', few: 'عرض البيانات المتاحة (${n} أيام)', many: 'عرض البيانات المتاحة (${n} يوماً)', other: 'عرض البيانات المتاحة (${n} يوم)', ), 
			'marketPrices.emptyTitle' => 'لا توجد أسعار سوق بعد',
			'marketPrices.emptyBody' => 'ستظهر بيانات أسعار السوق هنا بمجرد توفرها.',
			'marketPrices.range.oneWeek' => 'أسبوع',
			'marketPrices.range.oneMonth' => 'شهر',
			'marketPrices.range.threeMonths' => '3 أشهر',
			'charts.semantics.summary' => ({required num n, required Object title, required Object latest, required Object lowest, required Object highest}) => (_root.$meta.cardinalResolver ?? PluralResolvers.cardinal('ar'))(n, zero: '${title}، آخر ${n} يوم: الأحدث ${latest}، الأدنى ${lowest}، الأعلى ${highest}.', one: '${title}، لآخر يوم واحد: الأحدث ${latest}، الأدنى ${lowest}، الأعلى ${highest}.', two: '${title}، لآخر يومين: الأحدث ${latest}، الأدنى ${lowest}، الأعلى ${highest}.', few: '${title}، لآخر ${n} أيام: الأحدث ${latest}، الأدنى ${lowest}، الأعلى ${highest}.', many: '${title}، لآخر ${n} يوماً: الأحدث ${latest}، الأدنى ${lowest}، الأعلى ${highest}.', other: '${title}، لآخر ${n} يوم: الأحدث ${latest}، الأدنى ${lowest}، الأعلى ${highest}.', ), 
			'charts.semantics.realValue' => 'القيمة الحقيقية للمحفظة',
			'charts.semantics.priceHistory' => 'سجل السعر',
			'charts.semantics.recentPrices' => 'الأسعار الأخيرة',
			'app_lock.promptReason' => 'افتح قيّمة للمتابعة',
			'app_lock.disableReason' => 'أكّد هويتك لإيقاف قفل التطبيق',
			'app_lock.title' => 'قيّمة مقفلة',
			'app_lock.hint' => 'استخدم بيانات اعتماد جهازك لفتح التطبيق',
			'app_lock.unlockButton' => 'فتح',
			'app_lock.lockedOutMessage' => 'محاولات كثيرة. أعد المحاولة بعد انتهاء المهلة.',
			'app_lock.unavailableMessage' => 'تعذّر التحقق الآن. تحقق من قفل الجهاز ثم أعد المحاولة.',
			'app_lock.errorMessage' => 'تعذّر التحقق من هويتك. حاول مرة أخرى.',
			'app_lock.cancelledMessage' => 'تم إلغاء التحقق.',
			'app_lock.noCredentialsMessage' => 'لا يوجد قفل شاشة على هذا الجهاز. ضع قفل شاشة لاستخدام قفل التطبيق.',
			'app_lock.settingsTitle' => 'قفل التطبيق',
			'app_lock.settingsSubtitle' => 'طلب فتح الجهاز عند فتح قيّمة',
			'app_lock.settingsNoDeviceLock' => 'اضبط قفل شاشة (رمز أو نمط أو كلمة مرور) في إعدادات النظام لاستخدام قفل التطبيق',
			_ => null,
		};
	}
}
