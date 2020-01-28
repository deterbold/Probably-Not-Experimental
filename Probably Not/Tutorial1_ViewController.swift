//
//  Tutorial1_ViewController.swift
//  Probably Not
//
//  Created by Miguel Angel Sicart on 20/11/2019.
//  Copyright © 2019 playable_systems. All rights reserved.
//

import UIKit

class Tutorial1_ViewController: UIViewController
{
    
    var topLabel: UILabel!
    var middleLabel:UILabel!
    var bottomLabel: UILabel!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        //TOP LABEL
        topLabel = UILabel(frame: CGRect(x: 10, y: 100, width: view.frame.width - 30, height: 200))
        topLabel.font = UIFont(name: "Avenir-BlackOblique", size: 20)
        topLabel.text = "For example, the game will want you find something THAT IS NOT, but COULD PROBABLY BE, "
        topLabel.numberOfLines = 0
        topLabel.adjustsFontSizeToFitWidth = true
        topLabel.adjustsFontForContentSizeCategory = true
        view.addSubview(topLabel)
        
        //MIDDLE LABEL
        middleLabel = UILabel(frame: CGRect(x: 10, y: view.frame.midY, width: view.frame.width - 30, height: 50))
        middleLabel.font = UIFont(name: "Avenir-BlackOblique", size: 20)
        middleLabel.text = "a desktop computer"
        middleLabel.numberOfLines = 0
        middleLabel.adjustsFontSizeToFitWidth = true
        middleLabel.adjustsFontForContentSizeCategory = true
        view.addSubview(middleLabel)
        
        //BOTTOM LABEL
        bottomLabel = UILabel(frame: CGRect(x: 10, y: view.frame.midY + 100, width: view.frame.width - 30, height: 200))
        bottomLabel.font = UIFont(name: "Avenir-BlackOblique", size: 40)
        bottomLabel.text = "Think about how the computer sees things. What is something that looks like a desktop computer, but is not a desktop computer? How can you cheat the algorithm to think that something could be a desktop computer? \n Let me give you an example. Press NEXT."
        bottomLabel.numberOfLines = 0
        bottomLabel.adjustsFontSizeToFitWidth = true
        bottomLabel.adjustsFontForContentSizeCategory = true
        if self.traitCollection.userInterfaceStyle == .dark
        {
            self.view.backgroundColor = .black
            topLabel.textColor = .white
            middleLabel.textColor = .white
            bottomLabel.textColor = .white
        }
        else if self.traitCollection.userInterfaceStyle == .light
        {
            self.view.backgroundColor = .white
            topLabel.textColor = .black
            middleLabel.textColor = .black
            bottomLabel.textColor = .black
        }
        view.addSubview(bottomLabel)
    }
    
    //MARK: - UI CHANGES
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
         if self.traitCollection.userInterfaceStyle == .dark
               {
                   self.view.backgroundColor = .black
                   topLabel.textColor = .white
                   middleLabel.textColor = .white
                   bottomLabel.textColor = .white
               }
               else if self.traitCollection.userInterfaceStyle == .light
               {
                   self.view.backgroundColor = .white
                   topLabel.textColor = .black
                   middleLabel.textColor = .black
                   bottomLabel.textColor = .black
               }
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
         if self.traitCollection.userInterfaceStyle == .dark
               {
                   self.view.backgroundColor = .black
                  topLabel.textColor = .white
                   middleLabel.textColor = .white
                   bottomLabel.textColor = .white
               }
               else if self.traitCollection.userInterfaceStyle == .light
               {
                   self.view.backgroundColor = .white
                   topLabel.textColor = .black
                middleLabel.textColor = .black
                bottomLabel.textColor = .black
               }
    }
}
