let
    // Function Name: NormalizeTextColumns
    // Description:
    // This function processes text values in the specified columns of a table by removing unnecessary line breaks, trimming extra spaces,
    // and ensuring that lines are concatenated correctly based on the content.
    // It optionally applies this transformation to all text columns if no specific columns are provided.
    // Parameters:
    //    - TableInput: The input table containing the columns to be processed.
    //    - ColumnNames (optional): A list of column names to apply the text normalization to. If not provided, the function will apply the transformation to all columns in the table.
    // Returns: A table with the specified text columns modified, where line breaks are adjusted, and text is normalized according to the rules outlined in the function.
    // Example:
    //    Given a table with text columns containing inconsistent line breaks and spacing, the function can be used to clean and standardize the text format across the specified columns.
    // Processing Logic:
    //    - Text is split by line breaks.
    //    - Each line is trimmed of extra spaces.
    //    - Lines are then concatenated with a space or line break based on whether the current line starts with a symbol or the previous line ends with a period.


    NormalizeTextColumns = (TableInput as table, optional ColumnNames as list) as table =>
    let
        // Function to process a single text value
        ProcessText = (text as nullable text) as nullable text =>
            if text = null then null
            else
                let
                    SplitText = Text.Split(text, "#(lf)"),
                    ProcessedLines = List.Transform(SplitText, each Text.Trim(_)),
                    CombinedText = List.Accumulate(
                        ProcessedLines,
                        "",
                        (state, current) =>
                            let
                                PrevLine = if state = "" then "" else Text.End(state, 1),
                                CurrentStartsWithSymbol = Text.Start(current, 1) <> "" and not Text.Contains("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789(", Text.Start(current, 1)),
                                PrevEndsWithPeriod = PrevLine = ".",
                                NewLineSeparator = if CurrentStartsWithSymbol or PrevEndsWithPeriod then "#(lf)" else " "
                            in
                                state & (if state = "" then "" else NewLineSeparator) & current
                    )
                in
                    CombinedText,
        
        // Determine which columns to process
        ColumnsToProcess = if ColumnNames = null then Table.ColumnNames(TableInput) else ColumnNames,
        
        // Apply the transformation to selected columns
        ModifiedTable = Table.TransformColumns(
            TableInput, 
            List.Transform(
                ColumnsToProcess, 
                (colName) => {colName, ProcessText, type nullable text}
            )
        )
    in
        ModifiedTable
in
    NormalizeTextColumns