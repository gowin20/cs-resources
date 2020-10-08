open List

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
    [] -> false
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

(* testing 2. *)
printf "%B" (equal_sets setA setA);;



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
(* testing 5. *)
let () = List.iter (printf "%d") (set_difference setB setA)