//
//  ViewController.swift
//  Probably Not
//
//  Created by Miguel Angel Sicart on 11/11/2019.
//  Copyright © 2019 playable_systems. All rights reserved.
//

import UIKit

class ViewController: UIViewController
{
    //MARK: - USER DEFAULTS
    let defaults = UserDefaults.standard
    
    //MARK: - USER INTERFACE
    var presentationLabel: UILabel!
    var absolutely: UIBarButtonItem!
    var game: UIBarButtonItem!
    var probably: UIBarButtonItem!
   
    
    override func viewDidAppear(_ animated: Bool)
    {
        if self.traitCollection.userInterfaceStyle == .dark
        {
            self.view.backgroundColor = .black
            presentationLabel.textColor = .white
        }
        else if self.traitCollection.userInterfaceStyle == .light
        {
            self.view.backgroundColor = .white
            presentationLabel.textColor = .black
        }
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        //MARK: - NAVIGATION CONTROLLER
        self.navigationController?.navigationBar.isHidden = true
        navigationController?.setToolbarHidden(false, animated: true)
        navigationController?.toolbar.barTintColor = .systemBackground
        absolutely = UIBarButtonItem(title: "Absolutely Not", style: .plain, target: self, action: #selector(absolutelyNot))
        game = UIBarButtonItem(title: "Game", style: .plain, target: self, action: #selector(pressedGame))
        probably = UIBarButtonItem(title: "Probably Not", style: .plain, target: self, action: #selector(probablyNot))
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: self, action: nil)
        toolbarItems = [spacer, absolutely, spacer, spacer, game, spacer, spacer, probably, spacer]


        // Do any additional setup after loading the view.
        print(UserDefaults.standard.bool(forKey: "didSee"))

        //MARK: - UI ELEMENTS INIT
        presentationLabel = UILabel(frame: CGRect(x: 10, y: 150, width: view.frame.width - 15, height: view.frame.height - 300))
        presentationLabel.font = UIFont(name: "Avenir-BlackOblique", size: 60)
        presentationLabel.text = "Learn to see the world through the lenses of Artificial Intelligence!\nChoose between:\n \n Absolutely Not: take a picture, or choose a picture from your library, and let the AI tell you what the thing in the picture is absolutely not.\n \nProbably Not: take a picture, or choose a picture from your library, and let the AI tell you what the thing in the picture is probably not.\n \n Or try the AI-powered treasure hunt game!\n \n \n Inspired by the work of Kate Crawford and Trevor Paglen."
        presentationLabel.numberOfLines = 0
        presentationLabel.adjustsFontSizeToFitWidth = true
        presentationLabel.adjustsFontForContentSizeCategory = true
        if self.traitCollection.userInterfaceStyle == .dark
        {
            self.view.backgroundColor = .black
            presentationLabel.textColor = .white
        }
        else if self.traitCollection.userInterfaceStyle == .light
        {
            self.view.backgroundColor = .white
            presentationLabel.textColor = .black
        }
        view.addSubview(presentationLabel)
        
        let tripleTap = UITapGestureRecognizer(target: self, action: #selector(changeFont))
        tripleTap.numberOfTapsRequired = 3
        view.addGestureRecognizer(tripleTap)
    }
    
    //MARK: - UI CHANGES
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
         if self.traitCollection.userInterfaceStyle == .dark
               {
                   self.view.backgroundColor = .black
                   presentationLabel.textColor = .white
               }
               else if self.traitCollection.userInterfaceStyle == .light
               {
                   self.view.backgroundColor = .white
                   presentationLabel.textColor = .black
               }
    }

    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
         if self.traitCollection.userInterfaceStyle == .dark
               {
                   self.view.backgroundColor = .black
                   presentationLabel.textColor = .white
               }
               else if self.traitCollection.userInterfaceStyle == .light
               {
                   self.view.backgroundColor = .white
                   presentationLabel.textColor = .black
               }
    }

    @objc func pressedGame()
    {
        if !UserDefaults.standard.bool(forKey: "didSee")
        {
            UserDefaults.standard.set(true, forKey: "didSee")
            performSegue(withIdentifier: "toTutorial", sender: self)
        }
        else
        {
            performSegue(withIdentifier: "toGame", sender: self)
        }
    }
    
    @objc func absolutelyNot()
    {
        performSegue(withIdentifier: "toAbsolutely", sender: self)
    }
    
    @objc func probablyNot()
    {
        performSegue(withIdentifier: "toProbably", sender: self)
    }
    
    @objc func changeFont()
    {
        print("triple tapped")
        presentationLabel.font = UIFont(name: "SansBullshitSans", size: UIFont.labelFontSize)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.navigationBar.isHidden = false
    }
    
}

