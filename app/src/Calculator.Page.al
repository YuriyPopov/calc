page 50100 "Calculator"
{
    PageType = Card;
    ApplicationArea = All;
    UsageCategory = Administration;

    layout
    {
        area(Content)
        {
            field(Input; Input)
            {
                ApplicationArea = All;
                MultiLine = false;
            }
            field(Output; Output)
            {
                ApplicationArea = All;
                Editable = false;
                MultiLine = true;
            }
        }
    }

    actions
    {
        area(Processing)
        {
            action(Evaluate)
            {
                ApplicationArea = All;

                trigger OnAction()
                var
                    Lexer: Codeunit Lexer;
                    Parser: Codeunit Parser;
                    AST: JsonObject;
                    Interpreter: Codeunit Interpreter;
                begin
                    Lexer.Init(Input);
                    Parser.Init(Lexer);
                    AST := Parser.Parse();
                    Output := Format(Interpreter.Eval(AST));
                end;
            }
            action(PrintTokens)
            {
                ApplicationArea = All;
                Caption = 'Print tokens';

                trigger OnAction()
                var
                    Lexer: Codeunit Lexer;
                    Token: Codeunit Token;
                    JsnArr: JsonArray;
                    JsnObj: JsonObject;
                begin
                    Lexer.Init(Input);

                    repeat
                        Token := Lexer.NextToken();
                        JsnArr.Add(Token.ToJson());
                    until Token.Type() = TokenTypes::EOF;

                    Clear(Output);
                    JsnObj.Add('tokens', JsnArr);
                    JsnObj.WriteTo(Output);

                end;
            }
            action(PrintAST)
            {
                ApplicationArea = All;
                Caption = 'Print AST';

                trigger OnAction()
                var
                    Lexer: Codeunit Lexer;
                    Parser: Codeunit Parser;
                    AST: JsonObject;
                begin
                    Lexer.Init(Input);
                    Parser.Init(Lexer);
                    AST := Parser.Parse();
                    AST.WriteTo(Output);
                end;

            }
        }
    }

    var
        Input: Text;
        Output: Text;
}