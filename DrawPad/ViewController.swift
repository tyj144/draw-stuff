//
//  ViewController.swift
//  DrawPad
//
//  Created by Jean-Pierre Distler on 13.11.14.
//  Copyright (c) 2014 Ray Wenderlich. All rights reserved.
//  Designed by Tyler Jiang using http://www.raywenderlich.com/87899/make-simple-drawing-app-uikit-swift#comments for basic structure
//  LaunchScreen uses an image from 123FreeVectors http://img1.123freevectors.com/wp-content/uploads/new/people/524-human-hand-holding-a-pencil-clip-art.png
//

import UIKit

class ViewController: UIViewController {
    
    //Variables
    @IBOutlet weak var drawing: DrawingView!
    
    var lastPoint = CGPoint.zeroPoint   //stores the last drawn point on the canvas
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    var brushWidth: CGFloat = 2.0
    var opacity: CGFloat = 1.0
    var swiped = false  //sees if brush stroke is continuous
    
    var colors: [UIButton] = []
    var pencilsVisible: Bool = true
    
    var choice: Int?
    
    @IBOutlet weak var redColor: UIButton!
    @IBOutlet weak var orangeColor: UIButton!
    @IBOutlet weak var yellowColor: UIButton!
    @IBOutlet weak var greenColor: UIButton!
    @IBOutlet weak var blueColor: UIButton!
    @IBOutlet weak var purpleColor: UIButton!
    @IBOutlet weak var blackColor: UIButton!
    @IBOutlet weak var brushSettings: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        colors = [redColor, orangeColor, yellowColor, greenColor, blueColor, purpleColor, blackColor, brushSettings]
        
    }
    
   /*override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        for var i = 0; i < colors.count; i++ {
            if i != 0 {
                var colorsFrame = self.colors[i].frame
                colorsFrame.origin.y += colorsFrame.size.height
                
                self.colors[i].frame = colorsFrame
            }
        }

    }*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func colorPressed(sender: AnyObject) {
        
        //Stores which pencil was pressed
        choice = sender.tag ?? 0
        
        if choice < 0 || choice >= drawing.colors.count {
            choice = 0
        }
        
        animateColors()
        
        (red, green, blue) = drawing.colors[choice!]
        drawing.color = UIColor(red: red, green: green, blue: blue, alpha: opacity)

    }
    
    func animateColors() {
        for var i = 0; i < colors.count; i++ {
            //Shows all pencils
            
            if pencilsVisible {
                    UIView.animateWithDuration(1.0, animations: {
                        var colorsFrame = self.colors[i].frame
                        colorsFrame.origin.x -= colorsFrame.size.width + 10
                        
                        self.colors[i].frame = colorsFrame
                    })
                }
    
            //Moves pencils off screen
            else {
            UIView.animateWithDuration(1.0, animations: {
                var colorsFrame = self.colors[i].frame
                colorsFrame.origin.x += colorsFrame.size.width + 10
                        
                self.colors[i].frame = colorsFrame
                
                })
                
            }
        }
        
        //After running through the loop, pencils hidden is now opposite
        if pencilsVisible {
            pencilsVisible = false
        }
        else {
            pencilsVisible = true
        }
    }

    @IBAction func brushPressed(sender: AnyObject) {
        drawing.lineWidth = 30
        drawing.color = UIColor(red: red, green: green, blue: blue, alpha: 0.5)
        self.opacity = 0.5
        
        animateColors()
    }
    
    @IBAction func penPressed(sender: AnyObject) {
        drawing.lineWidth = 2.0
        drawing.color = UIColor(red: red, green: green, blue: blue, alpha: 1.0)
        self.opacity = 1.0
        
        animateColors()
    }
    
    @IBAction func eraserPressed(sender: AnyObject) {
        drawing.color = UIColor.whiteColor()
        self.opacity = 1.0
        
    }
    
    @IBAction func reset(sender: AnyObject) {
        drawing.clear()
    }
    
    @IBAction func done(segue: UIStoryboardSegue) {

    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let nav = segue.destinationViewController as! UINavigationController    //cast it through UINavigationController
        let settingsViewController = nav.topViewController as! SettingsViewController   //only need to access topViewController
        settingsViewController.delegate = self
        settingsViewController.brush = drawing.lineWidth!
        settingsViewController.opacity = opacity
        
        settingsViewController.red = red
        settingsViewController.green = green
        settingsViewController.blue = blue

    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func undo(sender: AnyObject) {
        drawing.undo()
    }
    
}


extension ViewController: SettingsViewControllerDelegate {
    func settingsViewControllerFinished(settingsViewController: SettingsViewController) {
        self.brushWidth = settingsViewController.brush
        self.opacity = settingsViewController.opacity
        self.red = settingsViewController.red
        self.green = settingsViewController.green
        self.blue = settingsViewController.blue
        self.pencilsVisible = true

        drawingViewSetPreferences(drawing)  //need to keep ViewController delegates because drawing is declared in ViewController
    }
}

extension ViewController: DrawingViewDelegate {
    func drawingViewSetPreferences(drawingView: DrawingView) {
        drawingView.lineWidth = brushWidth
        drawingView.color = UIColor(red: red, green: green, blue: blue, alpha: opacity)
    }
}