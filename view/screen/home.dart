import 'dart:async';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:news_app/view/widgets/newsElement.dart';
import 'package:news_app/cubits/news/news_cubit.dart';
import 'package:news_app/model/models/news.dart';
import 'package:news_app/view/widgets/error_dialog.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  late TabController _tabController;

  late ConnectivityResult _connectionStatus;
  final Connectivity _connectivity = Connectivity();
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _connectionStatus = ConnectivityResult.none;
    _initConnectivity();
    _connectivitySubscription =
        _connectivity.onConnectivityChanged.listen(_updateConnectionStatus);
    context.read<NewsCubit>().fetchNews('general');
    _tabController = TabController(length: 4, vsync: this);
  }

  Future<void> _initConnectivity() async {
    ConnectivityResult result;
    try {
      result = await _connectivity.checkConnectivity();
    } catch (e) {
      result = ConnectivityResult.none;
    }
    if (!mounted) {
      return;
    }

    _updateConnectionStatus(result);
  }

  void _updateConnectionStatus(ConnectivityResult result) {
    setState(() {
      _connectionStatus = result;
    });
  }

  int pageIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('By:tarek'),
        actions: const [],
      ),
      body: (_connectionStatus == ConnectivityResult.none)
          ? _nointernet()
          : _content(),
    );
  }

  Widget _nointernet() {
    return const Center(
      child: Text(
        "No Internet",
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 40.0,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _content() {
    return BlocConsumer<NewsCubit, NewsState>(
      listener: (context, state) {
        if (state.status == NewsStatus.error) {
          errorDialog(context, state.error.errMsg);
        }
      },
      builder: (context, state) {
        if (state.status == NewsStatus.initial) {
          return const Center(
            child: Text(
              'something wrong! try later',
              style: TextStyle(fontSize: 20.0),
            ),
          );
        }

        if (state.status == NewsStatus.loading) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        if (state.status == NewsStatus.error) {
          return const Center(
            child: Text(
              'something wrong! try later',
              style: TextStyle(fontSize: 20.0),
            ),
          );
        }
        log("from main......");
        // print(state.news[0].title);

        return Column(
          children: [
            TabBar(
                isScrollable: true,
                unselectedLabelColor: const Color.fromARGB(255, 0, 0, 0),
                onTap: (value) {
                  setState(() {
                    String cat = getCategory(value);
                    context.read<NewsCubit>().fetchNews(cat);
                  });
                },
                controller: _tabController,
                tabs: const [
                  Tab(
                    text: 'General',
                    icon: Icon(Icons.public),
                  ),
                  Tab(
                    text: 'Science',
                    icon: Icon(Icons.science),
                  ),
                  Tab(
                    text: 'Sports',
                    icon: Icon(Icons.sports),
                  ),
                  Tab(
                    text: 'Technology',
                    icon: Icon(Icons.rocket),
                  )
                ]),
            Expanded(
                child: AnimationLimiter(
              child: ListView.builder(
                itemCount: state.news.length,
                itemBuilder: (context, index) {
                  News news = state.news[index];
                  return AnimationConfiguration.staggeredList(
                      position: index,
                      duration: const Duration(milliseconds: 375),
                      child: SlideAnimation(
                          horizontalOffset: 500.0,
                          child: FadeInAnimation(
                              child: NewsCard(
                                  title: news.title, source: news.source))));
                },
              ),
            ))
          ],
        );
      },
    );
  }

  String getCategory(int index) {
    switch (index) {
      case 1:
        return "science";
      case 2:
        return "sports";
      case 3:
        return "technology";
      default:
        return "general";
    }
  }
}
