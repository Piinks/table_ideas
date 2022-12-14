// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Table 2 Example

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
          columnCount: 3,
          columnBuilder: (int column) {
            late final TableSpanExtent extent;
            
            switch (column) {
              case 0:
                extent = FixedTableSpanExtent(150);
                break;
              case 1:
                extent = FractionalTableSpanExtent(0.6);
                break;
              case 2:
                extent = MinTableSpanExtent(
                  FixedTableSpanExtent(145),
                  RemainingTableSpanExtent(),
                );
            }
            
            return TableSpan(
              extent: extent,
              backgroundDecoration: TableSpanDecoration(
                border: TableSpanBorder(
                  trailing: BorderSide(color: Colors.amber),
                ),
              )
            );
          },
          rowCount: 10,
          rowBuilder: (int row) {
            return TableSpan(
              extent: row.isEven ? FixedTableSpanExtent(150) : FixedTableSpanExtent(200),
              backgroundDecoration: TableSpanDecoration(
                border: TableSpanBorder(
                  leading: BorderSide(color: Colors.indigo),
                )
              ),
            );
          },
        ),
      ),
    );
  }
}
