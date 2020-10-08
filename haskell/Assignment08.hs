{-# OPTIONS_GHC -fwarn-incomplete-patterns #-}
{-# OPTIONS_GHC -fwarn-incomplete-uni-patterns #-}

module Assignment08 where

import Control.Applicative(liftA, liftA2, liftA3)

import TreeGrammars

plainWords = ["John","Mary","ate","bought","an","apple","books","yesterday","C","laughed","because"]
whWords = ["who","what","why"]
qWords = ["Q"]

-- (1a)/(2a) `C John ate an apple'
tree_1a :: Tree String
tree_1a =
    Node "*" [
        Node "C" [], 
        Node "*" [
            Node "John" [],
            Node "*" [
                Node "ate" [],
                Node "*" [Node "an" [], Node "apple" []]
            ]
        ]
    ]

-- (1b)/(2b) `Q John ate what'
tree_1b :: Tree String
tree_1b =
    Node "*" [
        Node "Q" [], 
        Node "*" [
            Node "John" [],
            Node "*" [
                Node "ate" [],
                Node "what" []
            ]
        ]
    ]

-- (3a) `Q John ate an apple'
tree_3a :: Tree String
tree_3a =
    Node "*" [
        Node "Q" [], 
        Node "*" [
            Node "John" [],
            Node "*" [
                Node "ate" [],
                Node "*" [Node "an" [], Node "apple" []]
            ]
        ]
    ]

-- (3b) `C John ate what'
tree_3b :: Tree String
tree_3b =
    Node "*" [
        Node "C" [], 
        Node "*" [
            Node "John" [],
            Node "*" [
                Node "ate" [],
                Node "what" []
            ]
        ]
    ]

tree_13 :: Tree String
tree_13 =
    Node "*" [
        Node "Q" [],
        Node "*" [
            Node "John" [],
            Node "*" [
                Node "laughed" [],
                Node "**" [
                    Node "because" [],
                    Node "*" [
                        Node "Mary" [],
                        Node "*" [
                            Node "*" [Node "bought" [], Node "books" []],
                            Node "why" []
                        ]
                    ]
                ]
            ]
        ]
    ]

------------------------------------------------------------------
------------------------------------------------------------------
-- IMPORTANT: Please do not change anything above here.
--            Write all your code below this line.


count :: (Eq a) => a -> Tree a -> Int
count x (Node y ts) = case (x == y) of
                        True -> 1 + sum(map(count x) ts)
                        False -> sum(map(count x) ts)

leftEdge :: Tree a -> [a]
leftEdge (Node y ts) = case ts of
                        [] -> y : []
                        (x:rest) -> y : leftEdge x


--this was difficult
allLists :: Int -> [a] -> [[a]]
allLists n l = case n of
                0 -> [[]]
                1 -> map(\y -> [y]) l
                n' -> liftA2 (\p1 -> \p2 -> [p1] ++ p2) l (allLists(n'-1) l)

--this was way more difficult.
under :: (Eq st, Eq sy) => Automaton st sy -> Tree sy -> st -> Bool
under m tree q = let (states, syms, f, delta) = m in
                 let Node x ts = tree in
                 let func qs = (elem (qs,x,q) delta) && and(zipWith (\tr -> \q1 -> under m tr q1) ts qs) in
                 let qList = allLists (length ts) states in
                 or (map func qList)

--this was easy though
generates :: (Eq st, Eq sy) => Automaton st sy -> Tree sy -> Bool
generates m tree = let (states, syms, f, delta) = m in
                    or (map (\q -> elem q f && under m tree q)states)

waluigi = "wah"




--------------------------------
--WH- AUTOMATA
--------------------------------

--plainWords = ["John","Mary","ate","bought","an","apple","books","yesterday","C","laughed","because"]
--whWords = ["who","what","why"]
--qWords = ["Q"]

data QStatus = WH | LicWH | OK | Invalid deriving (Show, Eq)
-- the invalid state exists to deal with this tree: (Node "*" [Node "Q" [], Node "*" [Node "Q" [], Node "John" []]])
-- simply using the "wh" state as an invalid indicator does not work because of this.
-- however, this means it gets way grosser b/c you have to add 7 new state transitions for robustness
fsta_wh1 :: Automaton QStatus String
fsta_wh1 = ([WH, LicWH, OK, Invalid], 
            ["*"] ++ plainWords ++ whWords ++ qWords,
            [OK,LicWH],--finals
            [([WH,WH], "*", WH),
             ([WH,OK], "*", WH),
             --([WH,LicWH], "*", WH), not sure if this one is needed or correct
             ([OK,WH], "*", WH),
             ([OK,LicWH], "*", OK),
             ([OK,OK], "*", OK),
             ([LicWH,WH], "*", OK),
             ([LicWH,OK], "*", Invalid),
             ([OK,Invalid],"*", Invalid),
             ([WH,Invalid],"*", Invalid),
             ([LicWH,Invalid],"*", Invalid),
             ([Invalid,OK],"*", Invalid),
             ([Invalid,WH],"*", Invalid),
             ([Invalid,LicWH],"*", Invalid),
             ([Invalid,Invalid],"*", Invalid),
             ([LicWH,LicWH], "*", OK)
            ] --deltas
            ++ map (\s -> ([], s, OK)) plainWords
            ++ map (\s -> ([], s, LicWH)) qWords
            ++ map (\s -> ([], s, WH)) whWords
            )


--gross code, but I'm not going to risk leaving out any transitions, even those which don't make sense
fsta_wh2 :: Automaton QStatus String
fsta_wh2 = ([WH, LicWH, OK, Invalid], 
            ["*"] ++ plainWords ++ whWords ++ qWords,
            [OK,LicWH],--finals
            [([WH,WH], "*", WH),
            ([WH,OK], "*", WH),
            ([OK,WH], "*", WH),
            ([OK,LicWH], "*", OK),
            ([OK,OK], "*", OK),
            ([LicWH,WH], "*", OK),
            ([LicWH,OK], "*", Invalid),
            ([OK,Invalid],"*", Invalid),
            ([WH,Invalid],"*", Invalid),
            ([LicWH,Invalid],"*", Invalid),
            ([Invalid,OK],"*", Invalid),
            ([Invalid,WH],"*", Invalid),
            ([Invalid,LicWH],"*", Invalid),
            ([Invalid,Invalid],"*", Invalid),
            ([LicWH,LicWH], "*", OK),
            ([LicWH,WH], "**", OK), --valid adjunct with question
            ([OK,OK], "**", OK), -- valid adjunct without question
            ([LicWH,OK], "**", Invalid), --invalid adjunct w/ Q but no WH
            ([OK,WH], "**", Invalid), -- invalid adjunct w/ WH but no Q
            ([LicWH,LicWH], "**", OK),
            ([WH,WH], "**", Invalid), -- basically, WH can never travel outside of a "**" node
            ([WH,OK], "**", Invalid),
            ([OK,LicWH], "**", OK),
            ([OK,Invalid],"**", Invalid),
            ([WH,Invalid],"**", Invalid),
            ([LicWH,Invalid],"**", Invalid),
            ([Invalid,OK],"**", Invalid),
            ([Invalid,WH],"**", Invalid),
            ([Invalid,LicWH],"**", Invalid),
            ([Invalid,Invalid],"**", Invalid)
            ] --deltas
            ++ map (\s -> ([], s, OK)) plainWords
            ++ map (\s -> ([], s, LicWH)) qWords
            ++ map (\s -> ([], s, WH)) whWords
            )





{-
    case ts of
        Node y [] -> elem q f
        Node x ts -> or (liftA3( \tr -> \q1 -> \q2 -> (elem (q1,x,q) delta) && (under m tr q2)) ts (allLists 2 states) states)

    --liftA3 (\tr -> \q1 -> \qList -> (elem (qList, x, q) delta) && (under m tr q1)) ts states (allLists 2 states)
    --or (liftA3( \tr -> \q1 -> \q2 -> (elem (q1,x,q) delta) && (under m tr q2)) ts (allLists 2 states) states)


--allLists 1 ts
--or (map (\q1 -> ( && under m ts q1)) states)

backward m w q = 
    let (states, syms, i, f, delta) = m in
    case w of
        [] -> f q
        (x:rest) -> gen_or (map (\q1 ->(delta (q,x,q1) &&& (backward m rest q1))) states)

--(map(\y -> [x] ++ y) (allLists (n'-1) l))

--take n and combine it with every item in the list, 
--then combine that with every item in the list
--then combine that with every item in the list (do this n times)

case l of
                [] -> [[]]
                x : rest -> case n of 
                            0 -> [[]]
                            n' -> (map(\y -> [x] ++ allLists (n'-1) y) l) ++ (allLists n' rest)


combineElements :: Int -> [a] -> [a]
combineElements n h l = case l of
                        [] -> []
                        x : [] -> []
                        x : y : rest -> case n of
                                      0 -> []
                                      n' -> [x] ++ combineElements


--[[x]] ++ (allLists (n'-1) l)

--allLists n l = liftA3 (\x -> \y -> \z -> [x] ++ [y] ++ [z]) l l l

--allLists e l = liftA2 (\x -> \y -> [x] ++ [y]) l l

-}