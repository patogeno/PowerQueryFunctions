let
    // Function Name: GroupAndConcatenateColumnB
    // Description: This function groups the rows of a table by a specified column (ColumnA) and concatenates the values of another specified column (ColumnB) within each group. The concatenated values in ColumnB are separated by a user-defined separator, with a line break as the default separator.
    // Parameters:
    //    - TableInput: The input table to be grouped and modified.
    //    - ColumnAName: The name of the column by which the table will be grouped.
    //    - ColumnBName: The name of the column whose values will be concatenated within each group.
    //    - Separator (optional): A text string used to separate the concatenated values in ColumnB. Defaults to a line break ("#(lf)").
    // Returns: A table where each unique value in ColumnA is represented by a single row, and the corresponding values in ColumnB are concatenated and separated by the specified separator.
    // Example:
    //    Given a table with columns ["Category", "Item"], if ColumnAName = "Category" and ColumnBName = "Item", and Separator = ", ", the function will group the table by "Category" and concatenate all "Item" values within each group into a single string, separated by ", ".

    GroupAndConcatenateColumnB = (TableInput as table, ColumnAName as text, ColumnBName as text, optional Separator as text) as table =>
    let
        // Set the default separator to a line break if not provided
        SeparatorValue = if Separator = null then "#(lf)" else Separator,

        // Group the table by ColumnA and concatenate the values in ColumnB
        GroupedTable = Table.Group(
            TableInput,
            {ColumnAName},
            {
                {ColumnBName, each Text.Combine(Table.Column(_, ColumnBName), SeparatorValue), type text}
            }
        )
    in
        GroupedTable
in
    GroupAndConcatenateColumnB
