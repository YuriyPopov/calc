codeunit 50100 "Token"
{

    #region token properties with their setters and getters
    var
        _type: Enum TokenTypes;

    procedure Type(TokenType: Enum TokenTypes)
    begin
        _type := TokenType;
    end;

    procedure Type(): Enum TokenTypes
    begin
        exit(_type);
    end;

    var
        _value: JsonValue;

    procedure Value(Val: JsonValue)
    begin
        _value := Val;
    end;

    procedure Value(): JsonValue
    begin
        exit(_value);
    end;
    #endregion

    procedure New(TokenType: Enum TokenTypes) This: Codeunit Token
    var
        JsnVal: JsonValue;
    begin
        This := New(TokenType, JsnVal);
    end;

    procedure New(TokenType: Enum TokenTypes; TokenValue: JsonValue) This: Codeunit Token
    begin
        This.Type(TokenType);
        This.Value(TokenValue);
    end;

    procedure FromJson(JsnObj: JsonObject): Codeunit Token
    var
        JsnTok: JsonToken;
        TokenType: Enum TokenTypes;
        TokenValue: JsonValue;
    begin
        JsnObj.Get('type', JsnTok);
        TokenType := TokenTypes.FromInteger(JsnTok.AsValue().AsInteger());

        JsnObj.Get('value', JsnTok);
        TokenValue := JsnTok.AsValue();

        exit(New(TokenType, TokenValue));
    end;

    procedure ToJson() JsnObj: JsonObject
    begin
        JsnObj.Add('type', _type.AsInteger());
        JsnObj.Add('type.name', Format(_type));
        JsnObj.Add('value', _value);
    end;

}