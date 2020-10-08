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

--FLOAT is max x y
--DOUBLE is x + y

distrib_rhs :: (Semiring v) => v -> v -> v -> v
distrib_rhs x y z = (x &&& y) ||| (x &&& z)



dotprod :: (Semiring v) => [v] -> [v] -> v
dotprod v1 v2 = case v1 of
                [] -> gfalse
                x1 : rest1 -> case v2 of
                            [] -> gfalse
                            x2 : rest2 -> (x1 &&& x2) ||| (dotprod rest1 rest2)