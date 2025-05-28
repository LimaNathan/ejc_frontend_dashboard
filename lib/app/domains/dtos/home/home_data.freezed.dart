// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'home_data.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$HomeData {
  int? get totalAnswers => throw _privateConstructorUsedError;
  int? get totalAnswersUntilThreeDays => throw _privateConstructorUsedError;
  List<PersonModel>? get lastAnswers => throw _privateConstructorUsedError;

  /// Create a copy of HomeData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $HomeDataCopyWith<HomeData> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $HomeDataCopyWith<$Res> {
  factory $HomeDataCopyWith(HomeData value, $Res Function(HomeData) then) =
      _$HomeDataCopyWithImpl<$Res, HomeData>;
  @useResult
  $Res call(
      {int? totalAnswers,
      int? totalAnswersUntilThreeDays,
      List<PersonModel>? lastAnswers});
}

/// @nodoc
class _$HomeDataCopyWithImpl<$Res, $Val extends HomeData>
    implements $HomeDataCopyWith<$Res> {
  _$HomeDataCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of HomeData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalAnswers = freezed,
    Object? totalAnswersUntilThreeDays = freezed,
    Object? lastAnswers = freezed,
  }) {
    return _then(_value.copyWith(
      totalAnswers: freezed == totalAnswers
          ? _value.totalAnswers
          : totalAnswers // ignore: cast_nullable_to_non_nullable
              as int?,
      totalAnswersUntilThreeDays: freezed == totalAnswersUntilThreeDays
          ? _value.totalAnswersUntilThreeDays
          : totalAnswersUntilThreeDays // ignore: cast_nullable_to_non_nullable
              as int?,
      lastAnswers: freezed == lastAnswers
          ? _value.lastAnswers
          : lastAnswers // ignore: cast_nullable_to_non_nullable
              as List<PersonModel>?,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$HomeDataImplCopyWith<$Res>
    implements $HomeDataCopyWith<$Res> {
  factory _$$HomeDataImplCopyWith(
          _$HomeDataImpl value, $Res Function(_$HomeDataImpl) then) =
      __$$HomeDataImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {int? totalAnswers,
      int? totalAnswersUntilThreeDays,
      List<PersonModel>? lastAnswers});
}

/// @nodoc
class __$$HomeDataImplCopyWithImpl<$Res>
    extends _$HomeDataCopyWithImpl<$Res, _$HomeDataImpl>
    implements _$$HomeDataImplCopyWith<$Res> {
  __$$HomeDataImplCopyWithImpl(
      _$HomeDataImpl _value, $Res Function(_$HomeDataImpl) _then)
      : super(_value, _then);

  /// Create a copy of HomeData
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalAnswers = freezed,
    Object? totalAnswersUntilThreeDays = freezed,
    Object? lastAnswers = freezed,
  }) {
    return _then(_$HomeDataImpl(
      totalAnswers: freezed == totalAnswers
          ? _value.totalAnswers
          : totalAnswers // ignore: cast_nullable_to_non_nullable
              as int?,
      totalAnswersUntilThreeDays: freezed == totalAnswersUntilThreeDays
          ? _value.totalAnswersUntilThreeDays
          : totalAnswersUntilThreeDays // ignore: cast_nullable_to_non_nullable
              as int?,
      lastAnswers: freezed == lastAnswers
          ? _value._lastAnswers
          : lastAnswers // ignore: cast_nullable_to_non_nullable
              as List<PersonModel>?,
    ));
  }
}

/// @nodoc

class _$HomeDataImpl implements _HomeData {
  _$HomeDataImpl(
      {this.totalAnswers,
      this.totalAnswersUntilThreeDays,
      final List<PersonModel>? lastAnswers})
      : _lastAnswers = lastAnswers;

  @override
  final int? totalAnswers;
  @override
  final int? totalAnswersUntilThreeDays;
  final List<PersonModel>? _lastAnswers;
  @override
  List<PersonModel>? get lastAnswers {
    final value = _lastAnswers;
    if (value == null) return null;
    if (_lastAnswers is EqualUnmodifiableListView) return _lastAnswers;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'HomeData(totalAnswers: $totalAnswers, totalAnswersUntilThreeDays: $totalAnswersUntilThreeDays, lastAnswers: $lastAnswers)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$HomeDataImpl &&
            (identical(other.totalAnswers, totalAnswers) ||
                other.totalAnswers == totalAnswers) &&
            (identical(other.totalAnswersUntilThreeDays,
                    totalAnswersUntilThreeDays) ||
                other.totalAnswersUntilThreeDays ==
                    totalAnswersUntilThreeDays) &&
            const DeepCollectionEquality()
                .equals(other._lastAnswers, _lastAnswers));
  }

  @override
  int get hashCode => Object.hash(
      runtimeType,
      totalAnswers,
      totalAnswersUntilThreeDays,
      const DeepCollectionEquality().hash(_lastAnswers));

  /// Create a copy of HomeData
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$HomeDataImplCopyWith<_$HomeDataImpl> get copyWith =>
      __$$HomeDataImplCopyWithImpl<_$HomeDataImpl>(this, _$identity);
}

abstract class _HomeData implements HomeData {
  factory _HomeData(
      {final int? totalAnswers,
      final int? totalAnswersUntilThreeDays,
      final List<PersonModel>? lastAnswers}) = _$HomeDataImpl;

  @override
  int? get totalAnswers;
  @override
  int? get totalAnswersUntilThreeDays;
  @override
  List<PersonModel>? get lastAnswers;

  /// Create a copy of HomeData
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$HomeDataImplCopyWith<_$HomeDataImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
