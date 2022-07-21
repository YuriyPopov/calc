codeunit 50105 "Node"
{

    var
        _Type: Text;

    procedure Type(): Text
    begin
        exit(_Type);
    end;

    procedure Type(NodeType: Text)
    begin
        _Type := NodeType;
    end;

    var
        _Value: JsonValue;

    procedure Value(): JsonValue
    begin
        exit(_Value);
    end;

    procedure Value(NodeValue: JsonValue)
    begin
        _Value := NodeValue;
    end;

    procedure FromJson(Node: JsonObject) This: Codeunit Node
    var
        JsnTok: JsonToken;
    begin
        Node.Get('type', JsnTok);
        This.Type(JsnTok.AsValue().AsText());

        if Node.Get('value', JsnTok) then
            This.Value(JsnTok.AsValue());
    end;
}