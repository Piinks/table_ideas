// Copyright 2022, the Flutter project authors. Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Table 3 Example

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
          columnCount: 6,
          pinnedColumnCount: 1,
          columnBuilder: (int column) {
            final TableSpanExtent extent = column.isEven
              ? MaxTableSpanExtent(
                  FractionalTableSpanExtent(0.2),
                  FixedTableSpanExtent(100)
                )
              : FixedTableSpanExtent(120);
            
            return TableSpan(
              extent: extent,
              backgroundDecoration: TableSpanDecoration(
                color: column == 0 ? Colors.blueAccent[100] : null,
              ),
            );
          },
          rowCount: 10,
          pinnedRowCount: 2,
          rowBuilder: (int row) {
            return TableSpan(
              extent: row.isEven ? FixedTableSpanExtent(52) : FixedTableSpanExtent(80),
              backgroundDecoration: TableSpanDecoration(
                color: row < 2 ? Colors.amberAccent[400] : null,
              ),
            );
          },
        ),
      ),
    );
  }
}
