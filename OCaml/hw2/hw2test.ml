
type professor_nonterminals =
 | Class | Topic | Discussion | Homework | OfficeHour | Exam


(* rules listed in hw1 style for convenient reading *)

let hw1_academic_rules = 
  [Class, [N Lecture; N Discussion;N Class];
  Class, [N Exam];
  Class, [N OfficeHour];
  Lecture, [N Topic; N Homework];
  Lecture, [N Topic];
  Lecture, [N Homework];
  Discussion, [N Topic; N Homework;];
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
let academic_rules = convert_grammar (Class,hw1_academic_rules)




let academic_parsetree = Node (Class, [
  Node (Lecture, []);


])