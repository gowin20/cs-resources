{-# OPTIONS_GHC -fwarn-incomplete-patterns #-}
{-# OPTIONS_GHC -fwarn-incomplete-uni-patterns #-}
{-# LANGUAGE FlexibleInstances #-}

module Assignment06 where

import Control.Applicative(liftA, liftA2, liftA3)

import SemiringCFG

data Tree nt t = Leaf nt t | NonLeaf nt (Tree nt t) (Tree nt t) deriving Show

tree1 :: Tree Cat String
tree1 = NonLeaf VP (NonLeaf VP (Leaf V "watches") (Leaf NP "spies"))
                   (NonLeaf PP (Leaf P "with") (Leaf NP "telescopes"))

tree2 :: Tree Cat String
tree2 = NonLeaf VP (Leaf V "watches")
                   (NonLeaf NP (Leaf NP "spies") (NonLeaf PP (Leaf P "with") (Leaf NP "telescopes")))

probToBool :: GenericCFG nt t Double -> GenericCFG nt t Bool
probToBool (nts, ts, i, r) =
    let newi = \nt -> (i nt > 0) in
    let newr = \rule -> (r rule > 0) in
    (nts, ts, newi, newr)

------------------------------------------------------------------
------------------------------------------------------------------
-- IMPORTANT: Please do not change anything above here.
--            Write all your code below this line.

--NTRule nt (nt,nt)
--TRule nt t



----------------------------
-- Part 1

treeToDeriv :: Tree nt t -> [RewriteRule nt t]

treeToDeriv tr = case tr of
                Leaf nt l -> [TRule nt l]
                NonLeaf nt tr1 tr2 -> let getNonTerminal tr = case tr of {Leaf nt l -> nt; NonLeaf nt tr1 tr2 -> nt} in
                                    [(NTRule nt (getNonTerminal tr1,getNonTerminal tr2))] ++ treeToDeriv tr1 ++ treeToDeriv tr2








-----------------------------
-- Part 2: Semirings & CFGs


f :: (Ord nt, Ord t, Semiring a) => GenericCFG nt t a -> [t] -> a

f m s = let (nts,ts,i,r) = m in
                gen_or( map (\n -> i n &&& fastInside m s n) nts)



-- define a semiring type for Int, such that a possible structure is 1 and an impossible one is 0

instance Semiring Int where
    x &&& y = x * y -- WHY is it x * y here? I don't understand, but it works lol
    x ||| y = x + y
    gtrue = 1
    gfalse = 0

    --case (x > 0 && y > 0) of {True -> 1; False -> 0}
boolToCount :: GenericCFG nt t Bool -> GenericCFG nt t Int

boolToCount (nts, ts, i, r) = let boolToInt b = case b of {True -> 1; False -> 0} in
                              let newi = \nt -> (boolToInt (i nt)) in
                              let newr = \rule -> (boolToInt (r rule)) in
                              (nts, ts, newi, newr)




instance Semiring [Double] where
    x &&& y = liftA2 (\x1 -> \y1 -> x1*y1) x y
    x ||| y = x ++ y
    gtrue = [1.0]
    gfalse = []

probToProbList :: GenericCFG nt t Double -> GenericCFG nt t [Double]
probToProbList (nts, ts, i, r) = let probToList d = case d of {0 -> []; x -> [x]} in
                                 let newi = \nt -> (probToList (i nt)) in 
                                 let newr = \rule -> (probToList (r rule)) in
                                 (nts, ts, newi, newr)



instance Semiring [[RewriteRule nt t]] where
    x &&& y = liftA2 (\x1 -> \y1 -> x1 ++ y1) x y
    x ||| y = x ++ y
    gtrue = [[]]
    gfalse = []


boolToDerivList :: GenericCFG nt t Bool -> GenericCFG nt t [[RewriteRule nt t]]
boolToDerivList (nts, ts, i, r) = let newi = \nt -> case (i nt) of { True -> gtrue; False -> gfalse } in
                                  let newr = \rule -> case (r rule) of {True -> [[rule]]; False -> gfalse} in
                                  (nts, ts, newi, newr)


--andLists :: (Double, [RewriteRule nt t]) -> (Double, [RewriteRule nt t]) -> (Double, [RewriteRule nt t])
--andLists (d,r) (d2,r2) = (d*d2, (r ++ r2))


instance Semiring [(Double, [RewriteRule nt t])] where
    x &&& y = let andLists (d,r) (d2,r2) = (d*d2, (r ++ r2)) in
                  liftA2 (\x1 -> \y1 -> andLists x1 y1) x y
    x ||| y = x ++ y
    gtrue = [(1.0, [])]
    gfalse = []


probToProbDerivList :: GenericCFG nt t Double -> GenericCFG nt t [(Double, [RewriteRule nt t])]

probToProbDerivList (nts, ts, i, r) = let newi = \nt -> case (i nt) of { 0.0 -> gfalse; x -> gtrue } in
                                      let newr = \rule -> case (r rule) of { 0.0 -> gfalse; x -> [(x, [rule])]} in
                                      (nts, ts, newi, newr)



{-
combLists :: [Double] -> [RewriteRule nt t] -> [(Double, [RewriteRule nt t])]
combLists d r = case d of
                    [] -> []
                    x : rest -> case r of
                          [] -> []
                          y : rest2 -> (x,) ++

-}
