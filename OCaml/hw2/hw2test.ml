
(* testing the functions of hw2.ml *)

type ('nonterminal, 'terminal) symbol =
| N of 'nonterminal
| T of 'terminal


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

let awkish_grammar =
  (Expr,
   function
     | Expr ->
         [[N Term; N Binop; N Expr];
          [N Term]]
     | Term ->
	 [[N Num];
	  [N Lvalue];
	  [N Incrop; N Lvalue];
	  [N Lvalue; N Incrop];
	  [T"("; N Expr; T")"]]
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
(*
let sample_hw2rulelist = [(N "a",["yes"]);(N "b",["nice"]);(N "c",["test"])]

let sample_prodfun = make_prodfun sample_hw2rulelist

let sample_ruleset = sample_prodfun (T "g")

let expr_rules = all_rules_with_sym Expr awksub_rules

let hw2rules = grouped_rule_list awksub_rules
*)