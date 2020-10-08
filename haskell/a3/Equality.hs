module Equality where

data Shape = Rock | Paper | Scissors deriving (Show,Eq)

-- Here's a function to check whether a list of Shapes contains Rock.
containsRock :: [Shape] -> Bool
containsRock l = case l of
                 [] -> False
                 (s:rest) -> case s of
                             Rock -> True
                             Paper -> containsRock rest
                             Scissors -> containsRock rest

-- We've seen functions with ``completely flexible'' types like these:
--      map :: (a -> b) -> [a] -> [b]
--      contains :: (a -> Bool) -> [a] -> Bool

-- It might seem at first that we would be able to write a more general 
-- ``is this thing in this list?'' function with a similarly flexible 
-- type too. But we end up stuck because we don't know how to ``look at'' the elements.
{-
isElement :: a -> [a] -> Bool
isElement x l = case l of
                [] -> False
                (y:rest) -> case (...???...) of
                            True -> True
                            False -> isElement x rest
-}

-- To fix this we can get the caller to provide an equality-checking function.
{-
isElement :: (a -> a -> Bool) -> a -> [a] -> Bool
isElement equals x l = case l of
                       [] -> False
                       (y:rest) -> case (equals x y) of
                                   True -> True
                                   False -> isElement equals x rest
-}

-- Haskell's notion of a type class provides a way to streamline this solution: 
-- a type is a member of the class `Eq' iff it carries around an appropriate 
-- equality-checking function with it. If x and y are of such a type, then you 
-- can write `x == y' to compare them using the equality-checking function that 
-- they are carrying around. 
-- Because the internals of this function rely on doing `x == y', it doesn't 
-- work for *absolutely any* type, only those types that belong to the class 
-- Eq. That's what the extra part of the type signature is saying.
isElement :: (Eq a) => (a -> [a] -> Bool)
isElement x l = case l of
                [] -> False
                (y:rest) -> case (x == y) of
                            True -> True
                            False -> isElement x rest

