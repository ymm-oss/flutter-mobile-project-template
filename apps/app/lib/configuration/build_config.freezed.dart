// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'build_config.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BuildConfig {

 String get appName; String get packageName; String get version; String get buildNumber; String get buildSignature; Flavor get flavor; String? get installerStore;



@override
bool operator ==(Object other) {
  final _this = this as BuildConfig;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BuildConfig&&(identical(other.appName, _this.appName) || other.appName == _this.appName)&&(identical(other.packageName, _this.packageName) || other.packageName == _this.packageName)&&(identical(other.version, _this.version) || other.version == _this.version)&&(identical(other.buildNumber, _this.buildNumber) || other.buildNumber == _this.buildNumber)&&(identical(other.buildSignature, _this.buildSignature) || other.buildSignature == _this.buildSignature)&&(identical(other.flavor, _this.flavor) || other.flavor == _this.flavor)&&(identical(other.installerStore, _this.installerStore) || other.installerStore == _this.installerStore));
}


@override
int get hashCode {
  final _this = this as BuildConfig;
  return Object.hash(runtimeType,_this.appName,_this.packageName,_this.version,_this.buildNumber,_this.buildSignature,_this.flavor,_this.installerStore);
}

@override
String toString() {
  final _this = this as BuildConfig;
  return 'BuildConfig(appName: ${_this.appName}, packageName: ${_this.packageName}, version: ${_this.version}, buildNumber: ${_this.buildNumber}, buildSignature: ${_this.buildSignature}, flavor: ${_this.flavor}, installerStore: ${_this.installerStore})';
}


}





/// @nodoc


class _BuildConfig extends BuildConfig {
  const _BuildConfig({required this.appName, required this.packageName, required this.version, required this.buildNumber, required this.buildSignature, required this.flavor, required this.installerStore}): super._();
  

@override final  String appName;
@override final  String packageName;
@override final  String version;
@override final  String buildNumber;
@override final  String buildSignature;
@override final  Flavor flavor;
@override final  String? installerStore;




@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _BuildConfig&&(identical(other.appName, appName) || other.appName == appName)&&(identical(other.packageName, packageName) || other.packageName == packageName)&&(identical(other.version, version) || other.version == version)&&(identical(other.buildNumber, buildNumber) || other.buildNumber == buildNumber)&&(identical(other.buildSignature, buildSignature) || other.buildSignature == buildSignature)&&(identical(other.flavor, flavor) || other.flavor == flavor)&&(identical(other.installerStore, installerStore) || other.installerStore == installerStore));
}


@override
int get hashCode {
    return Object.hash(runtimeType,appName,packageName,version,buildNumber,buildSignature,flavor,installerStore);
}

@override
String toString() {
    return 'BuildConfig._init(appName: $appName, packageName: $packageName, version: $version, buildNumber: $buildNumber, buildSignature: $buildSignature, flavor: $flavor, installerStore: $installerStore)';
}


}




// dart format on
