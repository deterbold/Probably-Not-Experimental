//
//  Tutorial2_ViewController.swift
//  Probably Not
//
//  Created by Miguel Angel Sicart on 20/11/2019.
//  Copyright © 2019 playable_systems. All rights reserved.
//

import UIKit

class Tutorial2_ViewController: UIViewController
{
    //tutorial label
    var tutorialLabel: UILabel!
    //text view
    var answerField: UITextView!
    //outletView
    var outletView: UIImageView!
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        //MARK: - TUTORIAL LABEL
        tutorialLabel = UILabel(frame: CGRect(x: 10, y: 50, width: view.frame.width - 30, height: 200))
        tutorialLabel.font = UIFont(name: "Avenir-BlackOblique", size: 20)
        tutorialLabel.text = "This picture fools the algorithm into thinking that what it sees IS NOT, but COULD POSSIBLY BE, a desktop computer. Look at the Results"
        tutorialLabel.numberOfLines = 0
        tutorialLabel.adjustsFontSizeToFitWidth = true
        tutorialLabel.adjustsFontForContentSizeCategory = true
        view.addSubview(tutorialLabel)
        
        //MARK: - OUTLET VIEW INIT
        outletView = UIImageView(frame: CGRect(x: 0, y: 200, width: self.view.frame.width, height: self.view.frame.height * 0.8))
        outletView.contentMode = .center
        let image = UIImage(named: "desktop.jpeg")?.resizeImage(targetSize: CGSize(width: self.view.frame.width, height: self.view.frame.height/2))
        outletView.image = image
        
        view.addSubview(outletView)

        outletView.translatesAutoresizingMaskIntoConstraints = false
        outletView.trailingAnchor.constraint(equalTo: view.layoutMarginsGuide.trailingAnchor).isActive = true
        outletView.leadingAnchor.constraint(equalTo: view.layoutMarginsGuide.leadingAnchor).isActive = true
        outletView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor).isActive = true
        outletView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        outletView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        //MARK: - LABEL
         //https://stackoverflow.com/questions/37893000/swift-infinite-fade-in-and-out-loop
        answerField = UITextView(frame: CGRect(x: 25, y: self.view.frame.midY - 50, width: self.view.frame.width - 50, height: 120))
        answerField.font = UIFont(name: "Avenir-BlackOblique", size: 60)
        answerField.textColor = .black
        answerField.textAlignment = .center
        answerField.isEditable = false
        answerField.adjustsFontForContentSizeCategory = true
        answerField.text = "The computer sees: \n monitor, desktop computer, notebook, screen."
        answerField.updateTextFont()
        
        if self.traitCollection.userInterfaceStyle == .dark
        {
            self.view.backgroundColor = .black
            tutorialLabel.textColor = .white
          self.answerField.textColor = .white
            answerField.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.6)
        }
        else if self.traitCollection.userInterfaceStyle == .light
        {
            self.view.backgroundColor = .white
            tutorialLabel.textColor = .black
          self.answerField.textColor = .black
            answerField.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.6)
        }
        
        view.addSubview(answerField)
        
        
        
        
    }
    
    //MARK: - INTERFACE CHANGES
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
            if self.traitCollection.userInterfaceStyle == .dark
                  {
                      self.view.backgroundColor = .black
                    tutorialLabel.textColor = .white
                    self.answerField.textColor = .white
                    answerField.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.6)
                  }
                  else if self.traitCollection.userInterfaceStyle == .light
                  {
                      self.view.backgroundColor = .white
                    tutorialLabel.textColor = .black
                    self.answerField.textColor = .black
                    answerField.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.6)
                  }
       }

       override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
            if self.traitCollection.userInterfaceStyle == .dark
            {
                self.view.backgroundColor = .black
                tutorialLabel.textColor = .white
              self.answerField.textColor = .white
                answerField.backgroundColor = UIColor(displayP3Red: 0, green: 0, blue: 0, alpha: 0.6)

            }
            else if self.traitCollection.userInterfaceStyle == .light
            {
                self.view.backgroundColor = .white
                tutorialLabel.textColor = .black
              self.answerField.textColor = .black
                answerField.backgroundColor = UIColor(displayP3Red: 1, green: 1, blue: 1, alpha: 0.6)

            }
       }
    
}
