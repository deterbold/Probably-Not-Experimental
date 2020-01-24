//
//  LabelAnimation.swift
//  Probably Not
//
//  Created by Miguel Sicart on 24/01/2020.
//  Copyright © 2020 playable_systems. All rights reserved.
//

import Foundation
import UIKit
import Swift

//.https://stackoverflow.com/questions/11686642/letter-by-letter-animation-for-uilabel


extension UILabel
{
    func animate(newText: String, characterDelay: TimeInterval)
    {
        DispatchQueue.main.async
            {
            self.text = ""

            for(index, character) in newText.enumerated()
            {
                DispatchQueue.main.asyncAfter(deadline: .now() + characterDelay * Double(index))
                {
                    self.text?.append(character)
                }
            }
        }
    }
}
