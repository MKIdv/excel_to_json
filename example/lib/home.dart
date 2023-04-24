import 'package:excel_to_json/excel_to_json.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  const Home({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Converter Excel em JSON')),
      body: Center(
        child: Column(
          children: [
            ElevatedButton(
              child: const Text("PRESS TO UPLOAD EXCEL AND CONVERT TO JSON STRING"),
              onPressed: () async {
                final excel = await ExcelToJson().convertToString();
                if (kDebugMode) {
                  print(excel);
                }
              },
            ),
            const SizedBox(height: 8.0,),
            ElevatedButton(
              child: const Text("PRESS TO UPLOAD EXCEL AND CONVERT TO JSON MAP"),
              onPressed: () async {
                final excel = await ExcelToJson().convertToMap();
                if (kDebugMode) {
                  print(excel);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
