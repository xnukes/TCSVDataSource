// @title CSV Parser to DataSource
// @author Lukáš Vlček
// @licence GNU Public Licence 3.0

unit uCSVDataSource;

interface

uses
  Classes, SysUtils;

type
  TCSVDataSource = class(TObject)
    protected
      _columns: TStringList;
      _rows: TStringList;
      _delimiter: Char;
      _index: Integer;
      _feof: Boolean;
    public
      constructor Create();
      procedure LoadFromFile(const FileName: ShortString);
      procedure SetDelimiter(const Character: Char);
      procedure First;
      function GetTotal(): Integer;
      function GetRowString(): String;
      function FieldByNameAsString(Column: ShortString): String;
      function FieldByNameAsInteger(Column: ShortString): Integer;
      function FieldByNameAsFloat(Column: ShortString): Extended;
      procedure Next;
      property Eof: Boolean read _feof;
    private
      function GetColumnIndex(Column: ShortString): Integer;
    published
  end;

implementation

constructor TCSVDataSource.Create;
begin
  Self._columns := TStringList.Create;
  Self._rows := TStringList.Create;
  Self._columns.Clear;
  Self._rows.Clear;
  Self._index := -1;
end;

procedure TCSVDataSource.LoadFromFile(const FileName: ShortString);
var
  loadedFile,Row: TStringList;
  I: Integer;
begin
  loadedFile := TStringList.Create;
  loadedFile.LoadFromFile(FileName);

  // load columns
  Row := TStringList.Create;
  Row.StrictDelimiter := True;
  Row.Delimiter := Self._delimiter;
  Row.DelimitedText := loadedFile.Strings[0]; // first row is column names

  for I := 0 to Row.Count -1 do
  begin
    Self._columns.Add(Row.Strings[I]);
  end;

  // load rows
  for I := 1 to loadedFile.Count - 1 do
  begin
    Self._rows.Add(loadedFile.Strings[I]);
  end;

  Self._index := 0;
  Self._feof := False;
end;

procedure TCSVDataSource.SetDelimiter(const Character: Char);
begin
  Self._delimiter := Character;
end;

procedure TCSVDataSource.First;
begin
  Self._index := 0;
end;

function TCSVDataSource.GetTotal: Integer;
begin
  Result := Self._rows.Count;
end;

function TCSVDataSource.GetRowString: String;
begin
  Result := Self._rows.Strings[Self._index];
end;

function TCSVDataSource.GetColumnIndex(Column: ShortString): Integer;
var
  ColumnIndex: Integer;
begin
  ColumnIndex := Self._columns.IndexOf(Column);
  if ColumnIndex <> -1 then
    Result := ColumnIndex
  else
    raise Exception.Create('Error: Column "' + Column + '" not found !');
end;

function TCSVDataSource.FieldByNameAsString(Column: ShortString): String;
var
  ColumnIndex: Integer;
  Row: TStringList;
begin
  ColumnIndex := Self.GetColumnIndex(Column);
  Row := TStringList.Create;
  Row.StrictDelimiter := True;
  Row.Delimiter := Self._delimiter;
  Row.DelimitedText := Self._rows.Strings[Self._index];
  Result := Row.Strings[ColumnIndex];
end;

function TCSVDataSource.FieldByNameAsInteger(Column: ShortString): Integer;
var
  ColumnIndex: Integer;
  Row: TStringList;
begin
  ColumnIndex := Self.GetColumnIndex(Column);
  Row := TStringList.Create;
  Row.StrictDelimiter := True;
  Row.Delimiter := Self._delimiter;
  Row.DelimitedText := Self._rows.Strings[Self._index];
  Result := StrToIntDef(Row.Strings[ColumnIndex], 0);
end;

function TCSVDataSource.FieldByNameAsFloat(Column: ShortString): Extended;
var
  ColumnIndex: Integer;
  Row: TStringList;
begin
  ColumnIndex := Self.GetColumnIndex(Column);
  Row := TStringList.Create;
  Row.StrictDelimiter := True;
  Row.Delimiter := Self._delimiter;
  Row.DelimitedText := Self._rows.Strings[Self._index];
  Result := StrToFloatDef(Row.Strings[ColumnIndex], 0);
end;

procedure TCSVDataSource.Next;
begin
  Inc(Self._index);
  if Self._index = Self._rows.Count then
    Self._feof := True;
end;

end.
