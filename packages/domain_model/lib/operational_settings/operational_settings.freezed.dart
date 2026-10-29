// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'operational_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$OperationalSettings {

 MaintenancePolicy get maintenancePolicy; ForceUpdatePolicy get forceUpdatePolicy;
/// Create a copy of OperationalSettings
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OperationalSettingsCopyWith<OperationalSettings> get copyWith => _$OperationalSettingsCopyWithImpl<OperationalSettings>(this as OperationalSettings, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as OperationalSettings;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OperationalSettings&&(identical(other.maintenancePolicy, _this.maintenancePolicy) || other.maintenancePolicy == _this.maintenancePolicy)&&(identical(other.forceUpdatePolicy, _this.forceUpdatePolicy) || other.forceUpdatePolicy == _this.forceUpdatePolicy));
}


@override
int get hashCode {
  final _this = this as OperationalSettings;
  return Object.hash(runtimeType,_this.maintenancePolicy,_this.forceUpdatePolicy);
}

@override
String toString() {
  final _this = this as OperationalSettings;
  return 'OperationalSettings(maintenancePolicy: ${_this.maintenancePolicy}, forceUpdatePolicy: ${_this.forceUpdatePolicy})';
}


}

/// @nodoc
abstract mixin class $OperationalSettingsCopyWith<$Res>  {
  factory $OperationalSettingsCopyWith(OperationalSettings value, $Res Function(OperationalSettings) _then) = _$OperationalSettingsCopyWithImpl;
@useResult
$Res call({
 MaintenancePolicy maintenancePolicy, ForceUpdatePolicy forceUpdatePolicy
});


$MaintenancePolicyCopyWith<$Res> get maintenancePolicy;$ForceUpdatePolicyCopyWith<$Res> get forceUpdatePolicy;

}
/// @nodoc
class _$OperationalSettingsCopyWithImpl<$Res>
    implements $OperationalSettingsCopyWith<$Res> {
  _$OperationalSettingsCopyWithImpl(this._self, this._then);

  final OperationalSettings _self;
  final $Res Function(OperationalSettings) _then;

/// Create a copy of OperationalSettings
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? maintenancePolicy = null,Object? forceUpdatePolicy = null,}) {
  return _then(OperationalSettings(
maintenancePolicy: null == maintenancePolicy ? _self.maintenancePolicy : maintenancePolicy // ignore: cast_nullable_to_non_nullable
as MaintenancePolicy,forceUpdatePolicy: null == forceUpdatePolicy ? _self.forceUpdatePolicy : forceUpdatePolicy // ignore: cast_nullable_to_non_nullable
as ForceUpdatePolicy,
  ));
}
/// Create a copy of OperationalSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MaintenancePolicyCopyWith<$Res> get maintenancePolicy {
  
  return $MaintenancePolicyCopyWith<$Res>(_self.maintenancePolicy, (value) {
    return _then(_self.copyWith(maintenancePolicy: value));
  });
}/// Create a copy of OperationalSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ForceUpdatePolicyCopyWith<$Res> get forceUpdatePolicy {
  
  return $ForceUpdatePolicyCopyWith<$Res>(_self.forceUpdatePolicy, (value) {
    return _then(_self.copyWith(forceUpdatePolicy: value));
  });
}
}


/// Adds pattern-matching-related methods to [OperationalSettings].
extension OperationalSettingsPatterns on OperationalSettings {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OperationalSettings value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OperationalSettings() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OperationalSettings value)  $default,){
final _that = this;
switch (_that) {
case _OperationalSettings():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OperationalSettings value)?  $default,){
final _that = this;
switch (_that) {
case _OperationalSettings() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( MaintenancePolicy maintenancePolicy,  ForceUpdatePolicy forceUpdatePolicy)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OperationalSettings() when $default != null:
return $default(_that.maintenancePolicy,_that.forceUpdatePolicy);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( MaintenancePolicy maintenancePolicy,  ForceUpdatePolicy forceUpdatePolicy)  $default,) {final _that = this;
switch (_that) {
case _OperationalSettings():
return $default(_that.maintenancePolicy,_that.forceUpdatePolicy);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( MaintenancePolicy maintenancePolicy,  ForceUpdatePolicy forceUpdatePolicy)?  $default,) {final _that = this;
switch (_that) {
case _OperationalSettings() when $default != null:
return $default(_that.maintenancePolicy,_that.forceUpdatePolicy);case _:
  return null;

}
}

}

/// @nodoc


class _OperationalSettings extends OperationalSettings {
  const _OperationalSettings({required this.maintenancePolicy, required this.forceUpdatePolicy}): super._();
  

@override final  MaintenancePolicy maintenancePolicy;
@override final  ForceUpdatePolicy forceUpdatePolicy;

/// Create a copy of OperationalSettings
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OperationalSettingsCopyWith<_OperationalSettings> get copyWith => __$OperationalSettingsCopyWithImpl<_OperationalSettings>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OperationalSettings&&(identical(other.maintenancePolicy, maintenancePolicy) || other.maintenancePolicy == maintenancePolicy)&&(identical(other.forceUpdatePolicy, forceUpdatePolicy) || other.forceUpdatePolicy == forceUpdatePolicy));
}


@override
int get hashCode {
    return Object.hash(runtimeType,maintenancePolicy,forceUpdatePolicy);
}

@override
String toString() {
    return 'OperationalSettings(maintenancePolicy: $maintenancePolicy, forceUpdatePolicy: $forceUpdatePolicy)';
}


}

/// @nodoc
abstract mixin class _$OperationalSettingsCopyWith<$Res> implements $OperationalSettingsCopyWith<$Res> {
  factory _$OperationalSettingsCopyWith(_OperationalSettings value, $Res Function(_OperationalSettings) _then) = __$OperationalSettingsCopyWithImpl;
@override @useResult
$Res call({
 MaintenancePolicy maintenancePolicy, ForceUpdatePolicy forceUpdatePolicy
});


@override $MaintenancePolicyCopyWith<$Res> get maintenancePolicy;@override $ForceUpdatePolicyCopyWith<$Res> get forceUpdatePolicy;

}
/// @nodoc
class __$OperationalSettingsCopyWithImpl<$Res>
    implements _$OperationalSettingsCopyWith<$Res> {
  __$OperationalSettingsCopyWithImpl(this._self, this._then);

  final _OperationalSettings _self;
  final $Res Function(_OperationalSettings) _then;

/// Create a copy of OperationalSettings
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? maintenancePolicy = null,Object? forceUpdatePolicy = null,}) {
  return _then(_OperationalSettings(
maintenancePolicy: null == maintenancePolicy ? _self.maintenancePolicy : maintenancePolicy // ignore: cast_nullable_to_non_nullable
as MaintenancePolicy,forceUpdatePolicy: null == forceUpdatePolicy ? _self.forceUpdatePolicy : forceUpdatePolicy // ignore: cast_nullable_to_non_nullable
as ForceUpdatePolicy,
  ));
}

/// Create a copy of OperationalSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MaintenancePolicyCopyWith<$Res> get maintenancePolicy {
  
  return $MaintenancePolicyCopyWith<$Res>(_self.maintenancePolicy, (value) {
    return _then(_self.copyWith(maintenancePolicy: value));
  });
}/// Create a copy of OperationalSettings
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ForceUpdatePolicyCopyWith<$Res> get forceUpdatePolicy {
  
  return $ForceUpdatePolicyCopyWith<$Res>(_self.forceUpdatePolicy, (value) {
    return _then(_self.copyWith(forceUpdatePolicy: value));
  });
}
}

/// @nodoc
mixin _$MaintenancePolicy {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MaintenancePolicy);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'MaintenancePolicy()';
}


}

/// @nodoc
class $MaintenancePolicyCopyWith<$Res>  {
$MaintenancePolicyCopyWith(MaintenancePolicy _, $Res Function(MaintenancePolicy) __);
}


/// Adds pattern-matching-related methods to [MaintenancePolicy].
extension MaintenancePolicyPatterns on MaintenancePolicy {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( MaintenanceEnabled value)?  enabled,TResult Function( MaintenanceDisabled value)?  disabled,required TResult orElse(),}){
final _that = this;
switch (_that) {
case MaintenanceEnabled() when enabled != null:
return enabled(_that);case MaintenanceDisabled() when disabled != null:
return disabled(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( MaintenanceEnabled value)  enabled,required TResult Function( MaintenanceDisabled value)  disabled,}){
final _that = this;
switch (_that) {
case MaintenanceEnabled():
return enabled(_that);case MaintenanceDisabled():
return disabled(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( MaintenanceEnabled value)?  enabled,TResult? Function( MaintenanceDisabled value)?  disabled,}){
final _that = this;
switch (_that) {
case MaintenanceEnabled() when enabled != null:
return enabled(_that);case MaintenanceDisabled() when disabled != null:
return disabled(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String message)?  enabled,TResult Function()?  disabled,required TResult orElse(),}) {final _that = this;
switch (_that) {
case MaintenanceEnabled() when enabled != null:
return enabled(_that.message);case MaintenanceDisabled() when disabled != null:
return disabled();case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String message)  enabled,required TResult Function()  disabled,}) {final _that = this;
switch (_that) {
case MaintenanceEnabled():
return enabled(_that.message);case MaintenanceDisabled():
return disabled();}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String message)?  enabled,TResult? Function()?  disabled,}) {final _that = this;
switch (_that) {
case MaintenanceEnabled() when enabled != null:
return enabled(_that.message);case MaintenanceDisabled() when disabled != null:
return disabled();case _:
  return null;

}
}

}

/// @nodoc


class MaintenanceEnabled implements MaintenancePolicy {
  const MaintenanceEnabled({required this.message});
  

 final  String message;

/// Create a copy of MaintenancePolicy
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MaintenanceEnabledCopyWith<MaintenanceEnabled> get copyWith => _$MaintenanceEnabledCopyWithImpl<MaintenanceEnabled>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MaintenanceEnabled&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode {
    return Object.hash(runtimeType,message);
}

@override
String toString() {
    return 'MaintenancePolicy.enabled(message: $message)';
}


}

/// @nodoc
abstract mixin class $MaintenanceEnabledCopyWith<$Res> implements $MaintenancePolicyCopyWith<$Res> {
  factory $MaintenanceEnabledCopyWith(MaintenanceEnabled value, $Res Function(MaintenanceEnabled) _then) = _$MaintenanceEnabledCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$MaintenanceEnabledCopyWithImpl<$Res>
    implements $MaintenanceEnabledCopyWith<$Res> {
  _$MaintenanceEnabledCopyWithImpl(this._self, this._then);

  final MaintenanceEnabled _self;
  final $Res Function(MaintenanceEnabled) _then;

/// Create a copy of MaintenancePolicy
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(MaintenanceEnabled(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class MaintenanceDisabled implements MaintenancePolicy {
  const MaintenanceDisabled();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is MaintenanceDisabled);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'MaintenancePolicy.disabled()';
}


}




/// @nodoc
mixin _$ForceUpdatePolicy {





@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ForceUpdatePolicy);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ForceUpdatePolicy()';
}


}

/// @nodoc
class $ForceUpdatePolicyCopyWith<$Res>  {
$ForceUpdatePolicyCopyWith(ForceUpdatePolicy _, $Res Function(ForceUpdatePolicy) __);
}


/// Adds pattern-matching-related methods to [ForceUpdatePolicy].
extension ForceUpdatePolicyPatterns on ForceUpdatePolicy {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ForceUpdateEnabled value)?  enabled,TResult Function( ForceUpdateDisabled value)?  disabled,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ForceUpdateEnabled() when enabled != null:
return enabled(_that);case ForceUpdateDisabled() when disabled != null:
return disabled(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ForceUpdateEnabled value)  enabled,required TResult Function( ForceUpdateDisabled value)  disabled,}){
final _that = this;
switch (_that) {
case ForceUpdateEnabled():
return enabled(_that);case ForceUpdateDisabled():
return disabled(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ForceUpdateEnabled value)?  enabled,TResult? Function( ForceUpdateDisabled value)?  disabled,}){
final _that = this;
switch (_that) {
case ForceUpdateEnabled() when enabled != null:
return enabled(_that);case ForceUpdateDisabled() when disabled != null:
return disabled(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( RequiredVersions minimumVersions)?  enabled,TResult Function()?  disabled,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ForceUpdateEnabled() when enabled != null:
return enabled(_that.minimumVersions);case ForceUpdateDisabled() when disabled != null:
return disabled();case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( RequiredVersions minimumVersions)  enabled,required TResult Function()  disabled,}) {final _that = this;
switch (_that) {
case ForceUpdateEnabled():
return enabled(_that.minimumVersions);case ForceUpdateDisabled():
return disabled();}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( RequiredVersions minimumVersions)?  enabled,TResult? Function()?  disabled,}) {final _that = this;
switch (_that) {
case ForceUpdateEnabled() when enabled != null:
return enabled(_that.minimumVersions);case ForceUpdateDisabled() when disabled != null:
return disabled();case _:
  return null;

}
}

}

/// @nodoc


class ForceUpdateEnabled implements ForceUpdatePolicy {
  const ForceUpdateEnabled({required this.minimumVersions});
  

 final  RequiredVersions minimumVersions;

/// Create a copy of ForceUpdatePolicy
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ForceUpdateEnabledCopyWith<ForceUpdateEnabled> get copyWith => _$ForceUpdateEnabledCopyWithImpl<ForceUpdateEnabled>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ForceUpdateEnabled&&(identical(other.minimumVersions, minimumVersions) || other.minimumVersions == minimumVersions));
}


@override
int get hashCode {
    return Object.hash(runtimeType,minimumVersions);
}

@override
String toString() {
    return 'ForceUpdatePolicy.enabled(minimumVersions: $minimumVersions)';
}


}

/// @nodoc
abstract mixin class $ForceUpdateEnabledCopyWith<$Res> implements $ForceUpdatePolicyCopyWith<$Res> {
  factory $ForceUpdateEnabledCopyWith(ForceUpdateEnabled value, $Res Function(ForceUpdateEnabled) _then) = _$ForceUpdateEnabledCopyWithImpl;
@useResult
$Res call({
 RequiredVersions minimumVersions
});


$RequiredVersionsCopyWith<$Res> get minimumVersions;

}
/// @nodoc
class _$ForceUpdateEnabledCopyWithImpl<$Res>
    implements $ForceUpdateEnabledCopyWith<$Res> {
  _$ForceUpdateEnabledCopyWithImpl(this._self, this._then);

  final ForceUpdateEnabled _self;
  final $Res Function(ForceUpdateEnabled) _then;

/// Create a copy of ForceUpdatePolicy
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? minimumVersions = null,}) {
  return _then(ForceUpdateEnabled(
minimumVersions: null == minimumVersions ? _self.minimumVersions : minimumVersions // ignore: cast_nullable_to_non_nullable
as RequiredVersions,
  ));
}

/// Create a copy of ForceUpdatePolicy
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RequiredVersionsCopyWith<$Res> get minimumVersions {
  
  return $RequiredVersionsCopyWith<$Res>(_self.minimumVersions, (value) {
    return _then(_self.copyWith(minimumVersions: value));
  });
}
}

/// @nodoc


class ForceUpdateDisabled implements ForceUpdatePolicy {
  const ForceUpdateDisabled();
  






@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is ForceUpdateDisabled);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
    return 'ForceUpdatePolicy.disabled()';
}


}




/// @nodoc
mixin _$RequiredVersions {

 Version get ios; Version get android;
/// Create a copy of RequiredVersions
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RequiredVersionsCopyWith<RequiredVersions> get copyWith => _$RequiredVersionsCopyWithImpl<RequiredVersions>(this as RequiredVersions, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as RequiredVersions;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RequiredVersions&&(identical(other.ios, _this.ios) || other.ios == _this.ios)&&(identical(other.android, _this.android) || other.android == _this.android));
}


@override
int get hashCode {
  final _this = this as RequiredVersions;
  return Object.hash(runtimeType,_this.ios,_this.android);
}

@override
String toString() {
  final _this = this as RequiredVersions;
  return 'RequiredVersions(ios: ${_this.ios}, android: ${_this.android})';
}


}

/// @nodoc
abstract mixin class $RequiredVersionsCopyWith<$Res>  {
  factory $RequiredVersionsCopyWith(RequiredVersions value, $Res Function(RequiredVersions) _then) = _$RequiredVersionsCopyWithImpl;
@useResult
$Res call({
 Version ios, Version android
});




}
/// @nodoc
class _$RequiredVersionsCopyWithImpl<$Res>
    implements $RequiredVersionsCopyWith<$Res> {
  _$RequiredVersionsCopyWithImpl(this._self, this._then);

  final RequiredVersions _self;
  final $Res Function(RequiredVersions) _then;

/// Create a copy of RequiredVersions
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? ios = null,Object? android = null,}) {
  return _then(RequiredVersions(
ios: null == ios ? _self.ios : ios // ignore: cast_nullable_to_non_nullable
as Version,android: null == android ? _self.android : android // ignore: cast_nullable_to_non_nullable
as Version,
  ));
}

}


/// Adds pattern-matching-related methods to [RequiredVersions].
extension RequiredVersionsPatterns on RequiredVersions {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RequiredVersions value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RequiredVersions() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RequiredVersions value)  $default,){
final _that = this;
switch (_that) {
case _RequiredVersions():
return $default(_that);}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RequiredVersions value)?  $default,){
final _that = this;
switch (_that) {
case _RequiredVersions() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Version ios,  Version android)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RequiredVersions() when $default != null:
return $default(_that.ios,_that.android);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Version ios,  Version android)  $default,) {final _that = this;
switch (_that) {
case _RequiredVersions():
return $default(_that.ios,_that.android);}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Version ios,  Version android)?  $default,) {final _that = this;
switch (_that) {
case _RequiredVersions() when $default != null:
return $default(_that.ios,_that.android);case _:
  return null;

}
}

}

/// @nodoc


class _RequiredVersions extends RequiredVersions {
  const _RequiredVersions({required this.ios, required this.android}): super._();
  

@override final  Version ios;
@override final  Version android;

/// Create a copy of RequiredVersions
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RequiredVersionsCopyWith<_RequiredVersions> get copyWith => __$RequiredVersionsCopyWithImpl<_RequiredVersions>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RequiredVersions&&(identical(other.ios, ios) || other.ios == ios)&&(identical(other.android, android) || other.android == android));
}


@override
int get hashCode {
    return Object.hash(runtimeType,ios,android);
}

@override
String toString() {
    return 'RequiredVersions(ios: $ios, android: $android)';
}


}

/// @nodoc
abstract mixin class _$RequiredVersionsCopyWith<$Res> implements $RequiredVersionsCopyWith<$Res> {
  factory _$RequiredVersionsCopyWith(_RequiredVersions value, $Res Function(_RequiredVersions) _then) = __$RequiredVersionsCopyWithImpl;
@override @useResult
$Res call({
 Version ios, Version android
});




}
/// @nodoc
class __$RequiredVersionsCopyWithImpl<$Res>
    implements _$RequiredVersionsCopyWith<$Res> {
  __$RequiredVersionsCopyWithImpl(this._self, this._then);

  final _RequiredVersions _self;
  final $Res Function(_RequiredVersions) _then;

/// Create a copy of RequiredVersions
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? ios = null,Object? android = null,}) {
  return _then(_RequiredVersions(
ios: null == ios ? _self.ios : ios // ignore: cast_nullable_to_non_nullable
as Version,android: null == android ? _self.android : android // ignore: cast_nullable_to_non_nullable
as Version,
  ));
}


}

// dart format on
