codeunit 50102 "Parser"
{

    var
        _Lexer: Codeunit Lexer;
        Tree: Codeunit Tree;
        CurrToken: Codeunit Token;

    procedure Init(Lexer: Codeunit Lexer)
    var
        myInt: Integer;
    begin
        _Lexer := Lexer;
        CurrToken := _Lexer.NextToken();
    end;

    procedure Parse(): JsonObject
    begin
        exit(expr());
    end;

    local procedure ParsingError()
    begin
        Error('Invalid syntax!');
    end;

    local procedure Eat(TokenType: Enum TokenTypes)
    begin
        if CurrToken.Type() = TokenType then
            CurrToken := _Lexer.NextToken()
        else
            ParsingError();
    end;

    local procedure expr(): JsonObject
    var
        Left: JsonObject;
        Operator: Codeunit Token;
        Right: JsonObject;
    begin
        Left := term();

        while CurrToken.Type() in [TokenTypes::PLUS, TokenTypes::MINUS] do begin
            Operator := CurrToken;

            if Operator.Type() = TokenTypes::PLUS then
                Eat(TokenTypes::PLUS)
            else
                Eat(TokenTypes::MINUS);

            Right := term();

            Left := Tree.BinOp(Left, Operator, Right);
        end;

        exit(Left);

    end;

    local procedure term() Node: JsonObject
    var
        Left: JsonObject;
        Operator: Codeunit Token;
        Right: JsonObject;
    begin
        Left := factor();

        while CurrToken.Type() in [TokenTypes::MUL, TokenTypes::FDIV] do begin
            Operator := CurrToken;

            if Operator.Type() = TokenTypes::MUL then
                Eat(TokenTypes::MUL)
            else
                Eat(TokenTypes::FDIV);

            Right := factor();

            Left := Tree.BinOp(Left, Operator, Right);
        end;

        exit(Left);
    end;

    local procedure factor() Node: JsonObject
    var
        Operator: Codeunit Token;
    begin
        case CurrToken.Type() of
            TokenTypes::NUMBER:
                begin
                    Node := Tree.Number(CurrToken);
                    Eat(TokenTypes::NUMBER);
                end;
            TokenTypes::PLUS:
                begin
                    Operator := CurrToken;
                    Eat(TokenTypes::PLUS);
                    Node := Tree.UnaryOp(Operator, factor());
                end;
            TokenTypes::MINUS:
                begin
                    Operator := CurrToken;
                    Eat(TokenTypes::MINUS);
                    Node := Tree.UnaryOp(Operator, factor());
                end;
            else begin
                    Eat(TokenTypes::LPAREN);
                    Node := expr();
                    Eat(TokenTypes::RPAREN);
                end;
        end;
    end;
}