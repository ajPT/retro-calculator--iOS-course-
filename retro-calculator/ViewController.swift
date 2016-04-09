//
//  ViewController.swift
//  retro-calculator
//
//  Created by Amadeu Andrade on 03/04/16.
//  Copyright © 2016 Amadeu Andrade. All rights reserved.
//

import UIKit
import AVFoundation

class ViewController: UIViewController {
    
    //Properties
    var buttonSound: AVAudioPlayer!
    var currentValue: String = ""
    var valueForOperation: String = ""
    var previousOperator: Operator = Operator.empty
    
    enum Operator: String {
        case add = "+"
        case subtract = "-"
        case divide = "/"
        case multiply = "*"
        case equals = "="
        case empty = "Empty"
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let path = NSBundle.mainBundle().pathForResource("btn", ofType: "wav")
        let soundUrl = NSURL(fileURLWithPath: path!)
        
        do {
            try buttonSound = AVAudioPlayer(contentsOfURL: soundUrl)
            buttonSound.prepareToPlay()
        } catch let err as NSError {
            print(err.debugDescription)
        }
    }
    
    //Outlets and Actions
    @IBOutlet weak var outputLabel: UILabel!
    
    @IBAction func onDelPressed (sender: AnyObject){
        playSound()
        if currentValue == "0." {
            currentValue = ""
        } else if currentValue != "" {
            currentValue.removeAtIndex(currentValue.endIndex.predecessor())
        }
        outputLabel.text = currentValue
    }
    
    @IBAction func onDotPressed (sender: AnyObject) {
        playSound()
        if currentValue != "" && !hasDot() {
            currentValue += "."
            outputLabel.text = currentValue
        } else if currentValue == "" && previousOperator != Operator.equals {
            currentValue = "0."
            outputLabel.text = currentValue
        }
    }
    
    @IBAction func onNumberPressed (button: UIButton) {
        playSound()
        currentValue += "\(button.tag)"
        outputLabel.text = currentValue
    }
    
    @IBAction func onClearPressed(sender: AnyObject) {
        playSound()
        currentValue = ""
        valueForOperation = ""
        previousOperator = Operator.empty
        outputLabel.text = "0.0"
    }
    
    @IBAction func onDividePressed(sender: AnyObject) {
        doOperation(Operator.divide)
    }
    
    @IBAction func onMultiplyPressed(sender: AnyObject) {
        doOperation(Operator.multiply)
    }
    
    @IBAction func onAddPressed(sender: AnyObject) {
        doOperation(Operator.add)
    }
    
    @IBAction func onSubtractPressed(sender: AnyObject) {
        doOperation(Operator.subtract)
    }
    
    @IBAction func onEqualsPressed(sender: AnyObject) {
        doOperation(Operator.equals)
    }
    
    //Auxiliary functions
    
    func hasDot() -> Bool {
        if currentValue.rangeOfString(".") != nil {
            return true
        } else {
            return false
        }
    }
    
    func playSound() {
        if buttonSound.playing {
            buttonSound.stop()
        }
        buttonSound.play()
    }
    
    func doOperation(actualOperator: Operator) {
        playSound()
        if previousOperator != Operator.equals && currentValue != "" {
            //do operations
            if previousOperator == Operator.add {
                currentValue = "\(Double(valueForOperation)! + Double(currentValue)!)"
            } else if previousOperator == Operator.subtract {
                currentValue = "\(Double(valueForOperation)! - Double(currentValue)!)"
            } else if previousOperator == Operator.multiply {
                currentValue = "\(Double(valueForOperation)! * Double(currentValue)!)"
            } else if previousOperator == Operator.divide {
                currentValue = "\(Double(valueForOperation)! / Double(currentValue)!)"
            }
            //update
            valueForOperation = currentValue
            previousOperator = actualOperator
            outputLabel.text = currentValue
            currentValue = ""
        } else if actualOperator != Operator.equals { //last operator is equals and actual operator is not equals
            if currentValue != "" { //number pressed after equals
                valueForOperation = currentValue
                currentValue = ""
            }
            previousOperator = actualOperator
            outputLabel.text = valueForOperation
        }
    }
}

