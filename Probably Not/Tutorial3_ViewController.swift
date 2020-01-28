//
//  Tutorial3_ViewController.swift
//  Probably Not
//
//  Created by Miguel Angel Sicart on 20/11/2019.
//  Copyright © 2019 playable_systems. All rights reserved.
//

import UIKit

class Tutorial3_ViewController: UIViewController
{
    //tutorial label
    var tutorialLabel: UILabel!

    override func viewDidLoad()
    {
        super.viewDidLoad()

        //MARK: - TUTORIAL LABEL
        tutorialLabel = UILabel(frame: CGRect(x: 10, y: 150, width: view.frame.width - 30, height: view.frame.height - 300))
        tutorialLabel.font = UIFont(name: "Avenir-BlackOblique", size: 60)
        tutorialLabel.text = "When playing Probably Not (a game), try to think like a computer. What does a computer see? \n\n Take A LOT of pictures. Figure out the patterns in what the computer sees.\n\nThe game checks the second most probably answer, that is, what the algorithm considers to be the second most probably thing it is seeing. So learn to dougle-guess the computer.\n\nAnd like with all AI - be skeptic. This is silly technology, put to a silly use. "
        tutorialLabel.numberOfLines = 0
        tutorialLabel.adjustsFontSizeToFitWidth = true
        tutorialLabel.adjustsFontForContentSizeCategory = true
        if self.traitCollection.userInterfaceStyle == .dark
        {
            self.view.backgroundColor = .black
            tutorialLabel.textColor = .white
        }
        else if self.traitCollection.userInterfaceStyle == .light
        {
            self.view.backgroundColor = .white
            tutorialLabel.textColor = .black
        }
        view.addSubview(tutorialLabel)
    }
    
    //MARK: - UI CHANGES
        
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
             if self.traitCollection.userInterfaceStyle == .dark
                   {
                       self.view.backgroundColor = .black
                       tutorialLabel.textColor = .white
                   }
                   else if self.traitCollection.userInterfaceStyle == .light
                   {
                       self.view.backgroundColor = .white
                       tutorialLabel.textColor = .black
                   }
        }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
             if self.traitCollection.userInterfaceStyle == .dark
                   {
                       self.view.backgroundColor = .black
                       tutorialLabel.textColor = .white
                   }
                   else if self.traitCollection.userInterfaceStyle == .light
                   {
                       self.view.backgroundColor = .white
                       tutorialLabel.textColor = .black
                   }
        }
}
