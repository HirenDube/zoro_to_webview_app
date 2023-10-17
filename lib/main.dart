import "dart:io";

import "package:flutter/cupertino.dart";
import "package:flutter/material.dart";
import "package:flutter/services.dart";
import "package:flutter_inappwebview/flutter_inappwebview.dart";
import "package:hive/hive.dart";
import "package:path_provider/path_provider.dart";
import "package:wakelock_plus/wakelock_plus.dart";
import "package:zoro_to/change_url.dart";

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Directory folder = await getApplicationDocumentsDirectory();
  Hive.init(folder.path);
  await Hive.openBox("url");
  WakelockPlus.enable();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: ZoroApp(),
  ));
}

class ZoroApp extends StatefulWidget {
  const ZoroApp({Key? key}) : super(key: key);

  @override
  State<ZoroApp> createState() => _ZoroAppState();
}

class _ZoroAppState extends State<ZoroApp> {
  late InAppWebViewController zoro_to;

  bool visible = false;
  double posx = 10, posy = 10;

  GlobalKey webviewkey = GlobalKey();

  late PullToRefreshController refreseher =
      PullToRefreshController(onRefresh: () {
    zoro_to.reload();
  });

  String url = "https://aniwatch.to/";

  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    Box links = Hive.box("url");
    url = links.get("homeUrl") ?? "https://aniwatch.to/home";
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
                    title: Text("What you'd like to do now ? "),
                    actions: [
                      ButtonBar(
                        alignment: MainAxisAlignment.center,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                              exit(0);
                              // exit(0);
                            },
                            child: Text(
                              "Exit App",
                              style: TextStyle(
                                  color: Colors.red,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ChangeUrl(),
                                  ));
                              // exit(0);
                            },
                            child: Text(
                              "Change Home URL",
                              style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Don't Close App",
                              style: TextStyle(
                                  color: Colors.green,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      )
                    ],
                  ));
          return false;
        },
        child: SafeArea(
          child: Stack(
            children: [
              InAppWebView(
                  onEnterFullscreen: (controller) {
                    // Orientation.landscape;
                    SystemChrome.setPreferredOrientations(
                        [DeviceOrientation.landscapeLeft]);
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
                  onLoadStop: (controller, url) {
                    refreseher.endRefreshing();
                  },
                  initialUrlRequest: URLRequest(url: Uri.parse(url)),
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
