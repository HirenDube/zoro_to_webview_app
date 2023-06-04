import "dart:io";

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_inappwebview/flutter_inappwebview.dart";

void main() => runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ZoroApp(),
    ));

class ZoroApp extends StatefulWidget {
  const ZoroApp({Key? key}) : super(key: key);

  @override
  State<ZoroApp> createState() => _ZoroAppState();
}

class _ZoroAppState extends State<ZoroApp> with SingleTickerProviderStateMixin {
  late InAppWebViewController zoro_to;

  bool visible = false;
  double posx = 10, posy = 10;

  GlobalKey webviewkey = GlobalKey();

  late AnimationController animatedIconController;
  late Animation<double> _animation;
  late PullToRefreshController refreseher = PullToRefreshController(onRefresh: (){zoro_to.reload();});

  String url = "https://sanji.to/home";

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    animatedIconController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500))
          ..forward();
    _animation =
        Tween<double>(begin: 0.0, end: 1.0).animate(animatedIconController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: () async {
          if (await zoro_to.canGoBack()) {
            zoro_to.goBack();
            return false;
          }
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    actionsAlignment: MainAxisAlignment.spaceEvenly,
                    title: Text("Are you sure you want to exit the app ? "),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                          exit(0);
                          // exit(0);
                        },
                        child: Text(
                          "YES",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "NO",
                          style: TextStyle(
                              color: Colors.green,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      )
                    ],
                  ));
          return false;
        },
        child: SafeArea(
          child: Stack(
            children: [
              InAppWebView(onEnterFullscreen: (controller){
                // Orientation.landscape;
                SystemChrome.setPreferredOrientations([DeviceOrientation.landscapeLeft]);
              },
                  pullToRefreshController: refreseher,
                  // gestureRecognizers: Set()
                  //   ..add(
                  //     Factory<VerticalDragGestureRecognizer>(
                  //         () => VerticalDragGestureRecognizer()
                  //           ..onDown = (DragDownDetails dragDownDetails) {
                  //             zoro_to.getScrollY().then((value) {
                  //               if (value == 0 &&
                  //                   dragDownDetails.globalPosition.direction <
                  //                       1) {
                  //                 zoro_to.reload();
                  //               }
                  //             });
                  //           }),
                  //   ),
                  onLoadStop: (controller,url){
                    refreseher.endRefreshing();
                  },
                  initialUrlRequest:
                      URLRequest(url: Uri.parse("https://sanji.to/home")),
                  onWebViewCreated: (controller) {
                    zoro_to = controller;
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class searchBar extends SearchDelegate {
  @override
  List<Widget>? buildActions(BuildContext context) {
    // TODO: implement buildActions
    return [Container()];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    // TODO: implement buildLeading
    throw Container();
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    throw Container();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    // TODO: implement buildSuggestions
    throw Container();
  }
}
