// Function Name: MergeColumnsExceptFirst
// Description:
// This function merges all columns of a table into a single column, except for the first column.
// The first column is preserved, and a new column is created containing the merged values of the remaining columns, separated by a specified separator.
// Parameters:
//    - inputTable: The input table whose columns will be merged. The first column is preserved as-is.
//    - separator: A text string used to separate the values in the merged column.
// Returns: A table with two columns: the first column of the original table and a new "Merged" column containing the concatenated values of the remaining columns, separated by the specified separator.
// Example:
//    Given a table with columns ["Name", "Age", "City"], calling MergeColumnsExceptFirst with a comma separator will result in a table with columns ["Name", "Merged"] where "Merged" contains values like "Age, City".
let
    MergeColumnsExceptFirst = (inputTable as table, optional separator as text) as table =>
    let
        // Set default separator to a comma if not provided
        SeparatorValue = if separator = null then "," else separator,

        // Get the first column name
        FirstColumnName = Table.ColumnNames(inputTable){0},

        // Select all columns except the first one
        OtherColumns = Table.RemoveColumns(inputTable, {FirstColumnName}),

        // Add a new column that merges all the other columns
        MergedColumn = Table.AddColumn(inputTable, "Merged", each Text.Combine(Record.FieldValues(Record.SelectFields(_, Table.ColumnNames(OtherColumns))), SeparatorValue), type text),

        // Select only the first column and the newly merged column
        FinalTable = Table.SelectColumns(MergedColumn, {FirstColumnName, "Merged"})
    in
        FinalTable
in
    MergeColumnsExceptFirst
