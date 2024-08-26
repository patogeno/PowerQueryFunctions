let
    // Function Name: GroupAndConcatenateColumns
    // Description: This function groups the rows of a table by one or more specified columns and concatenates the values of the remaining columns within each group.
    // Parameters:
    //    - TableInput: The input table to be grouped and modified.
    //    - GroupingColumns: Either a text (single column name) or a list of texts (multiple column names) by which the table will be grouped.
    //    - Separator (optional): A text string used to separate the concatenated values. Defaults to a line break ("#(lf)").
    // Returns: A table where each unique combination of values in the grouping columns is represented by a single row, and the corresponding values in the remaining columns are concatenated and separated by the specified separator.

    GroupAndConcatenateColumns = (TableInput as table, GroupingColumns as any, optional Separator as text) as table =>
    let
        // Set the default separator to a line break if not provided
        SeparatorValue = if Separator = null then "#(lf)" else Separator,

        // Convert GroupingColumns to a list if it's a single text value
        GroupingColumnsList = if Value.Is(GroupingColumns, type text) then {GroupingColumns} else GroupingColumns,

        // Get all column names from the input table
        AllColumns = Table.ColumnNames(TableInput),

        // Determine which columns need to be concatenated (all columns except grouping columns)
        ColumnsToConcat = List.Difference(AllColumns, GroupingColumnsList),

        // Create a list of aggregations for the Group operation
        Aggregations = List.Transform(
            ColumnsToConcat,
            each {_, (t) => Text.Combine(List.Transform(Table.Column(t, _), Text.From), SeparatorValue), type text}
        ),

        // Group the table by the specified column(s) and concatenate the values in the remaining columns
        GroupedTable = Table.Group(
            TableInput,
            GroupingColumnsList,
            Aggregations
        )
    in
        GroupedTable
in
    GroupAndConcatenateColumns