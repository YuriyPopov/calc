codeunit 50103 "Tree"
{

    procedure BinOp(left: JsonObject; Operator: Codeunit Token; Right: JsonObject) Node: JsonObject
    begin
        Node.Add('type', 'BinOp');
        Node.Add('left', left);
        Node.Add('op', Operator.ToJson());
        Node.Add('right', Right)
    end;

    procedure UnaryOp(Operator: Codeunit Token; Right: JsonObject) Node: JsonObject
    begin
        Node.Add('type', 'UnaryOp');
        Node.Add('op', Operator.ToJson());
        Node.Add('right', Right)
    end;

    procedure Number(Token: Codeunit Token) Node: JsonObject
    begin
        Node.Add('type', 'Number');
        Node.Add('token', Token.ToJson());
        Node.Add('value', Token.Value());
    end;

}