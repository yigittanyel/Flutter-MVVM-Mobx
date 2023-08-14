import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter_mvvm_mobx/feature/model/post_model.dart';
import 'package:mobx/mobx.dart';
part 'post_viewmodel.g.dart';

class PostViewModel = _PostViewModelBase with _$PostViewModel;

abstract class _PostViewModelBase with Store {
  @observable
  PageState pageState = PageState.NORMAL;

  @observable
  List<PostModel> posts = [];

  @observable
  bool isServiseReuquestLoading = false;

  final String url = "https://jsonplaceholder.typicode.com/posts";

  @action
  Future<void> getAllPost() async {
    pageState = PageState.LOADING;

    try {
      final response = await Dio().get(url);

      if (response.statusCode == HttpStatus.ok) {
        final responseData = response.data as List;
        posts = responseData.map((e) => PostModel.fromJson(e)).toList();
        pageState = PageState.SUCCESS;
      }
    } catch (e) {
      pageState = PageState.ERROR;
    }
  }

  @action
  void changeRequest() {
    isServiseReuquestLoading = !isServiseReuquestLoading;
  }
}

enum PageState { LOADING, ERROR, SUCCESS, NORMAL }
