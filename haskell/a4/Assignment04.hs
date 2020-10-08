module Assignment04 where

import Control.Applicative(liftA, liftA2, liftA3)
import Data.List(nub)

import FiniteStatePart2

---------------------------------------
-- Setup for section 1

type SLG sy = ([sy], [sy], [sy], [(sy,sy)])
data ConstructedState sy = ExtraState | StateForSymbol sy deriving (Eq, Show)

slg1 :: SLG SegmentCV
slg1 = ([C,V], [C], [V], [(C,C),(C,V),(V,V)])

slg2 :: SLG Int
slg2 = ([1,2,3], [1,2,3], [1,2,3], [(1,1),(2,2),(3,3),(1,2),(2,1),(1,3),(3,1)])

---------------------------------------
-- Setup for section 2

data DisjointUnion a b = This a | That b deriving (Show,Eq)

data RegExp sy = Lit sy
               | Alt (RegExp sy) (RegExp sy)
               | Concat (RegExp sy) (RegExp sy)
               | Star (RegExp sy)
               | ZeroRE
               | OneRE
               deriving Show

re1 :: RegExp Char
re1 = Concat (Alt (Lit 'a') (Lit 'b')) (Lit 'c')

re2 :: RegExp Char
re2 = Star re1

re3 :: RegExp Int
re3 = Star (Concat ZeroRE (Lit 3))

re4 :: RegExp Int
re4 = Concat (Alt (Lit 0) (Lit 1)) (Star (Lit 2))

------------------------------------------------------------------
------------------------------------------------------------------
-- IMPORTANT: Please do not change anything above here.
--            Write all your code below this line.




backwardSLG :: (Eq sy) => SLG sy -> [sy] -> sy -> Bool
--pretty expressly intended solely for use with generatesSLG
backwardSLG slg w s =
        let (syms, i, f, bigram) = slg in --s is the previous element, x is the 'current' one
            case w of
                [] -> elem s f
                (x : rest) -> (elem (s, x) bigram) && (backwardSLG slg rest x)



generatesSLG :: (Eq sy) => SLG sy -> [sy] -> Bool
generatesSLG slg w =
        let (syms, i, f, bigram) = slg in
            case w of
              [] -> False --can't generate empty string
              x : rest -> (elem x i) && (backwardSLG slg rest x) --check transitions from x to the rest of the list



--all FSAs originating from SLGs will have an extra state at the beginning (as they cannot generate the empty string)
slgToFSA :: (Eq sy) => SLG sy -> Automaton (ConstructedState sy) sy
slgToFSA (syms, i, f, bigram) = 
        let states =  ExtraState : liftA (\x -> StateForSymbol x) syms in --there is one state for every unique symbol - works out pretty well
        let starts = [ExtraState] in --always going to be exactly one start point
        let ends = liftA (\x -> StateForSymbol x) f in --as many end points as the SLG had
        let symbols = syms in 
        let delta = (liftA (\y -> (ExtraState, y, StateForSymbol y)) i) ++ (liftA (\x -> (StateForSymbol (fst x), snd x, StateForSymbol (snd x))) bigram) in 
        -- add transitions from the new first state, along with transitions from all the rest
        (states, symbols, starts, ends, delta)


        --(liftA (\y -> ConstructedState y) i :

-------------------------------------------
-- PART 2

mapStates :: (a->b) -> EpsAutomaton a sy -> EpsAutomaton b sy
mapStates fn (states, syms, i, f, delta) =
            let newStates = liftA fn states in --basically just applying the (a->b) function wherever states are used
            let newStarts = liftA fn i in
            let newEnds = liftA fn f in
            let dist func (x, s, x') = (func x, s, func x') in --this syntax took me forever to figure out
            let newDelta = liftA (\x -> dist fn x) delta in
            (newStates, syms, newStarts, newEnds, newDelta)




flatten :: DisjointUnion Int Int -> Int
flatten dis =
        case dis of
             This a -> 2*a --maps everything of type "this" to a unique even integer
             That b -> 2*b + 1  -- maps everything of type "that" to a unique odd integer



unionFSAs :: (Eq sy) => EpsAutomaton st1 sy -> EpsAutomaton st2 sy -> EpsAutomaton (DisjointUnion st1 st2) sy
--
--liftA2 (\x -> \y -> (x,y))
--liftA2 (\x -> \y -> (x,y)) i i' 
--liftA2 (\x -> \y -> (x,y)) f f'
unionFSAs m m' =
          let (states, symbs, i, f, delta) = mapStates (\x -> This x) m in --make the two fsas compatible
          let (states', symbs', i', f', delta') = mapStates (\x -> That x) m' in
          let newStates = (states ++ states') in 
          let newStarts = (i ++ i') in
          let newEnds = (f ++ f') in
          let newSyms = nub (symbs ++ symbs') in
          let newDelta = (delta ++ delta') in --combines everything together so everybody is happy
          (newStates, newSyms, newStarts, newEnds, newDelta)
          



concatFSAs :: (Eq sy) => EpsAutomaton st1 sy -> EpsAutomaton st2 sy -> EpsAutomaton (DisjointUnion st1 st2) sy

concatFSAs m m' =
            let (states, symbs, i, f, delta) = mapStates (\x -> This x) m in --make the two fsas compatible
            let (states', symbs', i', f', delta') = mapStates (\x -> That x) m' in
            let newStates = states ++ states' in
            let newStarts = i in --starts at the start of the first machine
            let newEnds = f' in --ends at the end of the second machine
            let newSyms = nub(symbs ++ symbs') in
            let bridgeDelts = liftA2 (\x -> \y -> (x, Nothing, y)) f i' in -- links together the end of the first machine, and the start of the second
            let newDelta = delta ++ delta' ++ bridgeDelts in --combine the transitions of both machines, along with the new ones that bridge them
            (newStates, newSyms, newStarts, newEnds, newDelta)


starFSA :: EpsAutomaton st sy -> EpsAutomaton (DisjointUnion Int st) sy

starFSA m =
  let (states, symbs, i, f, delta) = mapStates (\x -> That x) m in
  let mid = This 0 in
  let newStates = mid : states in
  let newStarts = [mid] in
  let newEnds = f ++ [mid] in
  let newSyms = symbs in
  let bridgeFromEnd = liftA (\y -> (y, Nothing, mid)) f in
  let bridgeToStart = liftA (\x -> (mid, Nothing, x)) i in
  let newDelta = bridgeFromEnd ++ bridgeToStart ++ delta in
  (newStates, newSyms, newStarts, newEnds, newDelta)


{-
I ended up enumerating in the reToFSA function instead, so I didn't need this

newFlatten :: (Enum sy) => DisjointUnion Int sy -> Int
newFlatten dis =
          case dis of
            This a -> a - 2
            That b -> fromEnum b
-}


--to properly call the flatten function I had to write, I had to include (Enum sy) in the type declaration - that's the only way I know of to convert ambiguous types to ints
reToFSA :: (Eq sy, Enum sy) => RegExp sy -> EpsAutomaton Int sy

reToFSA re =
      case re of
          Lit x -> --the literal string is the one that actually constructs an automaton. Other cases simply combine these atomic units
            let q0 = That (fromEnum x) in
            let states = [q0] in
            let starts = [q0] in
            let ends = [q0] in
            let delta = [(q0, Just x, q0)] in
                mapStates flatten (states, [x], starts, ends, delta)
          Alt r r' -> mapStates flatten (unionFSAs (reToFSA r) (reToFSA r')) --here, we get to apply all those other functions I wrote
          Concat r r' -> mapStates flatten (concatFSAs (reToFSA r) (reToFSA r'))
          Star r -> mapStates flatten (starFSA (reToFSA r))
          ZeroRE -> ([],[],[],[],[]) --zero is NOTHING
          OneRE -> let states = [This 1] in --one is the epsilon transition ("nothing" but not literally nothing)
            let starts = [This 1] in
            let ends = [This 1] in
            let delta = [((This 1), Nothing, (This 1))] in
                mapStates flatten (states, [], starts, ends, delta)