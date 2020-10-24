open List



open String
(* Homework 2. More grammar stuff *)

type ('nonterminal, 'terminal) parse_tree =
  | Node of 'nonterminal * ('nonterminal, 'terminal) parse_tree list
  | Leaf of 'terminal


(* 1. Convert Grammar 
converts a hw1 style grammar into a hw2 style grammar
*)

let rec make_prodfun rules = fun sym -> 
  match rules with
  | [] -> []
  | sym_rule::rest_tuples ->  let rest_sym_rules = make_prodfun rest_tuples sym in
                              let this_sym = fst sym_rule in
                              if sym = this_sym then (snd sym_rule)::rest_sym_rules
                              else rest_sym_rules;;

let convert_grammar gram1 =
  let start = fst gram1 in
  let hw1Rules = snd gram1 in
  let prodfun = make_prodfun hw1Rules in
  (start,prodfun)




(* 2. Parse Tree *)

let rec parse_tree_leaves = function
  | Leaf l -> [l]
  | Node (sym, list) -> List.concat (List.map (parse_tree_leaves) (list));;
  


(* 
3. Make Matcher 

Write a function make_matcher gram that returns a matcher for the grammar gram. When applied to an acceptor accept and a fragment frag, 
the matcher must try the grammar rules in order and return the result of calling accept on the suffix corresponding to the 
first acceptable matching prefix of frag; this is not necessarily the shortest or the longest acceptable match. 
A match is considered to be acceptable if accept succeeds when given the suffix fragment that immediately follows the matching prefix. 
When this happens, the matcher returns whatever the acceptor returned. If no acceptable match is found, the matcher returns None.

1. second / third arguments: acceptor and fragment

1. try the grammar rules in order

2. return the result of calling accept on:
  the suffix corresponding to the first acceptable matching prefix of frag
  FIRST acceptable

  match is acceptable IF "accept" funcition returns Some when given the suffix fragment following the matching prefix

  matcher returns whatever the acceptor returns when it's successful
  if it's not successful, then don't return right away! keep trying, and if nothing is found then finally return the final "none"


prefix: first valid leaf node?


make_matcher creates a function. It's a curried function which supposedly takes grammar and input, then we just give it grammar


let make_matcher gram = fun acceptor -> fun frag ->
  

1. find prefix
- find_prefix gram frag

- helper function takes in a fragment and grammar as input
- work your way through the grammar from the starting symbol and down the list DFS
- if any of the generated terminal strings match the input, then that's the prefix!!! use the first match you find
- stop 

- cycle through the rules
- cycle through the fragment

- function which just checks for equality

function is_substring
- just like is_subset except order and duplicated matter


  1. generate a list of strings via DFS on a symbol
    - avoid recursion in several ways
  2. check if each string in the list is_subset of the frag
    return if so, otherwise check the next rule

2. call "accept" on the suffix
  if it's not accepted, we have to keep finding a new prefix until it is


"1" "+" "$" "7"


++ $ 1

"1+2"

1
1+
1+2


1;2;3;
Expr;Binop;Expr

"1";Binop;"2"

Expr -> "5";"+";"2"



"1";



k indicates position in the string

Expr -> Incrop Expr
Expr -> Num
Num -> 1
Incrop -> ++

++ 1


Expr -> Incrop Expr --------- k=1, check incrop first
Incrop -> ++ ------------ check against kth character
match! ------------------ k++
if no match for the first sym found, exit

keep going on Expr -> Incrop Expr ------------------------ k = 2

Expr -> Incrop Expr
  Incrop -> ++ ---------------------- check againt kth character
  no match! -------------------- exit out of that rule
Expr -> Num ---------------------- k=2
Num -> 1 --------------------------- check against kth character
match! ----------------------------- k++

match found


*)



let rec find_match gram rule prefix =
  if prefix = rule then 



let rec find_prefix gram term =
  let start_sym = fst gram in
  let prod_fun = snd gram in
  let alternative_rules = prod_fun start_sym in
  match alternative_rules with
  | [] ->
  | rule::rest -> match symbol with
                  | N sym ->
                  | T leaf -> if term = leaf then 

(* hw 2 style grammar rules: 

tuple containing a NONTERMINAL STARTING SYMBOL, and a PRODUCTION FUNCTION


production function: argument is a nonterminal symbol, returns an alternative list of the RHS of rules corresponding to that symbol

alternative list: a list of right-hand sides for a specific rule


let prodfun s = function
    | Expr -> [[];[]]
    | 
*)


(* takes in a list of rules in the style of HW1, and returns a list of tuples of this form: 
(symbol,[all rules associated with that symbol])
This is then used in the production function
*)

(* 
My initial approach to this was very Pythonic. It was also slow and inefficient, and used 5 different helper functions.
returns a list of rules corresponding to a certain symbol, with an additional rule appended to it.

CHECK to make sure that the rules are added in proper order. probably doesn't matter 


(* returns a curried function which takes a symbol as input, and outputs a list of the rules associated with it (stored in memory)*)
let rec make_prodfun = fun rules -> (fun sym -> 
  match rules with
  | [] -> []
  | sym_rules::rest_tuples -> let this_sym = fst sym_rules in
                              if sym = this_sym then (snd sym_rules)
                              else make_prodfun rest_tuples sym
  );;


let rec append_rule sym rule rules =
  match rules with
  | [] -> []
  | aSymTuple::rest -> let lhs = fst aSymTuple in
                       if lhs = sym then let rhs = snd aSymTuple in
                        rule::rhs
                       else append_rule sym rule rest

(* boolean returns true if a given symbol already exists within the list of grouped rules *)
let rec in_rule_list query list =
  match list with
  | [] -> false
  | tuple::rest -> let left = fst tuple in
                   if query = left then true
                   else in_rule_list query rest;;

(* returns a copy of the hw2rules list without any rules for a given symbol *)
let rec exclude_sym sym hw2rules =
  match hw2rules with
  | [] -> []
  | symList::rest -> let main_rules = exclude_sym sym rest in
                     let this_sym = fst symList in
                     if this_sym = sym then main_rules
                     else hw2rules  

let rec grouped_rule_list hw1rules =
  match hw1rules with
  | [] -> []
  | rule::rest -> let lhs = fst rule in
                  let rhs = snd rule in
                  let hw2rules = grouped_rule_list rest in
                  if in_rule_list lhs hw2rules then (lhs,(append_rule lhs rhs hw2rules))::(exclude_sym lhs hw2rules)
                  else (lhs,[rhs])::hw2rules


let convert_grammar gram1 = 
  let start = fst gram1 in 
  let hw1Rules = snd gram1 in
  let hw2Grouping = grouped_rule_list hw1Rules in
  let hw2_prodfun = make_prodfun hw2Grouping in
  (start,hw2_prodfun);;
                  (* let hw2_symlist = hw2_prodfun rule_sym in
                  if hw2_symlist = () *)
*)


(* returns a curried function which takes a symbol as input, and outputs a list of the rules associated with it (stored in memory)*)