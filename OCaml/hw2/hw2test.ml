
type professor_nonterminals =
 | Class | Lecture | Discussion | Topic | Homework | OfficeHour | Exam

(* original acceptor that I based my derivational acceptor off of *)
let accept_empty_suffix = function
   | _::_ -> None
   | x -> Some x

(* rules listed in hw1 style for convenient reading *)

(* this grammar models the structure of a class at UCLA. this class has one discussion for every lecture *)
let hw1_academic_rules = 
  [Class, [N Lecture; N Discussion;N Class];
  Class, [N Exam];
  Class, [N OfficeHour];
  Lecture, [N Topic; N Homework];
  Lecture, [N Topic];
  Discussion, [N Homework;];
  Discussion, [N Topic; T"I am confused"];
  Topic, [T"OCaml"];
  Topic, [T"Java"];
  Topic, [T"Prolog"];
  Topic, [T"Scheme"];
  Topic, [T"Python"];
  Topic, [T"Dart"];
  Homework, [T"This takes forever"; N Homework];
  Homework, [T"Finally Finished!"];
  OfficeHour, [T"Nobody goes to Office Hours"];
  Exam, [T"Final"];
  Exam, [T"Midterm"]]

(* hw2 style grammar *)
let academic_gram = convert_grammar (Class,hw1_academic_rules)

(* ------- Testing make_matcher ------- *)

(* this fragment is pretty long, but it's totally valid *)
let academic_matcher_frag = ["OCaml";"Finally Finished!";"OCaml";"This takes forever";"Finally Finished!";
"This takes forever";"This takes forever";"This takes forever";"Finally Finished!";"Java";"Prolog";"I am confused";"Final"]


let academic_valid_matcher = make_matcher academic_gram accept_empty_suffix

let make_matcher_test = (academic_valid_matcher academic_matcher_frag) = (Some [])

(* here's the tree if you were wondering... *)
let match_tree = make_parser academic_gram academic_matcher_frag

(* ------- Testing make_parser ------- *)

(* the correct parse tree for the frag *)
let academic_parsetree = Some (Node (Class, [
  Node (Lecture, [Node (Topic, [Leaf"Java"])]);
  Node (Discussion, 
    [Node (Homework, 
      [ Leaf"This takes forever";
        Node (Homework, 
        [ Leaf"This takes forever";
          Node (Homework, 
          [ Leaf"This takes forever";
            Node (Homework, [Leaf"Finally Finished!"])])])])]);
  Node (Class, [
    Node (Lecture, [
      Node (Topic, [Leaf"OCaml"]);
      Node (Homework, [Leaf"Finally Finished!"])]);
    Node (Discussion, [
      Node (Topic, [Leaf"OCaml"]);
      Leaf"I am confused"]);
    Node (Class, [
      Node (Exam, [Leaf "Midterm"])])])]))

(* the actual frag *)
let academic_frag = ["Java";"This takes forever";"This takes forever";"This takes forever";"Finally Finished!";
                    "OCaml";"Finally Finished!";"OCaml";"I am confused";"Midterm"]

(* parser for the academic grammar. could also inline this in the make_parser_test, it doesn't matter *)
let academic_parser = make_parser academic_gram

(* my parser test case *)
let make_parser_test = let (Some parsed_tree) = academic_parser academic_frag in
                       ((Some parsed_tree) = academic_parsetree) && (parse_tree_leaves parsed_tree = academic_frag)