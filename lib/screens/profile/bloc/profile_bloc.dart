import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_instagram/blocs/auth/auth_bloc.dart';
import 'package:flutter_instagram/models/models.dart';
import 'package:flutter_instagram/repositories/repositories.dart';
import 'package:meta/meta.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final BaseUserRepository _userRepository;
  final AuthBloc _authBloc;
  final BasePostRepository _postRepository;

  StreamSubscription<List<Future<Post>>> _postsSubscription;

  ProfileBloc(
      {@required BaseUserRepository userRepository,
      @required AuthBloc authBloc, 
      @required BasePostRepository postRepository})
      : _userRepository = userRepository,
        _authBloc = authBloc,
        _postRepository = postRepository,
        super(ProfileState.initial());
  
  @override
  Future<void> close() {
    _postsSubscription.cancel();
    return super.close();
  }

  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is ProfileLoadUser) {
      yield* _mapProfileLoadUserToState(event);
    } else if (event is ProfileToggleGridView) {
      yield* _mapProfileToggleGridViewToState(event);
    } else if (event is ProfileUpdatePosts) {
      yield* _mapProfileUpdatePostsToState(event);
    }
  }

  Stream<ProfileState> _mapProfileLoadUserToState(
      ProfileLoadUser event) async* {
    yield state.copyWith(status: ProfileStatus.loading);
    try {
      final user = await _userRepository.getUserWithId(userId: event.userId);
      final isCurrentUser = _authBloc.state.user.uid == event.userId;
      _postsSubscription?.cancel();
      _postsSubscription = _postRepository.getUserPosts(userId: event.userId).listen((posts) async {
        final allPosts = await Future.wait(posts);
        add(ProfileUpdatePosts(posts: allPosts));
      }, 
      onError: (error, stackTrace) {
        print('ProfileBloc _mapProfileLoadUserToState _postsSubscription getUserPosts onError $error / $stackTrace');
      });
      yield state.copyWith(
          user: user,
          isCurrentUser: isCurrentUser,
          status: ProfileStatus.loaded);
    } catch (error) {
      yield state.copyWith(
          status: ProfileStatus.error,
          failure:
              const Failure(message: 'We were unable to load this profile'));
    }
  }

  Stream<ProfileState> _mapProfileToggleGridViewToState(ProfileToggleGridView event) async* {
    yield state.copyWith(isGridView: event.isGridView);
  }

  Stream<ProfileState> _mapProfileUpdatePostsToState(ProfileUpdatePosts event) async* {
    yield state.copyWith(posts: event.posts);
  }
}
