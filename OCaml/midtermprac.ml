
('a -> 'a -> bool) -> int List.t -> int List.t -> int List.t = <fun>

let merge_sorted lt lst1 lst2 =
    match lst1 with
    | [] -> lst2
    | i1::rest1 -> match lst2 with
                   | [] -> lst1
                   | i2::rest2 -> if (lt) i1 i2 then i1::merge_sorted lt rest1 lst2
                                  else i2::merge_sorted lt lst1 rest2


