open List



open String
(* Homework 2. More grammar stuff *)

type ('nonterminal, 'terminal) parse_tree =
  | Node of 'nonterminal * ('nonterminal, 'terminal) parse_tree list
  | Leaf of 'terminal

type ('nonterminal, 'terminal) symbol =
| N of 'nonterminal
| T of 'terminal

type 'a t = 'a option = 
| 	None
| 	Some of 'a

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

(* rule is a list of symbols, containing all the generated parts of the rule *)

(* prefix is a list of terminal symbols. we're checking to see if rule will properly generate prefix and nothing more *)


(* 

if prefix is empty, then we've done it! return something positive (true?)

check the first symbol in rule. 

if it's terminal, check if it matches the first symbol in prefix. 
  if it does, call find_match with the body of the rule and the body of the prefix
  if it doesn't match, exit out and return none or something

if it's nonterminal, plug it in to the grammar production function and obtain an alternative rule list
  map the find_match function to that entire alternative rule list, and OR it to see if any of the rules work


finds a match with a maximum depth of k? that's the exit condition then

*)



(* 
terminal matcher on just terminal symbols

make something able to track terminals

then make something able to do a single rule

then make something able to do the multi-rule
*)
let is_some x = (x != None);;

let is_none x = (x = None);;

let get x = (let (Some x_value) = x in x_value);;

let may f x = 
  if (is_some x) then (f x)
  else ();;

let default x opt =
	match opt with
	| None -> x 
	| Some v -> v;;

let map_default f x opt =
	match opt with
	| None -> x 
	| Some v -> f v;;


let rec some_in_list lst =
  match lst with
  | [] -> None
  | item::rest -> match item with
                  | None -> some_in_list rest
                  | Some v -> Some v

let rec filter_some lst =
  match lst with
  | [] -> []
  | item::rest -> match item with
                  | None -> filter_some rest
                  | Some _ -> item::(filter_some rest)



(* keep track of the derivation path used to get here, and return it in the acceptor *)
(*

Sym, body

*)


let terminal_matcher terminal accept frag = 
  match frag with
  | sym::rest_frag -> if (sym = terminal) then (accept rest_frag) else None
  | _ -> None

(* core nonterminal_matcher function matches a nonterminal symbol. It checks the entire nonterminal rule list of a symbol, and does the first one which works*)
let rec nonterminal_matcher prod_fun alt_rules accept frag =
  match alt_rules with
  | [] -> None
  | rule::rest_rules -> let works = body_matcher prod_fun rule accept frag in
                  match works with
                  | None -> nonterminal_matcher prod_fun rest_rules accept frag
                  | Some suf -> works
(* This function is magical. passing a curried version as "acceptor" to the terminal + nonterminal functions ensures that they always check the rules in the proper order *)
(*most importantly, this method takes care of backtracking. I initially tried to write match cases which backtrack, but that failed after hours of attempts *)
and body_matcher prod_fun rule accept frag = 
  match rule with
  | [] -> accept frag
  | sym::rest_sym -> let new_acceptor = body_matcher prod_fun rest_sym accept in (* curry the body_matcher function so that calling "accept" in the other functions will check the rest of the symbols *)
                     match sym with
                     | T s -> terminal_matcher s (new_acceptor) frag
                     | N s -> let s_alt_rules = prod_fun s in
                     nonterminal_matcher prod_fun s_alt_rules new_acceptor frag

let make_matcher gram = fun accept -> fun frag ->
  let start_sym = fst gram in
  let prod_fun = snd gram in
  let start_rules = prod_fun start_sym in
  nonterminal_matcher prod_fun start_rules accept frag





let accept_empty_suffix = function
   | _::_ -> None
   | x -> Some x





(* only accepts the empty suffix, and returns a PATH *)
let accept_empty_path frag path =
  match frag with
  | [] -> Some path
  | _ -> None

let rec derive_body prod_fun rule accept frag path =
  match rule with
  | [] -> accept frag path
  | sym::rest_rule_syms -> let accept_rest = derive_body prod_fun rest_rule_syms accept in
                           match sym with
                           | T s ->  ( match frag with (* Originally, used a terminal_path function with the same code here. However, that caused errors so I inlined it here *)
                                      | f_sym::f_rest -> if (s = f_sym) then (accept_rest f_rest path) else None
                                      | _ -> None )
                           | N s -> let alt_rules = prod_fun s in
                                    derive_nonterminal s prod_fun alt_rules accept_rest frag path

and derive_nonterminal s_sym prod_fun alt_rules accept frag path =
  match alt_rules with
  | [] -> None
  | rule::rest_rules -> let this_path = (s_sym,rule)::path in
                        let complete_path = derive_body prod_fun rule accept frag this_path in
                        match complete_path with
                        | None -> derive_nonterminal s_sym prod_fun rest_rules accept frag path
                        | Some apath -> complete_path


let construct_deriv gram frag =
  let fst_sym = fst gram in
  let prod_fun = snd gram in
  let alt_rules = prod_fun fst_sym in
  let backwards_deriv = derive_nonterminal fst_sym prod_fun alt_rules accept_empty_path frag [] in
  match backwards_deriv with
  | None -> None
  | Some deriv -> Some (List.rev deriv)
  


let build_leaf terminal = Leaf (terminal)


let deriv_done (deriv : (('nonterminal * ('nonterminal, 'terminal) symbol List.t) list t)) =
  match deriv with
  | Some [] -> []
(* returns a packet containing (num of rules used),(body of rule) *)


let rec exclude_n lst n =
  match lst with
  | [] -> []
  | item::rest -> if (n > 0) then exclude_n rest (n-1)
                  else item::(exclude_n rest n)

let rec build_node_body (body : (('nonterminal, 'terminal) symbol List.t)) (deriv : (('nonterminal * ('nonterminal, 'terminal) symbol List.t) list)) (numRules) = 
  match body with
  | [] -> (numRules,[])
  | b_sym::b_rest -> match b_sym with
                     | N s -> let tree_packet = make_tree (deriv) (numRules) in
                              let new_numRules = fst tree_packet in
                              let rules_used = (new_numRules) - (numRules) in
                              let tree = snd tree_packet in
                              let remaining_deriv = exclude_n deriv rules_used in
                              let rest_body_packet = build_node_body (b_rest) (remaining_deriv) (new_numRules) in
                              let total_rules = fst rest_body_packet in
                              let rest_body = snd rest_body_packet in
                              (total_rules,(tree::rest_body))
                     | T s -> let this_leaf = (Leaf s) in
                              let rest_body_packet = build_node_body (b_rest) (deriv) (numRules) in
                              let total_rules = fst rest_body_packet in
                              let rest_body = snd rest_body_packet in
                              (total_rules,(this_leaf::rest_body))

(* constructs a tree, given a DFS Path and a starting symbol + rule *)
and make_tree (deriv : (('nonterminal * ('nonterminal, 'terminal) symbol List.t) list)) (numRules) =
  match deriv with
  | (d_rule::d_rest) -> let (sym,rhs) = d_rule in
                           let node_body_packet = build_node_body (rhs) (d_rest) (numRules+1) in
                           let num_rules = fst node_body_packet in
                           let node_body = snd node_body_packet in
                           (num_rules,(Node (sym,node_body)))




let pass_deriv_to_tree deriv =
  match deriv with
  | None -> None
  | Some d -> Some (make_tree d 0)



let rec make_parser gram = fun frag ->
    let frag_deriv = construct_deriv gram frag in
    match frag_deriv with
    | None -> None
    | Some derivation -> let tree_packet = make_tree derivation 0 in
                         Some (snd tree_packet)

(*: (('nonterminal, 'terminal) symbol List.t)))*)
(* : (('nonterminal * ('nonterminal, 'terminal) symbol List.t) list t))*)
(*
(* returns a leaf node 

let build_leaf terminal = Leaf (terminal)


let deriv_done (deriv : (('nonterminal * ('nonterminal, 'terminal) symbol List.t) list t)) =
  match deriv with
  | Some [] -> []

let rec build_node_body (body : (('nonterminal, 'terminal) symbol List.t)) (accept) (deriv : (('nonterminal * ('nonterminal, 'terminal) symbol List.t) list t)) = 
  match body with
  | [] -> accept deriv
  | b_sym::b_rest -> let accept_rest = build_node_body (b_rest) (accept) in
                     match b_sym with
                     | N s -> (make_tree (deriv) (accept_rest))
                     | T s -> [Leaf s]

(* constructs a tree, given a DFS Path and a starting symbol + rule *)
and make_tree (deriv : (('nonterminal * ('nonterminal, 'terminal) symbol List.t) list t)) (accept) =
  match deriv with
  | Some (d_rule::d_rest) -> let (sym,rhs) = d_rule in
                           let node_body = build_node_body (rhs) (accept) (Some d_rest) in
                           Node (sym,node_body)
unnecessary?
*)
let make_leaf terminal frag = 
  match frag with
  | (T sym)::rest -> if sym = terminal then Some(Leaf sym) else None
  | _ -> None


(* Creates a Node and fills out its body list of subtrees *)
let rec make_node gram alt_list accept frag =
  let start_sym = fst gram in
  let prod_fun = snd gram in
  match alt_list with
  | [] -> None
  | rule::rest_rules -> let node_body = make_body prod_fun rule accept frag in
                        match node_body with
                        | Some list -> Some (Node (start_sym,list))
                        | None -> make_node gram rest_rules accept frag

(* returns a list of symbols for da body of da tree *)
and make_body prod_fun rule accept frag =
  match rule with
  | [] -> accept frag
  | symbol::rest_syms -> let accept_rest = make_body prod_fun rest_syms accept in
                         match symbol with
                         | T sym -> (match frag with
                                    | [] -> None
                                    | pre::suff -> if (pre = sym) then Some [Leaf sym](*::(accept_rest suff)*)
                                                   else None)
                         | N sym -> let node = (make_node (sym,prod_fun) (prod_fun sym) accept_rest frag) in
                                    match node with
                                    | None -> None
                                    | Some Node (symbol,lst) -> Some [Node (symbol,lst)](*::(accept_rest suff)*)

let rec build_tree gram frag =
  let symbol = fst gram in
  let prod_fun = snd gram in
  make_node gram (prod_fun symbol) accept_empty_suffix frag
*)



(*


(* helper function enables us to check every possible match for a nonterminal symbol, and return the suffix of the first match *)
let rec match_nonterminal prod_fun frag rest_main_rule_syms alternative_list =
  match alternative_list with
  | [] -> None
  | rule::rest_rules -> let some_match = find_match prod_fun frag rule in
                        match some_match with
                        | None -> (match_nonterminal (prod_fun) (frag) (rest_main_rule_syms) (rest_rules))
                        | Some suffix -> let rest_work = find_match prod_fun suffix rest_main_rule_syms in
                                         match rest_work with
                                         | None -> (match_nonterminal (prod_fun) (frag) (rest_main_rule_syms) (rest_rules))
                                         | Some suff -> Some suff

(* finds a match in the grammar for a fragment, and returns the remaining part as Some suffix *)
and find_match prod_fun frag rule =
  match rule with
  | [] -> Some frag (* when the rule finishes, call acceptor on the remaining fragment *)
  | rule_sym::rest_rule_syms -> match rule_sym with
                              | T t_sym -> (match frag with
                                           | [] -> None (* not a match *)
                                           | f_sym::rest_f_sym -> if (t_sym = f_sym) then (find_match (prod_fun) (rest_f_sym) (rest_rule_syms) (*k*)) (* recursive call on the rest of the prefix after finding a match *)
                                                                  else None)
                              | N nt_sym -> let alt_rules = prod_fun nt_sym in
                              let nt_match = (match_nonterminal (prod_fun) (frag) (rest_rule_syms) (alt_rules)) in
                              nt_match



let these_results prod_fun frag rule k alt_rules = List.map (fun rl -> find_match prod_fun frag rl ) alt_rules;;


let rec try_rules prod_fun accept frag rules =
  match rules with
  | [] -> None
  | rule::rest -> let sumthin = find_match (prod_fun) (frag) (rule) in
                  match sumthin with
                  | None -> try_not_to_cry prod_fun accept frag rest
                  | Some suffix -> let mat = accept suffix in
                                   match mat with
                                   | None -> try_rules prod_fun accept frag rest
                                   | Some _ -> mat

let make_matcher gram = fun accept -> fun frag ->
  let start_sym = fst gram in
  let prod_fun = snd gram in
  let start_sym_rules = prod_fun start_sym in
  try_not_to_cry prod_fun accept frag start_sym_rules
  

*)

(* 

let rec try_all_matches prod_fun some_matches rest_rule = 
    (match some_matches with
    | [] -> None
    | some_suff::rest_suffs -> let suff = get some_suff in
                               let match_works = find_match prod_fun suff rest_rule in
                               (match match_works with
                               | None -> try_all_matches prod_fun rest_suffs rest_rule
                               | Some suffx -> Some suffx))
(* finds a match in the grammar for a fragment, and returns the remaining part as Some suffix *)
and find_match prod_fun frag rule =
  match rule with
  | [] -> Some frag (* when the rule finishes, call acceptor on the remaining fragment *)
  | rule_sym::rest_rule_syms -> match rule_sym with
                              | T t_sym -> (match frag with
                                           | [] -> None (* SOMETIMES is a match *)
                                           | f_sym::rest_f_sym -> if (t_sym = f_sym) then (find_match (prod_fun) (rest_f_sym) (rest_rule_syms)) (* recursive call on the rest of the prefix after finding a match *)
                                                                  else None)
                              | N nt_sym -> let alt_rules = prod_fun nt_sym in
                              let all_alt_results = List.map (fun rl -> find_match prod_fun frag rl) alt_rules in
                              let some_results = filter_some all_alt_results in
                              try_all_matches prod_fun some_results rest_rule_syms;;



hw 2 style grammar rules: 

tuple containing a NONTERMINAL STARTING SYMBOL, and a PRODUCTION FUNCTION


production function: argument is a nonterminal symbol, returns an alternative list of the RHS of rules corresponding to that symbol

alternative list: a list of right-hand sides for a specific rule


let prodfun s = function
    | Expr -> [[];[]]
    | 
*)