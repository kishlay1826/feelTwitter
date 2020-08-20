//
//  ViewController.swift
//  feelTwitter
//
//  Created by Kishlay Chhajer on 2020-08-20.
//  Copyright © 2020 Kishlay Chhajer. All rights reserved.
//

import UIKit
import SwifteriOS
import CoreML
import SwiftyJSON

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var emojiLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    
    let swifter = Swifter(consumerKey: "YOUR_API_KEY", consumerSecret: "YOUR_SECRET_API_KEY")
    
    let classifier = SentimentClassifier()
    
    var score: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchTextField.delegate = self
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        searchTextField.endEditing(true)
        return true
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if let textEntry = searchTextField.text {
            swifter.searchTweet(using: textEntry, lang: "en", count: 100, tweetMode: .extended, success: { (results, metadata) in
                var tweetArray = [SentimentClassifierInput]()
                for i in 0..<100 {
                    if let tweet = results[i]["full_text"].string {
                        tweetArray.append(SentimentClassifierInput(text: tweet))
                    }
                }
                do {
                    self.score = 0
                    let result = try self.classifier.predictions(inputs: tweetArray)
                    for r in result {
                        if r.label == "Pos" {
                            self.score+=1
                        } else if r.label == "Neg" {
                            self.score-=1
                        }
                    }
                    self.updateUI()
                } catch {
                    print(error)
                }

        }
            ) { (error) in
            print(error)
            }
        }
    }
    
    func updateUI() {
        print(score)
           
           if score > 20 {
               self.emojiLabel.text = "😍"
               self.commentLabel.text = "Positive"
           } else if score > 10 {
               self.emojiLabel.text = "😀"
                self.commentLabel.text = "Positive"
           } else if score > 0 {
               self.emojiLabel.text = "🙂"
                self.commentLabel.text = "Positive"
           } else if score == 0 {
               self.emojiLabel.text = "😐"
                self.commentLabel.text = "Neutral"
           } else if score > -10 {
               self.emojiLabel.text = "😕"
                self.commentLabel.text = "Neutral"
           } else if score > -20 {
               self.emojiLabel.text = "😡"
                self.commentLabel.text = "Negative"
           } else {
               self.emojiLabel.text = "🤮"
                self.commentLabel.text = "Negative"
           }
       }



}

