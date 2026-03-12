// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ProfileModel {

 String get id; String get fullName; String? get email; String get desiredArea; SkillLevel get currentLevel; bool get onboardingCompleted; String? get selectedTrackId; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of ProfileModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileModelCopyWith<ProfileModel> get copyWith => _$ProfileModelCopyWithImpl<ProfileModel>(this as ProfileModel, _$identity);

  /// Serializes this ProfileModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileModel&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.email, email) || other.email == email)&&(identical(other.desiredArea, desiredArea) || other.desiredArea == desiredArea)&&(identical(other.currentLevel, currentLevel) || other.currentLevel == currentLevel)&&(identical(other.onboardingCompleted, onboardingCompleted) || other.onboardingCompleted == onboardingCompleted)&&(identical(other.selectedTrackId, selectedTrackId) || other.selectedTrackId == selectedTrackId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fullName,email,desiredArea,currentLevel,onboardingCompleted,selectedTrackId,createdAt,updatedAt);

@override
String toString() {
  return 'ProfileModel(id: $id, fullName: $fullName, email: $email, desiredArea: $desiredArea, currentLevel: $currentLevel, onboardingCompleted: $onboardingCompleted, selectedTrackId: $selectedTrackId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ProfileModelCopyWith<$Res>  {
  factory $ProfileModelCopyWith(ProfileModel value, $Res Function(ProfileModel) _then) = _$ProfileModelCopyWithImpl;
@useResult
$Res call({
 String id, String fullName, String? email, String desiredArea, SkillLevel currentLevel, bool onboardingCompleted, String? selectedTrackId, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$ProfileModelCopyWithImpl<$Res>
    implements $ProfileModelCopyWith<$Res> {
  _$ProfileModelCopyWithImpl(this._self, this._then);

  final ProfileModel _self;
  final $Res Function(ProfileModel) _then;

/// Create a copy of ProfileModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? fullName = null,Object? email = freezed,Object? desiredArea = null,Object? currentLevel = null,Object? onboardingCompleted = null,Object? selectedTrackId = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,desiredArea: null == desiredArea ? _self.desiredArea : desiredArea // ignore: cast_nullable_to_non_nullable
as String,currentLevel: null == currentLevel ? _self.currentLevel : currentLevel // ignore: cast_nullable_to_non_nullable
as SkillLevel,onboardingCompleted: null == onboardingCompleted ? _self.onboardingCompleted : onboardingCompleted // ignore: cast_nullable_to_non_nullable
as bool,selectedTrackId: freezed == selectedTrackId ? _self.selectedTrackId : selectedTrackId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileModel].
extension ProfileModelPatterns on ProfileModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileModel value)  $default,){
final _that = this;
switch (_that) {
case _ProfileModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String fullName,  String? email,  String desiredArea,  SkillLevel currentLevel,  bool onboardingCompleted,  String? selectedTrackId,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileModel() when $default != null:
return $default(_that.id,_that.fullName,_that.email,_that.desiredArea,_that.currentLevel,_that.onboardingCompleted,_that.selectedTrackId,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String fullName,  String? email,  String desiredArea,  SkillLevel currentLevel,  bool onboardingCompleted,  String? selectedTrackId,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ProfileModel():
return $default(_that.id,_that.fullName,_that.email,_that.desiredArea,_that.currentLevel,_that.onboardingCompleted,_that.selectedTrackId,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String fullName,  String? email,  String desiredArea,  SkillLevel currentLevel,  bool onboardingCompleted,  String? selectedTrackId,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ProfileModel() when $default != null:
return $default(_that.id,_that.fullName,_that.email,_that.desiredArea,_that.currentLevel,_that.onboardingCompleted,_that.selectedTrackId,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _ProfileModel implements ProfileModel {
  const _ProfileModel({required this.id, required this.fullName, this.email, required this.desiredArea, required this.currentLevel, required this.onboardingCompleted, this.selectedTrackId, required this.createdAt, required this.updatedAt});
  factory _ProfileModel.fromJson(Map<String, dynamic> json) => _$ProfileModelFromJson(json);

@override final  String id;
@override final  String fullName;
@override final  String? email;
@override final  String desiredArea;
@override final  SkillLevel currentLevel;
@override final  bool onboardingCompleted;
@override final  String? selectedTrackId;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of ProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileModelCopyWith<_ProfileModel> get copyWith => __$ProfileModelCopyWithImpl<_ProfileModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileModel&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.email, email) || other.email == email)&&(identical(other.desiredArea, desiredArea) || other.desiredArea == desiredArea)&&(identical(other.currentLevel, currentLevel) || other.currentLevel == currentLevel)&&(identical(other.onboardingCompleted, onboardingCompleted) || other.onboardingCompleted == onboardingCompleted)&&(identical(other.selectedTrackId, selectedTrackId) || other.selectedTrackId == selectedTrackId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,fullName,email,desiredArea,currentLevel,onboardingCompleted,selectedTrackId,createdAt,updatedAt);

@override
String toString() {
  return 'ProfileModel(id: $id, fullName: $fullName, email: $email, desiredArea: $desiredArea, currentLevel: $currentLevel, onboardingCompleted: $onboardingCompleted, selectedTrackId: $selectedTrackId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ProfileModelCopyWith<$Res> implements $ProfileModelCopyWith<$Res> {
  factory _$ProfileModelCopyWith(_ProfileModel value, $Res Function(_ProfileModel) _then) = __$ProfileModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String fullName, String? email, String desiredArea, SkillLevel currentLevel, bool onboardingCompleted, String? selectedTrackId, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$ProfileModelCopyWithImpl<$Res>
    implements _$ProfileModelCopyWith<$Res> {
  __$ProfileModelCopyWithImpl(this._self, this._then);

  final _ProfileModel _self;
  final $Res Function(_ProfileModel) _then;

/// Create a copy of ProfileModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fullName = null,Object? email = freezed,Object? desiredArea = null,Object? currentLevel = null,Object? onboardingCompleted = null,Object? selectedTrackId = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_ProfileModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,fullName: null == fullName ? _self.fullName : fullName // ignore: cast_nullable_to_non_nullable
as String,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,desiredArea: null == desiredArea ? _self.desiredArea : desiredArea // ignore: cast_nullable_to_non_nullable
as String,currentLevel: null == currentLevel ? _self.currentLevel : currentLevel // ignore: cast_nullable_to_non_nullable
as SkillLevel,onboardingCompleted: null == onboardingCompleted ? _self.onboardingCompleted : onboardingCompleted // ignore: cast_nullable_to_non_nullable
as bool,selectedTrackId: freezed == selectedTrackId ? _self.selectedTrackId : selectedTrackId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$UserGoalModel {

 String get id; String get userId; String get primaryGoal; String get desiredArea; FocusType get focusType; int get hoursPerDay; int get daysPerWeek; DateTime get deadline; SkillLevel get currentLevel; String get generatedPlan; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of UserGoalModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserGoalModelCopyWith<UserGoalModel> get copyWith => _$UserGoalModelCopyWithImpl<UserGoalModel>(this as UserGoalModel, _$identity);

  /// Serializes this UserGoalModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserGoalModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.primaryGoal, primaryGoal) || other.primaryGoal == primaryGoal)&&(identical(other.desiredArea, desiredArea) || other.desiredArea == desiredArea)&&(identical(other.focusType, focusType) || other.focusType == focusType)&&(identical(other.hoursPerDay, hoursPerDay) || other.hoursPerDay == hoursPerDay)&&(identical(other.daysPerWeek, daysPerWeek) || other.daysPerWeek == daysPerWeek)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.currentLevel, currentLevel) || other.currentLevel == currentLevel)&&(identical(other.generatedPlan, generatedPlan) || other.generatedPlan == generatedPlan)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,primaryGoal,desiredArea,focusType,hoursPerDay,daysPerWeek,deadline,currentLevel,generatedPlan,createdAt,updatedAt);

@override
String toString() {
  return 'UserGoalModel(id: $id, userId: $userId, primaryGoal: $primaryGoal, desiredArea: $desiredArea, focusType: $focusType, hoursPerDay: $hoursPerDay, daysPerWeek: $daysPerWeek, deadline: $deadline, currentLevel: $currentLevel, generatedPlan: $generatedPlan, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $UserGoalModelCopyWith<$Res>  {
  factory $UserGoalModelCopyWith(UserGoalModel value, $Res Function(UserGoalModel) _then) = _$UserGoalModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String primaryGoal, String desiredArea, FocusType focusType, int hoursPerDay, int daysPerWeek, DateTime deadline, SkillLevel currentLevel, String generatedPlan, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$UserGoalModelCopyWithImpl<$Res>
    implements $UserGoalModelCopyWith<$Res> {
  _$UserGoalModelCopyWithImpl(this._self, this._then);

  final UserGoalModel _self;
  final $Res Function(UserGoalModel) _then;

/// Create a copy of UserGoalModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? primaryGoal = null,Object? desiredArea = null,Object? focusType = null,Object? hoursPerDay = null,Object? daysPerWeek = null,Object? deadline = null,Object? currentLevel = null,Object? generatedPlan = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,primaryGoal: null == primaryGoal ? _self.primaryGoal : primaryGoal // ignore: cast_nullable_to_non_nullable
as String,desiredArea: null == desiredArea ? _self.desiredArea : desiredArea // ignore: cast_nullable_to_non_nullable
as String,focusType: null == focusType ? _self.focusType : focusType // ignore: cast_nullable_to_non_nullable
as FocusType,hoursPerDay: null == hoursPerDay ? _self.hoursPerDay : hoursPerDay // ignore: cast_nullable_to_non_nullable
as int,daysPerWeek: null == daysPerWeek ? _self.daysPerWeek : daysPerWeek // ignore: cast_nullable_to_non_nullable
as int,deadline: null == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime,currentLevel: null == currentLevel ? _self.currentLevel : currentLevel // ignore: cast_nullable_to_non_nullable
as SkillLevel,generatedPlan: null == generatedPlan ? _self.generatedPlan : generatedPlan // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [UserGoalModel].
extension UserGoalModelPatterns on UserGoalModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserGoalModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserGoalModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserGoalModel value)  $default,){
final _that = this;
switch (_that) {
case _UserGoalModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserGoalModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserGoalModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String primaryGoal,  String desiredArea,  FocusType focusType,  int hoursPerDay,  int daysPerWeek,  DateTime deadline,  SkillLevel currentLevel,  String generatedPlan,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserGoalModel() when $default != null:
return $default(_that.id,_that.userId,_that.primaryGoal,_that.desiredArea,_that.focusType,_that.hoursPerDay,_that.daysPerWeek,_that.deadline,_that.currentLevel,_that.generatedPlan,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String primaryGoal,  String desiredArea,  FocusType focusType,  int hoursPerDay,  int daysPerWeek,  DateTime deadline,  SkillLevel currentLevel,  String generatedPlan,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _UserGoalModel():
return $default(_that.id,_that.userId,_that.primaryGoal,_that.desiredArea,_that.focusType,_that.hoursPerDay,_that.daysPerWeek,_that.deadline,_that.currentLevel,_that.generatedPlan,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String primaryGoal,  String desiredArea,  FocusType focusType,  int hoursPerDay,  int daysPerWeek,  DateTime deadline,  SkillLevel currentLevel,  String generatedPlan,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _UserGoalModel() when $default != null:
return $default(_that.id,_that.userId,_that.primaryGoal,_that.desiredArea,_that.focusType,_that.hoursPerDay,_that.daysPerWeek,_that.deadline,_that.currentLevel,_that.generatedPlan,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _UserGoalModel implements UserGoalModel {
  const _UserGoalModel({required this.id, required this.userId, required this.primaryGoal, required this.desiredArea, required this.focusType, required this.hoursPerDay, required this.daysPerWeek, required this.deadline, required this.currentLevel, required this.generatedPlan, required this.createdAt, required this.updatedAt});
  factory _UserGoalModel.fromJson(Map<String, dynamic> json) => _$UserGoalModelFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String primaryGoal;
@override final  String desiredArea;
@override final  FocusType focusType;
@override final  int hoursPerDay;
@override final  int daysPerWeek;
@override final  DateTime deadline;
@override final  SkillLevel currentLevel;
@override final  String generatedPlan;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of UserGoalModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserGoalModelCopyWith<_UserGoalModel> get copyWith => __$UserGoalModelCopyWithImpl<_UserGoalModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserGoalModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserGoalModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.primaryGoal, primaryGoal) || other.primaryGoal == primaryGoal)&&(identical(other.desiredArea, desiredArea) || other.desiredArea == desiredArea)&&(identical(other.focusType, focusType) || other.focusType == focusType)&&(identical(other.hoursPerDay, hoursPerDay) || other.hoursPerDay == hoursPerDay)&&(identical(other.daysPerWeek, daysPerWeek) || other.daysPerWeek == daysPerWeek)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.currentLevel, currentLevel) || other.currentLevel == currentLevel)&&(identical(other.generatedPlan, generatedPlan) || other.generatedPlan == generatedPlan)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,primaryGoal,desiredArea,focusType,hoursPerDay,daysPerWeek,deadline,currentLevel,generatedPlan,createdAt,updatedAt);

@override
String toString() {
  return 'UserGoalModel(id: $id, userId: $userId, primaryGoal: $primaryGoal, desiredArea: $desiredArea, focusType: $focusType, hoursPerDay: $hoursPerDay, daysPerWeek: $daysPerWeek, deadline: $deadline, currentLevel: $currentLevel, generatedPlan: $generatedPlan, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$UserGoalModelCopyWith<$Res> implements $UserGoalModelCopyWith<$Res> {
  factory _$UserGoalModelCopyWith(_UserGoalModel value, $Res Function(_UserGoalModel) _then) = __$UserGoalModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String primaryGoal, String desiredArea, FocusType focusType, int hoursPerDay, int daysPerWeek, DateTime deadline, SkillLevel currentLevel, String generatedPlan, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$UserGoalModelCopyWithImpl<$Res>
    implements _$UserGoalModelCopyWith<$Res> {
  __$UserGoalModelCopyWithImpl(this._self, this._then);

  final _UserGoalModel _self;
  final $Res Function(_UserGoalModel) _then;

/// Create a copy of UserGoalModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? primaryGoal = null,Object? desiredArea = null,Object? focusType = null,Object? hoursPerDay = null,Object? daysPerWeek = null,Object? deadline = null,Object? currentLevel = null,Object? generatedPlan = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_UserGoalModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,primaryGoal: null == primaryGoal ? _self.primaryGoal : primaryGoal // ignore: cast_nullable_to_non_nullable
as String,desiredArea: null == desiredArea ? _self.desiredArea : desiredArea // ignore: cast_nullable_to_non_nullable
as String,focusType: null == focusType ? _self.focusType : focusType // ignore: cast_nullable_to_non_nullable
as FocusType,hoursPerDay: null == hoursPerDay ? _self.hoursPerDay : hoursPerDay // ignore: cast_nullable_to_non_nullable
as int,daysPerWeek: null == daysPerWeek ? _self.daysPerWeek : daysPerWeek // ignore: cast_nullable_to_non_nullable
as int,deadline: null == deadline ? _self.deadline : deadline // ignore: cast_nullable_to_non_nullable
as DateTime,currentLevel: null == currentLevel ? _self.currentLevel : currentLevel // ignore: cast_nullable_to_non_nullable
as SkillLevel,generatedPlan: null == generatedPlan ? _self.generatedPlan : generatedPlan // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$StudyTrackModel {

 String get id; String get name; String get description; String get iconKey; String get colorHex; String get roadmapSummary; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of StudyTrackModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudyTrackModelCopyWith<StudyTrackModel> get copyWith => _$StudyTrackModelCopyWithImpl<StudyTrackModel>(this as StudyTrackModel, _$identity);

  /// Serializes this StudyTrackModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudyTrackModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.iconKey, iconKey) || other.iconKey == iconKey)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&(identical(other.roadmapSummary, roadmapSummary) || other.roadmapSummary == roadmapSummary)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,iconKey,colorHex,roadmapSummary,createdAt,updatedAt);

@override
String toString() {
  return 'StudyTrackModel(id: $id, name: $name, description: $description, iconKey: $iconKey, colorHex: $colorHex, roadmapSummary: $roadmapSummary, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $StudyTrackModelCopyWith<$Res>  {
  factory $StudyTrackModelCopyWith(StudyTrackModel value, $Res Function(StudyTrackModel) _then) = _$StudyTrackModelCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description, String iconKey, String colorHex, String roadmapSummary, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$StudyTrackModelCopyWithImpl<$Res>
    implements $StudyTrackModelCopyWith<$Res> {
  _$StudyTrackModelCopyWithImpl(this._self, this._then);

  final StudyTrackModel _self;
  final $Res Function(StudyTrackModel) _then;

/// Create a copy of StudyTrackModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? description = null,Object? iconKey = null,Object? colorHex = null,Object? roadmapSummary = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,iconKey: null == iconKey ? _self.iconKey : iconKey // ignore: cast_nullable_to_non_nullable
as String,colorHex: null == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String,roadmapSummary: null == roadmapSummary ? _self.roadmapSummary : roadmapSummary // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [StudyTrackModel].
extension StudyTrackModelPatterns on StudyTrackModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudyTrackModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudyTrackModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudyTrackModel value)  $default,){
final _that = this;
switch (_that) {
case _StudyTrackModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudyTrackModel value)?  $default,){
final _that = this;
switch (_that) {
case _StudyTrackModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String description,  String iconKey,  String colorHex,  String roadmapSummary,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudyTrackModel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.iconKey,_that.colorHex,_that.roadmapSummary,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String description,  String iconKey,  String colorHex,  String roadmapSummary,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _StudyTrackModel():
return $default(_that.id,_that.name,_that.description,_that.iconKey,_that.colorHex,_that.roadmapSummary,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String description,  String iconKey,  String colorHex,  String roadmapSummary,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _StudyTrackModel() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.iconKey,_that.colorHex,_that.roadmapSummary,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _StudyTrackModel implements StudyTrackModel {
  const _StudyTrackModel({required this.id, required this.name, required this.description, required this.iconKey, required this.colorHex, required this.roadmapSummary, required this.createdAt, required this.updatedAt});
  factory _StudyTrackModel.fromJson(Map<String, dynamic> json) => _$StudyTrackModelFromJson(json);

@override final  String id;
@override final  String name;
@override final  String description;
@override final  String iconKey;
@override final  String colorHex;
@override final  String roadmapSummary;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of StudyTrackModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudyTrackModelCopyWith<_StudyTrackModel> get copyWith => __$StudyTrackModelCopyWithImpl<_StudyTrackModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudyTrackModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudyTrackModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.iconKey, iconKey) || other.iconKey == iconKey)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&(identical(other.roadmapSummary, roadmapSummary) || other.roadmapSummary == roadmapSummary)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,name,description,iconKey,colorHex,roadmapSummary,createdAt,updatedAt);

@override
String toString() {
  return 'StudyTrackModel(id: $id, name: $name, description: $description, iconKey: $iconKey, colorHex: $colorHex, roadmapSummary: $roadmapSummary, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$StudyTrackModelCopyWith<$Res> implements $StudyTrackModelCopyWith<$Res> {
  factory _$StudyTrackModelCopyWith(_StudyTrackModel value, $Res Function(_StudyTrackModel) _then) = __$StudyTrackModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String description, String iconKey, String colorHex, String roadmapSummary, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$StudyTrackModelCopyWithImpl<$Res>
    implements _$StudyTrackModelCopyWith<$Res> {
  __$StudyTrackModelCopyWithImpl(this._self, this._then);

  final _StudyTrackModel _self;
  final $Res Function(_StudyTrackModel) _then;

/// Create a copy of StudyTrackModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? iconKey = null,Object? colorHex = null,Object? roadmapSummary = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_StudyTrackModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,iconKey: null == iconKey ? _self.iconKey : iconKey // ignore: cast_nullable_to_non_nullable
as String,colorHex: null == colorHex ? _self.colorHex : colorHex // ignore: cast_nullable_to_non_nullable
as String,roadmapSummary: null == roadmapSummary ? _self.roadmapSummary : roadmapSummary // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$StudySkillModel {

 String get id; String get trackId; String get name; String get description; SkillLevel get targetLevel; int get sortOrder; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of StudySkillModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudySkillModelCopyWith<StudySkillModel> get copyWith => _$StudySkillModelCopyWithImpl<StudySkillModel>(this as StudySkillModel, _$identity);

  /// Serializes this StudySkillModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudySkillModel&&(identical(other.id, id) || other.id == id)&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.targetLevel, targetLevel) || other.targetLevel == targetLevel)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,trackId,name,description,targetLevel,sortOrder,createdAt,updatedAt);

@override
String toString() {
  return 'StudySkillModel(id: $id, trackId: $trackId, name: $name, description: $description, targetLevel: $targetLevel, sortOrder: $sortOrder, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $StudySkillModelCopyWith<$Res>  {
  factory $StudySkillModelCopyWith(StudySkillModel value, $Res Function(StudySkillModel) _then) = _$StudySkillModelCopyWithImpl;
@useResult
$Res call({
 String id, String trackId, String name, String description, SkillLevel targetLevel, int sortOrder, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$StudySkillModelCopyWithImpl<$Res>
    implements $StudySkillModelCopyWith<$Res> {
  _$StudySkillModelCopyWithImpl(this._self, this._then);

  final StudySkillModel _self;
  final $Res Function(StudySkillModel) _then;

/// Create a copy of StudySkillModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? trackId = null,Object? name = null,Object? description = null,Object? targetLevel = null,Object? sortOrder = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,trackId: null == trackId ? _self.trackId : trackId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,targetLevel: null == targetLevel ? _self.targetLevel : targetLevel // ignore: cast_nullable_to_non_nullable
as SkillLevel,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [StudySkillModel].
extension StudySkillModelPatterns on StudySkillModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudySkillModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudySkillModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudySkillModel value)  $default,){
final _that = this;
switch (_that) {
case _StudySkillModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudySkillModel value)?  $default,){
final _that = this;
switch (_that) {
case _StudySkillModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String trackId,  String name,  String description,  SkillLevel targetLevel,  int sortOrder,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudySkillModel() when $default != null:
return $default(_that.id,_that.trackId,_that.name,_that.description,_that.targetLevel,_that.sortOrder,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String trackId,  String name,  String description,  SkillLevel targetLevel,  int sortOrder,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _StudySkillModel():
return $default(_that.id,_that.trackId,_that.name,_that.description,_that.targetLevel,_that.sortOrder,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String trackId,  String name,  String description,  SkillLevel targetLevel,  int sortOrder,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _StudySkillModel() when $default != null:
return $default(_that.id,_that.trackId,_that.name,_that.description,_that.targetLevel,_that.sortOrder,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _StudySkillModel implements StudySkillModel {
  const _StudySkillModel({required this.id, required this.trackId, required this.name, required this.description, required this.targetLevel, required this.sortOrder, required this.createdAt, required this.updatedAt});
  factory _StudySkillModel.fromJson(Map<String, dynamic> json) => _$StudySkillModelFromJson(json);

@override final  String id;
@override final  String trackId;
@override final  String name;
@override final  String description;
@override final  SkillLevel targetLevel;
@override final  int sortOrder;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of StudySkillModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudySkillModelCopyWith<_StudySkillModel> get copyWith => __$StudySkillModelCopyWithImpl<_StudySkillModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudySkillModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudySkillModel&&(identical(other.id, id) || other.id == id)&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.targetLevel, targetLevel) || other.targetLevel == targetLevel)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,trackId,name,description,targetLevel,sortOrder,createdAt,updatedAt);

@override
String toString() {
  return 'StudySkillModel(id: $id, trackId: $trackId, name: $name, description: $description, targetLevel: $targetLevel, sortOrder: $sortOrder, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$StudySkillModelCopyWith<$Res> implements $StudySkillModelCopyWith<$Res> {
  factory _$StudySkillModelCopyWith(_StudySkillModel value, $Res Function(_StudySkillModel) _then) = __$StudySkillModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String trackId, String name, String description, SkillLevel targetLevel, int sortOrder, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$StudySkillModelCopyWithImpl<$Res>
    implements _$StudySkillModelCopyWith<$Res> {
  __$StudySkillModelCopyWithImpl(this._self, this._then);

  final _StudySkillModel _self;
  final $Res Function(_StudySkillModel) _then;

/// Create a copy of StudySkillModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? trackId = null,Object? name = null,Object? description = null,Object? targetLevel = null,Object? sortOrder = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_StudySkillModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,trackId: null == trackId ? _self.trackId : trackId // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,targetLevel: null == targetLevel ? _self.targetLevel : targetLevel // ignore: cast_nullable_to_non_nullable
as SkillLevel,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$UserSkillProgressModel {

 String get id; String get userId; String get skillId; double get progressPercent; DateTime? get lastStudiedAt; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of UserSkillProgressModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserSkillProgressModelCopyWith<UserSkillProgressModel> get copyWith => _$UserSkillProgressModelCopyWithImpl<UserSkillProgressModel>(this as UserSkillProgressModel, _$identity);

  /// Serializes this UserSkillProgressModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserSkillProgressModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.skillId, skillId) || other.skillId == skillId)&&(identical(other.progressPercent, progressPercent) || other.progressPercent == progressPercent)&&(identical(other.lastStudiedAt, lastStudiedAt) || other.lastStudiedAt == lastStudiedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,skillId,progressPercent,lastStudiedAt,createdAt,updatedAt);

@override
String toString() {
  return 'UserSkillProgressModel(id: $id, userId: $userId, skillId: $skillId, progressPercent: $progressPercent, lastStudiedAt: $lastStudiedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $UserSkillProgressModelCopyWith<$Res>  {
  factory $UserSkillProgressModelCopyWith(UserSkillProgressModel value, $Res Function(UserSkillProgressModel) _then) = _$UserSkillProgressModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String skillId, double progressPercent, DateTime? lastStudiedAt, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$UserSkillProgressModelCopyWithImpl<$Res>
    implements $UserSkillProgressModelCopyWith<$Res> {
  _$UserSkillProgressModelCopyWithImpl(this._self, this._then);

  final UserSkillProgressModel _self;
  final $Res Function(UserSkillProgressModel) _then;

/// Create a copy of UserSkillProgressModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? skillId = null,Object? progressPercent = null,Object? lastStudiedAt = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,skillId: null == skillId ? _self.skillId : skillId // ignore: cast_nullable_to_non_nullable
as String,progressPercent: null == progressPercent ? _self.progressPercent : progressPercent // ignore: cast_nullable_to_non_nullable
as double,lastStudiedAt: freezed == lastStudiedAt ? _self.lastStudiedAt : lastStudiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [UserSkillProgressModel].
extension UserSkillProgressModelPatterns on UserSkillProgressModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserSkillProgressModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserSkillProgressModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserSkillProgressModel value)  $default,){
final _that = this;
switch (_that) {
case _UserSkillProgressModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserSkillProgressModel value)?  $default,){
final _that = this;
switch (_that) {
case _UserSkillProgressModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String skillId,  double progressPercent,  DateTime? lastStudiedAt,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _UserSkillProgressModel() when $default != null:
return $default(_that.id,_that.userId,_that.skillId,_that.progressPercent,_that.lastStudiedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String skillId,  double progressPercent,  DateTime? lastStudiedAt,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _UserSkillProgressModel():
return $default(_that.id,_that.userId,_that.skillId,_that.progressPercent,_that.lastStudiedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String skillId,  double progressPercent,  DateTime? lastStudiedAt,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _UserSkillProgressModel() when $default != null:
return $default(_that.id,_that.userId,_that.skillId,_that.progressPercent,_that.lastStudiedAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _UserSkillProgressModel implements UserSkillProgressModel {
  const _UserSkillProgressModel({required this.id, required this.userId, required this.skillId, required this.progressPercent, this.lastStudiedAt, required this.createdAt, required this.updatedAt});
  factory _UserSkillProgressModel.fromJson(Map<String, dynamic> json) => _$UserSkillProgressModelFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String skillId;
@override final  double progressPercent;
@override final  DateTime? lastStudiedAt;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of UserSkillProgressModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserSkillProgressModelCopyWith<_UserSkillProgressModel> get copyWith => __$UserSkillProgressModelCopyWithImpl<_UserSkillProgressModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$UserSkillProgressModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserSkillProgressModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.skillId, skillId) || other.skillId == skillId)&&(identical(other.progressPercent, progressPercent) || other.progressPercent == progressPercent)&&(identical(other.lastStudiedAt, lastStudiedAt) || other.lastStudiedAt == lastStudiedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,skillId,progressPercent,lastStudiedAt,createdAt,updatedAt);

@override
String toString() {
  return 'UserSkillProgressModel(id: $id, userId: $userId, skillId: $skillId, progressPercent: $progressPercent, lastStudiedAt: $lastStudiedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$UserSkillProgressModelCopyWith<$Res> implements $UserSkillProgressModelCopyWith<$Res> {
  factory _$UserSkillProgressModelCopyWith(_UserSkillProgressModel value, $Res Function(_UserSkillProgressModel) _then) = __$UserSkillProgressModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String skillId, double progressPercent, DateTime? lastStudiedAt, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$UserSkillProgressModelCopyWithImpl<$Res>
    implements _$UserSkillProgressModelCopyWith<$Res> {
  __$UserSkillProgressModelCopyWithImpl(this._self, this._then);

  final _UserSkillProgressModel _self;
  final $Res Function(_UserSkillProgressModel) _then;

/// Create a copy of UserSkillProgressModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? skillId = null,Object? progressPercent = null,Object? lastStudiedAt = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_UserSkillProgressModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,skillId: null == skillId ? _self.skillId : skillId // ignore: cast_nullable_to_non_nullable
as String,progressPercent: null == progressPercent ? _self.progressPercent : progressPercent // ignore: cast_nullable_to_non_nullable
as double,lastStudiedAt: freezed == lastStudiedAt ? _self.lastStudiedAt : lastStudiedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$StudyModuleModel {

 String get id; String get trackId; String get title; String get summary; int get estimatedHours; int get sortOrder; bool get isCore; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of StudyModuleModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudyModuleModelCopyWith<StudyModuleModel> get copyWith => _$StudyModuleModelCopyWithImpl<StudyModuleModel>(this as StudyModuleModel, _$identity);

  /// Serializes this StudyModuleModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudyModuleModel&&(identical(other.id, id) || other.id == id)&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.title, title) || other.title == title)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.estimatedHours, estimatedHours) || other.estimatedHours == estimatedHours)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isCore, isCore) || other.isCore == isCore)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,trackId,title,summary,estimatedHours,sortOrder,isCore,createdAt,updatedAt);

@override
String toString() {
  return 'StudyModuleModel(id: $id, trackId: $trackId, title: $title, summary: $summary, estimatedHours: $estimatedHours, sortOrder: $sortOrder, isCore: $isCore, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $StudyModuleModelCopyWith<$Res>  {
  factory $StudyModuleModelCopyWith(StudyModuleModel value, $Res Function(StudyModuleModel) _then) = _$StudyModuleModelCopyWithImpl;
@useResult
$Res call({
 String id, String trackId, String title, String summary, int estimatedHours, int sortOrder, bool isCore, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$StudyModuleModelCopyWithImpl<$Res>
    implements $StudyModuleModelCopyWith<$Res> {
  _$StudyModuleModelCopyWithImpl(this._self, this._then);

  final StudyModuleModel _self;
  final $Res Function(StudyModuleModel) _then;

/// Create a copy of StudyModuleModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? trackId = null,Object? title = null,Object? summary = null,Object? estimatedHours = null,Object? sortOrder = null,Object? isCore = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,trackId: null == trackId ? _self.trackId : trackId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,estimatedHours: null == estimatedHours ? _self.estimatedHours : estimatedHours // ignore: cast_nullable_to_non_nullable
as int,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isCore: null == isCore ? _self.isCore : isCore // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [StudyModuleModel].
extension StudyModuleModelPatterns on StudyModuleModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudyModuleModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudyModuleModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudyModuleModel value)  $default,){
final _that = this;
switch (_that) {
case _StudyModuleModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudyModuleModel value)?  $default,){
final _that = this;
switch (_that) {
case _StudyModuleModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String trackId,  String title,  String summary,  int estimatedHours,  int sortOrder,  bool isCore,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudyModuleModel() when $default != null:
return $default(_that.id,_that.trackId,_that.title,_that.summary,_that.estimatedHours,_that.sortOrder,_that.isCore,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String trackId,  String title,  String summary,  int estimatedHours,  int sortOrder,  bool isCore,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _StudyModuleModel():
return $default(_that.id,_that.trackId,_that.title,_that.summary,_that.estimatedHours,_that.sortOrder,_that.isCore,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String trackId,  String title,  String summary,  int estimatedHours,  int sortOrder,  bool isCore,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _StudyModuleModel() when $default != null:
return $default(_that.id,_that.trackId,_that.title,_that.summary,_that.estimatedHours,_that.sortOrder,_that.isCore,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _StudyModuleModel implements StudyModuleModel {
  const _StudyModuleModel({required this.id, required this.trackId, required this.title, required this.summary, required this.estimatedHours, required this.sortOrder, required this.isCore, required this.createdAt, required this.updatedAt});
  factory _StudyModuleModel.fromJson(Map<String, dynamic> json) => _$StudyModuleModelFromJson(json);

@override final  String id;
@override final  String trackId;
@override final  String title;
@override final  String summary;
@override final  int estimatedHours;
@override final  int sortOrder;
@override final  bool isCore;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of StudyModuleModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudyModuleModelCopyWith<_StudyModuleModel> get copyWith => __$StudyModuleModelCopyWithImpl<_StudyModuleModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudyModuleModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudyModuleModel&&(identical(other.id, id) || other.id == id)&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.title, title) || other.title == title)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.estimatedHours, estimatedHours) || other.estimatedHours == estimatedHours)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isCore, isCore) || other.isCore == isCore)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,trackId,title,summary,estimatedHours,sortOrder,isCore,createdAt,updatedAt);

@override
String toString() {
  return 'StudyModuleModel(id: $id, trackId: $trackId, title: $title, summary: $summary, estimatedHours: $estimatedHours, sortOrder: $sortOrder, isCore: $isCore, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$StudyModuleModelCopyWith<$Res> implements $StudyModuleModelCopyWith<$Res> {
  factory _$StudyModuleModelCopyWith(_StudyModuleModel value, $Res Function(_StudyModuleModel) _then) = __$StudyModuleModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String trackId, String title, String summary, int estimatedHours, int sortOrder, bool isCore, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$StudyModuleModelCopyWithImpl<$Res>
    implements _$StudyModuleModelCopyWith<$Res> {
  __$StudyModuleModelCopyWithImpl(this._self, this._then);

  final _StudyModuleModel _self;
  final $Res Function(_StudyModuleModel) _then;

/// Create a copy of StudyModuleModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? trackId = null,Object? title = null,Object? summary = null,Object? estimatedHours = null,Object? sortOrder = null,Object? isCore = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_StudyModuleModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,trackId: null == trackId ? _self.trackId : trackId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,estimatedHours: null == estimatedHours ? _self.estimatedHours : estimatedHours // ignore: cast_nullable_to_non_nullable
as int,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,isCore: null == isCore ? _self.isCore : isCore // ignore: cast_nullable_to_non_nullable
as bool,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$StudySessionModel {

 String get id; String get userId; String? get trackId; String? get skillId; String? get moduleId; SessionType get type; DateTime get startTime; DateTime get endTime; int get durationMinutes; String get notes; int get productivityScore; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of StudySessionModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudySessionModelCopyWith<StudySessionModel> get copyWith => _$StudySessionModelCopyWithImpl<StudySessionModel>(this as StudySessionModel, _$identity);

  /// Serializes this StudySessionModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudySessionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.skillId, skillId) || other.skillId == skillId)&&(identical(other.moduleId, moduleId) || other.moduleId == moduleId)&&(identical(other.type, type) || other.type == type)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.productivityScore, productivityScore) || other.productivityScore == productivityScore)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,trackId,skillId,moduleId,type,startTime,endTime,durationMinutes,notes,productivityScore,createdAt,updatedAt);

@override
String toString() {
  return 'StudySessionModel(id: $id, userId: $userId, trackId: $trackId, skillId: $skillId, moduleId: $moduleId, type: $type, startTime: $startTime, endTime: $endTime, durationMinutes: $durationMinutes, notes: $notes, productivityScore: $productivityScore, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $StudySessionModelCopyWith<$Res>  {
  factory $StudySessionModelCopyWith(StudySessionModel value, $Res Function(StudySessionModel) _then) = _$StudySessionModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String? trackId, String? skillId, String? moduleId, SessionType type, DateTime startTime, DateTime endTime, int durationMinutes, String notes, int productivityScore, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$StudySessionModelCopyWithImpl<$Res>
    implements $StudySessionModelCopyWith<$Res> {
  _$StudySessionModelCopyWithImpl(this._self, this._then);

  final StudySessionModel _self;
  final $Res Function(StudySessionModel) _then;

/// Create a copy of StudySessionModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? trackId = freezed,Object? skillId = freezed,Object? moduleId = freezed,Object? type = null,Object? startTime = null,Object? endTime = null,Object? durationMinutes = null,Object? notes = null,Object? productivityScore = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,trackId: freezed == trackId ? _self.trackId : trackId // ignore: cast_nullable_to_non_nullable
as String?,skillId: freezed == skillId ? _self.skillId : skillId // ignore: cast_nullable_to_non_nullable
as String?,moduleId: freezed == moduleId ? _self.moduleId : moduleId // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as SessionType,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,productivityScore: null == productivityScore ? _self.productivityScore : productivityScore // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [StudySessionModel].
extension StudySessionModelPatterns on StudySessionModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudySessionModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudySessionModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudySessionModel value)  $default,){
final _that = this;
switch (_that) {
case _StudySessionModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudySessionModel value)?  $default,){
final _that = this;
switch (_that) {
case _StudySessionModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String? trackId,  String? skillId,  String? moduleId,  SessionType type,  DateTime startTime,  DateTime endTime,  int durationMinutes,  String notes,  int productivityScore,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudySessionModel() when $default != null:
return $default(_that.id,_that.userId,_that.trackId,_that.skillId,_that.moduleId,_that.type,_that.startTime,_that.endTime,_that.durationMinutes,_that.notes,_that.productivityScore,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String? trackId,  String? skillId,  String? moduleId,  SessionType type,  DateTime startTime,  DateTime endTime,  int durationMinutes,  String notes,  int productivityScore,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _StudySessionModel():
return $default(_that.id,_that.userId,_that.trackId,_that.skillId,_that.moduleId,_that.type,_that.startTime,_that.endTime,_that.durationMinutes,_that.notes,_that.productivityScore,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String? trackId,  String? skillId,  String? moduleId,  SessionType type,  DateTime startTime,  DateTime endTime,  int durationMinutes,  String notes,  int productivityScore,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _StudySessionModel() when $default != null:
return $default(_that.id,_that.userId,_that.trackId,_that.skillId,_that.moduleId,_that.type,_that.startTime,_that.endTime,_that.durationMinutes,_that.notes,_that.productivityScore,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _StudySessionModel implements StudySessionModel {
  const _StudySessionModel({required this.id, required this.userId, this.trackId, this.skillId, this.moduleId, required this.type, required this.startTime, required this.endTime, required this.durationMinutes, required this.notes, required this.productivityScore, required this.createdAt, required this.updatedAt});
  factory _StudySessionModel.fromJson(Map<String, dynamic> json) => _$StudySessionModelFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String? trackId;
@override final  String? skillId;
@override final  String? moduleId;
@override final  SessionType type;
@override final  DateTime startTime;
@override final  DateTime endTime;
@override final  int durationMinutes;
@override final  String notes;
@override final  int productivityScore;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of StudySessionModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudySessionModelCopyWith<_StudySessionModel> get copyWith => __$StudySessionModelCopyWithImpl<_StudySessionModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudySessionModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudySessionModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.skillId, skillId) || other.skillId == skillId)&&(identical(other.moduleId, moduleId) || other.moduleId == moduleId)&&(identical(other.type, type) || other.type == type)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.productivityScore, productivityScore) || other.productivityScore == productivityScore)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,trackId,skillId,moduleId,type,startTime,endTime,durationMinutes,notes,productivityScore,createdAt,updatedAt);

@override
String toString() {
  return 'StudySessionModel(id: $id, userId: $userId, trackId: $trackId, skillId: $skillId, moduleId: $moduleId, type: $type, startTime: $startTime, endTime: $endTime, durationMinutes: $durationMinutes, notes: $notes, productivityScore: $productivityScore, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$StudySessionModelCopyWith<$Res> implements $StudySessionModelCopyWith<$Res> {
  factory _$StudySessionModelCopyWith(_StudySessionModel value, $Res Function(_StudySessionModel) _then) = __$StudySessionModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String? trackId, String? skillId, String? moduleId, SessionType type, DateTime startTime, DateTime endTime, int durationMinutes, String notes, int productivityScore, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$StudySessionModelCopyWithImpl<$Res>
    implements _$StudySessionModelCopyWith<$Res> {
  __$StudySessionModelCopyWithImpl(this._self, this._then);

  final _StudySessionModel _self;
  final $Res Function(_StudySessionModel) _then;

/// Create a copy of StudySessionModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? trackId = freezed,Object? skillId = freezed,Object? moduleId = freezed,Object? type = null,Object? startTime = null,Object? endTime = null,Object? durationMinutes = null,Object? notes = null,Object? productivityScore = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_StudySessionModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,trackId: freezed == trackId ? _self.trackId : trackId // ignore: cast_nullable_to_non_nullable
as String?,skillId: freezed == skillId ? _self.skillId : skillId // ignore: cast_nullable_to_non_nullable
as String?,moduleId: freezed == moduleId ? _self.moduleId : moduleId // ignore: cast_nullable_to_non_nullable
as String?,type: null == type ? _self.type : type // ignore: cast_nullable_to_non_nullable
as SessionType,startTime: null == startTime ? _self.startTime : startTime // ignore: cast_nullable_to_non_nullable
as DateTime,endTime: null == endTime ? _self.endTime : endTime // ignore: cast_nullable_to_non_nullable
as DateTime,durationMinutes: null == durationMinutes ? _self.durationMinutes : durationMinutes // ignore: cast_nullable_to_non_nullable
as int,notes: null == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String,productivityScore: null == productivityScore ? _self.productivityScore : productivityScore // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$TaskModel {

 String get id; String get userId; String? get trackId; String? get moduleId; String get title; String get description; TaskPriority get priority; TaskStatus get status; DateTime? get dueDate; DateTime? get completedAt; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of TaskModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskModelCopyWith<TaskModel> get copyWith => _$TaskModelCopyWithImpl<TaskModel>(this as TaskModel, _$identity);

  /// Serializes this TaskModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.moduleId, moduleId) || other.moduleId == moduleId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.status, status) || other.status == status)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,trackId,moduleId,title,description,priority,status,dueDate,completedAt,createdAt,updatedAt);

@override
String toString() {
  return 'TaskModel(id: $id, userId: $userId, trackId: $trackId, moduleId: $moduleId, title: $title, description: $description, priority: $priority, status: $status, dueDate: $dueDate, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $TaskModelCopyWith<$Res>  {
  factory $TaskModelCopyWith(TaskModel value, $Res Function(TaskModel) _then) = _$TaskModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String? trackId, String? moduleId, String title, String description, TaskPriority priority, TaskStatus status, DateTime? dueDate, DateTime? completedAt, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$TaskModelCopyWithImpl<$Res>
    implements $TaskModelCopyWith<$Res> {
  _$TaskModelCopyWithImpl(this._self, this._then);

  final TaskModel _self;
  final $Res Function(TaskModel) _then;

/// Create a copy of TaskModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? trackId = freezed,Object? moduleId = freezed,Object? title = null,Object? description = null,Object? priority = null,Object? status = null,Object? dueDate = freezed,Object? completedAt = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,trackId: freezed == trackId ? _self.trackId : trackId // ignore: cast_nullable_to_non_nullable
as String?,moduleId: freezed == moduleId ? _self.moduleId : moduleId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [TaskModel].
extension TaskModelPatterns on TaskModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskModel value)  $default,){
final _that = this;
switch (_that) {
case _TaskModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskModel value)?  $default,){
final _that = this;
switch (_that) {
case _TaskModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String? trackId,  String? moduleId,  String title,  String description,  TaskPriority priority,  TaskStatus status,  DateTime? dueDate,  DateTime? completedAt,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TaskModel() when $default != null:
return $default(_that.id,_that.userId,_that.trackId,_that.moduleId,_that.title,_that.description,_that.priority,_that.status,_that.dueDate,_that.completedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String? trackId,  String? moduleId,  String title,  String description,  TaskPriority priority,  TaskStatus status,  DateTime? dueDate,  DateTime? completedAt,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _TaskModel():
return $default(_that.id,_that.userId,_that.trackId,_that.moduleId,_that.title,_that.description,_that.priority,_that.status,_that.dueDate,_that.completedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String? trackId,  String? moduleId,  String title,  String description,  TaskPriority priority,  TaskStatus status,  DateTime? dueDate,  DateTime? completedAt,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _TaskModel() when $default != null:
return $default(_that.id,_that.userId,_that.trackId,_that.moduleId,_that.title,_that.description,_that.priority,_that.status,_that.dueDate,_that.completedAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _TaskModel implements TaskModel {
  const _TaskModel({required this.id, required this.userId, this.trackId, this.moduleId, required this.title, required this.description, required this.priority, required this.status, this.dueDate, this.completedAt, required this.createdAt, required this.updatedAt});
  factory _TaskModel.fromJson(Map<String, dynamic> json) => _$TaskModelFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String? trackId;
@override final  String? moduleId;
@override final  String title;
@override final  String description;
@override final  TaskPriority priority;
@override final  TaskStatus status;
@override final  DateTime? dueDate;
@override final  DateTime? completedAt;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of TaskModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskModelCopyWith<_TaskModel> get copyWith => __$TaskModelCopyWithImpl<_TaskModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TaskModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.moduleId, moduleId) || other.moduleId == moduleId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.status, status) || other.status == status)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,trackId,moduleId,title,description,priority,status,dueDate,completedAt,createdAt,updatedAt);

@override
String toString() {
  return 'TaskModel(id: $id, userId: $userId, trackId: $trackId, moduleId: $moduleId, title: $title, description: $description, priority: $priority, status: $status, dueDate: $dueDate, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$TaskModelCopyWith<$Res> implements $TaskModelCopyWith<$Res> {
  factory _$TaskModelCopyWith(_TaskModel value, $Res Function(_TaskModel) _then) = __$TaskModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String? trackId, String? moduleId, String title, String description, TaskPriority priority, TaskStatus status, DateTime? dueDate, DateTime? completedAt, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$TaskModelCopyWithImpl<$Res>
    implements _$TaskModelCopyWith<$Res> {
  __$TaskModelCopyWithImpl(this._self, this._then);

  final _TaskModel _self;
  final $Res Function(_TaskModel) _then;

/// Create a copy of TaskModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? trackId = freezed,Object? moduleId = freezed,Object? title = null,Object? description = null,Object? priority = null,Object? status = null,Object? dueDate = freezed,Object? completedAt = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_TaskModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,trackId: freezed == trackId ? _self.trackId : trackId // ignore: cast_nullable_to_non_nullable
as String?,moduleId: freezed == moduleId ? _self.moduleId : moduleId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,priority: null == priority ? _self.priority : priority // ignore: cast_nullable_to_non_nullable
as TaskPriority,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as TaskStatus,dueDate: freezed == dueDate ? _self.dueDate : dueDate // ignore: cast_nullable_to_non_nullable
as DateTime?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$ReviewModel {

 String get id; String get userId; String? get sessionId; String? get trackId; String? get skillId; String get title; DateTime get scheduledFor; ReviewStatus get status; String get intervalLabel; String? get notes; DateTime? get completedAt; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of ReviewModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewModelCopyWith<ReviewModel> get copyWith => _$ReviewModelCopyWithImpl<ReviewModel>(this as ReviewModel, _$identity);

  /// Serializes this ReviewModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.skillId, skillId) || other.skillId == skillId)&&(identical(other.title, title) || other.title == title)&&(identical(other.scheduledFor, scheduledFor) || other.scheduledFor == scheduledFor)&&(identical(other.status, status) || other.status == status)&&(identical(other.intervalLabel, intervalLabel) || other.intervalLabel == intervalLabel)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,sessionId,trackId,skillId,title,scheduledFor,status,intervalLabel,notes,completedAt,createdAt,updatedAt);

@override
String toString() {
  return 'ReviewModel(id: $id, userId: $userId, sessionId: $sessionId, trackId: $trackId, skillId: $skillId, title: $title, scheduledFor: $scheduledFor, status: $status, intervalLabel: $intervalLabel, notes: $notes, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ReviewModelCopyWith<$Res>  {
  factory $ReviewModelCopyWith(ReviewModel value, $Res Function(ReviewModel) _then) = _$ReviewModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String? sessionId, String? trackId, String? skillId, String title, DateTime scheduledFor, ReviewStatus status, String intervalLabel, String? notes, DateTime? completedAt, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$ReviewModelCopyWithImpl<$Res>
    implements $ReviewModelCopyWith<$Res> {
  _$ReviewModelCopyWithImpl(this._self, this._then);

  final ReviewModel _self;
  final $Res Function(ReviewModel) _then;

/// Create a copy of ReviewModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? sessionId = freezed,Object? trackId = freezed,Object? skillId = freezed,Object? title = null,Object? scheduledFor = null,Object? status = null,Object? intervalLabel = null,Object? notes = freezed,Object? completedAt = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,trackId: freezed == trackId ? _self.trackId : trackId // ignore: cast_nullable_to_non_nullable
as String?,skillId: freezed == skillId ? _self.skillId : skillId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,scheduledFor: null == scheduledFor ? _self.scheduledFor : scheduledFor // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReviewStatus,intervalLabel: null == intervalLabel ? _self.intervalLabel : intervalLabel // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ReviewModel].
extension ReviewModelPatterns on ReviewModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReviewModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReviewModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReviewModel value)  $default,){
final _that = this;
switch (_that) {
case _ReviewModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReviewModel value)?  $default,){
final _that = this;
switch (_that) {
case _ReviewModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String? sessionId,  String? trackId,  String? skillId,  String title,  DateTime scheduledFor,  ReviewStatus status,  String intervalLabel,  String? notes,  DateTime? completedAt,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ReviewModel() when $default != null:
return $default(_that.id,_that.userId,_that.sessionId,_that.trackId,_that.skillId,_that.title,_that.scheduledFor,_that.status,_that.intervalLabel,_that.notes,_that.completedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String? sessionId,  String? trackId,  String? skillId,  String title,  DateTime scheduledFor,  ReviewStatus status,  String intervalLabel,  String? notes,  DateTime? completedAt,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ReviewModel():
return $default(_that.id,_that.userId,_that.sessionId,_that.trackId,_that.skillId,_that.title,_that.scheduledFor,_that.status,_that.intervalLabel,_that.notes,_that.completedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String? sessionId,  String? trackId,  String? skillId,  String title,  DateTime scheduledFor,  ReviewStatus status,  String intervalLabel,  String? notes,  DateTime? completedAt,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ReviewModel() when $default != null:
return $default(_that.id,_that.userId,_that.sessionId,_that.trackId,_that.skillId,_that.title,_that.scheduledFor,_that.status,_that.intervalLabel,_that.notes,_that.completedAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _ReviewModel implements ReviewModel {
  const _ReviewModel({required this.id, required this.userId, this.sessionId, this.trackId, this.skillId, required this.title, required this.scheduledFor, required this.status, required this.intervalLabel, this.notes, this.completedAt, required this.createdAt, required this.updatedAt});
  factory _ReviewModel.fromJson(Map<String, dynamic> json) => _$ReviewModelFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String? sessionId;
@override final  String? trackId;
@override final  String? skillId;
@override final  String title;
@override final  DateTime scheduledFor;
@override final  ReviewStatus status;
@override final  String intervalLabel;
@override final  String? notes;
@override final  DateTime? completedAt;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of ReviewModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewModelCopyWith<_ReviewModel> get copyWith => __$ReviewModelCopyWithImpl<_ReviewModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ReviewModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReviewModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.skillId, skillId) || other.skillId == skillId)&&(identical(other.title, title) || other.title == title)&&(identical(other.scheduledFor, scheduledFor) || other.scheduledFor == scheduledFor)&&(identical(other.status, status) || other.status == status)&&(identical(other.intervalLabel, intervalLabel) || other.intervalLabel == intervalLabel)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,sessionId,trackId,skillId,title,scheduledFor,status,intervalLabel,notes,completedAt,createdAt,updatedAt);

@override
String toString() {
  return 'ReviewModel(id: $id, userId: $userId, sessionId: $sessionId, trackId: $trackId, skillId: $skillId, title: $title, scheduledFor: $scheduledFor, status: $status, intervalLabel: $intervalLabel, notes: $notes, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ReviewModelCopyWith<$Res> implements $ReviewModelCopyWith<$Res> {
  factory _$ReviewModelCopyWith(_ReviewModel value, $Res Function(_ReviewModel) _then) = __$ReviewModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String? sessionId, String? trackId, String? skillId, String title, DateTime scheduledFor, ReviewStatus status, String intervalLabel, String? notes, DateTime? completedAt, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$ReviewModelCopyWithImpl<$Res>
    implements _$ReviewModelCopyWith<$Res> {
  __$ReviewModelCopyWithImpl(this._self, this._then);

  final _ReviewModel _self;
  final $Res Function(_ReviewModel) _then;

/// Create a copy of ReviewModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? sessionId = freezed,Object? trackId = freezed,Object? skillId = freezed,Object? title = null,Object? scheduledFor = null,Object? status = null,Object? intervalLabel = null,Object? notes = freezed,Object? completedAt = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_ReviewModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,sessionId: freezed == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String?,trackId: freezed == trackId ? _self.trackId : trackId // ignore: cast_nullable_to_non_nullable
as String?,skillId: freezed == skillId ? _self.skillId : skillId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,scheduledFor: null == scheduledFor ? _self.scheduledFor : scheduledFor // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ReviewStatus,intervalLabel: null == intervalLabel ? _self.intervalLabel : intervalLabel // ignore: cast_nullable_to_non_nullable
as String,notes: freezed == notes ? _self.notes : notes // ignore: cast_nullable_to_non_nullable
as String?,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$ProjectModel {

 String get id; String get userId; String? get trackId; String get title; String get scope; String get description; String? get repositoryUrl; String? get documentationUrl; String? get videoUrl; ProjectStatus get status; double get progressPercent; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of ProjectModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectModelCopyWith<ProjectModel> get copyWith => _$ProjectModelCopyWithImpl<ProjectModel>(this as ProjectModel, _$identity);

  /// Serializes this ProjectModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.title, title) || other.title == title)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.description, description) || other.description == description)&&(identical(other.repositoryUrl, repositoryUrl) || other.repositoryUrl == repositoryUrl)&&(identical(other.documentationUrl, documentationUrl) || other.documentationUrl == documentationUrl)&&(identical(other.videoUrl, videoUrl) || other.videoUrl == videoUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.progressPercent, progressPercent) || other.progressPercent == progressPercent)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,trackId,title,scope,description,repositoryUrl,documentationUrl,videoUrl,status,progressPercent,createdAt,updatedAt);

@override
String toString() {
  return 'ProjectModel(id: $id, userId: $userId, trackId: $trackId, title: $title, scope: $scope, description: $description, repositoryUrl: $repositoryUrl, documentationUrl: $documentationUrl, videoUrl: $videoUrl, status: $status, progressPercent: $progressPercent, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ProjectModelCopyWith<$Res>  {
  factory $ProjectModelCopyWith(ProjectModel value, $Res Function(ProjectModel) _then) = _$ProjectModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String? trackId, String title, String scope, String description, String? repositoryUrl, String? documentationUrl, String? videoUrl, ProjectStatus status, double progressPercent, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$ProjectModelCopyWithImpl<$Res>
    implements $ProjectModelCopyWith<$Res> {
  _$ProjectModelCopyWithImpl(this._self, this._then);

  final ProjectModel _self;
  final $Res Function(ProjectModel) _then;

/// Create a copy of ProjectModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? trackId = freezed,Object? title = null,Object? scope = null,Object? description = null,Object? repositoryUrl = freezed,Object? documentationUrl = freezed,Object? videoUrl = freezed,Object? status = null,Object? progressPercent = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,trackId: freezed == trackId ? _self.trackId : trackId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,repositoryUrl: freezed == repositoryUrl ? _self.repositoryUrl : repositoryUrl // ignore: cast_nullable_to_non_nullable
as String?,documentationUrl: freezed == documentationUrl ? _self.documentationUrl : documentationUrl // ignore: cast_nullable_to_non_nullable
as String?,videoUrl: freezed == videoUrl ? _self.videoUrl : videoUrl // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectStatus,progressPercent: null == progressPercent ? _self.progressPercent : progressPercent // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectModel].
extension ProjectModelPatterns on ProjectModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectModel value)  $default,){
final _that = this;
switch (_that) {
case _ProjectModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String? trackId,  String title,  String scope,  String description,  String? repositoryUrl,  String? documentationUrl,  String? videoUrl,  ProjectStatus status,  double progressPercent,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectModel() when $default != null:
return $default(_that.id,_that.userId,_that.trackId,_that.title,_that.scope,_that.description,_that.repositoryUrl,_that.documentationUrl,_that.videoUrl,_that.status,_that.progressPercent,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String? trackId,  String title,  String scope,  String description,  String? repositoryUrl,  String? documentationUrl,  String? videoUrl,  ProjectStatus status,  double progressPercent,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ProjectModel():
return $default(_that.id,_that.userId,_that.trackId,_that.title,_that.scope,_that.description,_that.repositoryUrl,_that.documentationUrl,_that.videoUrl,_that.status,_that.progressPercent,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String? trackId,  String title,  String scope,  String description,  String? repositoryUrl,  String? documentationUrl,  String? videoUrl,  ProjectStatus status,  double progressPercent,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ProjectModel() when $default != null:
return $default(_that.id,_that.userId,_that.trackId,_that.title,_that.scope,_that.description,_that.repositoryUrl,_that.documentationUrl,_that.videoUrl,_that.status,_that.progressPercent,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _ProjectModel implements ProjectModel {
  const _ProjectModel({required this.id, required this.userId, this.trackId, required this.title, required this.scope, required this.description, this.repositoryUrl, this.documentationUrl, this.videoUrl, required this.status, required this.progressPercent, required this.createdAt, required this.updatedAt});
  factory _ProjectModel.fromJson(Map<String, dynamic> json) => _$ProjectModelFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String? trackId;
@override final  String title;
@override final  String scope;
@override final  String description;
@override final  String? repositoryUrl;
@override final  String? documentationUrl;
@override final  String? videoUrl;
@override final  ProjectStatus status;
@override final  double progressPercent;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of ProjectModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectModelCopyWith<_ProjectModel> get copyWith => __$ProjectModelCopyWithImpl<_ProjectModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.title, title) || other.title == title)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.description, description) || other.description == description)&&(identical(other.repositoryUrl, repositoryUrl) || other.repositoryUrl == repositoryUrl)&&(identical(other.documentationUrl, documentationUrl) || other.documentationUrl == documentationUrl)&&(identical(other.videoUrl, videoUrl) || other.videoUrl == videoUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.progressPercent, progressPercent) || other.progressPercent == progressPercent)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,trackId,title,scope,description,repositoryUrl,documentationUrl,videoUrl,status,progressPercent,createdAt,updatedAt);

@override
String toString() {
  return 'ProjectModel(id: $id, userId: $userId, trackId: $trackId, title: $title, scope: $scope, description: $description, repositoryUrl: $repositoryUrl, documentationUrl: $documentationUrl, videoUrl: $videoUrl, status: $status, progressPercent: $progressPercent, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ProjectModelCopyWith<$Res> implements $ProjectModelCopyWith<$Res> {
  factory _$ProjectModelCopyWith(_ProjectModel value, $Res Function(_ProjectModel) _then) = __$ProjectModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String? trackId, String title, String scope, String description, String? repositoryUrl, String? documentationUrl, String? videoUrl, ProjectStatus status, double progressPercent, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$ProjectModelCopyWithImpl<$Res>
    implements _$ProjectModelCopyWith<$Res> {
  __$ProjectModelCopyWithImpl(this._self, this._then);

  final _ProjectModel _self;
  final $Res Function(_ProjectModel) _then;

/// Create a copy of ProjectModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? trackId = freezed,Object? title = null,Object? scope = null,Object? description = null,Object? repositoryUrl = freezed,Object? documentationUrl = freezed,Object? videoUrl = freezed,Object? status = null,Object? progressPercent = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_ProjectModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,trackId: freezed == trackId ? _self.trackId : trackId // ignore: cast_nullable_to_non_nullable
as String?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,scope: null == scope ? _self.scope : scope // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,repositoryUrl: freezed == repositoryUrl ? _self.repositoryUrl : repositoryUrl // ignore: cast_nullable_to_non_nullable
as String?,documentationUrl: freezed == documentationUrl ? _self.documentationUrl : documentationUrl // ignore: cast_nullable_to_non_nullable
as String?,videoUrl: freezed == videoUrl ? _self.videoUrl : videoUrl // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProjectStatus,progressPercent: null == progressPercent ? _self.progressPercent : progressPercent // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$ProjectStepModel {

 String get id; String get projectId; String get title; String get description; bool get isDone; int get sortOrder; DateTime? get completedAt; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of ProjectStepModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectStepModelCopyWith<ProjectStepModel> get copyWith => _$ProjectStepModelCopyWithImpl<ProjectStepModel>(this as ProjectStepModel, _$identity);

  /// Serializes this ProjectStepModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectStepModel&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.isDone, isDone) || other.isDone == isDone)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,projectId,title,description,isDone,sortOrder,completedAt,createdAt,updatedAt);

@override
String toString() {
  return 'ProjectStepModel(id: $id, projectId: $projectId, title: $title, description: $description, isDone: $isDone, sortOrder: $sortOrder, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ProjectStepModelCopyWith<$Res>  {
  factory $ProjectStepModelCopyWith(ProjectStepModel value, $Res Function(ProjectStepModel) _then) = _$ProjectStepModelCopyWithImpl;
@useResult
$Res call({
 String id, String projectId, String title, String description, bool isDone, int sortOrder, DateTime? completedAt, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$ProjectStepModelCopyWithImpl<$Res>
    implements $ProjectStepModelCopyWith<$Res> {
  _$ProjectStepModelCopyWithImpl(this._self, this._then);

  final ProjectStepModel _self;
  final $Res Function(ProjectStepModel) _then;

/// Create a copy of ProjectStepModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? projectId = null,Object? title = null,Object? description = null,Object? isDone = null,Object? sortOrder = null,Object? completedAt = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isDone: null == isDone ? _self.isDone : isDone // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [ProjectStepModel].
extension ProjectStepModelPatterns on ProjectStepModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectStepModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectStepModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectStepModel value)  $default,){
final _that = this;
switch (_that) {
case _ProjectStepModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectStepModel value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectStepModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String projectId,  String title,  String description,  bool isDone,  int sortOrder,  DateTime? completedAt,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProjectStepModel() when $default != null:
return $default(_that.id,_that.projectId,_that.title,_that.description,_that.isDone,_that.sortOrder,_that.completedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String projectId,  String title,  String description,  bool isDone,  int sortOrder,  DateTime? completedAt,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _ProjectStepModel():
return $default(_that.id,_that.projectId,_that.title,_that.description,_that.isDone,_that.sortOrder,_that.completedAt,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String projectId,  String title,  String description,  bool isDone,  int sortOrder,  DateTime? completedAt,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _ProjectStepModel() when $default != null:
return $default(_that.id,_that.projectId,_that.title,_that.description,_that.isDone,_that.sortOrder,_that.completedAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _ProjectStepModel implements ProjectStepModel {
  const _ProjectStepModel({required this.id, required this.projectId, required this.title, required this.description, required this.isDone, required this.sortOrder, this.completedAt, required this.createdAt, required this.updatedAt});
  factory _ProjectStepModel.fromJson(Map<String, dynamic> json) => _$ProjectStepModelFromJson(json);

@override final  String id;
@override final  String projectId;
@override final  String title;
@override final  String description;
@override final  bool isDone;
@override final  int sortOrder;
@override final  DateTime? completedAt;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of ProjectStepModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectStepModelCopyWith<_ProjectStepModel> get copyWith => __$ProjectStepModelCopyWithImpl<_ProjectStepModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProjectStepModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectStepModel&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.isDone, isDone) || other.isDone == isDone)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,projectId,title,description,isDone,sortOrder,completedAt,createdAt,updatedAt);

@override
String toString() {
  return 'ProjectStepModel(id: $id, projectId: $projectId, title: $title, description: $description, isDone: $isDone, sortOrder: $sortOrder, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ProjectStepModelCopyWith<$Res> implements $ProjectStepModelCopyWith<$Res> {
  factory _$ProjectStepModelCopyWith(_ProjectStepModel value, $Res Function(_ProjectStepModel) _then) = __$ProjectStepModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String projectId, String title, String description, bool isDone, int sortOrder, DateTime? completedAt, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$ProjectStepModelCopyWithImpl<$Res>
    implements _$ProjectStepModelCopyWith<$Res> {
  __$ProjectStepModelCopyWithImpl(this._self, this._then);

  final _ProjectStepModel _self;
  final $Res Function(_ProjectStepModel) _then;

/// Create a copy of ProjectStepModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? projectId = null,Object? title = null,Object? description = null,Object? isDone = null,Object? sortOrder = null,Object? completedAt = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_ProjectStepModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,projectId: null == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,description: null == description ? _self.description : description // ignore: cast_nullable_to_non_nullable
as String,isDone: null == isDone ? _self.isDone : isDone // ignore: cast_nullable_to_non_nullable
as bool,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,completedAt: freezed == completedAt ? _self.completedAt : completedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$StudyNoteModel {

 String get id; String get userId; String get folderName; String get title; String get content; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of StudyNoteModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudyNoteModelCopyWith<StudyNoteModel> get copyWith => _$StudyNoteModelCopyWithImpl<StudyNoteModel>(this as StudyNoteModel, _$identity);

  /// Serializes this StudyNoteModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudyNoteModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.folderName, folderName) || other.folderName == folderName)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,folderName,title,content,createdAt,updatedAt);

@override
String toString() {
  return 'StudyNoteModel(id: $id, userId: $userId, folderName: $folderName, title: $title, content: $content, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $StudyNoteModelCopyWith<$Res>  {
  factory $StudyNoteModelCopyWith(StudyNoteModel value, $Res Function(StudyNoteModel) _then) = _$StudyNoteModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String folderName, String title, String content, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$StudyNoteModelCopyWithImpl<$Res>
    implements $StudyNoteModelCopyWith<$Res> {
  _$StudyNoteModelCopyWithImpl(this._self, this._then);

  final StudyNoteModel _self;
  final $Res Function(StudyNoteModel) _then;

/// Create a copy of StudyNoteModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? folderName = null,Object? title = null,Object? content = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,folderName: null == folderName ? _self.folderName : folderName // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [StudyNoteModel].
extension StudyNoteModelPatterns on StudyNoteModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudyNoteModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudyNoteModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudyNoteModel value)  $default,){
final _that = this;
switch (_that) {
case _StudyNoteModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudyNoteModel value)?  $default,){
final _that = this;
switch (_that) {
case _StudyNoteModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String folderName,  String title,  String content,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StudyNoteModel() when $default != null:
return $default(_that.id,_that.userId,_that.folderName,_that.title,_that.content,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String folderName,  String title,  String content,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _StudyNoteModel():
return $default(_that.id,_that.userId,_that.folderName,_that.title,_that.content,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String folderName,  String title,  String content,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _StudyNoteModel() when $default != null:
return $default(_that.id,_that.userId,_that.folderName,_that.title,_that.content,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _StudyNoteModel implements StudyNoteModel {
  const _StudyNoteModel({required this.id, required this.userId, required this.folderName, required this.title, required this.content, required this.createdAt, required this.updatedAt});
  factory _StudyNoteModel.fromJson(Map<String, dynamic> json) => _$StudyNoteModelFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String folderName;
@override final  String title;
@override final  String content;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of StudyNoteModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudyNoteModelCopyWith<_StudyNoteModel> get copyWith => __$StudyNoteModelCopyWithImpl<_StudyNoteModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$StudyNoteModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudyNoteModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.folderName, folderName) || other.folderName == folderName)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,folderName,title,content,createdAt,updatedAt);

@override
String toString() {
  return 'StudyNoteModel(id: $id, userId: $userId, folderName: $folderName, title: $title, content: $content, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$StudyNoteModelCopyWith<$Res> implements $StudyNoteModelCopyWith<$Res> {
  factory _$StudyNoteModelCopyWith(_StudyNoteModel value, $Res Function(_StudyNoteModel) _then) = __$StudyNoteModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String folderName, String title, String content, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$StudyNoteModelCopyWithImpl<$Res>
    implements _$StudyNoteModelCopyWith<$Res> {
  __$StudyNoteModelCopyWithImpl(this._self, this._then);

  final _StudyNoteModel _self;
  final $Res Function(_StudyNoteModel) _then;

/// Create a copy of StudyNoteModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? folderName = null,Object? title = null,Object? content = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_StudyNoteModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,folderName: null == folderName ? _self.folderName : folderName // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,content: null == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$FlashcardModel {

 String get id; String get userId; String get deckName; String get question; String get answer; String? get trackId; String? get moduleId; String? get projectId; DateTime get dueAt; DateTime? get lastReviewedAt; int get reviewCount; int get correctStreak; double get easeFactor; int get intervalDays; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of FlashcardModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FlashcardModelCopyWith<FlashcardModel> get copyWith => _$FlashcardModelCopyWithImpl<FlashcardModel>(this as FlashcardModel, _$identity);

  /// Serializes this FlashcardModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FlashcardModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.deckName, deckName) || other.deckName == deckName)&&(identical(other.question, question) || other.question == question)&&(identical(other.answer, answer) || other.answer == answer)&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.moduleId, moduleId) || other.moduleId == moduleId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.lastReviewedAt, lastReviewedAt) || other.lastReviewedAt == lastReviewedAt)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&(identical(other.correctStreak, correctStreak) || other.correctStreak == correctStreak)&&(identical(other.easeFactor, easeFactor) || other.easeFactor == easeFactor)&&(identical(other.intervalDays, intervalDays) || other.intervalDays == intervalDays)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,deckName,question,answer,trackId,moduleId,projectId,dueAt,lastReviewedAt,reviewCount,correctStreak,easeFactor,intervalDays,createdAt,updatedAt);

@override
String toString() {
  return 'FlashcardModel(id: $id, userId: $userId, deckName: $deckName, question: $question, answer: $answer, trackId: $trackId, moduleId: $moduleId, projectId: $projectId, dueAt: $dueAt, lastReviewedAt: $lastReviewedAt, reviewCount: $reviewCount, correctStreak: $correctStreak, easeFactor: $easeFactor, intervalDays: $intervalDays, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $FlashcardModelCopyWith<$Res>  {
  factory $FlashcardModelCopyWith(FlashcardModel value, $Res Function(FlashcardModel) _then) = _$FlashcardModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String deckName, String question, String answer, String? trackId, String? moduleId, String? projectId, DateTime dueAt, DateTime? lastReviewedAt, int reviewCount, int correctStreak, double easeFactor, int intervalDays, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$FlashcardModelCopyWithImpl<$Res>
    implements $FlashcardModelCopyWith<$Res> {
  _$FlashcardModelCopyWithImpl(this._self, this._then);

  final FlashcardModel _self;
  final $Res Function(FlashcardModel) _then;

/// Create a copy of FlashcardModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? deckName = null,Object? question = null,Object? answer = null,Object? trackId = freezed,Object? moduleId = freezed,Object? projectId = freezed,Object? dueAt = null,Object? lastReviewedAt = freezed,Object? reviewCount = null,Object? correctStreak = null,Object? easeFactor = null,Object? intervalDays = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,deckName: null == deckName ? _self.deckName : deckName // ignore: cast_nullable_to_non_nullable
as String,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String,trackId: freezed == trackId ? _self.trackId : trackId // ignore: cast_nullable_to_non_nullable
as String?,moduleId: freezed == moduleId ? _self.moduleId : moduleId // ignore: cast_nullable_to_non_nullable
as String?,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,dueAt: null == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastReviewedAt: freezed == lastReviewedAt ? _self.lastReviewedAt : lastReviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reviewCount: null == reviewCount ? _self.reviewCount : reviewCount // ignore: cast_nullable_to_non_nullable
as int,correctStreak: null == correctStreak ? _self.correctStreak : correctStreak // ignore: cast_nullable_to_non_nullable
as int,easeFactor: null == easeFactor ? _self.easeFactor : easeFactor // ignore: cast_nullable_to_non_nullable
as double,intervalDays: null == intervalDays ? _self.intervalDays : intervalDays // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [FlashcardModel].
extension FlashcardModelPatterns on FlashcardModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FlashcardModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FlashcardModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FlashcardModel value)  $default,){
final _that = this;
switch (_that) {
case _FlashcardModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FlashcardModel value)?  $default,){
final _that = this;
switch (_that) {
case _FlashcardModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String deckName,  String question,  String answer,  String? trackId,  String? moduleId,  String? projectId,  DateTime dueAt,  DateTime? lastReviewedAt,  int reviewCount,  int correctStreak,  double easeFactor,  int intervalDays,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FlashcardModel() when $default != null:
return $default(_that.id,_that.userId,_that.deckName,_that.question,_that.answer,_that.trackId,_that.moduleId,_that.projectId,_that.dueAt,_that.lastReviewedAt,_that.reviewCount,_that.correctStreak,_that.easeFactor,_that.intervalDays,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String deckName,  String question,  String answer,  String? trackId,  String? moduleId,  String? projectId,  DateTime dueAt,  DateTime? lastReviewedAt,  int reviewCount,  int correctStreak,  double easeFactor,  int intervalDays,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _FlashcardModel():
return $default(_that.id,_that.userId,_that.deckName,_that.question,_that.answer,_that.trackId,_that.moduleId,_that.projectId,_that.dueAt,_that.lastReviewedAt,_that.reviewCount,_that.correctStreak,_that.easeFactor,_that.intervalDays,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String deckName,  String question,  String answer,  String? trackId,  String? moduleId,  String? projectId,  DateTime dueAt,  DateTime? lastReviewedAt,  int reviewCount,  int correctStreak,  double easeFactor,  int intervalDays,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _FlashcardModel() when $default != null:
return $default(_that.id,_that.userId,_that.deckName,_that.question,_that.answer,_that.trackId,_that.moduleId,_that.projectId,_that.dueAt,_that.lastReviewedAt,_that.reviewCount,_that.correctStreak,_that.easeFactor,_that.intervalDays,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _FlashcardModel implements FlashcardModel {
  const _FlashcardModel({required this.id, required this.userId, required this.deckName, required this.question, required this.answer, this.trackId, this.moduleId, this.projectId, required this.dueAt, this.lastReviewedAt, required this.reviewCount, required this.correctStreak, required this.easeFactor, required this.intervalDays, required this.createdAt, required this.updatedAt});
  factory _FlashcardModel.fromJson(Map<String, dynamic> json) => _$FlashcardModelFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String deckName;
@override final  String question;
@override final  String answer;
@override final  String? trackId;
@override final  String? moduleId;
@override final  String? projectId;
@override final  DateTime dueAt;
@override final  DateTime? lastReviewedAt;
@override final  int reviewCount;
@override final  int correctStreak;
@override final  double easeFactor;
@override final  int intervalDays;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of FlashcardModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FlashcardModelCopyWith<_FlashcardModel> get copyWith => __$FlashcardModelCopyWithImpl<_FlashcardModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FlashcardModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FlashcardModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.deckName, deckName) || other.deckName == deckName)&&(identical(other.question, question) || other.question == question)&&(identical(other.answer, answer) || other.answer == answer)&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.moduleId, moduleId) || other.moduleId == moduleId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.lastReviewedAt, lastReviewedAt) || other.lastReviewedAt == lastReviewedAt)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&(identical(other.correctStreak, correctStreak) || other.correctStreak == correctStreak)&&(identical(other.easeFactor, easeFactor) || other.easeFactor == easeFactor)&&(identical(other.intervalDays, intervalDays) || other.intervalDays == intervalDays)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,deckName,question,answer,trackId,moduleId,projectId,dueAt,lastReviewedAt,reviewCount,correctStreak,easeFactor,intervalDays,createdAt,updatedAt);

@override
String toString() {
  return 'FlashcardModel(id: $id, userId: $userId, deckName: $deckName, question: $question, answer: $answer, trackId: $trackId, moduleId: $moduleId, projectId: $projectId, dueAt: $dueAt, lastReviewedAt: $lastReviewedAt, reviewCount: $reviewCount, correctStreak: $correctStreak, easeFactor: $easeFactor, intervalDays: $intervalDays, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$FlashcardModelCopyWith<$Res> implements $FlashcardModelCopyWith<$Res> {
  factory _$FlashcardModelCopyWith(_FlashcardModel value, $Res Function(_FlashcardModel) _then) = __$FlashcardModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String deckName, String question, String answer, String? trackId, String? moduleId, String? projectId, DateTime dueAt, DateTime? lastReviewedAt, int reviewCount, int correctStreak, double easeFactor, int intervalDays, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$FlashcardModelCopyWithImpl<$Res>
    implements _$FlashcardModelCopyWith<$Res> {
  __$FlashcardModelCopyWithImpl(this._self, this._then);

  final _FlashcardModel _self;
  final $Res Function(_FlashcardModel) _then;

/// Create a copy of FlashcardModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? deckName = null,Object? question = null,Object? answer = null,Object? trackId = freezed,Object? moduleId = freezed,Object? projectId = freezed,Object? dueAt = null,Object? lastReviewedAt = freezed,Object? reviewCount = null,Object? correctStreak = null,Object? easeFactor = null,Object? intervalDays = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_FlashcardModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,deckName: null == deckName ? _self.deckName : deckName // ignore: cast_nullable_to_non_nullable
as String,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String,trackId: freezed == trackId ? _self.trackId : trackId // ignore: cast_nullable_to_non_nullable
as String?,moduleId: freezed == moduleId ? _self.moduleId : moduleId // ignore: cast_nullable_to_non_nullable
as String?,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,dueAt: null == dueAt ? _self.dueAt : dueAt // ignore: cast_nullable_to_non_nullable
as DateTime,lastReviewedAt: freezed == lastReviewedAt ? _self.lastReviewedAt : lastReviewedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,reviewCount: null == reviewCount ? _self.reviewCount : reviewCount // ignore: cast_nullable_to_non_nullable
as int,correctStreak: null == correctStreak ? _self.correctStreak : correctStreak // ignore: cast_nullable_to_non_nullable
as int,easeFactor: null == easeFactor ? _self.easeFactor : easeFactor // ignore: cast_nullable_to_non_nullable
as double,intervalDays: null == intervalDays ? _self.intervalDays : intervalDays // ignore: cast_nullable_to_non_nullable
as int,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$MindMapModel {

 String get id; String get userId; String get folderName; String get title; String get contentJson; String? get trackId; String? get moduleId; String? get projectId; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of MindMapModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MindMapModelCopyWith<MindMapModel> get copyWith => _$MindMapModelCopyWithImpl<MindMapModel>(this as MindMapModel, _$identity);

  /// Serializes this MindMapModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MindMapModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.folderName, folderName) || other.folderName == folderName)&&(identical(other.title, title) || other.title == title)&&(identical(other.contentJson, contentJson) || other.contentJson == contentJson)&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.moduleId, moduleId) || other.moduleId == moduleId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,folderName,title,contentJson,trackId,moduleId,projectId,createdAt,updatedAt);

@override
String toString() {
  return 'MindMapModel(id: $id, userId: $userId, folderName: $folderName, title: $title, contentJson: $contentJson, trackId: $trackId, moduleId: $moduleId, projectId: $projectId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $MindMapModelCopyWith<$Res>  {
  factory $MindMapModelCopyWith(MindMapModel value, $Res Function(MindMapModel) _then) = _$MindMapModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String folderName, String title, String contentJson, String? trackId, String? moduleId, String? projectId, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$MindMapModelCopyWithImpl<$Res>
    implements $MindMapModelCopyWith<$Res> {
  _$MindMapModelCopyWithImpl(this._self, this._then);

  final MindMapModel _self;
  final $Res Function(MindMapModel) _then;

/// Create a copy of MindMapModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? folderName = null,Object? title = null,Object? contentJson = null,Object? trackId = freezed,Object? moduleId = freezed,Object? projectId = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,folderName: null == folderName ? _self.folderName : folderName // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,contentJson: null == contentJson ? _self.contentJson : contentJson // ignore: cast_nullable_to_non_nullable
as String,trackId: freezed == trackId ? _self.trackId : trackId // ignore: cast_nullable_to_non_nullable
as String?,moduleId: freezed == moduleId ? _self.moduleId : moduleId // ignore: cast_nullable_to_non_nullable
as String?,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [MindMapModel].
extension MindMapModelPatterns on MindMapModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MindMapModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MindMapModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MindMapModel value)  $default,){
final _that = this;
switch (_that) {
case _MindMapModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MindMapModel value)?  $default,){
final _that = this;
switch (_that) {
case _MindMapModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  String folderName,  String title,  String contentJson,  String? trackId,  String? moduleId,  String? projectId,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MindMapModel() when $default != null:
return $default(_that.id,_that.userId,_that.folderName,_that.title,_that.contentJson,_that.trackId,_that.moduleId,_that.projectId,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  String folderName,  String title,  String contentJson,  String? trackId,  String? moduleId,  String? projectId,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _MindMapModel():
return $default(_that.id,_that.userId,_that.folderName,_that.title,_that.contentJson,_that.trackId,_that.moduleId,_that.projectId,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  String folderName,  String title,  String contentJson,  String? trackId,  String? moduleId,  String? projectId,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _MindMapModel() when $default != null:
return $default(_that.id,_that.userId,_that.folderName,_that.title,_that.contentJson,_that.trackId,_that.moduleId,_that.projectId,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _MindMapModel implements MindMapModel {
  const _MindMapModel({required this.id, required this.userId, required this.folderName, required this.title, required this.contentJson, this.trackId, this.moduleId, this.projectId, required this.createdAt, required this.updatedAt});
  factory _MindMapModel.fromJson(Map<String, dynamic> json) => _$MindMapModelFromJson(json);

@override final  String id;
@override final  String userId;
@override final  String folderName;
@override final  String title;
@override final  String contentJson;
@override final  String? trackId;
@override final  String? moduleId;
@override final  String? projectId;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of MindMapModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MindMapModelCopyWith<_MindMapModel> get copyWith => __$MindMapModelCopyWithImpl<_MindMapModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MindMapModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MindMapModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.folderName, folderName) || other.folderName == folderName)&&(identical(other.title, title) || other.title == title)&&(identical(other.contentJson, contentJson) || other.contentJson == contentJson)&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.moduleId, moduleId) || other.moduleId == moduleId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,folderName,title,contentJson,trackId,moduleId,projectId,createdAt,updatedAt);

@override
String toString() {
  return 'MindMapModel(id: $id, userId: $userId, folderName: $folderName, title: $title, contentJson: $contentJson, trackId: $trackId, moduleId: $moduleId, projectId: $projectId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$MindMapModelCopyWith<$Res> implements $MindMapModelCopyWith<$Res> {
  factory _$MindMapModelCopyWith(_MindMapModel value, $Res Function(_MindMapModel) _then) = __$MindMapModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String folderName, String title, String contentJson, String? trackId, String? moduleId, String? projectId, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$MindMapModelCopyWithImpl<$Res>
    implements _$MindMapModelCopyWith<$Res> {
  __$MindMapModelCopyWithImpl(this._self, this._then);

  final _MindMapModel _self;
  final $Res Function(_MindMapModel) _then;

/// Create a copy of MindMapModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? folderName = null,Object? title = null,Object? contentJson = null,Object? trackId = freezed,Object? moduleId = freezed,Object? projectId = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_MindMapModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,folderName: null == folderName ? _self.folderName : folderName // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,contentJson: null == contentJson ? _self.contentJson : contentJson // ignore: cast_nullable_to_non_nullable
as String,trackId: freezed == trackId ? _self.trackId : trackId // ignore: cast_nullable_to_non_nullable
as String?,moduleId: freezed == moduleId ? _self.moduleId : moduleId // ignore: cast_nullable_to_non_nullable
as String?,projectId: freezed == projectId ? _self.projectId : projectId // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}


/// @nodoc
mixin _$AppSettingsModel {

 String get id; String get userId; ThemePreference get themePreference; bool get notificationsEnabled; int? get dailyReminderHour; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of AppSettingsModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppSettingsModelCopyWith<AppSettingsModel> get copyWith => _$AppSettingsModelCopyWithImpl<AppSettingsModel>(this as AppSettingsModel, _$identity);

  /// Serializes this AppSettingsModel to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppSettingsModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.themePreference, themePreference) || other.themePreference == themePreference)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled)&&(identical(other.dailyReminderHour, dailyReminderHour) || other.dailyReminderHour == dailyReminderHour)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,themePreference,notificationsEnabled,dailyReminderHour,createdAt,updatedAt);

@override
String toString() {
  return 'AppSettingsModel(id: $id, userId: $userId, themePreference: $themePreference, notificationsEnabled: $notificationsEnabled, dailyReminderHour: $dailyReminderHour, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $AppSettingsModelCopyWith<$Res>  {
  factory $AppSettingsModelCopyWith(AppSettingsModel value, $Res Function(AppSettingsModel) _then) = _$AppSettingsModelCopyWithImpl;
@useResult
$Res call({
 String id, String userId, ThemePreference themePreference, bool notificationsEnabled, int? dailyReminderHour, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$AppSettingsModelCopyWithImpl<$Res>
    implements $AppSettingsModelCopyWith<$Res> {
  _$AppSettingsModelCopyWithImpl(this._self, this._then);

  final AppSettingsModel _self;
  final $Res Function(AppSettingsModel) _then;

/// Create a copy of AppSettingsModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? userId = null,Object? themePreference = null,Object? notificationsEnabled = null,Object? dailyReminderHour = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,themePreference: null == themePreference ? _self.themePreference : themePreference // ignore: cast_nullable_to_non_nullable
as ThemePreference,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,dailyReminderHour: freezed == dailyReminderHour ? _self.dailyReminderHour : dailyReminderHour // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [AppSettingsModel].
extension AppSettingsModelPatterns on AppSettingsModel {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppSettingsModel value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppSettingsModel() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppSettingsModel value)  $default,){
final _that = this;
switch (_that) {
case _AppSettingsModel():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppSettingsModel value)?  $default,){
final _that = this;
switch (_that) {
case _AppSettingsModel() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String userId,  ThemePreference themePreference,  bool notificationsEnabled,  int? dailyReminderHour,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AppSettingsModel() when $default != null:
return $default(_that.id,_that.userId,_that.themePreference,_that.notificationsEnabled,_that.dailyReminderHour,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String userId,  ThemePreference themePreference,  bool notificationsEnabled,  int? dailyReminderHour,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _AppSettingsModel():
return $default(_that.id,_that.userId,_that.themePreference,_that.notificationsEnabled,_that.dailyReminderHour,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String userId,  ThemePreference themePreference,  bool notificationsEnabled,  int? dailyReminderHour,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _AppSettingsModel() when $default != null:
return $default(_that.id,_that.userId,_that.themePreference,_that.notificationsEnabled,_that.dailyReminderHour,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc

@JsonSerializable(fieldRename: FieldRename.snake)
class _AppSettingsModel implements AppSettingsModel {
  const _AppSettingsModel({required this.id, required this.userId, required this.themePreference, required this.notificationsEnabled, this.dailyReminderHour, required this.createdAt, required this.updatedAt});
  factory _AppSettingsModel.fromJson(Map<String, dynamic> json) => _$AppSettingsModelFromJson(json);

@override final  String id;
@override final  String userId;
@override final  ThemePreference themePreference;
@override final  bool notificationsEnabled;
@override final  int? dailyReminderHour;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of AppSettingsModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppSettingsModelCopyWith<_AppSettingsModel> get copyWith => __$AppSettingsModelCopyWithImpl<_AppSettingsModel>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AppSettingsModelToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppSettingsModel&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.themePreference, themePreference) || other.themePreference == themePreference)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled)&&(identical(other.dailyReminderHour, dailyReminderHour) || other.dailyReminderHour == dailyReminderHour)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,userId,themePreference,notificationsEnabled,dailyReminderHour,createdAt,updatedAt);

@override
String toString() {
  return 'AppSettingsModel(id: $id, userId: $userId, themePreference: $themePreference, notificationsEnabled: $notificationsEnabled, dailyReminderHour: $dailyReminderHour, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$AppSettingsModelCopyWith<$Res> implements $AppSettingsModelCopyWith<$Res> {
  factory _$AppSettingsModelCopyWith(_AppSettingsModel value, $Res Function(_AppSettingsModel) _then) = __$AppSettingsModelCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, ThemePreference themePreference, bool notificationsEnabled, int? dailyReminderHour, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$AppSettingsModelCopyWithImpl<$Res>
    implements _$AppSettingsModelCopyWith<$Res> {
  __$AppSettingsModelCopyWithImpl(this._self, this._then);

  final _AppSettingsModel _self;
  final $Res Function(_AppSettingsModel) _then;

/// Create a copy of AppSettingsModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? themePreference = null,Object? notificationsEnabled = null,Object? dailyReminderHour = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_AppSettingsModel(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,userId: null == userId ? _self.userId : userId // ignore: cast_nullable_to_non_nullable
as String,themePreference: null == themePreference ? _self.themePreference : themePreference // ignore: cast_nullable_to_non_nullable
as ThemePreference,notificationsEnabled: null == notificationsEnabled ? _self.notificationsEnabled : notificationsEnabled // ignore: cast_nullable_to_non_nullable
as bool,dailyReminderHour: freezed == dailyReminderHour ? _self.dailyReminderHour : dailyReminderHour // ignore: cast_nullable_to_non_nullable
as int?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
