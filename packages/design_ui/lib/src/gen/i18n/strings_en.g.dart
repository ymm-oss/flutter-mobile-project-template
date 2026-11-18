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
class TranslationsEn with BaseTranslations<AppLocale, Translations> implements Translations {
	/// You can call this constructor and build your own translation instance of this locale.
	/// Constructing via the enum [AppLocale.build] is preferred.
	TranslationsEn({Map<String, Node>? overrides, PluralResolver? cardinalResolver, PluralResolver? ordinalResolver, TranslationMetadata<AppLocale, Translations>? meta})
		: assert(overrides == null, 'Set "translation_overrides: true" in order to enable this feature.'),
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.en,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <en>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	@override dynamic operator[](String key) => _meta.getTranslation(key);

	late final TranslationsEn _root = this; // ignore: unused_field

	@override 
	TranslationsEn $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => TranslationsEn(meta: meta ?? this.$meta);

	// Translations
	@override late final _Translations$bottomTab$en bottomTab = _Translations$bottomTab$en._(_root);
	@override late final _Translations$home$en home = _Translations$home$en._(_root);
	@override late final _Translations$maintenance$en maintenance = _Translations$maintenance$en._(_root);
	@override late final _Translations$setting$en setting = _Translations$setting$en._(_root);
}

// Path: bottomTab
class _Translations$bottomTab$en implements Translations$bottomTab$ja {
	_Translations$bottomTab$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get home => 'Home';
	@override String get settings => 'Settings';
}

// Path: home
class _Translations$home$en implements Translations$home$ja {
	_Translations$home$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get title => 'Home';
	@override String get appBarTitle => 'Flutter Template';
}

// Path: maintenance
class _Translations$maintenance$en implements Translations$maintenance$ja {
	_Translations$maintenance$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get appBarTitle => 'Maintenance mode';
	@override String get description => 'Maintenance in progress.';
	@override String get disableButtonLabel => 'Disable maintenance mode';
}

// Path: setting
class _Translations$setting$en implements Translations$setting$ja {
	_Translations$setting$en._(this._root);

	final TranslationsEn _root; // ignore: unused_field

	// Translations
	@override String get appBarTitle => 'Setting';
	@override String get themeSettingLabel => 'Theme Setting';
	@override String get aboutLabel => 'About FlutterMobileTemplate';
	@override String get openSourceLicensesLabel => 'Open source licenses';
	@override String get librariesWeUseLabel => 'Libraries we use';
	@override String get versionLabel => 'Version';
}

/// The flat map containing all translations for locale <en>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on TranslationsEn {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'bottomTab.home' => 'Home',
			'bottomTab.settings' => 'Settings',
			'home.title' => 'Home',
			'home.appBarTitle' => 'Flutter Template',
			'maintenance.appBarTitle' => 'Maintenance mode',
			'maintenance.description' => 'Maintenance in progress.',
			'maintenance.disableButtonLabel' => 'Disable maintenance mode',
			'setting.appBarTitle' => 'Setting',
			'setting.themeSettingLabel' => 'Theme Setting',
			'setting.aboutLabel' => 'About FlutterMobileTemplate',
			'setting.openSourceLicensesLabel' => 'Open source licenses',
			'setting.librariesWeUseLabel' => 'Libraries we use',
			'setting.versionLabel' => 'Version',
			_ => null,
		};
	}
}
