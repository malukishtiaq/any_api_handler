import 'dart:convert';
import 'package:flutter/material.dart';

class ResponseParser {
  static String correctJsonString(String jsonString) {
    final keyValuePattern = RegExp(r'(\w+):(?:\s+)?([^,}]+)');
    return jsonString.replaceAllMapped(keyValuePattern, (match) {
      String key = match.group(1)!;
      String value = match.group(2)!;

      if (!value.startsWith('"') &&
          !value.startsWith('{') &&
          !value.startsWith('[')) {
        value = '"$value"';
      }
      return '"$key": $value';
    });
  }

  static Widget buildDynamicResponse(dynamic data) {
    List<Widget> buildResponseWidgets(dynamic data, [String prefix = '']) {
      List<Widget> widgets = [];

      if (data is Map) {
        data.forEach(
          (key, value) {
            if (value is String &&
                (value.startsWith('{') || value.startsWith('['))) {
              try {
                String correctedJsonString = correctJsonString(value);
                var decodedJson = jsonDecode(correctedJsonString);
                widgets
                    .addAll(buildResponseWidgets(decodedJson, '$prefix$key: '));
              } catch (e) {
                debugPrint('Error parsing JSON from $key: $e\nString: $value');
                widgets.add(Text('$prefix$key: $value\n'));
              }
            } else {
              widgets.addAll(buildResponseWidgets(value, '$prefix$key: '));
            }
          },
        );
      } else if (data is List) {
        for (var i = 0; i < data.length; i++) {
          widgets.addAll(buildResponseWidgets(data[i], '$prefix[$i]: '));
        }
      } else {
        widgets.add(Text('$prefix$data\n'));
      }

      return widgets;
    }

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: buildResponseWidgets(data),
      ),
    );
  }
}
