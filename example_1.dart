// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Table 1 Example

import 'package:flutter/material.dart';

void main() {
  runApp(TableApp());
}

class TableApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: TableView.builder(
          cellBuilder: (BuildContext context, int column, int row) {
            return Center(child: Text('Cell $column : $row'));
          },
          columnBuilder: (int column) {
            return TableSpan(
              extent: FixedTableSpanExtent(100),
              decoration: TableSpanDecoration(
                border: RawTableBandBorder(
                  trailing: BorderSide(
                   color: Colors.black,
                   width: 2,
                   style: BorderStyle.solid,
                  ),
                ),
              ),
            );
          },
          rowBuilder: (int row) {
            return TableSpan(
              extent: FixedTableSpanExtent(100),
              decoration: TableSpanDecoration(
                color: Colors.blueAccent,
              ),
            );
          },
        ),
      ),
    );
  }
}
