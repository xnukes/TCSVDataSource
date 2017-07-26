# TObject - TCSVDataSource
CSV parser for Delphi Free. Fields as String, Integer or Extended.

# Usage:
```
  var Source: TCSVDataSource;

  Source := TCSVDataSource.Create;
  try
    Source.SetDelimiter(Char(59));
    Source.LoadFromFile(FileName);

    while not Source.Eof do
    begin

      ShowMessage(Source.FieldByNameAsString('CARDHOLDER'));

      Source.Next;
    end;
  finally
    Source.Free;
  end;
  end;
```
