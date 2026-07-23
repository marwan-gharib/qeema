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
	@override late final _Translations$appLock$ar appLock = _Translations$appLock$ar._(_root);
	@override late final _Translations$assets$ar assets = _Translations$assets$ar._(_root);
	@override late final _Translations$settings$ar settings = _Translations$settings$ar._(_root);
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
	@override String get biometricSetup => 'إعداد التحقق البيومتري';
	@override String get addAsset => 'إضافة أصل';
	@override String get assetDetail => 'الأصل {id}';
	@override String get editAsset => 'تعديل الأصل {id}';
	@override String get addGoal => 'إضافة هدف';
	@override String get goalDetail => 'الهدف {id}';
	@override String get notificationSettings => 'إعدادات الإشعارات';
}

// Path: appLock
class _Translations$appLock$ar extends Translations$appLock$en {
	_Translations$appLock$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get tooManyAttempts => 'محاولات كثيرة جداً. حاول مرة أخرى لاحقاً.';
	@override String get noCredentials => 'لم يتم إعداد قفل للجهاز. قم بإعداد قفل شاشة في إعدادات جهازك.';
	@override String get unavailable => 'التحقق من الجهاز غير متاح على هذا الجهاز.';
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
	@override String get securitySection => 'الأمان';
	@override String get requireUnlock => 'طلب فتح قفل الجهاز لفتح قيّمة';
	@override String get noDeviceLock => 'جهازك لا يحتوي على قفل شاشة. قم بإعداد واحد في إعدادات جهازك لاستخدام هذه الميزة.';
	@override String get authCancelled => 'تم إلغاء التحقق.';
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

// Path: auth.welcome
class _Translations$auth$welcome$ar extends Translations$auth$welcome$en {
	_Translations$auth$welcome$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get headline => 'اعرف القيمة الحقيقية لأموالك';
	@override String get subtext => 'تتبع مدخراتك مقابل التضخم وشاهد قوتك الشرائية الحقيقية عبر الزمن.';
	@override String get primaryCta => 'ابدأ بتتبع مدخراتك';
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
	@override String get priceAtEntry => 'سعر الشراء';
	@override String get note => 'ملاحظة (اختياري)';
	@override String get noteHint => 'أضف ملاحظة...';
	@override String get submit => 'إضافة أصل';
	@override String get amountRequired => 'الكمية مطلوبة';
	@override String get amountInvalid => 'أدخل كمية موجبة صالحة';
	@override String get priceRequired => 'السعر مطلوب';
	@override String get priceInvalid => 'أدخل سعراً موجباً صالحاً';
}

// Path: assets.edit
class _Translations$assets$edit$ar extends Translations$assets$edit$en {
	_Translations$assets$edit$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'تعديل {type}';
	@override String get submit => 'حفظ التغييرات';
}

// Path: assets.detail
class _Translations$assets$detail$ar extends Translations$assets$detail$en {
	_Translations$assets$detail$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get entryPrice => 'سعر الشراء: {price} جنيه للوحدة';
	@override String get valueTrend => 'اتجاه القيمة';
	@override String get editHistory => 'سجل التعديلات';
	@override String get noHistory => 'لا يوجد سجل تعديلات بعد';
	@override String get cashFlatValue => 'الأصول النقدية تحافظ على قيمة ثابتة';
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

// Path: assets.chart
class _Translations$assets$chart$ar extends Translations$assets$chart$en {
	_Translations$assets$chart$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get cashPlaceholder => 'الأصول النقدية تحافظ على قيمة ثابتة';
}

// Path: assets.history
class _Translations$assets$history$ar extends Translations$assets$history$en {
	_Translations$assets$history$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get created => 'تم الإنشاء';
	@override String get updated => 'تم التحديث';
	@override String get deleted => 'تم الحذف';
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
			'auth.welcome.headline' => 'اعرف القيمة الحقيقية لأموالك',
			'auth.welcome.subtext' => 'تتبع مدخراتك مقابل التضخم وشاهد قوتك الشرائية الحقيقية عبر الزمن.',
			'auth.welcome.primaryCta' => 'ابدأ بتتبع مدخراتك',
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
			'navigation.biometricSetup' => 'إعداد التحقق البيومتري',
			'navigation.addAsset' => 'إضافة أصل',
			'navigation.assetDetail' => 'الأصل {id}',
			'navigation.editAsset' => 'تعديل الأصل {id}',
			'navigation.addGoal' => 'إضافة هدف',
			'navigation.goalDetail' => 'الهدف {id}',
			'navigation.notificationSettings' => 'إعدادات الإشعارات',
			'appLock.tooManyAttempts' => 'محاولات كثيرة جداً. حاول مرة أخرى لاحقاً.',
			'appLock.noCredentials' => 'لم يتم إعداد قفل للجهاز. قم بإعداد قفل شاشة في إعدادات جهازك.',
			'appLock.unavailable' => 'التحقق من الجهاز غير متاح على هذا الجهاز.',
			'assets.list.title' => 'الأصول',
			'assets.list.emptyNoAssets' => 'لا توجد أصول بعد',
			'assets.list.emptyNoAssetsSubtitle' => 'أضف أصلَك الأول لبدء التتبع',
			'assets.list.emptyNoFiltered' => 'لا توجد أصول من هذا النوع',
			'assets.list.emptyNoFilteredSubtitle' => 'جرّب تصفية مختلفة',
			'assets.list.addFirst' => 'إضافة أصل',
			'assets.add.title' => 'إضافة أصل',
			'assets.add.selectType' => 'اختر نوع الأصل',
			'assets.add.amount' => 'الكمية',
			'assets.add.priceAtEntry' => 'سعر الشراء',
			'assets.add.note' => 'ملاحظة (اختياري)',
			'assets.add.noteHint' => 'أضف ملاحظة...',
			'assets.add.submit' => 'إضافة أصل',
			'assets.add.amountRequired' => 'الكمية مطلوبة',
			'assets.add.amountInvalid' => 'أدخل كمية موجبة صالحة',
			'assets.add.priceRequired' => 'السعر مطلوب',
			'assets.add.priceInvalid' => 'أدخل سعراً موجباً صالحاً',
			'assets.edit.title' => 'تعديل {type}',
			'assets.edit.submit' => 'حفظ التغييرات',
			'assets.detail.entryPrice' => 'سعر الشراء: {price} جنيه للوحدة',
			'assets.detail.valueTrend' => 'اتجاه القيمة',
			'assets.detail.editHistory' => 'سجل التعديلات',
			'assets.detail.noHistory' => 'لا يوجد سجل تعديلات بعد',
			'assets.detail.cashFlatValue' => 'الأصول النقدية تحافظ على قيمة ثابتة',
			'assets.sort.title' => 'ترتيب حسب',
			'assets.sort.date' => 'التاريخ',
			'assets.sort.value' => 'القيمة',
			'assets.sort.type' => 'النوع',
			'assets.filter.all' => 'الكل',
			'assets.chart.cashPlaceholder' => 'الأصول النقدية تحافظ على قيمة ثابتة',
			'assets.history.created' => 'تم الإنشاء',
			'assets.history.updated' => 'تم التحديث',
			'assets.history.deleted' => 'تم الحذف',
			'assets.delete.confirmTitle' => 'حذف الأصل؟',
			'assets.delete.confirmBody' => 'سيؤدي هذا إلى حذف سجل الأصل بشكل دائم.',
			'assets.failure.assetNotFound' => 'الأصل غير موجود.',
			'assets.failure.invalidAmount' => 'يجب أن تكون الكمية أكبر من الصفر.',
			'settings.securitySection' => 'الأمان',
			'settings.requireUnlock' => 'طلب فتح قفل الجهاز لفتح قيّمة',
			'settings.noDeviceLock' => 'جهازك لا يحتوي على قفل شاشة. قم بإعداد واحد في إعدادات جهازك لاستخدام هذه الميزة.',
			'settings.authCancelled' => 'تم إلغاء التحقق.',
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
