//
//  CardCollectionViewCell.swift
//  Match
//
//  Created by Gabriel Campos on 28/05/2018.
//  Copyright © 2018 Gabriel Campos. All rights reserved.
//

import UIKit

class CardCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var frontImageView: UIImageView!
    
    @IBOutlet weak var backImageView: UIImageView!
    
    var card:Card?
    
    func setCard(_ card:Card) {
        
        // Keep track of the card thats gets passed in
        self.card = card
        
        frontImageView.image = UIImage(named: card.imageName)
        
        // Determine if the card is in a flipped state or down state
        if card.isFlipped == true {
            // Make sure of frontimaview is on top
            UIView.transition(from: backImageView, to: frontImageView, duration: 0, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
            
        }
        else {
            //Make sure the backimageview is on top
            UIView.transition(from: frontImageView, to: backImageView, duration: 0, options: [.showHideTransitionViews, .transitionFlipFromLeft], completion: nil)
        
        }
        
    }
    
    func flip() {
        
        UIView.transition(from: backImageView, to: frontImageView, duration: 0.3, options: [.transitionFlipFromLeft, .showHideTransitionViews], completion: nil)
    }
    
    func flipBack() {
        
        UIView.transition(from: frontImageView, to: backImageView, duration: 0.3, options: [.transitionFlipFromRight, .showHideTransitionViews], completion: nil)
        
    }

}
