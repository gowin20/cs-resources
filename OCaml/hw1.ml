open List
open Stdlib
(* remove this before submitting!!! *)
open Format


type ('nonterminal, 'terminal) symbol =
| N of 'nonterminal
| T of 'terminal

(*
a is only a subset of b if every single element is present in b

cycle through a first. if an element of a is not found in the list, then it don't work

otherwise, continue checking if things are inSet
*)


(* Helper Functions 


val inSet : a -> a list -> bool

inSet returns true if element a is in list b, and false otherwise
O(n) time
*)
let rec inSet a b = 
  match b with
  | [] -> false
  | head::body ->
      if a = head then true
      else inSet a body;;


(* 
1. Subset Function 

val subset : a list -> a list -> bool
*)
let rec subset a b = 
  match a with
    [] -> true
  | head::body ->
      if inSet head b then subset body b
      else false;;

let setA = [1;1;1;1;];;
let setB = [1;2;3;4;5;6;7;8;9;10;];;

let setB2 = [1;2;3;4;5;6;7;8;9;10;]

let strSetA = ["a";"b";"c";"d";];;
let strSetB = ["A";"a";"B";"b";"C";"c";"D";"d";];;

(* testing 1.
printf "%B" (subset setA setB);;
printf "%B" (subset strSetA strSetB);; *)


(* 2. Equal Sets *)
let equal_sets a b = ((subset a b) && (subset b a));;

(* testing 2.
printf "%B" (equal_sets setA setA);;
*)


(* 3. Set Union *)
let rec set_union a b =
    match a with
        a_head::a_body -> a_head::(set_union a_body b)
        | [] -> match b with
                [] -> []
                | b_head::b_body -> b_head::(set_union a b_body);;

(* testing 3.
let () = List.iter (printf "%s") (set_union strSetA strSetB)
*)


(* 4. Set Intersection *)
let rec set_intersection a b =
    match a with
        head::body -> ( if (inSet head b) then head::(set_intersection body b)
                        else set_intersection body b)
        | [] -> [];;

(* testing 4.
let () = List.iter (printf "%d") (set_intersection setA setB)
*)

(* 5. Difference of Sets *)
let rec set_difference a b =
    match a with
        [] -> []
        | head::body -> if (inSet head b) then set_difference body b
                        else head::(set_difference body b);;
(* testing 5.
let () = List.iter (printf "%d") (set_difference setB setA)
 *)




(* 6. Computed Fixed Points *)

let rec computed_fixed_point eq f x =
  if (eq (x) (f x)) then x
  else computed_fixed_point eq (f) (f x);;

print_int (computed_fixed_point (=) (fun x -> x / 2) 1000000000);;




(* 7. Filter Reachable Grammar Rules 

Write a function filter_reachable g that returns a copy of the grammar g with all unreachable rules removed. 
This function should preserve the order of rules: 
that is, all rules that are returned should be in the same order as the rules in g.


takes in a list
creates a new list of rules that you can actually reach from the starting symbol
then reverses the order at the end


rule:
    A pair, consisting of (1) a nonterminal value (the left hand side of the grammar rule) and (2) a right hand side.
grammar:
    A pair, consisting of a start symbol and a list of rules. The start symbol is a nonterminal value.


function which starts at the start symbol, then recursively goes through and applies all possible rules
if a rule is applied, then it's added to the list of "reachable_rules"

at the end, we compare against the actual grammar and sort the rules, 
then repair them with the starting symbol for returning

*)
(*  helper function which takes in a list of grammar rules and returns a list that is reachable from the starting symbol 
a symbol -> a list -> a list -> <func> *)



(* takes in a list of symbols and returns a list of the nonterminals
excludes an inputted nonterminal symbol for less recursion
 *)
let rec cleaned lst_of_symbols exclude = 
	match lst_of_symbols with
	| [] -> []
	| first_symbol::rest_symbols ->
		let cleaned_rest_symbols = cleaned rest_symbols exclude in (*actual recursive call takes place here, returned as a list called cleaned_rest_symbols *)
		match first_symbol with (*figure out if a symbol in our grammar is okay *)
		| N sym -> if sym = exclude then cleaned_rest_symbols
               else sym::cleaned_rest_symbols (*nonterminal type with a value of "sym" => add it to the rest *)
		| T _ -> cleaned_rest_symbols;; (* terminal symbol with no value => don't add it to the rest *)



(* 
Clean_Rules function returns a list of rules reachable from the inputted grammar
- cycle through each rule and check if it can be applied to the given symbol
- if the rule can be applied, add it to the reachable_rules list and check the rest
- otherwise, don't add it to the list, but still check the rest of the rules

- clean rule body and remove any terminal symbols. form: list of nonterminal symbols
- map clean_rules function to the cleaned list of nonterminal symbols to obtain a list of lists containing valid rules
- concat and append to each other recursive call for the other valid rules

map clean rules function to cleaned list of r_Body nonterminal symbols
concat list of lists and append to the rest
*)



let rec clean_rules sym rules =
  match rules with (*cycle through all rules and check if they can be applied to the symbol *)
  | [] -> [] (*base case: done *)
  | rule::rest_rules -> let cleaned_rules = clean_rules sym rest_rules in (* clean the rest of the rules against this symbol *)
                        (* if inSet rule cleaned_rules then cleaned_rules *)
                        let rule_sym = fst rule in
                          if sym = rule_sym then let rule_body = snd rule in (*this means the rule is reachable *)
                            let rule_nonterminals = cleaned rule_body sym in
                            let deep_rules = concat_map (fun s -> clean_rules s rules) rule_nonterminals in 
                            append (rule::cleaned_rules) (deep_rules)(*form the actual list *)
                            (*call the function with every nonterminal symbol in the rule body *)
                        else cleaned_rules;; (*just return the cleaned rules up to this point otherwise *)





let rec sort_unique_rules order actual =
  match order with
  | [] -> []
  | head::rest -> if inSet head actual then head::sort_unique_rules rest actual
                  else sort_unique_rules rest actual

let rec filter_reachable g =
  let starting_symbol = fst g in
  let rule_list = snd g in
  let clean_rule_list = clean_rules starting_symbol rule_list in
  let sort_u_rule_list = sort_unique_rules rule_list clean_rule_list in
  (starting_symbol,sort_u_rule_list);;