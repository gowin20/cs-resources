open List
open Stdlib

type ('nonterminal, 'terminal) symbol =
| N of 'nonterminal
| T of 'terminal

(* ---- Generic Helper Functions ---- *)

(* val inSet : a -> a list -> bool
inSet returns true if element a is in list b, and false otherwise
O(n) time *)

let rec inSet a b = 
  match b with
  | [] -> false
  | head::body ->
      if a = head then true
      else inSet a body;;

(* version of inSet used specifically for grammar rules. checks against a list of tuples to see if a given symbol is the first element of any of them *)
let rec inRules sym rules =
  match rules with
  | [] -> false
  | rule::rest_rules -> let r_sym = fst rule in
                        if sym = r_sym then true
                        else inRules sym rest_rules

(* 1. Subset Function *)
(* val subset : a list -> a list -> bool *)
(* a is only a subset of b if every single element is present in b
cycle through a first. if an element of a is not found in the list, then it don't work
otherwise, continue checking if things are inSet *)

let rec subset a b = 
  match a with
  | [] -> true
  | head::body ->
      if inSet head b then subset body b
      else false;;

(* 2. Equal Sets *)
let equal_sets a b = ((subset a b) && (subset b a));;

(* 3. Set Union *)
let rec set_union a b =
    match a with
        | a_head::a_body -> a_head::(set_union a_body b)
        | [] -> match b with
                | [] -> []
                | b_head::b_body -> b_head::(set_union a b_body);;

(* 4. Set Intersection *)
let rec set_intersection a b =
    match a with
        | head::body -> ( if (inSet head b) then head::(set_intersection body b)
                        else set_intersection body b)
        | [] -> [];;

(* 5. Difference of Sets *)
let rec set_difference a b =
    match a with
        | [] -> []
        | head::body -> if (inSet head b) then set_difference body b
                        else head::(set_difference body b);;

(* 6. Computed Fixed Points *)
let rec computed_fixed_point eq f x =
  if (eq (x) (f x)) then x
  else computed_fixed_point eq (f) (f x);;

(* 7. Filter Reachable Grammar Rules  *)

(* my solution to this problem consists of the filter_reachable function, which in turn relies upon 3 helper functions
--> helper functions: cleaned, clean_rules, sort_unique_rules *)

(* ---- cleaned ---- *)

(*
"cleaned" helper function takes in a list of symbols and returns a list of the nonterminal symbols
this is used by the clean_rules function in order to parse the body of rules

Disclaimer: I took this function from my TA's slides, discussion section C
(although i am certainly capable of writing it myself!)
*)
let rec cleaned lst_of_symbols = 
	match lst_of_symbols with
	| [] -> []
	| first_symbol::rest_symbols ->
		let cleaned_rest_symbols = cleaned rest_symbols in (*actual recursive call takes place here, returned as a list called cleaned_rest_symbols *)
		match first_symbol with (*figure out if a symbol in our grammar is okay *)
		| N sym -> sym::cleaned_rest_symbols (*nonterminal type with a value of "sym" => add it to the rest *)
		| T _ -> cleaned_rest_symbols;; (* terminal symbol with no value => don't add it to the rest *)


(* ---- clean_rules ---- *) 

(* helper function for filter_reachable
contains the main logic of the program! This is the core function which looks at the list of rules, then returns all the reachable ones

this function ended up being pretty similar to those from LING 185A, (computational linguistics), which uses Haskell
*)

(* symbol is the symbol we're looking for in the rules. It starts with whatever is inputted, then is used in the deeper recursion *)
(* iter_rules is a copy of the rules list used to iterate through the top-level recursion. Checks a symbol against every rule*)
(* master is a reference point containing all the rules to check. Used when switching symbols *)
let rec clean_rules sym iter_rules master =
  match iter_rules with (*cycle through all rules and check if they can be applied to the symbol *)
  | [] -> [] (*base case: done *)
  | rule::iter_rest_rules -> (* clean the rest of the rules against this symbol *)
          let rule_sym = fst rule in
          let cleaned_rules = clean_rules sym iter_rest_rules master in (* top-level recursion checks one symbol against all rules *)
          if sym = rule_sym then let rule_body = snd rule in (*this means the rule is reachable *)
            let rule_nonterminals = cleaned rule_body in (* a cleaned-up version of the rule body. Contains only nonterminal symbols to recurse into *)
            let new_master = set_difference master [rule] in (* when we switch to a new symbol, we need to take out the rule we just looked at *)
            let deep_rules = concat_map (fun s -> clean_rules s new_master new_master) rule_nonterminals in (*call the function with every nonterminal symbol in the rule body *)
            append (rule::cleaned_rules) (deep_rules)(* form the actual list by smushing the two recursive calls together *)
          else cleaned_rules;;(* if the rule isn't a match, just return the cleaned rules up to this point *)

(* ---- sort_unique_rules ---- *)

(* helper function sorts rules and removes duplicates 
it does so by comparing the actual clean_rule_list (that clean_rules just created) to the original list of rules, which has the correct order
it then builds a new list from this
*)
let rec sort_unique_rules order actual =
  match order with
  | [] -> []
  | head::rest -> if inSet head actual then head::sort_unique_rules rest actual
                  else sort_unique_rules rest actual


(* 
the actual filter_reachable function is simple. it just calls clean_rules and sort_unique_rules, 
  then returns the data as a tuple paired with the original symbol 
*)
let filter_reachable g =
  let starting_symbol = fst g in
  let rule_list = snd g in
  let clean_rule_list = clean_rules starting_symbol rule_list rule_list in
  let sort_u_rule_list = sort_unique_rules rule_list clean_rule_list in
  (starting_symbol,sort_u_rule_list);;




(* ---- working notes ----
clean_rules function returns a list of rules reachable from the inputted grammar
- cycle through each rule and check if it can be applied to the given symbol
- if the rule can be applied, add it to the reachable_rules list and check the rest
- otherwise, don't add it to the list, but still check the rest of the rules

- clean rule body and remove any terminal symbols. form: list of nonterminal symbols
- map clean_rules function to the cleaned list of nonterminal symbols to obtain a list of lists containing valid rules
- concat and append to each other recursive call for the other valid rules

map clean rules function to cleaned list of r_Body nonterminal symbols
concat list of lists and append to the rest
*)
