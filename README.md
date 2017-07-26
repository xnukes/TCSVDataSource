# TCSVDataSource
CSV parser for Delphi Free

# Usage:
var Source: TCSVDataSource;

Source := TCSVDataSource.Create;
try
  Source.SetDelimiter(Char(59)); // Delimiter = ;
  Source.LoadFromFile('file.csv');

  while not Source.Eof do
  begin

    ShowMessage(Source.FieldByNameAsString('CARDHOLDER'));

    Source.Next;
  end;
finally
  Source.Free;
end;
end;
