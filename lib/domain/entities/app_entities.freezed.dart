// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'app_entities.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProfileEntity {

 String get id; String get fullName; String? get email; String get desiredArea; SkillLevel get currentLevel; bool get onboardingCompleted; String? get selectedTrackId; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of ProfileEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileEntityCopyWith<ProfileEntity> get copyWith => _$ProfileEntityCopyWithImpl<ProfileEntity>(this as ProfileEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.email, email) || other.email == email)&&(identical(other.desiredArea, desiredArea) || other.desiredArea == desiredArea)&&(identical(other.currentLevel, currentLevel) || other.currentLevel == currentLevel)&&(identical(other.onboardingCompleted, onboardingCompleted) || other.onboardingCompleted == onboardingCompleted)&&(identical(other.selectedTrackId, selectedTrackId) || other.selectedTrackId == selectedTrackId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,fullName,email,desiredArea,currentLevel,onboardingCompleted,selectedTrackId,createdAt,updatedAt);

@override
String toString() {
  return 'ProfileEntity(id: $id, fullName: $fullName, email: $email, desiredArea: $desiredArea, currentLevel: $currentLevel, onboardingCompleted: $onboardingCompleted, selectedTrackId: $selectedTrackId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ProfileEntityCopyWith<$Res>  {
  factory $ProfileEntityCopyWith(ProfileEntity value, $Res Function(ProfileEntity) _then) = _$ProfileEntityCopyWithImpl;
@useResult
$Res call({
 String id, String fullName, String? email, String desiredArea, SkillLevel currentLevel, bool onboardingCompleted, String? selectedTrackId, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$ProfileEntityCopyWithImpl<$Res>
    implements $ProfileEntityCopyWith<$Res> {
  _$ProfileEntityCopyWithImpl(this._self, this._then);

  final ProfileEntity _self;
  final $Res Function(ProfileEntity) _then;

/// Create a copy of ProfileEntity
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


/// Adds pattern-matching-related methods to [ProfileEntity].
extension ProfileEntityPatterns on ProfileEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileEntity value)  $default,){
final _that = this;
switch (_that) {
case _ProfileEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileEntity() when $default != null:
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
case _ProfileEntity() when $default != null:
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
case _ProfileEntity():
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
case _ProfileEntity() when $default != null:
return $default(_that.id,_that.fullName,_that.email,_that.desiredArea,_that.currentLevel,_that.onboardingCompleted,_that.selectedTrackId,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _ProfileEntity implements ProfileEntity {
  const _ProfileEntity({required this.id, required this.fullName, this.email, required this.desiredArea, required this.currentLevel, required this.onboardingCompleted, this.selectedTrackId, required this.createdAt, required this.updatedAt});
  

@override final  String id;
@override final  String fullName;
@override final  String? email;
@override final  String desiredArea;
@override final  SkillLevel currentLevel;
@override final  bool onboardingCompleted;
@override final  String? selectedTrackId;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of ProfileEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileEntityCopyWith<_ProfileEntity> get copyWith => __$ProfileEntityCopyWithImpl<_ProfileEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.fullName, fullName) || other.fullName == fullName)&&(identical(other.email, email) || other.email == email)&&(identical(other.desiredArea, desiredArea) || other.desiredArea == desiredArea)&&(identical(other.currentLevel, currentLevel) || other.currentLevel == currentLevel)&&(identical(other.onboardingCompleted, onboardingCompleted) || other.onboardingCompleted == onboardingCompleted)&&(identical(other.selectedTrackId, selectedTrackId) || other.selectedTrackId == selectedTrackId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,fullName,email,desiredArea,currentLevel,onboardingCompleted,selectedTrackId,createdAt,updatedAt);

@override
String toString() {
  return 'ProfileEntity(id: $id, fullName: $fullName, email: $email, desiredArea: $desiredArea, currentLevel: $currentLevel, onboardingCompleted: $onboardingCompleted, selectedTrackId: $selectedTrackId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ProfileEntityCopyWith<$Res> implements $ProfileEntityCopyWith<$Res> {
  factory _$ProfileEntityCopyWith(_ProfileEntity value, $Res Function(_ProfileEntity) _then) = __$ProfileEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String fullName, String? email, String desiredArea, SkillLevel currentLevel, bool onboardingCompleted, String? selectedTrackId, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$ProfileEntityCopyWithImpl<$Res>
    implements _$ProfileEntityCopyWith<$Res> {
  __$ProfileEntityCopyWithImpl(this._self, this._then);

  final _ProfileEntity _self;
  final $Res Function(_ProfileEntity) _then;

/// Create a copy of ProfileEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? fullName = null,Object? email = freezed,Object? desiredArea = null,Object? currentLevel = null,Object? onboardingCompleted = null,Object? selectedTrackId = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_ProfileEntity(
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
mixin _$UserGoalEntity {

 String get id; String get userId; String get primaryGoal; String get desiredArea; FocusType get focusType; int get hoursPerDay; int get daysPerWeek; DateTime get deadline; SkillLevel get currentLevel; String get generatedPlan; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of UserGoalEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserGoalEntityCopyWith<UserGoalEntity> get copyWith => _$UserGoalEntityCopyWithImpl<UserGoalEntity>(this as UserGoalEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserGoalEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.primaryGoal, primaryGoal) || other.primaryGoal == primaryGoal)&&(identical(other.desiredArea, desiredArea) || other.desiredArea == desiredArea)&&(identical(other.focusType, focusType) || other.focusType == focusType)&&(identical(other.hoursPerDay, hoursPerDay) || other.hoursPerDay == hoursPerDay)&&(identical(other.daysPerWeek, daysPerWeek) || other.daysPerWeek == daysPerWeek)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.currentLevel, currentLevel) || other.currentLevel == currentLevel)&&(identical(other.generatedPlan, generatedPlan) || other.generatedPlan == generatedPlan)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,primaryGoal,desiredArea,focusType,hoursPerDay,daysPerWeek,deadline,currentLevel,generatedPlan,createdAt,updatedAt);

@override
String toString() {
  return 'UserGoalEntity(id: $id, userId: $userId, primaryGoal: $primaryGoal, desiredArea: $desiredArea, focusType: $focusType, hoursPerDay: $hoursPerDay, daysPerWeek: $daysPerWeek, deadline: $deadline, currentLevel: $currentLevel, generatedPlan: $generatedPlan, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $UserGoalEntityCopyWith<$Res>  {
  factory $UserGoalEntityCopyWith(UserGoalEntity value, $Res Function(UserGoalEntity) _then) = _$UserGoalEntityCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String primaryGoal, String desiredArea, FocusType focusType, int hoursPerDay, int daysPerWeek, DateTime deadline, SkillLevel currentLevel, String generatedPlan, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$UserGoalEntityCopyWithImpl<$Res>
    implements $UserGoalEntityCopyWith<$Res> {
  _$UserGoalEntityCopyWithImpl(this._self, this._then);

  final UserGoalEntity _self;
  final $Res Function(UserGoalEntity) _then;

/// Create a copy of UserGoalEntity
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


/// Adds pattern-matching-related methods to [UserGoalEntity].
extension UserGoalEntityPatterns on UserGoalEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserGoalEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserGoalEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserGoalEntity value)  $default,){
final _that = this;
switch (_that) {
case _UserGoalEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserGoalEntity value)?  $default,){
final _that = this;
switch (_that) {
case _UserGoalEntity() when $default != null:
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
case _UserGoalEntity() when $default != null:
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
case _UserGoalEntity():
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
case _UserGoalEntity() when $default != null:
return $default(_that.id,_that.userId,_that.primaryGoal,_that.desiredArea,_that.focusType,_that.hoursPerDay,_that.daysPerWeek,_that.deadline,_that.currentLevel,_that.generatedPlan,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _UserGoalEntity implements UserGoalEntity {
  const _UserGoalEntity({required this.id, required this.userId, required this.primaryGoal, required this.desiredArea, required this.focusType, required this.hoursPerDay, required this.daysPerWeek, required this.deadline, required this.currentLevel, required this.generatedPlan, required this.createdAt, required this.updatedAt});
  

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

/// Create a copy of UserGoalEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserGoalEntityCopyWith<_UserGoalEntity> get copyWith => __$UserGoalEntityCopyWithImpl<_UserGoalEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserGoalEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.primaryGoal, primaryGoal) || other.primaryGoal == primaryGoal)&&(identical(other.desiredArea, desiredArea) || other.desiredArea == desiredArea)&&(identical(other.focusType, focusType) || other.focusType == focusType)&&(identical(other.hoursPerDay, hoursPerDay) || other.hoursPerDay == hoursPerDay)&&(identical(other.daysPerWeek, daysPerWeek) || other.daysPerWeek == daysPerWeek)&&(identical(other.deadline, deadline) || other.deadline == deadline)&&(identical(other.currentLevel, currentLevel) || other.currentLevel == currentLevel)&&(identical(other.generatedPlan, generatedPlan) || other.generatedPlan == generatedPlan)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,primaryGoal,desiredArea,focusType,hoursPerDay,daysPerWeek,deadline,currentLevel,generatedPlan,createdAt,updatedAt);

@override
String toString() {
  return 'UserGoalEntity(id: $id, userId: $userId, primaryGoal: $primaryGoal, desiredArea: $desiredArea, focusType: $focusType, hoursPerDay: $hoursPerDay, daysPerWeek: $daysPerWeek, deadline: $deadline, currentLevel: $currentLevel, generatedPlan: $generatedPlan, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$UserGoalEntityCopyWith<$Res> implements $UserGoalEntityCopyWith<$Res> {
  factory _$UserGoalEntityCopyWith(_UserGoalEntity value, $Res Function(_UserGoalEntity) _then) = __$UserGoalEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String primaryGoal, String desiredArea, FocusType focusType, int hoursPerDay, int daysPerWeek, DateTime deadline, SkillLevel currentLevel, String generatedPlan, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$UserGoalEntityCopyWithImpl<$Res>
    implements _$UserGoalEntityCopyWith<$Res> {
  __$UserGoalEntityCopyWithImpl(this._self, this._then);

  final _UserGoalEntity _self;
  final $Res Function(_UserGoalEntity) _then;

/// Create a copy of UserGoalEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? primaryGoal = null,Object? desiredArea = null,Object? focusType = null,Object? hoursPerDay = null,Object? daysPerWeek = null,Object? deadline = null,Object? currentLevel = null,Object? generatedPlan = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_UserGoalEntity(
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
mixin _$StudyTrackEntity {

 String get id; String get name; String get description; String get iconKey; String get colorHex; String get roadmapSummary; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of StudyTrackEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudyTrackEntityCopyWith<StudyTrackEntity> get copyWith => _$StudyTrackEntityCopyWithImpl<StudyTrackEntity>(this as StudyTrackEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudyTrackEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.iconKey, iconKey) || other.iconKey == iconKey)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&(identical(other.roadmapSummary, roadmapSummary) || other.roadmapSummary == roadmapSummary)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,description,iconKey,colorHex,roadmapSummary,createdAt,updatedAt);

@override
String toString() {
  return 'StudyTrackEntity(id: $id, name: $name, description: $description, iconKey: $iconKey, colorHex: $colorHex, roadmapSummary: $roadmapSummary, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $StudyTrackEntityCopyWith<$Res>  {
  factory $StudyTrackEntityCopyWith(StudyTrackEntity value, $Res Function(StudyTrackEntity) _then) = _$StudyTrackEntityCopyWithImpl;
@useResult
$Res call({
 String id, String name, String description, String iconKey, String colorHex, String roadmapSummary, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$StudyTrackEntityCopyWithImpl<$Res>
    implements $StudyTrackEntityCopyWith<$Res> {
  _$StudyTrackEntityCopyWithImpl(this._self, this._then);

  final StudyTrackEntity _self;
  final $Res Function(StudyTrackEntity) _then;

/// Create a copy of StudyTrackEntity
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


/// Adds pattern-matching-related methods to [StudyTrackEntity].
extension StudyTrackEntityPatterns on StudyTrackEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudyTrackEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudyTrackEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudyTrackEntity value)  $default,){
final _that = this;
switch (_that) {
case _StudyTrackEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudyTrackEntity value)?  $default,){
final _that = this;
switch (_that) {
case _StudyTrackEntity() when $default != null:
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
case _StudyTrackEntity() when $default != null:
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
case _StudyTrackEntity():
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
case _StudyTrackEntity() when $default != null:
return $default(_that.id,_that.name,_that.description,_that.iconKey,_that.colorHex,_that.roadmapSummary,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _StudyTrackEntity implements StudyTrackEntity {
  const _StudyTrackEntity({required this.id, required this.name, required this.description, required this.iconKey, required this.colorHex, required this.roadmapSummary, required this.createdAt, required this.updatedAt});
  

@override final  String id;
@override final  String name;
@override final  String description;
@override final  String iconKey;
@override final  String colorHex;
@override final  String roadmapSummary;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of StudyTrackEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudyTrackEntityCopyWith<_StudyTrackEntity> get copyWith => __$StudyTrackEntityCopyWithImpl<_StudyTrackEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudyTrackEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.iconKey, iconKey) || other.iconKey == iconKey)&&(identical(other.colorHex, colorHex) || other.colorHex == colorHex)&&(identical(other.roadmapSummary, roadmapSummary) || other.roadmapSummary == roadmapSummary)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,description,iconKey,colorHex,roadmapSummary,createdAt,updatedAt);

@override
String toString() {
  return 'StudyTrackEntity(id: $id, name: $name, description: $description, iconKey: $iconKey, colorHex: $colorHex, roadmapSummary: $roadmapSummary, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$StudyTrackEntityCopyWith<$Res> implements $StudyTrackEntityCopyWith<$Res> {
  factory _$StudyTrackEntityCopyWith(_StudyTrackEntity value, $Res Function(_StudyTrackEntity) _then) = __$StudyTrackEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String description, String iconKey, String colorHex, String roadmapSummary, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$StudyTrackEntityCopyWithImpl<$Res>
    implements _$StudyTrackEntityCopyWith<$Res> {
  __$StudyTrackEntityCopyWithImpl(this._self, this._then);

  final _StudyTrackEntity _self;
  final $Res Function(_StudyTrackEntity) _then;

/// Create a copy of StudyTrackEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? description = null,Object? iconKey = null,Object? colorHex = null,Object? roadmapSummary = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_StudyTrackEntity(
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
mixin _$StudySkillEntity {

 String get id; String get trackId; String get name; String get description; SkillLevel get targetLevel; int get sortOrder; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of StudySkillEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudySkillEntityCopyWith<StudySkillEntity> get copyWith => _$StudySkillEntityCopyWithImpl<StudySkillEntity>(this as StudySkillEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudySkillEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.targetLevel, targetLevel) || other.targetLevel == targetLevel)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,trackId,name,description,targetLevel,sortOrder,createdAt,updatedAt);

@override
String toString() {
  return 'StudySkillEntity(id: $id, trackId: $trackId, name: $name, description: $description, targetLevel: $targetLevel, sortOrder: $sortOrder, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $StudySkillEntityCopyWith<$Res>  {
  factory $StudySkillEntityCopyWith(StudySkillEntity value, $Res Function(StudySkillEntity) _then) = _$StudySkillEntityCopyWithImpl;
@useResult
$Res call({
 String id, String trackId, String name, String description, SkillLevel targetLevel, int sortOrder, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$StudySkillEntityCopyWithImpl<$Res>
    implements $StudySkillEntityCopyWith<$Res> {
  _$StudySkillEntityCopyWithImpl(this._self, this._then);

  final StudySkillEntity _self;
  final $Res Function(StudySkillEntity) _then;

/// Create a copy of StudySkillEntity
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


/// Adds pattern-matching-related methods to [StudySkillEntity].
extension StudySkillEntityPatterns on StudySkillEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudySkillEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudySkillEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudySkillEntity value)  $default,){
final _that = this;
switch (_that) {
case _StudySkillEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudySkillEntity value)?  $default,){
final _that = this;
switch (_that) {
case _StudySkillEntity() when $default != null:
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
case _StudySkillEntity() when $default != null:
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
case _StudySkillEntity():
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
case _StudySkillEntity() when $default != null:
return $default(_that.id,_that.trackId,_that.name,_that.description,_that.targetLevel,_that.sortOrder,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _StudySkillEntity implements StudySkillEntity {
  const _StudySkillEntity({required this.id, required this.trackId, required this.name, required this.description, required this.targetLevel, required this.sortOrder, required this.createdAt, required this.updatedAt});
  

@override final  String id;
@override final  String trackId;
@override final  String name;
@override final  String description;
@override final  SkillLevel targetLevel;
@override final  int sortOrder;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of StudySkillEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudySkillEntityCopyWith<_StudySkillEntity> get copyWith => __$StudySkillEntityCopyWithImpl<_StudySkillEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudySkillEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.name, name) || other.name == name)&&(identical(other.description, description) || other.description == description)&&(identical(other.targetLevel, targetLevel) || other.targetLevel == targetLevel)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,trackId,name,description,targetLevel,sortOrder,createdAt,updatedAt);

@override
String toString() {
  return 'StudySkillEntity(id: $id, trackId: $trackId, name: $name, description: $description, targetLevel: $targetLevel, sortOrder: $sortOrder, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$StudySkillEntityCopyWith<$Res> implements $StudySkillEntityCopyWith<$Res> {
  factory _$StudySkillEntityCopyWith(_StudySkillEntity value, $Res Function(_StudySkillEntity) _then) = __$StudySkillEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String trackId, String name, String description, SkillLevel targetLevel, int sortOrder, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$StudySkillEntityCopyWithImpl<$Res>
    implements _$StudySkillEntityCopyWith<$Res> {
  __$StudySkillEntityCopyWithImpl(this._self, this._then);

  final _StudySkillEntity _self;
  final $Res Function(_StudySkillEntity) _then;

/// Create a copy of StudySkillEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? trackId = null,Object? name = null,Object? description = null,Object? targetLevel = null,Object? sortOrder = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_StudySkillEntity(
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
mixin _$UserSkillProgressEntity {

 String get id; String get userId; String get skillId; double get progressPercent; DateTime? get lastStudiedAt; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of UserSkillProgressEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UserSkillProgressEntityCopyWith<UserSkillProgressEntity> get copyWith => _$UserSkillProgressEntityCopyWithImpl<UserSkillProgressEntity>(this as UserSkillProgressEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UserSkillProgressEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.skillId, skillId) || other.skillId == skillId)&&(identical(other.progressPercent, progressPercent) || other.progressPercent == progressPercent)&&(identical(other.lastStudiedAt, lastStudiedAt) || other.lastStudiedAt == lastStudiedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,skillId,progressPercent,lastStudiedAt,createdAt,updatedAt);

@override
String toString() {
  return 'UserSkillProgressEntity(id: $id, userId: $userId, skillId: $skillId, progressPercent: $progressPercent, lastStudiedAt: $lastStudiedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $UserSkillProgressEntityCopyWith<$Res>  {
  factory $UserSkillProgressEntityCopyWith(UserSkillProgressEntity value, $Res Function(UserSkillProgressEntity) _then) = _$UserSkillProgressEntityCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String skillId, double progressPercent, DateTime? lastStudiedAt, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$UserSkillProgressEntityCopyWithImpl<$Res>
    implements $UserSkillProgressEntityCopyWith<$Res> {
  _$UserSkillProgressEntityCopyWithImpl(this._self, this._then);

  final UserSkillProgressEntity _self;
  final $Res Function(UserSkillProgressEntity) _then;

/// Create a copy of UserSkillProgressEntity
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


/// Adds pattern-matching-related methods to [UserSkillProgressEntity].
extension UserSkillProgressEntityPatterns on UserSkillProgressEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _UserSkillProgressEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _UserSkillProgressEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _UserSkillProgressEntity value)  $default,){
final _that = this;
switch (_that) {
case _UserSkillProgressEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _UserSkillProgressEntity value)?  $default,){
final _that = this;
switch (_that) {
case _UserSkillProgressEntity() when $default != null:
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
case _UserSkillProgressEntity() when $default != null:
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
case _UserSkillProgressEntity():
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
case _UserSkillProgressEntity() when $default != null:
return $default(_that.id,_that.userId,_that.skillId,_that.progressPercent,_that.lastStudiedAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _UserSkillProgressEntity implements UserSkillProgressEntity {
  const _UserSkillProgressEntity({required this.id, required this.userId, required this.skillId, required this.progressPercent, this.lastStudiedAt, required this.createdAt, required this.updatedAt});
  

@override final  String id;
@override final  String userId;
@override final  String skillId;
@override final  double progressPercent;
@override final  DateTime? lastStudiedAt;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of UserSkillProgressEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$UserSkillProgressEntityCopyWith<_UserSkillProgressEntity> get copyWith => __$UserSkillProgressEntityCopyWithImpl<_UserSkillProgressEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _UserSkillProgressEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.skillId, skillId) || other.skillId == skillId)&&(identical(other.progressPercent, progressPercent) || other.progressPercent == progressPercent)&&(identical(other.lastStudiedAt, lastStudiedAt) || other.lastStudiedAt == lastStudiedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,skillId,progressPercent,lastStudiedAt,createdAt,updatedAt);

@override
String toString() {
  return 'UserSkillProgressEntity(id: $id, userId: $userId, skillId: $skillId, progressPercent: $progressPercent, lastStudiedAt: $lastStudiedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$UserSkillProgressEntityCopyWith<$Res> implements $UserSkillProgressEntityCopyWith<$Res> {
  factory _$UserSkillProgressEntityCopyWith(_UserSkillProgressEntity value, $Res Function(_UserSkillProgressEntity) _then) = __$UserSkillProgressEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String skillId, double progressPercent, DateTime? lastStudiedAt, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$UserSkillProgressEntityCopyWithImpl<$Res>
    implements _$UserSkillProgressEntityCopyWith<$Res> {
  __$UserSkillProgressEntityCopyWithImpl(this._self, this._then);

  final _UserSkillProgressEntity _self;
  final $Res Function(_UserSkillProgressEntity) _then;

/// Create a copy of UserSkillProgressEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? skillId = null,Object? progressPercent = null,Object? lastStudiedAt = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_UserSkillProgressEntity(
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
mixin _$StudyModuleEntity {

 String get id; String get trackId; String get title; String get summary; int get estimatedHours; int get sortOrder; bool get isCore; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of StudyModuleEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudyModuleEntityCopyWith<StudyModuleEntity> get copyWith => _$StudyModuleEntityCopyWithImpl<StudyModuleEntity>(this as StudyModuleEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudyModuleEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.title, title) || other.title == title)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.estimatedHours, estimatedHours) || other.estimatedHours == estimatedHours)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isCore, isCore) || other.isCore == isCore)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,trackId,title,summary,estimatedHours,sortOrder,isCore,createdAt,updatedAt);

@override
String toString() {
  return 'StudyModuleEntity(id: $id, trackId: $trackId, title: $title, summary: $summary, estimatedHours: $estimatedHours, sortOrder: $sortOrder, isCore: $isCore, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $StudyModuleEntityCopyWith<$Res>  {
  factory $StudyModuleEntityCopyWith(StudyModuleEntity value, $Res Function(StudyModuleEntity) _then) = _$StudyModuleEntityCopyWithImpl;
@useResult
$Res call({
 String id, String trackId, String title, String summary, int estimatedHours, int sortOrder, bool isCore, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$StudyModuleEntityCopyWithImpl<$Res>
    implements $StudyModuleEntityCopyWith<$Res> {
  _$StudyModuleEntityCopyWithImpl(this._self, this._then);

  final StudyModuleEntity _self;
  final $Res Function(StudyModuleEntity) _then;

/// Create a copy of StudyModuleEntity
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


/// Adds pattern-matching-related methods to [StudyModuleEntity].
extension StudyModuleEntityPatterns on StudyModuleEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudyModuleEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudyModuleEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudyModuleEntity value)  $default,){
final _that = this;
switch (_that) {
case _StudyModuleEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudyModuleEntity value)?  $default,){
final _that = this;
switch (_that) {
case _StudyModuleEntity() when $default != null:
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
case _StudyModuleEntity() when $default != null:
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
case _StudyModuleEntity():
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
case _StudyModuleEntity() when $default != null:
return $default(_that.id,_that.trackId,_that.title,_that.summary,_that.estimatedHours,_that.sortOrder,_that.isCore,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _StudyModuleEntity implements StudyModuleEntity {
  const _StudyModuleEntity({required this.id, required this.trackId, required this.title, required this.summary, required this.estimatedHours, required this.sortOrder, required this.isCore, required this.createdAt, required this.updatedAt});
  

@override final  String id;
@override final  String trackId;
@override final  String title;
@override final  String summary;
@override final  int estimatedHours;
@override final  int sortOrder;
@override final  bool isCore;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of StudyModuleEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudyModuleEntityCopyWith<_StudyModuleEntity> get copyWith => __$StudyModuleEntityCopyWithImpl<_StudyModuleEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudyModuleEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.title, title) || other.title == title)&&(identical(other.summary, summary) || other.summary == summary)&&(identical(other.estimatedHours, estimatedHours) || other.estimatedHours == estimatedHours)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.isCore, isCore) || other.isCore == isCore)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,trackId,title,summary,estimatedHours,sortOrder,isCore,createdAt,updatedAt);

@override
String toString() {
  return 'StudyModuleEntity(id: $id, trackId: $trackId, title: $title, summary: $summary, estimatedHours: $estimatedHours, sortOrder: $sortOrder, isCore: $isCore, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$StudyModuleEntityCopyWith<$Res> implements $StudyModuleEntityCopyWith<$Res> {
  factory _$StudyModuleEntityCopyWith(_StudyModuleEntity value, $Res Function(_StudyModuleEntity) _then) = __$StudyModuleEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String trackId, String title, String summary, int estimatedHours, int sortOrder, bool isCore, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$StudyModuleEntityCopyWithImpl<$Res>
    implements _$StudyModuleEntityCopyWith<$Res> {
  __$StudyModuleEntityCopyWithImpl(this._self, this._then);

  final _StudyModuleEntity _self;
  final $Res Function(_StudyModuleEntity) _then;

/// Create a copy of StudyModuleEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? trackId = null,Object? title = null,Object? summary = null,Object? estimatedHours = null,Object? sortOrder = null,Object? isCore = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_StudyModuleEntity(
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
mixin _$StudySessionEntity {

 String get id; String get userId; String? get trackId; String? get skillId; String? get moduleId; SessionType get type; DateTime get startTime; DateTime get endTime; int get durationMinutes; String get notes; int get productivityScore; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of StudySessionEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudySessionEntityCopyWith<StudySessionEntity> get copyWith => _$StudySessionEntityCopyWithImpl<StudySessionEntity>(this as StudySessionEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudySessionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.skillId, skillId) || other.skillId == skillId)&&(identical(other.moduleId, moduleId) || other.moduleId == moduleId)&&(identical(other.type, type) || other.type == type)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.productivityScore, productivityScore) || other.productivityScore == productivityScore)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,trackId,skillId,moduleId,type,startTime,endTime,durationMinutes,notes,productivityScore,createdAt,updatedAt);

@override
String toString() {
  return 'StudySessionEntity(id: $id, userId: $userId, trackId: $trackId, skillId: $skillId, moduleId: $moduleId, type: $type, startTime: $startTime, endTime: $endTime, durationMinutes: $durationMinutes, notes: $notes, productivityScore: $productivityScore, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $StudySessionEntityCopyWith<$Res>  {
  factory $StudySessionEntityCopyWith(StudySessionEntity value, $Res Function(StudySessionEntity) _then) = _$StudySessionEntityCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String? trackId, String? skillId, String? moduleId, SessionType type, DateTime startTime, DateTime endTime, int durationMinutes, String notes, int productivityScore, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$StudySessionEntityCopyWithImpl<$Res>
    implements $StudySessionEntityCopyWith<$Res> {
  _$StudySessionEntityCopyWithImpl(this._self, this._then);

  final StudySessionEntity _self;
  final $Res Function(StudySessionEntity) _then;

/// Create a copy of StudySessionEntity
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


/// Adds pattern-matching-related methods to [StudySessionEntity].
extension StudySessionEntityPatterns on StudySessionEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudySessionEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudySessionEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudySessionEntity value)  $default,){
final _that = this;
switch (_that) {
case _StudySessionEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudySessionEntity value)?  $default,){
final _that = this;
switch (_that) {
case _StudySessionEntity() when $default != null:
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
case _StudySessionEntity() when $default != null:
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
case _StudySessionEntity():
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
case _StudySessionEntity() when $default != null:
return $default(_that.id,_that.userId,_that.trackId,_that.skillId,_that.moduleId,_that.type,_that.startTime,_that.endTime,_that.durationMinutes,_that.notes,_that.productivityScore,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _StudySessionEntity implements StudySessionEntity {
  const _StudySessionEntity({required this.id, required this.userId, this.trackId, this.skillId, this.moduleId, required this.type, required this.startTime, required this.endTime, required this.durationMinutes, required this.notes, required this.productivityScore, required this.createdAt, required this.updatedAt});
  

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

/// Create a copy of StudySessionEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudySessionEntityCopyWith<_StudySessionEntity> get copyWith => __$StudySessionEntityCopyWithImpl<_StudySessionEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudySessionEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.skillId, skillId) || other.skillId == skillId)&&(identical(other.moduleId, moduleId) || other.moduleId == moduleId)&&(identical(other.type, type) || other.type == type)&&(identical(other.startTime, startTime) || other.startTime == startTime)&&(identical(other.endTime, endTime) || other.endTime == endTime)&&(identical(other.durationMinutes, durationMinutes) || other.durationMinutes == durationMinutes)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.productivityScore, productivityScore) || other.productivityScore == productivityScore)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,trackId,skillId,moduleId,type,startTime,endTime,durationMinutes,notes,productivityScore,createdAt,updatedAt);

@override
String toString() {
  return 'StudySessionEntity(id: $id, userId: $userId, trackId: $trackId, skillId: $skillId, moduleId: $moduleId, type: $type, startTime: $startTime, endTime: $endTime, durationMinutes: $durationMinutes, notes: $notes, productivityScore: $productivityScore, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$StudySessionEntityCopyWith<$Res> implements $StudySessionEntityCopyWith<$Res> {
  factory _$StudySessionEntityCopyWith(_StudySessionEntity value, $Res Function(_StudySessionEntity) _then) = __$StudySessionEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String? trackId, String? skillId, String? moduleId, SessionType type, DateTime startTime, DateTime endTime, int durationMinutes, String notes, int productivityScore, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$StudySessionEntityCopyWithImpl<$Res>
    implements _$StudySessionEntityCopyWith<$Res> {
  __$StudySessionEntityCopyWithImpl(this._self, this._then);

  final _StudySessionEntity _self;
  final $Res Function(_StudySessionEntity) _then;

/// Create a copy of StudySessionEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? trackId = freezed,Object? skillId = freezed,Object? moduleId = freezed,Object? type = null,Object? startTime = null,Object? endTime = null,Object? durationMinutes = null,Object? notes = null,Object? productivityScore = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_StudySessionEntity(
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
mixin _$TaskEntity {

 String get id; String get userId; String? get trackId; String? get moduleId; String get title; String get description; TaskPriority get priority; TaskStatus get status; DateTime? get dueDate; DateTime? get completedAt; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of TaskEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TaskEntityCopyWith<TaskEntity> get copyWith => _$TaskEntityCopyWithImpl<TaskEntity>(this as TaskEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TaskEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.moduleId, moduleId) || other.moduleId == moduleId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.status, status) || other.status == status)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,trackId,moduleId,title,description,priority,status,dueDate,completedAt,createdAt,updatedAt);

@override
String toString() {
  return 'TaskEntity(id: $id, userId: $userId, trackId: $trackId, moduleId: $moduleId, title: $title, description: $description, priority: $priority, status: $status, dueDate: $dueDate, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $TaskEntityCopyWith<$Res>  {
  factory $TaskEntityCopyWith(TaskEntity value, $Res Function(TaskEntity) _then) = _$TaskEntityCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String? trackId, String? moduleId, String title, String description, TaskPriority priority, TaskStatus status, DateTime? dueDate, DateTime? completedAt, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$TaskEntityCopyWithImpl<$Res>
    implements $TaskEntityCopyWith<$Res> {
  _$TaskEntityCopyWithImpl(this._self, this._then);

  final TaskEntity _self;
  final $Res Function(TaskEntity) _then;

/// Create a copy of TaskEntity
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


/// Adds pattern-matching-related methods to [TaskEntity].
extension TaskEntityPatterns on TaskEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TaskEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TaskEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TaskEntity value)  $default,){
final _that = this;
switch (_that) {
case _TaskEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TaskEntity value)?  $default,){
final _that = this;
switch (_that) {
case _TaskEntity() when $default != null:
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
case _TaskEntity() when $default != null:
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
case _TaskEntity():
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
case _TaskEntity() when $default != null:
return $default(_that.id,_that.userId,_that.trackId,_that.moduleId,_that.title,_that.description,_that.priority,_that.status,_that.dueDate,_that.completedAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _TaskEntity implements TaskEntity {
  const _TaskEntity({required this.id, required this.userId, this.trackId, this.moduleId, required this.title, required this.description, required this.priority, required this.status, this.dueDate, this.completedAt, required this.createdAt, required this.updatedAt});
  

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

/// Create a copy of TaskEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TaskEntityCopyWith<_TaskEntity> get copyWith => __$TaskEntityCopyWithImpl<_TaskEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TaskEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.moduleId, moduleId) || other.moduleId == moduleId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.priority, priority) || other.priority == priority)&&(identical(other.status, status) || other.status == status)&&(identical(other.dueDate, dueDate) || other.dueDate == dueDate)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,trackId,moduleId,title,description,priority,status,dueDate,completedAt,createdAt,updatedAt);

@override
String toString() {
  return 'TaskEntity(id: $id, userId: $userId, trackId: $trackId, moduleId: $moduleId, title: $title, description: $description, priority: $priority, status: $status, dueDate: $dueDate, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$TaskEntityCopyWith<$Res> implements $TaskEntityCopyWith<$Res> {
  factory _$TaskEntityCopyWith(_TaskEntity value, $Res Function(_TaskEntity) _then) = __$TaskEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String? trackId, String? moduleId, String title, String description, TaskPriority priority, TaskStatus status, DateTime? dueDate, DateTime? completedAt, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$TaskEntityCopyWithImpl<$Res>
    implements _$TaskEntityCopyWith<$Res> {
  __$TaskEntityCopyWithImpl(this._self, this._then);

  final _TaskEntity _self;
  final $Res Function(_TaskEntity) _then;

/// Create a copy of TaskEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? trackId = freezed,Object? moduleId = freezed,Object? title = null,Object? description = null,Object? priority = null,Object? status = null,Object? dueDate = freezed,Object? completedAt = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_TaskEntity(
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
mixin _$ReviewEntity {

 String get id; String get userId; String? get sessionId; String? get trackId; String? get skillId; String get title; DateTime get scheduledFor; ReviewStatus get status; String get intervalLabel; String? get notes; DateTime? get completedAt; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of ReviewEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ReviewEntityCopyWith<ReviewEntity> get copyWith => _$ReviewEntityCopyWithImpl<ReviewEntity>(this as ReviewEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ReviewEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.skillId, skillId) || other.skillId == skillId)&&(identical(other.title, title) || other.title == title)&&(identical(other.scheduledFor, scheduledFor) || other.scheduledFor == scheduledFor)&&(identical(other.status, status) || other.status == status)&&(identical(other.intervalLabel, intervalLabel) || other.intervalLabel == intervalLabel)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,sessionId,trackId,skillId,title,scheduledFor,status,intervalLabel,notes,completedAt,createdAt,updatedAt);

@override
String toString() {
  return 'ReviewEntity(id: $id, userId: $userId, sessionId: $sessionId, trackId: $trackId, skillId: $skillId, title: $title, scheduledFor: $scheduledFor, status: $status, intervalLabel: $intervalLabel, notes: $notes, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ReviewEntityCopyWith<$Res>  {
  factory $ReviewEntityCopyWith(ReviewEntity value, $Res Function(ReviewEntity) _then) = _$ReviewEntityCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String? sessionId, String? trackId, String? skillId, String title, DateTime scheduledFor, ReviewStatus status, String intervalLabel, String? notes, DateTime? completedAt, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$ReviewEntityCopyWithImpl<$Res>
    implements $ReviewEntityCopyWith<$Res> {
  _$ReviewEntityCopyWithImpl(this._self, this._then);

  final ReviewEntity _self;
  final $Res Function(ReviewEntity) _then;

/// Create a copy of ReviewEntity
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


/// Adds pattern-matching-related methods to [ReviewEntity].
extension ReviewEntityPatterns on ReviewEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ReviewEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ReviewEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ReviewEntity value)  $default,){
final _that = this;
switch (_that) {
case _ReviewEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ReviewEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ReviewEntity() when $default != null:
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
case _ReviewEntity() when $default != null:
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
case _ReviewEntity():
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
case _ReviewEntity() when $default != null:
return $default(_that.id,_that.userId,_that.sessionId,_that.trackId,_that.skillId,_that.title,_that.scheduledFor,_that.status,_that.intervalLabel,_that.notes,_that.completedAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _ReviewEntity implements ReviewEntity {
  const _ReviewEntity({required this.id, required this.userId, this.sessionId, this.trackId, this.skillId, required this.title, required this.scheduledFor, required this.status, required this.intervalLabel, this.notes, this.completedAt, required this.createdAt, required this.updatedAt});
  

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

/// Create a copy of ReviewEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ReviewEntityCopyWith<_ReviewEntity> get copyWith => __$ReviewEntityCopyWithImpl<_ReviewEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ReviewEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.skillId, skillId) || other.skillId == skillId)&&(identical(other.title, title) || other.title == title)&&(identical(other.scheduledFor, scheduledFor) || other.scheduledFor == scheduledFor)&&(identical(other.status, status) || other.status == status)&&(identical(other.intervalLabel, intervalLabel) || other.intervalLabel == intervalLabel)&&(identical(other.notes, notes) || other.notes == notes)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,sessionId,trackId,skillId,title,scheduledFor,status,intervalLabel,notes,completedAt,createdAt,updatedAt);

@override
String toString() {
  return 'ReviewEntity(id: $id, userId: $userId, sessionId: $sessionId, trackId: $trackId, skillId: $skillId, title: $title, scheduledFor: $scheduledFor, status: $status, intervalLabel: $intervalLabel, notes: $notes, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ReviewEntityCopyWith<$Res> implements $ReviewEntityCopyWith<$Res> {
  factory _$ReviewEntityCopyWith(_ReviewEntity value, $Res Function(_ReviewEntity) _then) = __$ReviewEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String? sessionId, String? trackId, String? skillId, String title, DateTime scheduledFor, ReviewStatus status, String intervalLabel, String? notes, DateTime? completedAt, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$ReviewEntityCopyWithImpl<$Res>
    implements _$ReviewEntityCopyWith<$Res> {
  __$ReviewEntityCopyWithImpl(this._self, this._then);

  final _ReviewEntity _self;
  final $Res Function(_ReviewEntity) _then;

/// Create a copy of ReviewEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? sessionId = freezed,Object? trackId = freezed,Object? skillId = freezed,Object? title = null,Object? scheduledFor = null,Object? status = null,Object? intervalLabel = null,Object? notes = freezed,Object? completedAt = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_ReviewEntity(
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
mixin _$ProjectEntity {

 String get id; String get userId; String? get trackId; String get title; String get scope; String get description; String? get repositoryUrl; String? get documentationUrl; String? get videoUrl; ProjectStatus get status; double get progressPercent; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of ProjectEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectEntityCopyWith<ProjectEntity> get copyWith => _$ProjectEntityCopyWithImpl<ProjectEntity>(this as ProjectEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.title, title) || other.title == title)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.description, description) || other.description == description)&&(identical(other.repositoryUrl, repositoryUrl) || other.repositoryUrl == repositoryUrl)&&(identical(other.documentationUrl, documentationUrl) || other.documentationUrl == documentationUrl)&&(identical(other.videoUrl, videoUrl) || other.videoUrl == videoUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.progressPercent, progressPercent) || other.progressPercent == progressPercent)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,trackId,title,scope,description,repositoryUrl,documentationUrl,videoUrl,status,progressPercent,createdAt,updatedAt);

@override
String toString() {
  return 'ProjectEntity(id: $id, userId: $userId, trackId: $trackId, title: $title, scope: $scope, description: $description, repositoryUrl: $repositoryUrl, documentationUrl: $documentationUrl, videoUrl: $videoUrl, status: $status, progressPercent: $progressPercent, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ProjectEntityCopyWith<$Res>  {
  factory $ProjectEntityCopyWith(ProjectEntity value, $Res Function(ProjectEntity) _then) = _$ProjectEntityCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String? trackId, String title, String scope, String description, String? repositoryUrl, String? documentationUrl, String? videoUrl, ProjectStatus status, double progressPercent, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$ProjectEntityCopyWithImpl<$Res>
    implements $ProjectEntityCopyWith<$Res> {
  _$ProjectEntityCopyWithImpl(this._self, this._then);

  final ProjectEntity _self;
  final $Res Function(ProjectEntity) _then;

/// Create a copy of ProjectEntity
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


/// Adds pattern-matching-related methods to [ProjectEntity].
extension ProjectEntityPatterns on ProjectEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectEntity value)  $default,){
final _that = this;
switch (_that) {
case _ProjectEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectEntity() when $default != null:
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
case _ProjectEntity() when $default != null:
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
case _ProjectEntity():
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
case _ProjectEntity() when $default != null:
return $default(_that.id,_that.userId,_that.trackId,_that.title,_that.scope,_that.description,_that.repositoryUrl,_that.documentationUrl,_that.videoUrl,_that.status,_that.progressPercent,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _ProjectEntity implements ProjectEntity {
  const _ProjectEntity({required this.id, required this.userId, this.trackId, required this.title, required this.scope, required this.description, this.repositoryUrl, this.documentationUrl, this.videoUrl, required this.status, required this.progressPercent, required this.createdAt, required this.updatedAt});
  

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

/// Create a copy of ProjectEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectEntityCopyWith<_ProjectEntity> get copyWith => __$ProjectEntityCopyWithImpl<_ProjectEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.title, title) || other.title == title)&&(identical(other.scope, scope) || other.scope == scope)&&(identical(other.description, description) || other.description == description)&&(identical(other.repositoryUrl, repositoryUrl) || other.repositoryUrl == repositoryUrl)&&(identical(other.documentationUrl, documentationUrl) || other.documentationUrl == documentationUrl)&&(identical(other.videoUrl, videoUrl) || other.videoUrl == videoUrl)&&(identical(other.status, status) || other.status == status)&&(identical(other.progressPercent, progressPercent) || other.progressPercent == progressPercent)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,trackId,title,scope,description,repositoryUrl,documentationUrl,videoUrl,status,progressPercent,createdAt,updatedAt);

@override
String toString() {
  return 'ProjectEntity(id: $id, userId: $userId, trackId: $trackId, title: $title, scope: $scope, description: $description, repositoryUrl: $repositoryUrl, documentationUrl: $documentationUrl, videoUrl: $videoUrl, status: $status, progressPercent: $progressPercent, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ProjectEntityCopyWith<$Res> implements $ProjectEntityCopyWith<$Res> {
  factory _$ProjectEntityCopyWith(_ProjectEntity value, $Res Function(_ProjectEntity) _then) = __$ProjectEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String? trackId, String title, String scope, String description, String? repositoryUrl, String? documentationUrl, String? videoUrl, ProjectStatus status, double progressPercent, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$ProjectEntityCopyWithImpl<$Res>
    implements _$ProjectEntityCopyWith<$Res> {
  __$ProjectEntityCopyWithImpl(this._self, this._then);

  final _ProjectEntity _self;
  final $Res Function(_ProjectEntity) _then;

/// Create a copy of ProjectEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? trackId = freezed,Object? title = null,Object? scope = null,Object? description = null,Object? repositoryUrl = freezed,Object? documentationUrl = freezed,Object? videoUrl = freezed,Object? status = null,Object? progressPercent = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_ProjectEntity(
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
mixin _$ProjectStepEntity {

 String get id; String get projectId; String get title; String get description; bool get isDone; int get sortOrder; DateTime? get completedAt; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of ProjectStepEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProjectStepEntityCopyWith<ProjectStepEntity> get copyWith => _$ProjectStepEntityCopyWithImpl<ProjectStepEntity>(this as ProjectStepEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProjectStepEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.isDone, isDone) || other.isDone == isDone)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,projectId,title,description,isDone,sortOrder,completedAt,createdAt,updatedAt);

@override
String toString() {
  return 'ProjectStepEntity(id: $id, projectId: $projectId, title: $title, description: $description, isDone: $isDone, sortOrder: $sortOrder, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ProjectStepEntityCopyWith<$Res>  {
  factory $ProjectStepEntityCopyWith(ProjectStepEntity value, $Res Function(ProjectStepEntity) _then) = _$ProjectStepEntityCopyWithImpl;
@useResult
$Res call({
 String id, String projectId, String title, String description, bool isDone, int sortOrder, DateTime? completedAt, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$ProjectStepEntityCopyWithImpl<$Res>
    implements $ProjectStepEntityCopyWith<$Res> {
  _$ProjectStepEntityCopyWithImpl(this._self, this._then);

  final ProjectStepEntity _self;
  final $Res Function(ProjectStepEntity) _then;

/// Create a copy of ProjectStepEntity
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


/// Adds pattern-matching-related methods to [ProjectStepEntity].
extension ProjectStepEntityPatterns on ProjectStepEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProjectStepEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProjectStepEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProjectStepEntity value)  $default,){
final _that = this;
switch (_that) {
case _ProjectStepEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProjectStepEntity value)?  $default,){
final _that = this;
switch (_that) {
case _ProjectStepEntity() when $default != null:
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
case _ProjectStepEntity() when $default != null:
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
case _ProjectStepEntity():
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
case _ProjectStepEntity() when $default != null:
return $default(_that.id,_that.projectId,_that.title,_that.description,_that.isDone,_that.sortOrder,_that.completedAt,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _ProjectStepEntity implements ProjectStepEntity {
  const _ProjectStepEntity({required this.id, required this.projectId, required this.title, required this.description, required this.isDone, required this.sortOrder, this.completedAt, required this.createdAt, required this.updatedAt});
  

@override final  String id;
@override final  String projectId;
@override final  String title;
@override final  String description;
@override final  bool isDone;
@override final  int sortOrder;
@override final  DateTime? completedAt;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of ProjectStepEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProjectStepEntityCopyWith<_ProjectStepEntity> get copyWith => __$ProjectStepEntityCopyWithImpl<_ProjectStepEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProjectStepEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.title, title) || other.title == title)&&(identical(other.description, description) || other.description == description)&&(identical(other.isDone, isDone) || other.isDone == isDone)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder)&&(identical(other.completedAt, completedAt) || other.completedAt == completedAt)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,projectId,title,description,isDone,sortOrder,completedAt,createdAt,updatedAt);

@override
String toString() {
  return 'ProjectStepEntity(id: $id, projectId: $projectId, title: $title, description: $description, isDone: $isDone, sortOrder: $sortOrder, completedAt: $completedAt, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ProjectStepEntityCopyWith<$Res> implements $ProjectStepEntityCopyWith<$Res> {
  factory _$ProjectStepEntityCopyWith(_ProjectStepEntity value, $Res Function(_ProjectStepEntity) _then) = __$ProjectStepEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String projectId, String title, String description, bool isDone, int sortOrder, DateTime? completedAt, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$ProjectStepEntityCopyWithImpl<$Res>
    implements _$ProjectStepEntityCopyWith<$Res> {
  __$ProjectStepEntityCopyWithImpl(this._self, this._then);

  final _ProjectStepEntity _self;
  final $Res Function(_ProjectStepEntity) _then;

/// Create a copy of ProjectStepEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? projectId = null,Object? title = null,Object? description = null,Object? isDone = null,Object? sortOrder = null,Object? completedAt = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_ProjectStepEntity(
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
mixin _$StudyNoteEntity {

 String get id; String get userId; String get folderName; String get title; String get content; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of StudyNoteEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StudyNoteEntityCopyWith<StudyNoteEntity> get copyWith => _$StudyNoteEntityCopyWithImpl<StudyNoteEntity>(this as StudyNoteEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StudyNoteEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.folderName, folderName) || other.folderName == folderName)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,folderName,title,content,createdAt,updatedAt);

@override
String toString() {
  return 'StudyNoteEntity(id: $id, userId: $userId, folderName: $folderName, title: $title, content: $content, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $StudyNoteEntityCopyWith<$Res>  {
  factory $StudyNoteEntityCopyWith(StudyNoteEntity value, $Res Function(StudyNoteEntity) _then) = _$StudyNoteEntityCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String folderName, String title, String content, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$StudyNoteEntityCopyWithImpl<$Res>
    implements $StudyNoteEntityCopyWith<$Res> {
  _$StudyNoteEntityCopyWithImpl(this._self, this._then);

  final StudyNoteEntity _self;
  final $Res Function(StudyNoteEntity) _then;

/// Create a copy of StudyNoteEntity
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


/// Adds pattern-matching-related methods to [StudyNoteEntity].
extension StudyNoteEntityPatterns on StudyNoteEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StudyNoteEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StudyNoteEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StudyNoteEntity value)  $default,){
final _that = this;
switch (_that) {
case _StudyNoteEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StudyNoteEntity value)?  $default,){
final _that = this;
switch (_that) {
case _StudyNoteEntity() when $default != null:
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
case _StudyNoteEntity() when $default != null:
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
case _StudyNoteEntity():
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
case _StudyNoteEntity() when $default != null:
return $default(_that.id,_that.userId,_that.folderName,_that.title,_that.content,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _StudyNoteEntity implements StudyNoteEntity {
  const _StudyNoteEntity({required this.id, required this.userId, required this.folderName, required this.title, required this.content, required this.createdAt, required this.updatedAt});
  

@override final  String id;
@override final  String userId;
@override final  String folderName;
@override final  String title;
@override final  String content;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of StudyNoteEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StudyNoteEntityCopyWith<_StudyNoteEntity> get copyWith => __$StudyNoteEntityCopyWithImpl<_StudyNoteEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StudyNoteEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.folderName, folderName) || other.folderName == folderName)&&(identical(other.title, title) || other.title == title)&&(identical(other.content, content) || other.content == content)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,folderName,title,content,createdAt,updatedAt);

@override
String toString() {
  return 'StudyNoteEntity(id: $id, userId: $userId, folderName: $folderName, title: $title, content: $content, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$StudyNoteEntityCopyWith<$Res> implements $StudyNoteEntityCopyWith<$Res> {
  factory _$StudyNoteEntityCopyWith(_StudyNoteEntity value, $Res Function(_StudyNoteEntity) _then) = __$StudyNoteEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String folderName, String title, String content, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$StudyNoteEntityCopyWithImpl<$Res>
    implements _$StudyNoteEntityCopyWith<$Res> {
  __$StudyNoteEntityCopyWithImpl(this._self, this._then);

  final _StudyNoteEntity _self;
  final $Res Function(_StudyNoteEntity) _then;

/// Create a copy of StudyNoteEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? folderName = null,Object? title = null,Object? content = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_StudyNoteEntity(
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
mixin _$FlashcardEntity {

 String get id; String get userId; String get deckName; String get question; String get answer; String? get trackId; String? get moduleId; String? get projectId; DateTime get dueAt; DateTime? get lastReviewedAt; int get reviewCount; int get correctStreak; double get easeFactor; int get intervalDays; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of FlashcardEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FlashcardEntityCopyWith<FlashcardEntity> get copyWith => _$FlashcardEntityCopyWithImpl<FlashcardEntity>(this as FlashcardEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FlashcardEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.deckName, deckName) || other.deckName == deckName)&&(identical(other.question, question) || other.question == question)&&(identical(other.answer, answer) || other.answer == answer)&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.moduleId, moduleId) || other.moduleId == moduleId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.lastReviewedAt, lastReviewedAt) || other.lastReviewedAt == lastReviewedAt)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&(identical(other.correctStreak, correctStreak) || other.correctStreak == correctStreak)&&(identical(other.easeFactor, easeFactor) || other.easeFactor == easeFactor)&&(identical(other.intervalDays, intervalDays) || other.intervalDays == intervalDays)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,deckName,question,answer,trackId,moduleId,projectId,dueAt,lastReviewedAt,reviewCount,correctStreak,easeFactor,intervalDays,createdAt,updatedAt);

@override
String toString() {
  return 'FlashcardEntity(id: $id, userId: $userId, deckName: $deckName, question: $question, answer: $answer, trackId: $trackId, moduleId: $moduleId, projectId: $projectId, dueAt: $dueAt, lastReviewedAt: $lastReviewedAt, reviewCount: $reviewCount, correctStreak: $correctStreak, easeFactor: $easeFactor, intervalDays: $intervalDays, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $FlashcardEntityCopyWith<$Res>  {
  factory $FlashcardEntityCopyWith(FlashcardEntity value, $Res Function(FlashcardEntity) _then) = _$FlashcardEntityCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String deckName, String question, String answer, String? trackId, String? moduleId, String? projectId, DateTime dueAt, DateTime? lastReviewedAt, int reviewCount, int correctStreak, double easeFactor, int intervalDays, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$FlashcardEntityCopyWithImpl<$Res>
    implements $FlashcardEntityCopyWith<$Res> {
  _$FlashcardEntityCopyWithImpl(this._self, this._then);

  final FlashcardEntity _self;
  final $Res Function(FlashcardEntity) _then;

/// Create a copy of FlashcardEntity
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


/// Adds pattern-matching-related methods to [FlashcardEntity].
extension FlashcardEntityPatterns on FlashcardEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FlashcardEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FlashcardEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FlashcardEntity value)  $default,){
final _that = this;
switch (_that) {
case _FlashcardEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FlashcardEntity value)?  $default,){
final _that = this;
switch (_that) {
case _FlashcardEntity() when $default != null:
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
case _FlashcardEntity() when $default != null:
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
case _FlashcardEntity():
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
case _FlashcardEntity() when $default != null:
return $default(_that.id,_that.userId,_that.deckName,_that.question,_that.answer,_that.trackId,_that.moduleId,_that.projectId,_that.dueAt,_that.lastReviewedAt,_that.reviewCount,_that.correctStreak,_that.easeFactor,_that.intervalDays,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _FlashcardEntity implements FlashcardEntity {
  const _FlashcardEntity({required this.id, required this.userId, required this.deckName, required this.question, required this.answer, this.trackId, this.moduleId, this.projectId, required this.dueAt, this.lastReviewedAt, required this.reviewCount, required this.correctStreak, required this.easeFactor, required this.intervalDays, required this.createdAt, required this.updatedAt});
  

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

/// Create a copy of FlashcardEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FlashcardEntityCopyWith<_FlashcardEntity> get copyWith => __$FlashcardEntityCopyWithImpl<_FlashcardEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _FlashcardEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.deckName, deckName) || other.deckName == deckName)&&(identical(other.question, question) || other.question == question)&&(identical(other.answer, answer) || other.answer == answer)&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.moduleId, moduleId) || other.moduleId == moduleId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.dueAt, dueAt) || other.dueAt == dueAt)&&(identical(other.lastReviewedAt, lastReviewedAt) || other.lastReviewedAt == lastReviewedAt)&&(identical(other.reviewCount, reviewCount) || other.reviewCount == reviewCount)&&(identical(other.correctStreak, correctStreak) || other.correctStreak == correctStreak)&&(identical(other.easeFactor, easeFactor) || other.easeFactor == easeFactor)&&(identical(other.intervalDays, intervalDays) || other.intervalDays == intervalDays)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,deckName,question,answer,trackId,moduleId,projectId,dueAt,lastReviewedAt,reviewCount,correctStreak,easeFactor,intervalDays,createdAt,updatedAt);

@override
String toString() {
  return 'FlashcardEntity(id: $id, userId: $userId, deckName: $deckName, question: $question, answer: $answer, trackId: $trackId, moduleId: $moduleId, projectId: $projectId, dueAt: $dueAt, lastReviewedAt: $lastReviewedAt, reviewCount: $reviewCount, correctStreak: $correctStreak, easeFactor: $easeFactor, intervalDays: $intervalDays, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$FlashcardEntityCopyWith<$Res> implements $FlashcardEntityCopyWith<$Res> {
  factory _$FlashcardEntityCopyWith(_FlashcardEntity value, $Res Function(_FlashcardEntity) _then) = __$FlashcardEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String deckName, String question, String answer, String? trackId, String? moduleId, String? projectId, DateTime dueAt, DateTime? lastReviewedAt, int reviewCount, int correctStreak, double easeFactor, int intervalDays, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$FlashcardEntityCopyWithImpl<$Res>
    implements _$FlashcardEntityCopyWith<$Res> {
  __$FlashcardEntityCopyWithImpl(this._self, this._then);

  final _FlashcardEntity _self;
  final $Res Function(_FlashcardEntity) _then;

/// Create a copy of FlashcardEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? deckName = null,Object? question = null,Object? answer = null,Object? trackId = freezed,Object? moduleId = freezed,Object? projectId = freezed,Object? dueAt = null,Object? lastReviewedAt = freezed,Object? reviewCount = null,Object? correctStreak = null,Object? easeFactor = null,Object? intervalDays = null,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_FlashcardEntity(
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
mixin _$MindMapEntity {

 String get id; String get userId; String get folderName; String get title; String get contentJson; String? get trackId; String? get moduleId; String? get projectId; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of MindMapEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MindMapEntityCopyWith<MindMapEntity> get copyWith => _$MindMapEntityCopyWithImpl<MindMapEntity>(this as MindMapEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MindMapEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.folderName, folderName) || other.folderName == folderName)&&(identical(other.title, title) || other.title == title)&&(identical(other.contentJson, contentJson) || other.contentJson == contentJson)&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.moduleId, moduleId) || other.moduleId == moduleId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,folderName,title,contentJson,trackId,moduleId,projectId,createdAt,updatedAt);

@override
String toString() {
  return 'MindMapEntity(id: $id, userId: $userId, folderName: $folderName, title: $title, contentJson: $contentJson, trackId: $trackId, moduleId: $moduleId, projectId: $projectId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $MindMapEntityCopyWith<$Res>  {
  factory $MindMapEntityCopyWith(MindMapEntity value, $Res Function(MindMapEntity) _then) = _$MindMapEntityCopyWithImpl;
@useResult
$Res call({
 String id, String userId, String folderName, String title, String contentJson, String? trackId, String? moduleId, String? projectId, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$MindMapEntityCopyWithImpl<$Res>
    implements $MindMapEntityCopyWith<$Res> {
  _$MindMapEntityCopyWithImpl(this._self, this._then);

  final MindMapEntity _self;
  final $Res Function(MindMapEntity) _then;

/// Create a copy of MindMapEntity
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


/// Adds pattern-matching-related methods to [MindMapEntity].
extension MindMapEntityPatterns on MindMapEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MindMapEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MindMapEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MindMapEntity value)  $default,){
final _that = this;
switch (_that) {
case _MindMapEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MindMapEntity value)?  $default,){
final _that = this;
switch (_that) {
case _MindMapEntity() when $default != null:
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
case _MindMapEntity() when $default != null:
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
case _MindMapEntity():
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
case _MindMapEntity() when $default != null:
return $default(_that.id,_that.userId,_that.folderName,_that.title,_that.contentJson,_that.trackId,_that.moduleId,_that.projectId,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _MindMapEntity implements MindMapEntity {
  const _MindMapEntity({required this.id, required this.userId, required this.folderName, required this.title, required this.contentJson, this.trackId, this.moduleId, this.projectId, required this.createdAt, required this.updatedAt});
  

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

/// Create a copy of MindMapEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MindMapEntityCopyWith<_MindMapEntity> get copyWith => __$MindMapEntityCopyWithImpl<_MindMapEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _MindMapEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.folderName, folderName) || other.folderName == folderName)&&(identical(other.title, title) || other.title == title)&&(identical(other.contentJson, contentJson) || other.contentJson == contentJson)&&(identical(other.trackId, trackId) || other.trackId == trackId)&&(identical(other.moduleId, moduleId) || other.moduleId == moduleId)&&(identical(other.projectId, projectId) || other.projectId == projectId)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,folderName,title,contentJson,trackId,moduleId,projectId,createdAt,updatedAt);

@override
String toString() {
  return 'MindMapEntity(id: $id, userId: $userId, folderName: $folderName, title: $title, contentJson: $contentJson, trackId: $trackId, moduleId: $moduleId, projectId: $projectId, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$MindMapEntityCopyWith<$Res> implements $MindMapEntityCopyWith<$Res> {
  factory _$MindMapEntityCopyWith(_MindMapEntity value, $Res Function(_MindMapEntity) _then) = __$MindMapEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, String folderName, String title, String contentJson, String? trackId, String? moduleId, String? projectId, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$MindMapEntityCopyWithImpl<$Res>
    implements _$MindMapEntityCopyWith<$Res> {
  __$MindMapEntityCopyWithImpl(this._self, this._then);

  final _MindMapEntity _self;
  final $Res Function(_MindMapEntity) _then;

/// Create a copy of MindMapEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? folderName = null,Object? title = null,Object? contentJson = null,Object? trackId = freezed,Object? moduleId = freezed,Object? projectId = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_MindMapEntity(
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
mixin _$AppSettingsEntity {

 String get id; String get userId; ThemePreference get themePreference; bool get notificationsEnabled; int? get dailyReminderHour; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of AppSettingsEntity
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AppSettingsEntityCopyWith<AppSettingsEntity> get copyWith => _$AppSettingsEntityCopyWithImpl<AppSettingsEntity>(this as AppSettingsEntity, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AppSettingsEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.themePreference, themePreference) || other.themePreference == themePreference)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled)&&(identical(other.dailyReminderHour, dailyReminderHour) || other.dailyReminderHour == dailyReminderHour)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,themePreference,notificationsEnabled,dailyReminderHour,createdAt,updatedAt);

@override
String toString() {
  return 'AppSettingsEntity(id: $id, userId: $userId, themePreference: $themePreference, notificationsEnabled: $notificationsEnabled, dailyReminderHour: $dailyReminderHour, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $AppSettingsEntityCopyWith<$Res>  {
  factory $AppSettingsEntityCopyWith(AppSettingsEntity value, $Res Function(AppSettingsEntity) _then) = _$AppSettingsEntityCopyWithImpl;
@useResult
$Res call({
 String id, String userId, ThemePreference themePreference, bool notificationsEnabled, int? dailyReminderHour, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class _$AppSettingsEntityCopyWithImpl<$Res>
    implements $AppSettingsEntityCopyWith<$Res> {
  _$AppSettingsEntityCopyWithImpl(this._self, this._then);

  final AppSettingsEntity _self;
  final $Res Function(AppSettingsEntity) _then;

/// Create a copy of AppSettingsEntity
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


/// Adds pattern-matching-related methods to [AppSettingsEntity].
extension AppSettingsEntityPatterns on AppSettingsEntity {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AppSettingsEntity value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AppSettingsEntity() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AppSettingsEntity value)  $default,){
final _that = this;
switch (_that) {
case _AppSettingsEntity():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AppSettingsEntity value)?  $default,){
final _that = this;
switch (_that) {
case _AppSettingsEntity() when $default != null:
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
case _AppSettingsEntity() when $default != null:
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
case _AppSettingsEntity():
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
case _AppSettingsEntity() when $default != null:
return $default(_that.id,_that.userId,_that.themePreference,_that.notificationsEnabled,_that.dailyReminderHour,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _AppSettingsEntity implements AppSettingsEntity {
  const _AppSettingsEntity({required this.id, required this.userId, required this.themePreference, required this.notificationsEnabled, this.dailyReminderHour, required this.createdAt, required this.updatedAt});
  

@override final  String id;
@override final  String userId;
@override final  ThemePreference themePreference;
@override final  bool notificationsEnabled;
@override final  int? dailyReminderHour;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of AppSettingsEntity
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AppSettingsEntityCopyWith<_AppSettingsEntity> get copyWith => __$AppSettingsEntityCopyWithImpl<_AppSettingsEntity>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AppSettingsEntity&&(identical(other.id, id) || other.id == id)&&(identical(other.userId, userId) || other.userId == userId)&&(identical(other.themePreference, themePreference) || other.themePreference == themePreference)&&(identical(other.notificationsEnabled, notificationsEnabled) || other.notificationsEnabled == notificationsEnabled)&&(identical(other.dailyReminderHour, dailyReminderHour) || other.dailyReminderHour == dailyReminderHour)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,userId,themePreference,notificationsEnabled,dailyReminderHour,createdAt,updatedAt);

@override
String toString() {
  return 'AppSettingsEntity(id: $id, userId: $userId, themePreference: $themePreference, notificationsEnabled: $notificationsEnabled, dailyReminderHour: $dailyReminderHour, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$AppSettingsEntityCopyWith<$Res> implements $AppSettingsEntityCopyWith<$Res> {
  factory _$AppSettingsEntityCopyWith(_AppSettingsEntity value, $Res Function(_AppSettingsEntity) _then) = __$AppSettingsEntityCopyWithImpl;
@override @useResult
$Res call({
 String id, String userId, ThemePreference themePreference, bool notificationsEnabled, int? dailyReminderHour, DateTime createdAt, DateTime updatedAt
});




}
/// @nodoc
class __$AppSettingsEntityCopyWithImpl<$Res>
    implements _$AppSettingsEntityCopyWith<$Res> {
  __$AppSettingsEntityCopyWithImpl(this._self, this._then);

  final _AppSettingsEntity _self;
  final $Res Function(_AppSettingsEntity) _then;

/// Create a copy of AppSettingsEntity
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? userId = null,Object? themePreference = null,Object? notificationsEnabled = null,Object? dailyReminderHour = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_AppSettingsEntity(
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
