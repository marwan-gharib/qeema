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
class TranslationsAr with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsAr({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  $meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ar,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		$meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ar>.
	@override final TranslationMetadata<AppLocale, Translations> $meta;

	/// Access flat map
	@override dynamic operator[](String key) => $meta.getTranslation(key);

	late final TranslationsAr _root = this; // ignore: unused_field

	@override 
	TranslationsAr $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsAr(meta: meta ?? this.$meta);

	// Translations
	@override late final _Translations$core$ar core = _Translations$core$ar._(_root);
	@override late final _Translations$auth$ar auth = _Translations$auth$ar._(_root);
	@override late final _Translations$navigation$ar navigation = _Translations$navigation$ar._(_root);
}

// Path: core
class _Translations$core$ar implements Translations$core$en {
	_Translations$core$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override late final _Translations$core$error$ar error = _Translations$core$error$ar._(_root);
	@override late final _Translations$core$empty$ar empty = _Translations$core$empty$ar._(_root);
	@override late final _Translations$core$loading$ar loading = _Translations$core$loading$ar._(_root);
	@override late final _Translations$core$search$ar search = _Translations$core$search$ar._(_root);
}

// Path: auth
class _Translations$auth$ar implements Translations$auth$en {
	_Translations$auth$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get login => 'تسجيل الدخول';
	@override String get signUp => 'إنشاء حساب';
	@override String get forgotPassword => 'نسيت كلمة المرور';
	@override String get logout => 'تسجيل الخروج';
	@override String get email => 'البريد الإلكتروني';
	@override String get password => 'كلمة المرور';
}

// Path: navigation
class _Translations$navigation$ar implements Translations$navigation$en {
	_Translations$navigation$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get home => 'الرئيسية';
	@override String get assets => 'الأصول';
	@override String get insights => 'التوصيات';
	@override String get goals => 'الأهداف';
	@override String get marketPrices => 'أسعار السوق';
	@override String get notifications => 'الإشعارات';
	@override String get profile => 'الملف الشخصي';
	@override String get settings => 'الإعدادات';
}

// Path: core.error
class _Translations$core$error$ar implements Translations$core$error$en {
	_Translations$core$error$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'حدث خطأ ما';
	@override String get body => 'حدث خطأ ما من جانبنا.';
	@override String get tryAgain => 'حاول مرة أخرى';
}

// Path: core.empty
class _Translations$core$empty$ar implements Translations$core$empty$en {
	_Translations$core$empty$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'لا توجد بيانات بعد';
	@override String get body => 'لا يوجد شيء هنا بعد.';
}

// Path: core.loading
class _Translations$core$loading$ar implements Translations$core$loading$en {
	_Translations$core$loading$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get message => 'جارٍ التحميل...';
}

// Path: core.search
class _Translations$core$search$ar implements Translations$core$search$en {
	_Translations$core$search$ar._(this._root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get hint => 'بحث...';
	@override String get noResults => 'لم يتم العثور على نتائج.';
}

/// The flat map containing all translations for locale <ar>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsAr {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'core.error.title' => 'حدث خطأ ما',
			'core.error.body' => 'حدث خطأ ما من جانبنا.',
			'core.error.tryAgain' => 'حاول مرة أخرى',
			'core.empty.title' => 'لا توجد بيانات بعد',
			'core.empty.body' => 'لا يوجد شيء هنا بعد.',
			'core.loading.message' => 'جارٍ التحميل...',
			'core.search.hint' => 'بحث...',
			'core.search.noResults' => 'لم يتم العثور على نتائج.',
			'auth.login' => 'تسجيل الدخول',
			'auth.signUp' => 'إنشاء حساب',
			'auth.forgotPassword' => 'نسيت كلمة المرور',
			'auth.logout' => 'تسجيل الخروج',
			'auth.email' => 'البريد الإلكتروني',
			'auth.password' => 'كلمة المرور',
			'navigation.home' => 'الرئيسية',
			'navigation.assets' => 'الأصول',
			'navigation.insights' => 'التوصيات',
			'navigation.goals' => 'الأهداف',
			'navigation.marketPrices' => 'أسعار السوق',
			'navigation.notifications' => 'الإشعارات',
			'navigation.profile' => 'الملف الشخصي',
			'navigation.settings' => 'الإعدادات',
			_ => null,
		};
	}
}
