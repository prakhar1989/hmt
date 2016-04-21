type id = string

type op = Add | Mul | Gt | Lt

type primitiveType =
  | TNum
  | TBool
  | T of string
  | TFun of primitiveType * primitiveType
;;

type expr =
  | NumLit of int
  | BoolLit of bool
  | Val of string
  | Binop of expr * op * expr
  | Fun of id * expr
  | App of expr * expr
;;

(* annotated expr -> expr with types *)
type aexpr =
  | ANumLit of int * primitiveType
  | ABoolLit of bool * primitiveType
  | AVal of string * primitiveType
  | ABinop of aexpr * op * aexpr * primitiveType
  | AFun of id * aexpr * primitiveType
  | AApp of aexpr * aexpr * primitiveType
;;

let rec string_of_type (t: primitiveType): string =
  match t with
  | TNum -> "num" | TBool -> "bool"
  | T(x) -> Printf.sprintf "'%s" x
  | TFun(t1, t2) -> let st1 = string_of_type t1
    and st2 = string_of_type t2 in
    Printf.sprintf "(%s -> %s)" st1 st2
;;

let string_of_op (op: op) =
  match op with
  | Add -> "+" | Mul -> "*" | Lt -> "<" | Gt -> ">" ;;

let rec string_of_aexpr (ae: aexpr): string =
  match ae with
  | ANumLit(x, t)  -> Printf.sprintf "(%s: %s)" (string_of_int x) (string_of_type t)
  | ABoolLit(b, t) -> Printf.sprintf "(%s: %s)" (string_of_bool b) (string_of_type t)
  | AVal(x, t) -> Printf.sprintf "(%s: %s)" x (string_of_type t)
  | ABinop(e1, op, e2, t) ->
    let s1 = string_of_aexpr e1 in let s2 = string_of_aexpr e2 in
    let sop = string_of_op op in let st = string_of_type t in
    Printf.sprintf "(%s %s %s: %s)" s1 sop s2 st
  | AFun(id, ae, t) ->
    let s1 = string_of_aexpr ae in
    let st = string_of_type t in
    Printf.sprintf "(fun %s -> %s): %s" id s1 st
  | AApp(e1, e2, t) -> 
    let s1 = string_of_aexpr e1 and
    s2 = string_of_aexpr e2 and st = string_of_type t in
    Printf.sprintf "(%s %s): %s" s1 s2 st
;;

let rec string_of_expr (e: expr): string =
  match e with
  | NumLit(x) -> string_of_int x
  | BoolLit(b) -> string_of_bool b
  | Val(s) -> s
  | Binop(e1, op, e2) ->
    let s1 = string_of_expr e1 and s2 = string_of_expr e2 in
    let sop = string_of_op op in
    Printf.sprintf "(%s %s %s)" s1 sop s2
  | Fun(id, e) ->
    let s1 = string_of_expr e in Printf.sprintf "(fun %s -> %s)" id s1
  | App(e1, e2) ->
    let s1 = string_of_expr e1 and s2 = string_of_expr e2 in
    Printf.sprintf "(%s %s)" s1 s2
;;
