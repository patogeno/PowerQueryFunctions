(TableInput as table, optional ColumnNames as list) as table =>
let
    // Function to process a single text value
    ProcessText = (text as text) as text =>
        let
            SplitText = Text.Split(text, "#(lf)"),
            ProcessedLines = List.Transform(SplitText, each Text.Trim(_)),
            CombinedText = List.Accumulate(
                ProcessedLines,
                "",
                (state, current) =>
                    let
                        PrevLine = if state = "" then "" else Text.End(state, 1),
                        CurrentStartsWithSymbol = Text.Start(current, 1) <> "" and not Text.Contains("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789", Text.Start(current, 1)),
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
            (colName) => {colName, ProcessText, type text}
        )
    )
in
    ModifiedTable