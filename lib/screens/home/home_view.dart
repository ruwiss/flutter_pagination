import 'package:flutter/material.dart';
import 'package:pagination/models/data_model.dart';
import 'package:pagination/screens/home/home_viewmodel.dart';
import 'package:provider/provider.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<HomeViewmodel>()
        ..fetchData()
        ..listenScrollBottom();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Consumer<HomeViewmodel>(
            builder: (context, model, child) {
              if (model.dataModel == null) {
                return const CircularProgressIndicator();
              } else {
                return _listWidget(model);
              }
            },
          ),
        ),
      ),
    );
  }

  ListView _listWidget(HomeViewmodel model) {
    final List<PostItem> posts = model.dataModel!.posts;
    return ListView.builder(
      controller: model.scrollController,
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final PostItem item = posts[index];
        return Column(
          children: [
            Text(
              item.title,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            Text(
              item.body,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text("ID: ${item.id}"),
            const Divider(),
            if (model.loading && index == posts.length - 1)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: CircularProgressIndicator(),
              )
          ],
        );
      },
    );
  }
}
