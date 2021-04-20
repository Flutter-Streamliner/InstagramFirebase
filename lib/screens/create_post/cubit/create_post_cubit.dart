import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_instagram/blocs/auth/auth_bloc.dart';
import 'package:flutter_instagram/models/models.dart';
import 'package:flutter_instagram/repositories/post/base_post_repository.dart';
import 'package:flutter_instagram/repositories/storage/base_storage_repository.dart';
import 'package:meta/meta.dart';

part 'create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  final BasePostRepository _postRepository;
  final BaseStorageRepository _storageRepository;
  final AuthBloc _authBloc;
  
  CreatePostCubit({
    @required BasePostRepository postRepository,
    @required BaseStorageRepository storageRepository,
    @required AuthBloc authBloc
  }) : _postRepository = postRepository, 
       _storageRepository = storageRepository,
       _authBloc = authBloc, super(CreatePostState.initital());

  void postImageChanged(File file) {
    emit(state.copyWith(postImage: file, status: CreatePostStatus.initial));
  }

  void captionChanged(String caption) {
    emit(state.copyWith(caption: caption, status: CreatePostStatus.initial));
  }

  void submit() async {
    emit(state.copyWith(status: CreatePostStatus.submitting));
    try {
      final author = User.empty.copyWith(id: _authBloc.state.user.uid);
      final postImageUrl = await _storageRepository.uploadPostImage(image: state.postImage);
      final post = Post(
        author: author,
        imageUrl: postImageUrl,
        caption: state.caption,
        likes: 0,
        date: DateTime.now(), 
      );
      await _postRepository.createPost(post: post);
      emit(state.copyWith(status: CreatePostStatus.success));
    } catch (e) {
      emit(state.copyWith(status: CreatePostStatus.error, failure: const Failure(message: 'We were unable to create your post')));
    }
  }

  void reset() {
    emit(CreatePostState.initital());
  }
}
