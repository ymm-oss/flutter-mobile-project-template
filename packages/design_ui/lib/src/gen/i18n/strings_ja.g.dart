///
/// Generated file. Do not edit.
///
// coverage:ignore-file
// ignore_for_file: type=lint, unused_import
// dart format off

part of 'strings.g.dart';

// Path: <root>
typedef TranslationsJa = Translations; // ignore: unused_element
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
		  _meta = meta ?? TranslationMetadata(
		    locale: AppLocale.ja,
		    overrides: overrides ?? {},
		    cardinalResolver: cardinalResolver,
		    ordinalResolver: ordinalResolver,
		  ) {
		_meta.setFlatMapFunction(_flatMapFunction);
	}

	/// Metadata for the translations of <ja>.
	final TranslationMetadata<AppLocale, Translations> _meta;
	@override TranslationMetadata<AppLocale, Translations> get $meta => _meta;

	/// Access flat map
	dynamic operator[](String key) => _meta.getTranslation(key);

	late final Translations _root = this; // ignore: unused_field

	Translations $copyWith({TranslationMetadata<AppLocale, Translations>? meta}) => Translations(meta: meta ?? this.$meta);

	// Translations
	late final Translations$bottomTab$ja bottomTab = Translations$bottomTab$ja._(_root);
	late final Translations$home$ja home = Translations$home$ja._(_root);
	late final Translations$maintenance$ja maintenance = Translations$maintenance$ja._(_root);
	late final Translations$setting$ja setting = Translations$setting$ja._(_root);
}

// Path: bottomTab
class Translations$bottomTab$ja {
	Translations$bottomTab$ja._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// ja: 'ホーム'
	String get home => 'ホーム';

	/// ja: '設定'
	String get settings => '設定';
}

// Path: home
class Translations$home$ja {
	Translations$home$ja._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// ja: 'ホーム'
	String get title => 'ホーム';

	/// ja: 'Flutter テンプレート'
	String get appBarTitle => 'Flutter テンプレート';
}

// Path: maintenance
class Translations$maintenance$ja {
	Translations$maintenance$ja._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// ja: 'メンテナンスモード'
	String get appBarTitle => 'メンテナンスモード';

	/// ja: 'メンテナンス中です.'
	String get description => 'メンテナンス中です.';

	/// ja: 'メンテナンスモードを無効にする'
	String get disableButtonLabel => 'メンテナンスモードを無効にする';
}

// Path: setting
class Translations$setting$ja {
	Translations$setting$ja._(this._root);

	final Translations _root; // ignore: unused_field

	// Translations

	/// ja: '設定'
	String get appBarTitle => '設定';

	/// ja: 'テーマ設定'
	String get themeSettingLabel => 'テーマ設定';

	/// ja: 'FlutterMobileTemplate について'
	String get aboutLabel => 'FlutterMobileTemplate について';

	/// ja: 'オープンソースライセンス'
	String get openSourceLicensesLabel => 'オープンソースライセンス';

	/// ja: '使用しているライブラリ'
	String get librariesWeUseLabel => '使用しているライブラリ';

	/// ja: 'バージョン'
	String get versionLabel => 'バージョン';
}

/// The flat map containing all translations for locale <ja>.
/// Only for edge cases! For simple maps, use the map function of this library.
///
/// The Dart AOT compiler has issues with very large switch statements,
/// so the map is split into smaller functions (512 entries each).
extension on Translations {
	dynamic _flatMapFunction(String path) {
		return switch (path) {
			'bottomTab.home' => 'ホーム',
			'bottomTab.settings' => '設定',
			'home.title' => 'ホーム',
			'home.appBarTitle' => 'Flutter テンプレート',
			'maintenance.appBarTitle' => 'メンテナンスモード',
			'maintenance.description' => 'メンテナンス中です.',
			'maintenance.disableButtonLabel' => 'メンテナンスモードを無効にする',
			'setting.appBarTitle' => '設定',
			'setting.themeSettingLabel' => 'テーマ設定',
			'setting.aboutLabel' => 'FlutterMobileTemplate について',
			'setting.openSourceLicensesLabel' => 'オープンソースライセンス',
			'setting.librariesWeUseLabel' => '使用しているライブラリ',
			'setting.versionLabel' => 'バージョン',
			_ => null,
		};
	}
}
