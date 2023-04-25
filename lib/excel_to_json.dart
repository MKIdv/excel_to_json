library excel_to_json;

import 'dart:convert';
import 'dart:developer';

import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

/// This is the main project class.
class ExcelToJson {
  /// Use this method to convert the file to a json.

  Future<String?> convertToString() async {
    Excel? excel = await _getFile();
    if (excel != null) {
      return jsonEncode(_convert(excel));
    }
    return null;
  }

  Future<Map<String, dynamic>?> convertToMap() async {
    Excel? excel = await _getFile();
    if (excel != null) {
      return _convert(excel);
    }
    return null;
  }

  Future<Map<String, dynamic>?> _convert(Excel excel) async {
    List<String> sheets = _getSheets(excel);

    int index = 0;
    Map<String, dynamic> json = {};

    for (String sheet in sheets) {
      List<Data?> keys = [];
      json.addAll({sheet: []});

      for (List<Data?> row in excel.sheets[sheet]?.rows ?? []) {
        try {
          if (index == 0) {
            keys = row;
            index++;
          } else {
            Map<String, dynamic> temp = _getRows(keys, row);

            json[sheet].add(temp);
          }
        } catch (ex) {
          log(ex.toString());

          rethrow;
        }
      }
      index = 0;
    }
    return json;
  }

  Map<String, dynamic> _getRows(List<Data?> keys, List<Data?> row) {
    Map<String, dynamic> temp = {};
    int index = 0;
    String tk = '';

    for (Data? key in keys) {
      if (key != null && key.value != null) {
        tk = key.value.toString();

        if ([
          CellType.String,
          CellType.int,
          CellType.double,
          CellType.bool,
        ].contains(row[index]?.cellType)) {
          if (row[index]?.value == 'true') {
            temp[tk] = true;
          } else if (row[index]?.value == 'false') {
            temp[tk] = false;
          } else {
            temp[tk] = row[index]?.value;
          }
        } else if (row[index]?.cellType == CellType.Formula) {
          temp[tk] = row[index]?.value.toString();
        }
        index++;
      }
    }
    return temp;
  }

  List<String> _getSheets(Excel excel) {
    List<String> keys = [];

    for (String sheet in excel.sheets.keys) {
      keys.add(sheet);
    }
    return keys;
  }

  Future<Excel?> _getFile() async {
    FilePickerResult? file = await FilePicker.platform.pickFiles(
      withData: true,
      type: FileType.custom,
      allowedExtensions: ['xlsx', 'csv', 'xls'],
    );
    if (file != null && file.files.isNotEmpty) {
      Uint8List bytes = file.files.first.bytes!;

      return Excel.decodeBytes(bytes);
    } else {
      return null;
    }
  }
}
