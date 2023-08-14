import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../view-model/post_viewmodel.dart';

class PostView extends StatelessWidget {
  final _viewModel = PostViewModel();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.refresh),
        onPressed: () {
          _viewModel.getAllPost();
        },
      ),
      body: Observer(
        builder: (_) {
          switch (_viewModel.pageState) {
            case PageState.LOADING:
              return const Center(child: CircularProgressIndicator());
            case PageState.SUCCESS:
              return buildListViewPosts();
            case PageState.ERROR:
              return const Center(child: Text("Error"));
            default:
              return const Center(child: FlutterLogo());
          }
        },
      ),
    );
  }

  Widget buildListViewPosts() {
    return Observer(
      builder: (_) {
        return ListView.separated(
          separatorBuilder: (context, index) => const Divider(),
          itemCount: _viewModel.posts.length,
          itemBuilder: (context, index) => buildListTileCard(index),
        );
      },
    );
  }

  ListTile buildListTileCard(int index) {
    return ListTile(
      leading: Text(_viewModel.posts[index].userId.toString()),
      title: Text(_viewModel.posts[index].title ?? ""),
      subtitle: Text(_viewModel.posts[index].body ?? ""),
    );
  }

  AppBar buildAppBar() {
    return AppBar(
      title: const Text("Post Datas"),
      leading: Observer(
        builder: (_) {
          return Visibility(
            visible: _viewModel.isServiseReuquestLoading,
            child: const Padding(
              padding: EdgeInsets.all(8.0),
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            ),
          );
        },
      ),
    );
  }
}
