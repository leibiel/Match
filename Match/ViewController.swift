//
//  ViewController.swift
//  Match
//
//  Created by Gabriel Campos on 27/05/2018.
//  Copyright © 2018 Gabriel Campos. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {    
    
    @IBOutlet weak var timerLabel: UILabel!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var model = CardModel()
    var cardArray = [Card]()
    
    var firstFlippedCardIndex:IndexPath?
    
    var timer:Timer?
    var milliseconds:Float = 30 * 1000 // 30 seconds

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Call the getCards method of the card model
        cardArray = model.getCards()
        
        collectionView.delegate = self
        collectionView.dataSource = self
    
        // Create timer
        timer = Timer.scheduledTimer(timeInterval: 0.001, target: self, selector: #selector(timeElapsed), userInfo: nil, repeats: true)
        RunLoop.main.add(timer!, forMode: .commonModes)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        SoundManager.playSound(.shuffle)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Timer Methods
    
    @objc func timeElapsed() {
        
        milliseconds -= 1
        
        // Convert to seconds
        let seconds = String(format: "%.2f", milliseconds/1000)
        
        // Set label
        timerLabel.text = "Tempo Restante: \(seconds)"
        
        // When the timer has reached 0...
        if milliseconds == 0 {
            
            //Stop the timer
            timer?.invalidate()
            timerLabel.textColor = UIColor.red
            
            // Check if there are any cards unmatched
            checkGameEnded()
        
            
        }
    }

    // MARK: - UICollectionView Protocol Methods
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        return  cardArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        // Get an CardCollectionViewCell object
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CardCell", for: indexPath) as! CardCollectionViewCell
        
        // Get the card that the collection view is trying to display
        let card = cardArray[indexPath.row]
        
        // Set that card for the cell
        cell.setCard(card)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // Check if there's any time left
        if milliseconds <= 0 {
            return
        }
        
        
        // Get the cell that the user selected
        let cell = collectionView.cellForItem(at: indexPath) as! CardCollectionViewCell
        
        // Get the card that the user selected
        let card = cardArray[indexPath.row]
        
        if card.isFlipped == false && card.isMatched == false {
            
            //Flip the card
            cell.flip()
            
            //Play the flip sound
            SoundManager.playSound(.flip)
            
            // Set the status of the card
            card.isFlipped = true
            
            // Determine if it's the first or the second card that's flipped over
            
            if firstFlippedCardIndex == nil {
                
                // This is the first card being flipped
                firstFlippedCardIndex = indexPath
            
            }
            else {
                // This is the second card being flipped
                
                // Perform the matching logic
                checkForMatches(indexPath)
            }
        }
        
    } // End didSelecItemAt method
    
    // Mark: - Game Logic Methods
    
    func checkForMatches(_ secondFlippedCardIndex: IndexPath) {
        
        // Get the cells for the two cards that were revelead
        let cardOneCell = collectionView.cellForItem(at: firstFlippedCardIndex!) as? CardCollectionViewCell
        
        let cardTwoCell = collectionView.cellForItem(at: secondFlippedCardIndex) as? CardCollectionViewCell
        
        // Get the cards for the two cards that were revelead
        let cardOne = cardArray[firstFlippedCardIndex!.row]
        let cardTwo = cardArray[secondFlippedCardIndex.row]
        
        // Compare the two cards
        if cardOne.imageName == cardTwo.imageName {
            
            // It's a match
            
            // Play sound
            SoundManager.playSound(.match)
            
            // Set the statuses of the cards
            cardOne.isMatched = true
            cardTwo.isMatched = true
            
            // Remove the cards from the grid
            cardOneCell?.remove()
            cardTwoCell?.remove()
            
            // Check if there are any cards left unmatched
            checkGameEnded()
            
        }
        else{
            
            // It's not a match
            
            // Play sound
            SoundManager.playSound(.nomatch)
            
            // Set the statuses of the cards
            cardOne.isFlipped = false
            cardTwo.isFlipped = false
            
            // Flip both cards back
            cardOneCell?.flipBack()
            cardTwoCell?.flipBack()
        }
        
        // Dizer para o collectionview para recarregar a célula com o primeiro card se o resultado for nil
        if cardOneCell == nil {
            collectionView.reloadItems(at: [firstFlippedCardIndex!])
        }
        
        // Resetar a propriedade que diz se o primeiro card foi flipado
        firstFlippedCardIndex = nil
    }
    
    func checkGameEnded() {
        
        // Determine if there any cards unmatched
        var isWon = true
        
        for card in cardArray {
            
            if card.isMatched == false {
                isWon = false
                break
            }
            
        }
        
        // Messaging variableas
        var title = ""
        var message = ""
        
        // If not, then user has won, stop the timer
        if isWon == true {
            
            if milliseconds > 0 {
                timer?.invalidate()
            }
            
            title = "Parabéns"
            message = "Você Ganhou"
            
        }
        else {
            // If there are unmatched cards, check if theres any time left
            
            if milliseconds > 0 {
                return
            }
            
            title = "Fim do Jogo"
            message = "Você Perdeu"
        }
        
        // Show won/lost messaging
        showAlert(title, message)
    }
    
    func showAlert(_ title:String, _ message:String) {
        
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
        
        alert.addAction(alertAction)
        
        present(alert, animated: true, completion: nil)
        }

} // End ViewController class


