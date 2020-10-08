(*nice *)
open Format 


let rec range a b =
  if a > b then []
  else a :: range(a+1) b;;


(* let rec subset a b = *)

