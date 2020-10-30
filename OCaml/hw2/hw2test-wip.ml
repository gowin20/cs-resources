(* testing the functions of hw2.ml *)



type professor_nonterminals =
 | Class | Lecture | Discussion | Homework | OfficeHour | Exam


type awksub_nonterminals =
  | Expr | Term | Lvalue | Incrop | Binop | Num

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
    Num, [T"0";];
    Num, [T"1"];
    Num, [T"2"];
    Num, [T"3"];
    Num, [T"4"];
    Num, [T"5"];
    Num, [T"6"];
    Num, [T"7"];
    Num, [T"8"];
    Num, [T"9"]]

let awksub_grammar1 = Expr, awksub_rules


type awksub_nonterminals =
  | Expr | Term | Lvalue | Incrop | Binop | Num

let awkish_grammar =
  (Expr,
   function
     | Expr ->
         [[N Term; N Binop; N Expr]; (* 1 + 8 *)
          [N Term]]
     | Term ->
      [[N Num];
        [N Lvalue]; (* $ 8 *)
        [N Incrop; N Lvalue]; (* ++ $ 8 *)
        [N Lvalue; N Incrop]; (* ( $ 8 ++ ) *)
        [T"("; N Expr; T")"]] (* $ 8 ++ ) *)
     | Lvalue ->
	 [[T"$"; N Expr]]
     | Incrop ->
	 [[T"++"];
	  [T"--"]]
     | Binop ->
	 [[T"+"];
	  [T"-"]]
     | Num ->
	 [[T"0"]; [T"1"]; [T"2"]; [T"3"]; [T"4"];
	  [T"5"]; [T"6"]; [T"7"]; [T"8"]; [T"9"]])

let awk_parse = snd awkish_grammar


let test_gram = convert_grammar awksub_grammar1
let parse_fun = snd test_gram


let hw1_academic_guidelines = 
  [Class, [N Lecture; N Discussion;];
  Class, [N Homework; N OfficeHour];
  Lecture, [T"New topic: Functional Programming"; N Homework];
  Lecture, [N Lecture; N Homework];
  Lecture, [N Exam];
  Discussion, [N Homework; T"That makes no sense!"];
  Discussion, [T"I am confused";T"I'm going to get a 0"];
  Homework, [T"This takes forever"; N Homework];
  Homework, [T"Finally Finished! That was actually fun"];
  OfficeHour, [T"Nobody goes to Office Hours"];
  Exam, [T"Final"];
  Exam, [T"Midterm"]]


let academic_grammar = convert_grammar (Class,hw1_academic_guidelines)
let academic_prodfun = snd academic_grammar
let discussion_topics = academic_prodfun Discussion

let ternary_awksub_tree = Node(Expr, [
                              Node (Term, [
                                   Node (Num, [Leaf "1"])
                                   ]);
                              Node (Binop, [Leaf "+"]);
                              Node (Expr,[
                                    Node (Term,[
                                          Node (Num,[Leaf "3"])
                                    ]);
                              Node (Binop, [Leaf "+"])
                              ])
                          ])



let nice_mike = parse_tree_leaves ternary_awksub_tree


let test5 =
  (parse_tree_leaves (Node ("+", [Leaf 3; Node ("*", [Leaf 4; Leaf 5])]))
   = [3; 4; 5])


let accept_all string = Some string



let awkish_prodfun = snd awkish_grammar;;

let awkish_expr = ["0";"+";"9";"aha!"]

let awkish_matcher = make_matcher awkish_grammar

let valid_expr = awkish_matcher accept_empty_suffix awkish_expr

type normie_nonterminals =
    | Convo | Talk | Date | With | Name

let normie_grammar = (Convo,
    function
        | Convo -> [[N Talk; N Convo; N Date];
                    [N Talk;]]
        | Talk -> [[T"talk"; N With; N Name];
                    [N With;N Name];
                    [T"talk"]]
        | Date -> [[T"pizza";];[T"hook"];[T"zoo"]]
        | With -> [[T"with"];[T"without"]]
        | Name -> [[T"Sarah"];[T"George"];[T"who?"];[T"Jeremy"];[T"Mike"]]
)
(*
let normie_prodfun = snd normie_grammar

let match_01 = find_match normie_prodfun ["talk";"talk";"with";"Sarah";"George"] [N Convo]

let match_02 = find_match normie_prodfun ["talk";"with";"Sarah"] [N Convo]

let match_03 = find_match normie_prodfun ["talk";"with";"Sarah";"pizza"] [N Convo]

let match_04 = find_match normie_prodfun ["talk";"without";"George";"zoo"] [N Convo]

let match_05 = find_match normie_prodfun ["talk"] [N Convo]

let match_06 = find_match normie_prodfun ["without";"who?"] [N Convo]
*)


let awkish_prodfun = snd awkish_grammar
(*
let find_match_test01 = find_match awkish_prodfun ["(";"++";"$";"8";")";] [N Expr]


let lv= find_match awkish_prodfun ["8"] [N Expr]

let lv0 = find_match awkish_prodfun ["++";"$";"8"] [N Expr]

let lv1 = find_match awkish_prodfun ["$";"8";"++"] [N Expr]
let find_match_test0 = find_match awkish_prodfun ["(";"$"; "8"; "++";")"] [N Expr]


let find_match_test1 = find_match awkish_prodfun ["8";"+";"$";"1";"+"] [N Expr]


let find_match_tesst2 = find_match awkish_prodfun ["(";"8";"+";"$";"3";"++";")"] [N Expr]


let debug0 = find_match awkish_prodfun ["(";"$";"8";"++";")"] [N Expr]
*)
let test0 =
  ((make_matcher awkish_grammar accept_all ["ouch"]) = None)

let test1 =
  ((make_matcher awkish_grammar accept_all ["9"])
   = Some [])

let test2 =
  ((make_matcher awkish_grammar accept_all ["9"; "+"; "$"; "1"; "+"])
   = Some ["+"])

let test3 =
  ((make_matcher awkish_grammar accept_empty_suffix ["9"; "+"; "$"; "1"; "+"])
   = None)


let test35 = ((make_matcher awkish_grammar accept_empty_suffix ["$"; "$"; "$"; "$"; "$"; "++"; "$"; "$"; "5"; "++";
      "++"; "--";]) = Some [])

(* This one might take a bit longer.... *)
let test4 =
 ((make_matcher awkish_grammar accept_all
     ["("; "$"; "8"; ")"; "-"; "$"; "++"; "$"; "--"; "$"; "9"; "+";
      "("; "$"; "++"; "$"; "2"; "+"; "("; "8"; ")"; "-"; "9"; ")";
      "-"; "("; "$"; "$"; "$"; "$"; "$"; "++"; "$"; "$"; "5"; "++";
      "++"; "--"; ")"; "-"; "++"; "$"; "$"; "("; "$"; "8"; "++"; ")";
      "++"; "+"; "0"])
  = Some [])


let test5 =
  (parse_tree_leaves (Node ("+", [Leaf 3; Node ("*", [Leaf 4; Leaf 5])]))
   = [3; 4; 5])

let small_awk_frag = ["$"; "1"; "++"; "-"; "2"]

let test6 =
  ((make_parser awkish_grammar small_awk_frag)
   = Some (Node (Expr,
		 [Node (Term,
			[Node (Lvalue,
			       [Leaf "$";
				Node (Expr,
				      [Node (Term,
					     [Node (Num,
						    [Leaf "1"])])])]);
			 Node (Incrop, [Leaf "++"])]);
		  Node (Binop,
			[Leaf "-"]);
		  Node (Expr,
			[Node (Term,
			       [Node (Num,
				      [Leaf "2"])])])])))
let test7 =
  match make_parser awkish_grammar small_awk_frag with
    | Some tree -> parse_tree_leaves tree = small_awk_frag
    | _ -> false


let awkish_parser = make_parser awkish_grammar



let tree0 = awkish_parser ["1"]


let tree0 = awkish_parser ["9";"+";"1"]


let tree0 = awkish_parser ["(";"9";"+";"1";")"]

let tree0 = awkish_parser ["(";"9";"+";"$";"1";")"]

let tree0 = awkish_parser ["$";"9";"++"]


(*
let sample_hw2rulelist = [(N "a",["yes"]);(N "b",["nice"]);(N "c",["test"])]

let sample_prodfun = make_prodfun sample_hw2rulelist

let sample_ruleset = sample_prodfun (T "g")

let expr_rules = all_rules_with_sym Expr awksub_rules

let hw2rules = grouped_rule_list awksub_rules
*)