codeunit 50101 "Lexer"
{
    var
        Token: Codeunit Token;
        Txt: Text;
        Pos: Integer;
        CurrChar: Char;

    procedure Init(Input: Text)
    begin
        Txt := Input;
        Advance();
    end;

    procedure NextToken(): Codeunit Token
    begin
        case CurrChar of
            ' ':
                begin
                    Advance();
                    exit(NextToken());
                end;
            0:
                exit(Token.New(TokenTypes::EOF));
            '0', '1', '2', '3', '4', '5', '6', '7', '8', '9':
                exit(Token.New(TokenTypes::NUMBER, Number()));
            '+':
                exit(Token.New(TokenTypes::PLUS, Character()));
            '-':
                exit(Token.New(TokenTypes::MINUS, Character()));
            '*':
                exit(Token.New(TokenTypes::MUL, Character()));
            '/':
                exit(Token.New(TokenTypes::FDIV, Character()));
            '(':
                exit(Token.New(TokenTypes::LPAREN, Character()));
            ')':
                exit(Token.New(TokenTypes::RPAREN, Character()));
            else
                LexerError();
        end;
    end;

    local procedure LexerError()
    var
        LexerErr: Label '"%1" was a complete surprise for me! Found it at position %2';
    begin
        Error(LexerErr, CurrChar, Pos);
    end;

    local procedure Character() JsnVal: JsonValue
    begin
        JsnVal.SetValue(Format(CurrChar));
        Advance();
    end;

    local procedure Number() JsnVal: JsonValue
    var
        Txt: Text;
        Num: Decimal;
    begin
        while CurrChar in ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'] do begin
            Txt += CurrChar;
            Advance();
        end;

        if CurrChar = '.' then
            if Peek() in ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'] then
                repeat
                    Txt += CurrChar;
                    Advance();
                until not (CurrChar in ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9']);

        Evaluate(Num, Txt);
        JsnVal.SetValue(Num);
    end;

    local procedure Advance()
    begin
        Pos += 1;
        if Pos > StrLen(Txt) then
            CurrChar := 0
        else
            CurrChar := Txt[Pos];
    end;

    local procedure Peek(): Char
    var
        PeekPos: Integer;
    begin
        PeekPos := Pos + 1;
        if PeekPos > StrLen(Txt) then
            exit(0)
        else
            exit(Txt[PeekPos]);
    end;
}