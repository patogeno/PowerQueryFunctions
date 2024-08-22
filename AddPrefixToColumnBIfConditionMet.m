let
    // Function Name: AddPrefixToColumnBIfConditionMet
    // Description: 
    // This function modifies a given table by adding a prefix to the values in a specified column (ColumnB) based on a condition applied to another column (ColumnA).
    // If the value in ColumnA matches the specified ConditionValue, the prefix is added to the corresponding value in ColumnB. 
    // The original ColumnB is then replaced with the modified values.
    // Parameters:
    //    - TableInput: The input table to be modified.
    //    - ColumnAName: The name of the column where the condition will be checked.
    //    - ColumnBName: The name of the column to be modified by adding the prefix if the condition is met.
    //    - ConditionValue: The value to check in ColumnA. If a row in ColumnA matches this value, the corresponding value in ColumnB will be prefixed.
    //    - Prefix: The text to be added as a prefix to the values in ColumnB when the condition is met.
    // Returns: A table with the original ColumnB replaced by a new column where values have been prefixed based on the condition.
    // Example:
    //    Given a table with columns ["ID", "Status", "Code"], if ColumnAName = "Status", ColumnBName = "Code", ConditionValue = "Active", and Prefix = "PRE-", the function will add "PRE-" to the "Code" values where "Status" is "Active".

    AddPrefixToColumnBIfConditionMet = (TableInput as table, ColumnAName as text, ColumnBName as text, ConditionValue as text, Prefix as text) as table =>
    let
        // Add a custom column based on the condition
        ModifiedTable = Table.AddColumn(TableInput, "ModifiedColumnB", each if Record.Field(_, ColumnAName) = ConditionValue then Prefix & Record.Field(_, ColumnBName) else Record.Field(_, ColumnBName), type text),
        
        // Remove the original ColumnB and rename the new column
        RemovedOriginalColumnB = Table.RemoveColumns(ModifiedTable, {ColumnBName}),
        RenamedColumn = Table.RenameColumns(RemovedOriginalColumnB, {{"ModifiedColumnB", ColumnBName}})
    in
        RenamedColumn
in
    AddPrefixToColumnBIfConditionMet
