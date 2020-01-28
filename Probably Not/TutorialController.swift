//
//  TutorialController.swift
//  Probably Not
//
//  Created by Miguel Angel Sicart on 11/11/2019.
//  Copyright © 2019 playable_systems. All rights reserved.
//

import UIKit

class TutorialController: UIViewController
{
    
    var tutorialLabel: UILabel!
    var skip: UIBarButtonItem!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //MARK: - TOOLBAR INTERFACE
        navigationController?.setToolbarHidden(false, animated: true)
        navigationController?.setNavigationBarHidden(false, animated: true)
        navigationController?.toolbar.barTintColor = .systemBackground
        skip = UIBarButtonItem(title: "SKIP TUTORIAL", style: .plain, target: self, action: #selector(skipTutorial))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbarItems = [spacer, spacer, spacer, skip, spacer, spacer, spacer]
        
        //MARK: - UI ELEMENTS INIT
        tutorialLabel = UILabel(frame: CGRect(x: 10, y: 75, width: view.frame.width - 50, height: view.frame.height - 200))
        tutorialLabel.font = UIFont(name: "Avenir-BlackOblique", size: 60)
        tutorialLabel.text = "This is Probably Not (a game). \n \n The computer will ask you to find an object. \n \n Find something that is not, but could probably be that object.\n \n For example, if you were to find a Desktop Computer, this picture would convince the computer that the thing in the picture is not, but could be a Desktop Computer.\n\n\nPress NEXT"
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
        
    
        
        
        //MARK: - UI CHANGES
        
        func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
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

        func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
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
    
    @objc func skipTutorial()
    {
        performSegue(withIdentifier: "toGame", sender: self)
    }
}
