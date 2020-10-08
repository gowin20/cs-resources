module Assignment02 where

-- Imports everything from the Recursion module. 
import Recursion

-- Imports just a few things that we have seen from the standard Prelude module. 
-- (If there is no explicit 'import Prelude' line, then the entire Prelude 
-- module is imported. I'm restricting things here so a very bare-bones system.)
import Prelude((+), (-), (*), (<), (>), (++), not, Bool(..), Char)

------------------------------------------------------------------
------------------------------------------------------------------
-- IMPORTANT: Please do not change anything above here.
--            Write all your code below this line.



mult :: Numb -> Numb -> Numb
mult = \n-> (\m -> case n of
            Z -> Z -- stop searching
            S n' -> (add m) (mult n' m) -- add 'm' to the running total, and call mult on n-1
            )
    -- 0 -> return out
    -- nonzero -> add num to running total, call mult on num-1


sumUpTo :: Numb -> Numb
sumUpTo = \n -> case n of
            Z -> Z -- stop here
            S n' -> (add n (sumUpTo n')) --add the number to the running total, and run recursively on that number minus one


equal :: Numb -> Numb -> Bool
equal = \n -> (\m-> case n of
              Z -> (case m of 
                    Z-> True --if both m and n are zero, then the numbers are equal
                    S m' -> False --if n reaches zero before m, they're not equal
                   )
              S n' -> (case m of 
                       Z -> False --if m reaches zero first, they're not equal
                       S m' -> (equal n' m') --if they're both nonzero, keep decrementing and checking
                      )
              )


count :: (a -> Bool) -> ([a] -> Numb)
count = \f -> \l -> (case l of
                [] -> Z -- base case
                x : rest -> (case (f x) of
                            True -> S (count f rest) -- increase count by one, and count the rest
                            False -> (count f rest) -- count stays the same, and count the rest
                            )
                )


listOf :: Numb -> a -> [a]
listOf = \n -> \t -> case n of
                Z -> [] -- end of the list
                S n' -> t : listOf n' t -- decrease 'n' by one and add another item to the list


addToEnd :: a -> [a] -> [a]
addToEnd = \t -> \l -> case l of 
                    [] -> t : [] --when you reach the end of the list, the final item is 't' (our desired item to add)
                    x : rest -> (x : addToEnd t rest) --iterate through the list, and construct a new identical list


remove :: (a -> Bool) -> [a] -> [a] --takes a list, removes items for which the function returns true
-- it actually builds a new list that does not contain the items we want to remove
remove = \f -> \l -> case l of
                    [] -> [] --end when we run out of list
                    x : rest -> (case (f x) of --test the boy - is x something we want on the list?
                                True -> (remove f rest) --keep building the list, but don't add x to it
                                False -> x : (remove f rest) --keep building the list with x on it
                                )


prefix :: Numb -> [a] -> [a]
prefix = \n -> \l -> case l of 
                     [] -> [] --if you reach the end of the list, return regardless of what n is
                     x : rest -> (case n of 
                                  Z -> [] -- if n is 0, return what you got
                                  S n' -> x : (prefix n' rest) -- otherwise, decrement n and build your list out of the rest of the list
                                 )


countStars :: RegExp -> Numb
countStars = \r -> case r of
                    Lit c -> Z --base case, stop searching here
                    Alt r1 r2 -> add (countStars r1) (countStars r2) --count the stars in each smaller regex and add em together
                    Concat r3 r4 -> add (countStars r3) (countStars r4) --count the stars in each smaller regex
                    Star r5 -> S (countStars r5) -- add one to the count, and count the stars in the smaller regex
                    ZeroRE -> Z --base case? not sure if this is necessary, there were no examples using them
                    OneRE -> Z --


depth :: RegExp -> Numb
depth = \r -> case r of --basically, add one to the count for every regex found
                Lit c -> S Z --when it reaches lit, zeroRE, or oneRE, it stop searching
                ZeroRE -> S Z
                OneRE -> S Z
                Star r1 -> S (depth r1)
                Alt r2 r3 -> S (bigger (depth r2) (depth r2)) --for Alt and Concat, return whichever subtree is longer (bigger)
                Concat r4 r5 -> S (bigger (depth r4) (depth r5))


reToString :: RegExp -> [Char]
reToString = \r -> case r of
                    Star r1 -> (reToString r1) ++ "*" -- star appends a * after the regex
                    Alt r2 r3 -> "(" ++ (reToString r2) ++ "|" ++ reToString r3 ++ ")" --alt sandwiches a | between its two regexes, and puts the expression in parentheses
                    Concat r4 r5 -> "(" ++ (reToString r4) ++ "." ++ reToString r5 ++ ")" -- concat is like alt, but uses a . instead of a pipe
                    Lit c -> [c] --literal is literally just the character
                    ZeroRE -> "0"
                    OneRE -> "1"