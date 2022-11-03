/// A widget that displays a table, which can scroll in horizontal and vertical
/// directions.
///
/// A table consists of rows and columns. Rows fill the vertical space of
/// the table, while columns fill it vertically. If there is not enough space
/// available to display all the rows at the same time, the table will scroll
/// vertically. If there is not enough space for all the columns, it will
/// scroll horizontally.
///
/// The content displayed by the table is organized in cells. Each cell belongs
/// to exactly one row and one column. The table supports lazy rendering and
/// will only instantiate those cells, that are currently visible in the
/// table's viewport.
class TableView extends RawTableView {
  /// Creates a scrollable, two dimensional table of widgets that are
  /// created on demand.
  const TableView.builder({
    super.key,
    super.horizontalController,
    super.verticalController,
    required TableCellBuilder cellBuilder,
    required TableSpanBuilder columnBuilder,
    required TableSpanBuilder rowBuilder,
    int? columnCount,
    int? rowCount,
  });
 
  /// A ScrollController for the horizontal axis of the table.
  final ScrollController horizontalController;
  
  /// A ScrollController for the vertical axis of the table.
  final ScrollController verticalController;

  /// Builds the widget for the cell at the provided `column` and `row` index.
  ///
  /// The builder is only invoked for cells that are actually visible in the
  /// table's viewport ('lazy rendering').
  ///
  /// The `column` indices provided to this builder will be between 0 and
  /// [columnCount]. The `row` indices will be between 0 and [rowCount].
  final TableCellBuilder cellBuilder;

  /// Builds the [TableSpan] that describes the column at the provided index.
  ///
  /// The builder must return a valid [TableSpan] for all indices smaller than
  /// [columnCount].
  final TableSpanBuilder columnBuilder;

  /// Builds the [TableSpan] that describes the row at the provided index.
  ///
  /// The builder must return a valid [TableSpan] for all indices smaller than
  /// [rowCount].
  final TableSpanBuilder rowBuilder;

  /// The number of columns in the table.
  ///
  /// If null, the number of rows will be double.infinity.
  int? columnCount;
  
  /// The number of columns that are permanently shown on the edge of
  /// the viewport.
  ///
  /// If scrolling is enabled, other columns will scroll underneath the pinned
  /// columns.
  ///
  /// Just like for regular columns, [columnBuilder] will be consulted for
  /// additional information about the pinned column. The indices of pinned columns
  /// start at zero and go to `pinnedColumnCount - 1`.
  ///
  /// Must be smaller than (or equal to) the [columnCount].
  int? pinnedColumnCount;
  
  /// The number of rows in the table.
  ///
  /// If null, the number of rows will be double.infinity.
  int? rowCount;
  
  /// The number of rows that are permanently shown on the edge of
  /// the viewport.
  ///
  /// If scrolling is enabled, other rows will scroll underneath the pinned
  /// rows.
  ///
  /// Just like for regular rows, [rowBuilder] will be consulted for
  /// additional information about the pinned row. The indices of pinned rows
  /// start at zero and go to `pinnedRowCount - 1`.
  ///
  /// Must be smaller than (or equal to) the [rowCount].
  int? pinnedRowCount;
}

/// Signature for a function that creates a TableSpan for a given index of row or
/// column in a table.
typedef TableSpanBuilder = TableSpan Function(int index);
/// Signature for a function that creates a widget for a given index or row and
/// column.
typedef TableCellBuilder = Widget Function(BuildContext context, int row, int column);

/// Defines the extent and visual appearance of a row or
/// column in a [TableView].
class TableSpan {
  /// Creates a [TableSpan].
  ///
  /// The [extent] argument must be provided.
  const TableSpan({
    required this.extent,
    this.backgroundDecoration,
    this.foregroundDecoration,
  });

  /// Defines the extent of the span.
  ///
  /// If the span represents a row, this is the height of the row. If it
  /// represents a column, this is the width of the column.
  final TableSpanExtent extent;

  /// The [TableSpanDecoration] to paint behind the content of this span.
  ///
  /// The [backgroundDecoration]s of columns are painted before the
  /// [backgroundDecoration]s of rows. On top of that, the content of the
  /// individual cells in this span are painted. That's followed up with the
  /// [foregroundDecoration]s of the rows and the [foregroundDecoration] of the
  /// columns.
  final TableSpanDecoration? backgroundDecoration;

  /// The [TableSpanDecoration] to paint behind the content of this span.
  ///
  /// The [backgroundDecoration]s of columns are painted before the
  /// [backgroundDecoration]s of rows. On top of that, the content of the
  /// individual cells in this span are painted. That's followed up with the
  /// [foregroundDecoration]s of the rows and the [foregroundDecoration] of the
  /// columns.
  final TableSpanDecoration? foregroundDecoration;
}

/// A span extent with a fixed [pixel] value.
class FixedTableSpanExtent extends TableSpanExtent {
  /// Creates a [FixedTableSpanExtent].
  ///
  /// The provided [pixels] value must be equal to or greater than zero.
  const FixedTableSpanExtent(this.pixels) : assert(pixels >= 0.0);

  /// The extent of the span in pixels.
  final double pixels;
}

/// Specified the span extent as a fraction of the viewport extent.
///
/// For example, a column with a 1.0 as [fraction] will be as wide as the
/// viewport.
class FractionalTableSpanExtent extends TableSpanExtent {
  /// Creates a [FractionalTableSpanExtent].
  ///
  /// The provided [fraction] value must be equal to or greater than zero.
  const FractionalTableSpanExtent(this.fraction) : assert(fraction >= 0.0);

  /// The fraction of the [TableSpanExtentDelegate.viewportExtent] that the
  /// span should occupy.
  final double fraction;
}

/// Specifies that the span should occupy the remaining space in the viewport.
///
/// If the previous span can already fill out the viewport, this will evaluate
/// the span's extent to zero. If the previous span cannot fill out the viewport,
/// this span's extent will be whatever space is left to fill out the viewport.
///
/// To avoid that the span's extent evaluates to zero, consider combining this
/// extent with another extent. The following example will make sure that the
/// span's extent is at least 200 pixels, but if there's more than that available
/// in the viewport, it will fill all that space.:
///
/// ```dart
/// const MaxTableSpanExtent(FixedTableSpanExtent(200.0), RemainingTableSpanExtent());
/// ```
class RemainingTableSpanExtent extends TableSpanExtent {
  /// Creates a [RemainingTableSpanExtent].
  const RemainingTableSpanExtent();
}

/// Signature for a function that combines the result of two
/// [TableSpanExtent.calculateExtent] invocations.
///
/// Used by [CombiningTableSpanExtent.combiner];
typedef TableSpanExtentCombiner = double Function(double, double);

/// Runs the result of two [TableSpanExtent]s through a `combiner` function
/// to determine the ultimate pixel extent of a span.
class CombiningTableSpanExtent extends TableSpanExtent {
  /// Creates a [CombiningTableSpanExtent];
  const CombiningTableSpanExtent(this._spec1, this._spec2, this._combiner);

  final TableSpanExtent _spec1;
  final TableSpanExtent _spec2;
  final TableSpanExtentCombiner _combiner;
}

/// Returns the larger pixel extent of the two provided [TableSpanExtent].
class MaxTableSpanExtent extends CombiningTableSpanExtent {
  /// Creates a [MaxTableSpanExtent].
  const MaxTableSpanExtent(TableSpanExtent spec1, TableSpanExtent spec2) : super(spec1, spec2, math.max);
}

/// Returns the smaller pixel extent of the two provided [TableSpanExtent].
class MinTableSpanExtent extends CombiningTableSpanExtent {
  /// Creates a [MinTableSpanExtent].
  const MinTableSpanExtent(TableSpanExtent spec1, TableSpanExtent spec2) : super(spec1, spec2, math.min);
}

/// A decoration for a [TableSpan].
class TableSpanDecoration {
  /// Creates a [TableSpanDecoration].
  const TableSpanDecoration({this.border, this.color});

  /// The border drawn around the span.
  final TableSpanBorder? border;

  /// The color to fill the bounds of the span with.
  final Color? color;
}

/// Describes the border for a [TableSpan].
class TableSpanBorder {
  /// Creates a [TableSpanBorder].
  const TableSpanBorder({this.trailing = BorderSide.none, this.leading = BorderSide.none});

  /// The border to draw on the trailing side of the span.
  ///
  /// The trailing side of a row is the bottom, the trailing side of a column
  /// is its right side.
  final BorderSide trailing;

  /// The border to draw on the leading side of the span.
  ///
  /// The leading side of a row is the top, the trailing side of a column
  /// is its left side.
  final BorderSide leading;
}
