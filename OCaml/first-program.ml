(*nice *)
open Format 


let rec range a b =
  if a > b then []
  else a :: range(a+1) b;;

(*

a is only a subset of b if every single element is present in b

cycle through a first. if an element of a is not found in the list, then it don't work

otherwise, continue checking if things are inSet
*)

let rec inSet a b = 
  match b with
    [] -> false
  | head::body ->
      if a = head then true
      else inSet a body;;

let rec subset a b = 
  match a with
    [] -> true
  | head::body ->
      if inSet head b then subset body b
      else false;;




let setA = [1;1;1;1;];;
let setB = [1;2;3;4;5;6;7;8;9;10];;
printf "%B" (subset setA setB);;


(* let rec subset a b = *)

