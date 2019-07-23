#lang brag

top : (fun | app)*
fun : /"fun" ID /"(" argvars /")" /"=" expr
/argvars : [ID (/"," ID)*]
@expr : add-or-sub
add-or-sub : [add-or-sub (ADD | MINUS)] mult-or-div
mult-or-div : [mult-or-div (TIMES | DIV)] value
@value : INT | ID | app | /"(" expr /")"
app : ID /"(" [expr (/"," expr)*] /")"
