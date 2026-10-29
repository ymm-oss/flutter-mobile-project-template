// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'github_repository.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GitHubRepository {

 String get name; String? get description;
/// Create a copy of GitHubRepository
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GitHubRepositoryCopyWith<GitHubRepository> get copyWith => _$GitHubRepositoryCopyWithImpl<GitHubRepository>(this as GitHubRepository, _$identity);

  /// Serializes this GitHubRepository to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as GitHubRepository;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GitHubRepository&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.description, _this.description) || other.description == _this.description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as GitHubRepository;
  return Object.hash(runtimeType,_this.name,_this.description);
}

@override
String toString() {
  final _this = this as GitHubRepository;
  return 'GitHubRepository(name: ${_this.name}, description: ${_this.description})';
}


}

/// @nodoc
abstract mixin class $GitHubRepositoryCopyWith<$Res>  {
  factory $GitHubRepositoryCopyWith(GitHubRepository value, $Res Function(GitHubRepository) _then) = _$GitHubRepositoryCopyWithImpl;
@useResult
$Res call({
 String name, String? description
});




}
/// @nodoc
class _$GitHubRepositoryCopyWithImpl<$Res>
    implements $GitHubRepositoryCopyWith<$Res> {
  _$GitHubRepositoryCopyWithImpl(this._self, this._then);

  final GitHubRepository _self;
  final $Res Function(GitHubRepository) _then;

/// Create a copy of GitHubRepository
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? name = null,Object? description = freezed,}) {
  return _then(GitHubRepository(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GitHubRepository].
extension GitHubRepositoryPatterns on GitHubRepository {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GitHubRepository value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GitHubRepository() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GitHubRepository value)  $default,){
final _that = this;
switch (_that) {
case _GitHubRepository():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GitHubRepository value)?  $default,){
final _that = this;
switch (_that) {
case _GitHubRepository() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String name,  String? description)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GitHubRepository() when $default != null:
return $default(_that.name,_that.description);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String name,  String? description)  $default,) {final _that = this;
switch (_that) {
case _GitHubRepository():
return $default(_that.name,_that.description);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String name,  String? description)?  $default,) {final _that = this;
switch (_that) {
case _GitHubRepository() when $default != null:
return $default(_that.name,_that.description);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GitHubRepository implements GitHubRepository {
  const _GitHubRepository({required this.name, required this.description});
  factory _GitHubRepository.fromJson(Map<String, dynamic> json) => _$GitHubRepositoryFromJson(json);

@override final  String name;
@override final  String? description;

/// Create a copy of GitHubRepository
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GitHubRepositoryCopyWith<_GitHubRepository> get copyWith => __$GitHubRepositoryCopyWithImpl<_GitHubRepository>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GitHubRepositoryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _GitHubRepository&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,name,description);
}

@override
String toString() {
    return 'GitHubRepository(name: $name, description: $description)';
}


}

/// @nodoc
abstract mixin class _$GitHubRepositoryCopyWith<$Res> implements $GitHubRepositoryCopyWith<$Res> {
  factory _$GitHubRepositoryCopyWith(_GitHubRepository value, $Res Function(_GitHubRepository) _then) = __$GitHubRepositoryCopyWithImpl;
@override @useResult
$Res call({
 String name, String? description
});




}
/// @nodoc
class __$GitHubRepositoryCopyWithImpl<$Res>
    implements _$GitHubRepositoryCopyWith<$Res> {
  __$GitHubRepositoryCopyWithImpl(this._self, this._then);

  final _GitHubRepository _self;
  final $Res Function(_GitHubRepository) _then;

/// Create a copy of GitHubRepository
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? name = null,Object? description = freezed,}) {
  return _then(_GitHubRepository(
name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: freezed == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
