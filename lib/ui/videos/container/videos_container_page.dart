import 'package:flutter/material.dart';

import '../../../constants.dart';
import '../movies/movies_page.dart';
import '../tv_series/tv_series_page.dart';

class VideosContainerPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion(
      value: systemUiOverlayStyleGlobal,
      child: DefaultTabController(
        length: 2,
        child: Scaffold(
          backgroundColor: colorPrimary,
          body: SafeArea(
            child: Column(
              children: [
                TabBar(
                  indicatorColor: Colors.white,
                  labelStyle: const TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontFamily: "Product Sans",
                    fontWeight: FontWeight.w500,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    color: colorDisabled,
                    fontSize: 16.0,
                    fontFamily: "Product Sans",
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: [
                    Tab(
                      text: "Movies",
                    ),
                    Tab(
                      text: "Tv Series",
                    ),
                  ],
                ),
                Expanded(
                  child: TabBarView(
                    children: [
                      MoviesPage(),
                      TvSeriesPage(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
