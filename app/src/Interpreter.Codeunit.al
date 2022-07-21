codeunit 50104 "Interpreter"
{
    procedure Eval(Tree: JsonObject) Result: Decimal
    var
        Node: Codeunit Node;
    begin
        Node := Node.FromJson(Tree);

        case Node.Type() of
            'BinOp':
                Result := Visit_BinOp(Tree);
            'UnaryOp':
                Result := Visit_UnaryOp(Tree);
            'Number':
                Result := Visit_Number(Node);
        end;
    end;

    local procedure Visit_BinOp(Tree: JsonObject): Decimal
    var
        JsnTok: JsonToken;
        Node: Codeunit Node;
        Operator: Codeunit Token;
        Left: Decimal;
        Right: Decimal;
    begin
        Tree.Get('left', JsnTok);
        Left := Eval(JsnTok.AsObject());

        Tree.Get('op', JsnTok);
        Operator := Operator.FromJson(JsnTok.AsObject());

        Tree.Get('right', JsnTok);
        Right := Eval(JsnTok.AsObject());

        case Operator.Type() of
            TokenTypes::PLUS:
                exit(Left + Right);
            TokenTypes::MINUS:
                exit(Left - Right);
            TokenTypes::MUL:
                exit(Left * Right);
            TokenTypes::FDIV:
                exit(Left / Right);
        end;

    end;

    local procedure Visit_UnaryOp(Tree: JsonObject): Decimal
    var
        JsnTok: JsonToken;
        Node: Codeunit Node;
        Operator: Codeunit Token;
        Right: Decimal;
    begin
        Tree.Get('op', JsnTok);
        Operator := Operator.FromJson(JsnTok.AsObject());

        Tree.Get('right', JsnTok);
        Right := Eval(JsnTok.AsObject());

        case Operator.Type() of
            TokenTypes::MINUS:
                exit(-Right);
            else
                exit(Right);
        end;
    end;

    local procedure Visit_Number(Node: Codeunit Node): Decimal
    begin
        exit(Node.Value().AsDecimal());
    end;

}
