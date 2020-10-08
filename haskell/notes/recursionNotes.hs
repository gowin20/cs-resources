
-- comments in haskell are two hyphens - the compiler ignores this completely

{-
aaaa
 multiline comments can continue for many lines
aaa
-}

-- data Bool = False | True deriving Show

-- not = \b -> case b of {True->False; False->True}

--functional completeness


module Recursion where

data Form = T | F | Neg Form | Cnj Form Form | Dsj Form Form deriving Show

f1 = Dsj (Neg T) (Cnj F T)
f2 = Dsj (Neg T) (Cnj T T)

-- function removing all negatives from a program, recursively :)
removeNegs = \form -> case form of
 T->T
 F->F
 Neg phi-> removeNegs phi
 Cnj phi psi-> Cnj (removeNegs phi) (removeNegs psi)
 Dsj phi psi-> Dsj (removeNegs phi) (removeNegs psi)



-- function that evaluates the truthfulness of these expressions. Associates boolean values with our system
denotation = \form -> case form of
    T -> True
    F-> False
    Neg phi-> case (denotation phi) of {True-> False; False-> True}
    Cnj phi psi -> case (denotation phi) of True -> denotation psi; False-> False
    Dsj phi psi -> case (denotation phi) of True-> True; False -> denotation psi

-- If statements are a specific type of case statement
-- they're really just a case split on a boolean



-- Apparently Haskell Just Highlights words that are Capitalized. This actually makes sense and is pretty easy to implement

------------------------------------------------

-- Let's get all the natural numbers

data Numb = Z | S Numb deriving Show

zero = Z
one = S Z
two = S one
three = S two


lessThanTwo :: Numb->Bool
lessThanTwo = \n -> case n of
    Z -> True
    S n' -> case n' of {Z-> True; S n'' -> False}


isOne :: Numb->Bool
isOne = \n -> case n of
    Z-> False
    S n' -> case n' of {Z-> True; S n'' -> False}




-- assume the recursive call works okay


double :: Numb->Numb
double = \n -> case n of 
    Z->Z
    S n' -> S (S (double n'))

dbl :: Int->Int

dbl = \n -> case (n==0) of
    True -> 0;
    False -> 2 + dbl (n-1)


isOdd::Numb->Bool
isOdd = \n -> case n of
    Z -> False
    S n' -> not (isOdd n')

add :: Numb -> (Numb -> Numb)
add = \n -> (\m -> case n of
                   Z -> m
                   S n' -> (add n') (S m) )-- S (add n') m





------------------------------------------------

data IntList = Empty | NonEmpty Int IntList deriving Show

total:: IntList -> Int

total = \l -> case l of
        Empty->0
        NonEmpty x rest -> x + total rest

-- Haskell has builtin syntax for using lists
--5 : (7 : (2 : []))    --lists are structured like this. The other format is really just syntactic sugar
--     == [5,7,2]

total2 :: [Int] -> Int

total2 = \l -> case l of
        [] -> 0
        x : rest -> x + total2 rest




--contains :: (Numb->Bool) -> [Numb] -> Bool

contains :: (a->Bool) -> [a] -> Bool
--polymorphism! a can be of any type


-- f is a function from int to bool : for example, isOdd
-- l evaluates to x, and x is a number -- really, a list of numbers
--      these two inputs evaluate to a bool


contains = \f -> \l -> case l of
            [] -> False
            x : rest -> case (f x) of
                        True -> True
                        False -> contains f rest
