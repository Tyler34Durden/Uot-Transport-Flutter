// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stations_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$StationsState {
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<StationEntity> stations) loaded,
    required TResult Function(Failure failure) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<StationEntity> stations)? loaded,
    TResult? Function(Failure failure)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<StationEntity> stations)? loaded,
    TResult Function(Failure failure)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_StationsInitial value) initial,
    required TResult Function(_StationsLoading value) loading,
    required TResult Function(_StationsLoaded value) loaded,
    required TResult Function(_StationsFailure value) failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_StationsInitial value)? initial,
    TResult? Function(_StationsLoading value)? loading,
    TResult? Function(_StationsLoaded value)? loaded,
    TResult? Function(_StationsFailure value)? failure,
  }) =>
      throw _privateConstructorUsedError;
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_StationsInitial value)? initial,
    TResult Function(_StationsLoading value)? loading,
    TResult Function(_StationsLoaded value)? loaded,
    TResult Function(_StationsFailure value)? failure,
    required TResult orElse(),
  }) =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StationsStateCopyWith<$Res> {
  factory $StationsStateCopyWith(
          StationsState value, $Res Function(StationsState) then) =
      _$StationsStateCopyWithImpl<$Res, StationsState>;
}

/// @nodoc
class _$StationsStateCopyWithImpl<$Res, $Val extends StationsState>
    implements $StationsStateCopyWith<$Res> {
  _$StationsStateCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of StationsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc
abstract class _$$StationsInitialImplCopyWith<$Res> {
  factory _$$StationsInitialImplCopyWith(_$StationsInitialImpl value,
          $Res Function(_$StationsInitialImpl) then) =
      __$$StationsInitialImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$StationsInitialImplCopyWithImpl<$Res>
    extends _$StationsStateCopyWithImpl<$Res, _$StationsInitialImpl>
    implements _$$StationsInitialImplCopyWith<$Res> {
  __$$StationsInitialImplCopyWithImpl(
      _$StationsInitialImpl _value, $Res Function(_$StationsInitialImpl) _then)
      : super(_value, _then);

  /// Create a copy of StationsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$StationsInitialImpl implements _StationsInitial {
  const _$StationsInitialImpl();

  @override
  String toString() {
    return 'StationsState.initial()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$StationsInitialImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<StationEntity> stations) loaded,
    required TResult Function(Failure failure) failure,
  }) {
    return initial();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<StationEntity> stations)? loaded,
    TResult? Function(Failure failure)? failure,
  }) {
    return initial?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<StationEntity> stations)? loaded,
    TResult Function(Failure failure)? failure,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_StationsInitial value) initial,
    required TResult Function(_StationsLoading value) loading,
    required TResult Function(_StationsLoaded value) loaded,
    required TResult Function(_StationsFailure value) failure,
  }) {
    return initial(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_StationsInitial value)? initial,
    TResult? Function(_StationsLoading value)? loading,
    TResult? Function(_StationsLoaded value)? loaded,
    TResult? Function(_StationsFailure value)? failure,
  }) {
    return initial?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_StationsInitial value)? initial,
    TResult Function(_StationsLoading value)? loading,
    TResult Function(_StationsLoaded value)? loaded,
    TResult Function(_StationsFailure value)? failure,
    required TResult orElse(),
  }) {
    if (initial != null) {
      return initial(this);
    }
    return orElse();
  }
}

abstract class _StationsInitial implements StationsState {
  const factory _StationsInitial() = _$StationsInitialImpl;
}

/// @nodoc
abstract class _$$StationsLoadingImplCopyWith<$Res> {
  factory _$$StationsLoadingImplCopyWith(_$StationsLoadingImpl value,
          $Res Function(_$StationsLoadingImpl) then) =
      __$$StationsLoadingImplCopyWithImpl<$Res>;
}

/// @nodoc
class __$$StationsLoadingImplCopyWithImpl<$Res>
    extends _$StationsStateCopyWithImpl<$Res, _$StationsLoadingImpl>
    implements _$$StationsLoadingImplCopyWith<$Res> {
  __$$StationsLoadingImplCopyWithImpl(
      _$StationsLoadingImpl _value, $Res Function(_$StationsLoadingImpl) _then)
      : super(_value, _then);

  /// Create a copy of StationsState
  /// with the given fields replaced by the non-null parameter values.
}

/// @nodoc

class _$StationsLoadingImpl implements _StationsLoading {
  const _$StationsLoadingImpl();

  @override
  String toString() {
    return 'StationsState.loading()';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType && other is _$StationsLoadingImpl);
  }

  @override
  int get hashCode => runtimeType.hashCode;

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<StationEntity> stations) loaded,
    required TResult Function(Failure failure) failure,
  }) {
    return loading();
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<StationEntity> stations)? loaded,
    TResult? Function(Failure failure)? failure,
  }) {
    return loading?.call();
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<StationEntity> stations)? loaded,
    TResult Function(Failure failure)? failure,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading();
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_StationsInitial value) initial,
    required TResult Function(_StationsLoading value) loading,
    required TResult Function(_StationsLoaded value) loaded,
    required TResult Function(_StationsFailure value) failure,
  }) {
    return loading(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_StationsInitial value)? initial,
    TResult? Function(_StationsLoading value)? loading,
    TResult? Function(_StationsLoaded value)? loaded,
    TResult? Function(_StationsFailure value)? failure,
  }) {
    return loading?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_StationsInitial value)? initial,
    TResult Function(_StationsLoading value)? loading,
    TResult Function(_StationsLoaded value)? loaded,
    TResult Function(_StationsFailure value)? failure,
    required TResult orElse(),
  }) {
    if (loading != null) {
      return loading(this);
    }
    return orElse();
  }
}

abstract class _StationsLoading implements StationsState {
  const factory _StationsLoading() = _$StationsLoadingImpl;
}

/// @nodoc
abstract class _$$StationsLoadedImplCopyWith<$Res> {
  factory _$$StationsLoadedImplCopyWith(_$StationsLoadedImpl value,
          $Res Function(_$StationsLoadedImpl) then) =
      __$$StationsLoadedImplCopyWithImpl<$Res>;
  @useResult
  $Res call({List<StationEntity> stations});
}

/// @nodoc
class __$$StationsLoadedImplCopyWithImpl<$Res>
    extends _$StationsStateCopyWithImpl<$Res, _$StationsLoadedImpl>
    implements _$$StationsLoadedImplCopyWith<$Res> {
  __$$StationsLoadedImplCopyWithImpl(
      _$StationsLoadedImpl _value, $Res Function(_$StationsLoadedImpl) _then)
      : super(_value, _then);

  /// Create a copy of StationsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stations = null,
  }) {
    return _then(_$StationsLoadedImpl(
      stations: null == stations
          ? _value._stations
          : stations // ignore: cast_nullable_to_non_nullable
              as List<StationEntity>,
    ));
  }
}

/// @nodoc

class _$StationsLoadedImpl implements _StationsLoaded {
  const _$StationsLoadedImpl({required final List<StationEntity> stations})
      : _stations = stations;

  final List<StationEntity> _stations;
  @override
  List<StationEntity> get stations {
    if (_stations is EqualUnmodifiableListView) return _stations;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stations);
  }

  @override
  String toString() {
    return 'StationsState.loaded(stations: $stations)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StationsLoadedImpl &&
            const DeepCollectionEquality().equals(other._stations, _stations));
  }

  @override
  int get hashCode =>
      Object.hash(runtimeType, const DeepCollectionEquality().hash(_stations));

  /// Create a copy of StationsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StationsLoadedImplCopyWith<_$StationsLoadedImpl> get copyWith =>
      __$$StationsLoadedImplCopyWithImpl<_$StationsLoadedImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<StationEntity> stations) loaded,
    required TResult Function(Failure failure) failure,
  }) {
    return loaded(stations);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<StationEntity> stations)? loaded,
    TResult? Function(Failure failure)? failure,
  }) {
    return loaded?.call(stations);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<StationEntity> stations)? loaded,
    TResult Function(Failure failure)? failure,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(stations);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_StationsInitial value) initial,
    required TResult Function(_StationsLoading value) loading,
    required TResult Function(_StationsLoaded value) loaded,
    required TResult Function(_StationsFailure value) failure,
  }) {
    return loaded(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_StationsInitial value)? initial,
    TResult? Function(_StationsLoading value)? loading,
    TResult? Function(_StationsLoaded value)? loaded,
    TResult? Function(_StationsFailure value)? failure,
  }) {
    return loaded?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_StationsInitial value)? initial,
    TResult Function(_StationsLoading value)? loading,
    TResult Function(_StationsLoaded value)? loaded,
    TResult Function(_StationsFailure value)? failure,
    required TResult orElse(),
  }) {
    if (loaded != null) {
      return loaded(this);
    }
    return orElse();
  }
}

abstract class _StationsLoaded implements StationsState {
  const factory _StationsLoaded({required final List<StationEntity> stations}) =
      _$StationsLoadedImpl;

  List<StationEntity> get stations;

  /// Create a copy of StationsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StationsLoadedImplCopyWith<_$StationsLoadedImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class _$$StationsFailureImplCopyWith<$Res> {
  factory _$$StationsFailureImplCopyWith(_$StationsFailureImpl value,
          $Res Function(_$StationsFailureImpl) then) =
      __$$StationsFailureImplCopyWithImpl<$Res>;
  @useResult
  $Res call({Failure failure});
}

/// @nodoc
class __$$StationsFailureImplCopyWithImpl<$Res>
    extends _$StationsStateCopyWithImpl<$Res, _$StationsFailureImpl>
    implements _$$StationsFailureImplCopyWith<$Res> {
  __$$StationsFailureImplCopyWithImpl(
      _$StationsFailureImpl _value, $Res Function(_$StationsFailureImpl) _then)
      : super(_value, _then);

  /// Create a copy of StationsState
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? failure = null,
  }) {
    return _then(_$StationsFailureImpl(
      failure: null == failure
          ? _value.failure
          : failure // ignore: cast_nullable_to_non_nullable
              as Failure,
    ));
  }
}

/// @nodoc

class _$StationsFailureImpl implements _StationsFailure {
  const _$StationsFailureImpl({required this.failure});

  @override
  final Failure failure;

  @override
  String toString() {
    return 'StationsState.failure(failure: $failure)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$StationsFailureImpl &&
            (identical(other.failure, failure) || other.failure == failure));
  }

  @override
  int get hashCode => Object.hash(runtimeType, failure);

  /// Create a copy of StationsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$StationsFailureImplCopyWith<_$StationsFailureImpl> get copyWith =>
      __$$StationsFailureImplCopyWithImpl<_$StationsFailureImpl>(
          this, _$identity);

  @override
  @optionalTypeArgs
  TResult when<TResult extends Object?>({
    required TResult Function() initial,
    required TResult Function() loading,
    required TResult Function(List<StationEntity> stations) loaded,
    required TResult Function(Failure failure) failure,
  }) {
    return failure(this.failure);
  }

  @override
  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>({
    TResult? Function()? initial,
    TResult? Function()? loading,
    TResult? Function(List<StationEntity> stations)? loaded,
    TResult? Function(Failure failure)? failure,
  }) {
    return failure?.call(this.failure);
  }

  @override
  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>({
    TResult Function()? initial,
    TResult Function()? loading,
    TResult Function(List<StationEntity> stations)? loaded,
    TResult Function(Failure failure)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this.failure);
    }
    return orElse();
  }

  @override
  @optionalTypeArgs
  TResult map<TResult extends Object?>({
    required TResult Function(_StationsInitial value) initial,
    required TResult Function(_StationsLoading value) loading,
    required TResult Function(_StationsLoaded value) loaded,
    required TResult Function(_StationsFailure value) failure,
  }) {
    return failure(this);
  }

  @override
  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>({
    TResult? Function(_StationsInitial value)? initial,
    TResult? Function(_StationsLoading value)? loading,
    TResult? Function(_StationsLoaded value)? loaded,
    TResult? Function(_StationsFailure value)? failure,
  }) {
    return failure?.call(this);
  }

  @override
  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>({
    TResult Function(_StationsInitial value)? initial,
    TResult Function(_StationsLoading value)? loading,
    TResult Function(_StationsLoaded value)? loaded,
    TResult Function(_StationsFailure value)? failure,
    required TResult orElse(),
  }) {
    if (failure != null) {
      return failure(this);
    }
    return orElse();
  }
}

abstract class _StationsFailure implements StationsState {
  const factory _StationsFailure({required final Failure failure}) =
      _$StationsFailureImpl;

  Failure get failure;

  /// Create a copy of StationsState
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$StationsFailureImplCopyWith<_$StationsFailureImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
