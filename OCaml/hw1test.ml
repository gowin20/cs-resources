

let setA = [1;1;1;1;];;
let setB = [1;2;3;4;5;6;7;8;9;10;];;

let setB2 = [1;2;3;4;5;6;7;8;9;10;]

let strSetA = ["a";"b";"c";"d";];;
let strSetB = ["A";"a";"B";"b";"C";"c";"D";"d";];;


(* testing 1. *)

let subset_test0 = subset setA setB

let subset_test1 = subset strSetA strSetB


(* testing 2. *)

let equal_sets_test0 = equal_sets setA setA

let equal_sets_test1 = not (equal_sets setA setB)


(* testing 3. *)

let set_union_test0 = equal_sets (set_union strSetA strSetB) ["a";"b";"c";"d";"A";"a";"B";"b";"C";"c";"D";"d";]

let set_union_test1 = equal_sets (set_union setA [2;3;4;5]) [1;2;3;4;5]

(* testing 4. *)

let set_intersection_test0 = equal_sets (set_intersection setA setB) [1;]

let set_intersection_test1 = equal_sets (set_intersection setB setB) setB


(* testing 5. *)

let set_diff_test0 = equal_sets (set_difference setB setA) [2;3;4;5;6;7;8;9;10]

let set_diff_test1 = equal_sets (set_difference setA setB) []


(* testing 6. *)

let computed_fixed_point_test0 = (computed_fixed_point (=) (fun x -> x /. 2.) 1.) = 0.

let computed_fixed_point_test1 = (computed_fixed_point (=) (fun x -> x *. 10.) 1.) = infinity










type awksub_nonterminals =
  | Expr | Lvalue | Incrop | Binop | Num

let awksub_rules =
   [Expr, [T"("; N Expr; T")"];
    Expr, [N Num];
    Expr, [N Expr; N Binop; N Expr];
    Expr, [N Lvalue];
    Expr, [N Incrop; N Lvalue];
    Expr, [N Lvalue; N Incrop];
    Lvalue, [T"$"; N Expr];
    Incrop, [T"++"];
    Incrop, [T"--"];
    Binop, [T"+"];
    Binop, [T"-"];
    Num, [T"0"];
    Num, [T"1"];
    Num, [T"2"];
    Num, [T"3"];
    Num, [T"4"];
    Num, [T"5"];
    Num, [T"6"];
    Num, [T"7"];
    Num, [T"8"];
    Num, [T"9"]]

let awksub_grammar = Expr, awksub_rules

(* 
let in_grammar = inRules Expr awksub_rules

let awksub_reachable_rules = clean_rules Lvalue awksub_rules awksub_rules

let more_rules = clean_rules Lvalue awksub_rules awksub_rules;;

 let filtered_grammar = filter_reachable awksub_grammar;; *)

let awksub_test0 =
  filter_reachable awksub_grammar = awksub_grammar

let awksub_test1 =
  filter_reachable (Expr, List.tl awksub_rules) = (Expr, List.tl awksub_rules)

let awksub_test2 =
  filter_reachable (Lvalue, awksub_rules) = (Lvalue, awksub_rules)

let awksub_test3 =
  filter_reachable (Expr, List.tl (List.tl awksub_rules)) =
    (Expr,
     [Expr, [N Expr; N Binop; N Expr];
      Expr, [N Lvalue];
      Expr, [N Incrop; N Lvalue];
      Expr, [N Lvalue; N Incrop];
      Lvalue, [T "$"; N Expr];
      Incrop, [T "++"];
      Incrop, [T "--"];
      Binop, [T "+"];
      Binop, [T "-"]])

let awksub_test4 =
  filter_reachable (Expr, List.tl (List.tl (List.tl awksub_rules))) =
    (Expr,
     [Expr, [N Lvalue];
      Expr, [N Incrop; N Lvalue];
      Expr, [N Lvalue; N Incrop];
      Lvalue, [T "$"; N Expr];
      Incrop, [T "++"];
      Incrop, [T "--"]])

type giant_nonterminals =
  | Conversation | Sentence | Grunt | Snore | Shout | Quiet

let giant_grammar =
  Conversation,
  [Snore, [T"ZZZ"];
   Quiet, [];
   Grunt, [T"khrgh"];
   Shout, [T"aooogah!"];
   Sentence, [N Quiet];
   Sentence, [N Grunt];
   Sentence, [N Shout];
   Conversation, [N Snore];
   Conversation, [N Sentence; T","; N Conversation]]

let giant_test0 =
  filter_reachable giant_grammar = giant_grammar

let giant_test1 =
  filter_reachable (Sentence, List.tl (snd giant_grammar)) =
    (Sentence,
     [Quiet, []; Grunt, [T "khrgh"]; Shout, [T "aooogah!"];
      Sentence, [N Quiet]; Sentence, [N Grunt]; Sentence, [N Shout]])

let giant_test2 =
  filter_reachable (Quiet, snd giant_grammar) = (Quiet, [Quiet, []])
