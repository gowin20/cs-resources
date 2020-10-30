hw2.ml
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
  


let get x = (let (Some x_value) = x in x_value);;



(*
---------Deprecated helper functions, from when I originally used mapping for this problem-----------

(* the equivalent of a multi-operand "or" on the list, where Some and None map to True and False *)
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


(* build_node_body and make_tree helper functions *)
(* creates a tree given a fragment derivation *)

(* this function returns the BODY of a node: a list containing subtrees *)
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

(* constructs a tree, given a DFS Derivation and a variable initialized to 0*)
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
