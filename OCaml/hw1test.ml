
(* sets used for testing 1-5 *)
let setA = [1;1;1;1;];;
let setB = [1;2;3;4;5;6;7;8;9;10;];;

let setB2 = [1;2;3;4;5;6;7;8;9;10;]

let strSetA = ["a";"b";"c";"d";];;
let strSetB = ["A";"a";"B";"b";"C";"c";"D";"d";];;


(* testing 1. *)

let my_subset_test0 = subset setA setB

let my_subset_test1 = subset strSetA strSetB


(* testing 2. *)

let my_equal_sets_test0 = equal_sets setA setA

let my_equal_sets_test1 = not (equal_sets setA setB)


(* testing 3. *)

let my_set_union_test0 = equal_sets (set_union strSetA strSetB) ["a";"b";"c";"d";"A";"a";"B";"b";"C";"c";"D";"d";]

let my_set_union_test1 = equal_sets (set_union setA [2;3;4;5]) [1;2;3;4;5]

(* testing 4. *)

let my_set_intersection_test0 = equal_sets (set_intersection setA setB) [1;]

let my_set_intersection_test1 = equal_sets (set_intersection setB setB) setB


(* testing 5. *)

let my_set_diff_test0 = equal_sets (set_difference setB setA) [2;3;4;5;6;7;8;9;10]

let my_set_diff_test1 = equal_sets (set_difference setA setB) []


(* testing 6. *)

let my_computed_fixed_point_test0 = (computed_fixed_point (=) (fun x -> x /. 2.) 1.) = 0.

let my_computed_fixed_point_test1 = (computed_fixed_point (=) (fun x -> x *. 10.) 1.) = infinity


(* testing 7. *)

type professor_nonterminals =
 | Class | Lecture | Discussion | Homework | OfficeHour | Exam

let academic_guidelines = 
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

let professor_grammar = Class, academic_guidelines

let my_filter_reachable_test0 =
  filter_reachable professor_grammar = professor_grammar

let my_filter_reachable_test1 =
  filter_reachable (OfficeHour, academic_guidelines) = (OfficeHour, [OfficeHour, [T"Nobody goes to Office Hours"]])

let my_filter_reachable_test2 =
  filter_reachable (Discussion, academic_guidelines) = (Discussion, [Discussion, [N Homework; T"That makes no sense!"];
                                              Discussion, [T"I am confused";T"I'm going to get a 0"];
                                              Homework, [T"This takes forever"; N Homework];
                                              Homework, [T"Finally Finished! That was actually fun"];])