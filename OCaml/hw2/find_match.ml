open List

type ('nonterminal, 'terminal) symbol =
| N of 'nonterminal
| T of 'terminal

let get x = (let (Some x_value) = x in x_value);;

let rec filter_some lst =
  match lst with
  | [] -> []
  | item::rest -> match item with
                  | None -> filter_some rest
                  | Some _ -> item::(filter_some rest)

let rec try_all_matches prod_fun some_matches rest_rule k = 
    (match some_matches with
    | [] -> None
    | some_suff::rest_suffs -> let suff = get some_suff in
                               let match_works = find_match prod_fun suff rest_rule k in
                               (match match_works with
                               | None -> try_all_matches prod_fun rest_suffs rest_rule k
                               | Some suff -> Some suff))
(* finds a match in the grammar for a fragment, and returns the remaining part as Some suffix *)
and find_match prod_fun frag rule k =
  if k > 10 then None
  else match rule with
  | [] -> Some frag (* when the rule finishes, call acceptor on the remaining fragment *)
  | rule_sym::rest_rule_syms -> match rule_sym with
                              | T t_sym -> (match frag with
                                           | [] -> None (* not a match *)
                                           | f_sym::rest_f_sym -> if (t_sym = f_sym) then (find_match (prod_fun) (rest_f_sym) (rest_rule_syms) (k)) (* recursive call on the rest of the prefix after finding a match *)
                                                                  else None)
                              | N nt_sym -> let alt_rules = prod_fun nt_sym in
                              let all_alt_results = map (fun rl -> find_match prod_fun frag rl (k+1)) alt_rules in
                              let some_results = filter_some all_alt_results in
                              try_all_matches prod_fun some_results rest_rule_syms k;;




type awksub_nonterminals =
  | Expr | Term | Lvalue | Incrop | Binop | Num

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

type normie_nonterminals =
    | Convo | Talk | Date | With | Name

let normie_grammar = (Convo,
    function
        | Convo -> [[N Convo;N Talk];
                    [N Talk; N Convo; N Date];
                    [N Talk;]]
        | Talk -> [[T"talk"; N With; N Name];
                    [N With;N Name];
                    [T"talk"]]
        | Date -> [[T"pizza";];[T"hook"];[T"zoo"]]
        | With -> [[T"with"];[T"without"]]
        | Name -> [[T"Sarah"];[T"George"];[T"who?"];[T"Jeremy"];[T"Mike"]]
)

let normie_prodfun = snd normie_grammar

let match_01 = find_match normie_prodfun ["talk";"talk";"with";"Sarah"] [N Convo] 0

let match_02 = find_match normie_prodfun ["talk";"with";"Sarah"] [N Convo] 0

let match_03 = find_match normie_prodfun ["talk";"with";"Sarah";"pizza"] [N Convo] 0

let match_04 = find_match normie_prodfun ["talk";"without";"George";"zoo"] [N Convo] 0

let match_05 = find_match normie_prodfun ["talk"] [N Convo] 0

let match_06 = find_match normie_prodfun ["without";"who?"] [N Convo] 0

let awkish_prodfun = snd awkish_grammar

let find_match_test01 = find_match awkish_prodfun ["(";"++";"$";"8";")";] [N Expr] 0


let lv= find_match awkish_prodfun ["8"] [N Expr] 0

let lv0 = find_match awkish_prodfun ["++";"$";"8"] [N Expr] 0

let lv1 = find_match awkish_prodfun ["$";"8";"++"] [N Expr] 0


let find_match_test1 = find_match awkish_prodfun ["8";"+";"$";"1";"+"] [N Expr] 0


let find_match_test0 = find_match awkish_prodfun ["(";"$"; "8"; "++";")"] [N Expr] 0

let find_match_tesst2 = find_match awkish_prodfun ["(";"8";"+";"$";"3";"++";")"] [N Expr] 0


let debug0 = find_match awkish_prodfun ["(";"$";"8";"++";")"] [N Expr] 0

