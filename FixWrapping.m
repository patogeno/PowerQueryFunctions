(TableInput as table, ColumnName as text) as table =>
let
    ModifiedTable = Table.TransformColumns(TableInput, {
        {ColumnName, (text) =>
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
                CombinedText
        }
    })
in
    ModifiedTable