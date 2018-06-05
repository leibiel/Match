//
//  CardModel.swift
//  Match
//
//  Created by Gabriel Campos on 27/05/2018.
//  Copyright © 2018 Gabriel Campos. All rights reserved.
//

import Foundation

class CardModel {
    
    
    func getCards() -> [Card] {
        
        // Declare an array to store the numbers generated
        var generatedNumbersArray = [Int]()
        
        // Declare an array to store the generated cards
        var generatedCardsArray = [Card]()
        
        // Randomly generate pairs of cards
        while generatedNumbersArray.count < 8 {
            
            // Get a random number
            let randomNumber = arc4random_uniform(13) + 1
            
            if generatedNumbersArray.contains(Int(randomNumber)) == false {
                
                // Log the number
                print(randomNumber)
                
                // Store the number into the generatedNumbersArray
                generatedNumbersArray.append(Int(randomNumber))
                
                //Create the first card object
                let cardOne = Card()
                cardOne.imageName = "card\(randomNumber)"
                
                generatedCardsArray.append(cardOne)
                
                // Create the second card object
                let cardTwo = Card()
                cardTwo.imageName = "card\(randomNumber)"
                
                generatedCardsArray.append(cardTwo)
            }
        }
        
        // Randomize the array
        for i in 0...generatedCardsArray.count-1 {
            
            // Find a random index to swap with
            let randomNumber = Int(arc4random_uniform(UInt32(generatedCardsArray.count)))
            
            // Swap the two cards
            let temporaryStorage = generatedCardsArray[i]
            generatedCardsArray[i] = generatedCardsArray[randomNumber]
            generatedCardsArray[randomNumber] = temporaryStorage
        }
        
        // Return the array
        return generatedCardsArray
    
    }
    
    
}
