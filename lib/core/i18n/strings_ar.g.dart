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
	@override late final Translations$core$ar core = Translations$core$ar._(_root);
	@override late final Translations$auth$ar auth = Translations$auth$ar._(_root);
	@override late final Translations$navigation$ar navigation = Translations$navigation$ar._(_root);
}

// Path: core
class Translations$core$ar extends Translations$core$en {
	Translations$core$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override late final Translations$core$error$ar error = Translations$core$error$ar._(_root);
	@override late final Translations$core$empty$ar empty = Translations$core$empty$ar._(_root);
	@override late final Translations$core$loading$ar loading = Translations$core$loading$ar._(_root);
	@override late final Translations$core$search$ar search = Translations$core$search$ar._(_root);
}

// Path: auth
class Translations$auth$ar extends Translations$auth$en {
	Translations$auth$ar._(TranslationsAr root) : this._root = root, super.internal(root);

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
class Translations$navigation$ar extends Translations$navigation$en {
	Translations$navigation$ar._(TranslationsAr root) : this._root = root, super.internal(root);

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
class Translations$core$error$ar extends Translations$core$error$en {
	Translations$core$error$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'حدث خطأ ما';
	@override String get body => 'حدث خطأ ما من جانبنا.';
	@override String get tryAgain => 'حاول مرة أخرى';
}

// Path: core.empty
class Translations$core$empty$ar extends Translations$core$empty$en {
	Translations$core$empty$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get title => 'لا توجد بيانات بعد';
	@override String get body => 'لا يوجد شيء هنا بعد.';
}

// Path: core.loading
class Translations$core$loading$ar extends Translations$core$loading$en {
	Translations$core$loading$ar._(TranslationsAr root) : this._root = root, super.internal(root);

	final TranslationsAr _root; // ignore: unused_field

	// Translations
	@override String get message => 'جارٍ التحميل...';
}

// Path: core.search
class Translations$core$search$ar extends Translations$core$search$en {
	Translations$core$search$ar._(TranslationsAr root) : this._root = root, super.internal(root);

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
