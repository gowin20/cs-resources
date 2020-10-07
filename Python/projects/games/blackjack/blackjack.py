import random
import time


"""

DISCLAIMER: I DID NOT MAKE THIS PROJECT

This project was created by Juni Learning, and is included here for reference purposes only. I have no intent to distribute this code, and it is being used for education.

"""




input("Welcome to the game of Blackjack! In this game, you will be dealt two cards to start. Your goal is to get as close to 21 as possible without going over - or busting! In this game, Jack, Queen, and King are each worth 10 and the Ace is worth 1 or 11.\n\nThe dealer will first ask you to hit (take another card) or stay. As long as you don't bust, once you decide to stay, the dealer will then play his hand. The dealer always has to hit until his hand is at least 17. Whoever has the better hand at the end wins!\n\nPress Enter to start playing.\n")

# the cardNames dicts translates the J, Q, K, A
cardNames = {11: "Jack", 12: "Queen", 13: "King", 1: "Ace"}

# this function prints out a hand with the appropriate names
def printHand(hand):
  outputHand = []
  for num in hand:
    if num == 1 or num > 10:
      outputHand.append(cardNames[num])
    else:
      outputHand.append(num)
  print(outputHand)
  print()

# this function calculates the possible values of each hand (Ace can be 1 or 11)
def calcHandValues(hand):
  sum = 0
  numAces = 0
  for num in hand:
    if num == 1:
      numAces += 1
      sum += 1
    elif num > 10:
      sum += 10
    else:
      sum += num
  
  # sum currently holds the minimum possible value of the hand. for each Ace in the hand, we should add 10 to the possible values
  values = [sum]
  for i in range(1,numAces+1):
    values.append(sum + i * 10)
  
  return values

# this function calculates the largest possible value of a hand under 21
def getFinalValue(hand):
  finalValue = 0
  values = sorted(calcHandValues(hand))
  for num in values:
    if num <= 21:
      finalValue = num

  return finalValue

while True:
  playerHand = []

  # deal first two cards to player
  for i in range(2):
   playerHand.append(random.randint(1,13))
  
  # print out player's cards
  print("Here is your hand: ")
  printHand(playerHand)
  
  # use this variable to track when the game should end immediately
  continueGame = True  

  # check for blackjack
  if 21 in calcHandValues(playerHand):
    print("Blackjack! You win! :D")
    continueGame = False

  if continueGame:
    # ask to Hit or Stay
    hitOrStay = "H"

    while hitOrStay == "H":
      while True:
        hitOrStay = input("Type in H to hit or S to stay:")
        if hitOrStay == "H" or hitOrStay == "S":
          break
        else:
          print("Invalid input.\n")

      # if Hit, add new card and check if busted
      if hitOrStay == "H":
        playerHand.append(random.randint(1,13))
        print("Here is your hand: ")
        printHand(playerHand)

        handValues = calcHandValues(playerHand)
        if min(handValues) > 21:
          print("You busted! :(\n")
          continueGame = False
          break
        elif 21 in handValues:
          print("Blackjack! You win! :D")
          continueGame = False
          break
      
    if continueGame:
      print("Dealer's turn!\n")

      # deal first two cards to dealer
      dealerHand = []
      for i in range(2):
        dealerHand.append(random.randint(1,13))
      
      # print out dealer's cards
      print("Here is the dealer's hand: ")
      printHand(dealerHand)

      # the dealer continues to hit until his hand is at least 17
      while True:
        time.sleep(1) # make game more realistic
        handValues = calcHandValues(dealerHand)
        if min(handValues) < 17:
          dealerHand.append(random.randint(1,13))
          print("The dealer hit. Here is the dealer's new hand:")
          printHand(dealerHand)
        elif 21 in handValues:
          print("The dealer got blackjack!")
          break
        elif min(handValues) > 21:
          print("The dealer busted! You win! :)")
          break
        else:
          print("The dealer has finalized his hand.")
          # if the game is still going, see whose hand wins
          time.sleep(1)
          if getFinalValue(playerHand) > getFinalValue(dealerHand):
            print("You win! :)\n")
          elif getFinalValue(playerHand) < getFinalValue(dealerHand):
            print("The dealer won. :(\n")
          else:
            print("It's a tie!\n")
          break

  input("Press Enter to play again!\n")