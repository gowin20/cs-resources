{-# LANGUAGE FlexibleInstances #-}

module Assignment05 where

import Control.Applicative(liftA, liftA2, liftA3)

import SemiringFSA

data Numb = Z | S Numb deriving Show

distrib_lhs :: (Semiring v) => v -> v -> v -> v
distrib_lhs x y z = x &&& (y ||| z)

------------------------------------------------------------------
------------------------------------------------------------------
-- IMPORTANT: Please do not change anything above here.
--            Write all your code below this line.

-- both AND is x * y
--FLOAT OR is max x y
--DOUBLE OR is x + y


----------------------------------
-- PART 1



distrib_rhs :: (Semiring v) => v -> v -> v -> v
distrib_rhs x y z = (x &&& y) ||| (x &&& z)



dotprod :: (Semiring v) => [v] -> [v] -> v
dotprod v1 v2 = case v1 of
                [] -> gfalse
                x1 : rest1 -> case v2 of
                            [] -> gfalse
                            x2 : rest2 -> (x1 &&& x2) ||| (dotprod rest1 rest2)


expn :: (Semiring v) => v -> Numb -> v
expn v num = case num of
                Z -> gtrue
                S num' -> v &&& (expn v num')



---------------------------------
-- PART 2


backward :: (Semiring v) => GenericAutomaton st sy v -> [sy] -> st -> v

backward m w q = 
    let (states, syms, i, f, delta) = m in
    case w of
        [] -> f q
        (x:rest) -> gen_or (map (\q1 ->(delta (q,x,q1) &&& (backward m rest q1))) states)


{-
    I initially forgot that we changed generic automatons to use functions instead of lists, so I wrote these case statements to translate bool to generic

    [] -> case (elem q f) of
        True -> gtrue
        False -> gfalse
    x: rest -> [...] (case (elem (q,x,q1) delta) of { True -> gtrue; False -> gfalse }) [...]
-}

f :: (Semiring v) => GenericAutomaton st sy v -> [sy] -> v
f m w =
    let (states, syms, i, f, delta) = m in
        gen_or (map (\q-> i q &&& backward m w q) states)

--semirings are cool!


-----------------------------
-- PART 3


{-

COST stuff:

Inf | TheInt Int

Values : N union inf (done already)
&&& : +
gtrue : 0
gfalse : Inf
||| : min


-}

addCost :: Cost -> Cost -> Cost
addCost c1 c2 =
    case c1 of
        Inf -> Inf
        TheInt x -> case c2 of
                    Inf -> Inf
                    TheInt y -> TheInt (x+y)


minCost :: Cost -> Cost -> Cost
minCost c1 c2 =
    case c1 of
        Inf -> c2
        TheInt x -> case c2 of
                    Inf -> c1
                    TheInt y -> TheInt (min x y)


instance Semiring Cost where
    x &&& y = addCost x y
    x ||| y = minCost x y
    gtrue = TheInt 0
    gfalse = Inf


-----------------------------------------
-- PART 4


sadd :: [String] -> [String] -> [String]
sadd s1 s2 = liftA2 (\x -> \y -> x ++ y) s1 s2

instance Semiring [String] where
    x &&& y = sadd x y
    x ||| y = x ++ y
    gtrue = [""]
    gfalse = []


gfsa13 :: GenericAutomaton Int Char [String]
gfsa13 = makeGFSA [] ([1,2,3], 
                    ['C','V'], 
                    [(1, [""])],
                    [(1, [""])],
                    [((1,'C',2), ["C"]),
                    ((1,'V',1), ["V"]),
                    ((1,'V',3), ["V"]),
                    ((2,'V',1), ["VV"]),
                    ((2,'V',3), ["VV"]),
                    ((3,'C',1), [""])
                    ])


gfsa_flap :: GenericAutomaton Int Char [String]

gfsa_flap = makeGFSA [] ([0,1,2],
                         ['a','n','t','T'],
                         [(0, [""])],
                         [(0, [""]),(1, [""]),(2, ["t"])],
                         [((0,'n',0),["n"]),
                        ((0,'t',0),["t"]),
                        ((0,'a',1),["a"]),
                        ((1,'a',1),["a"]),
                        ((1,'t',2),[""]),
                        ((1,'n',0),["n"]),
                        ((2,'a',1),["ta","Ta"]),
                        ((2,'n',0),["tn"]),
                        ((2,'t',0),["tt"])
                         ])