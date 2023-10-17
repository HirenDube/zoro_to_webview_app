import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:zoro_to/main.dart';

class ChangeUrl extends StatefulWidget {
  const ChangeUrl({super.key});

  @override
  State<ChangeUrl> createState() => _ChangeUrlState();
}

class _ChangeUrlState extends State<ChangeUrl> {
  TextEditingController stringUrl = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: TextField(
                maxLines: 1,
                controller: stringUrl,
                decoration: InputDecoration(hintText: "URL :-"),
              ),
            ),
            ElevatedButton(
                onPressed: () {
                  Box links = Hive.box("url");
                  links.put("homeUrl", stringUrl.text);
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ZoroApp(),
                      ));
                },
                child: Text("Change Now"))
          ],
        ),
      ),
    );
  }
}
