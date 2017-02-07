

import UIKit

//Lets SettingsViewController communicate
protocol SettingsViewControllerDelegate: class {
    func settingsViewControllerFinished(settingsViewController: SettingsViewController)
}

class SettingsViewController: UITableViewController {

    weak var delegate: SettingsViewControllerDelegate?  //holds the reference to the delegate
    
    @IBOutlet weak var sliderBrush: UISlider!
    @IBOutlet weak var sliderOpacity: UISlider!
    
    @IBOutlet weak var imageViewBrush: UIImageView!
    @IBOutlet weak var imageViewOpacity: UIImageView!

    @IBOutlet weak var labelBrush: UILabel!
    @IBOutlet weak var labelOpacity: UILabel!
    
    @IBOutlet weak var sliderRed: UISlider!
    @IBOutlet weak var sliderGreen: UISlider!
    @IBOutlet weak var sliderBlue: UISlider!

    @IBOutlet weak var labelRed: UILabel!
    @IBOutlet weak var labelGreen: UILabel!
    @IBOutlet weak var labelBlue: UILabel!
    
    var brush: CGFloat = 2.0
    var opacity: CGFloat = 1.0
    
    var red: CGFloat = 0.0
    var green: CGFloat = 0.0
    var blue: CGFloat = 0.0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var nav = self.navigationController?.navigationBar
        nav!.frame.origin.y = -10
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func close(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
        self.delegate?.settingsViewControllerFinished(self) //send signal to delegate
    }
    
    @IBAction func colorChanged(sender: UISlider) {
        //println("Changing the color...")
        red = CGFloat(sliderRed.value / 255.0)  //takes the value of the red slider
        labelRed.text = NSString(format: "%d", Int(sliderRed.value)) as String
        
        green = CGFloat(sliderGreen.value / 255.0)  //takes the value of the green slider
        labelGreen.text = NSString(format: "%d", Int(sliderGreen.value)) as String
        
        blue = CGFloat(sliderBlue.value / 255.0)  //takes the value of the blue slider
        labelBlue.text = NSString(format: "%d", Int(sliderBlue.value)) as String
        
        drawPreview()
    }
    
    @IBAction func sliderChanged(sender: UISlider) {
        //Conditions for which slider is used
        if sender == sliderBrush {
            brush = CGFloat(sender.value)   //take the slider's value
            labelBrush.text = NSString(format: "%.1f", brush.native) as String  //print the value in the text
        }
        else {  //other slider is the opacity slider
            opacity = CGFloat(sender.value)
            labelOpacity.text = NSString(format: "%.2f", opacity.native) as String
        }
        
        drawPreview()
    }
    
    func drawPreview() {
        UIGraphicsBeginImageContextWithOptions(imageViewBrush.frame.size, false, 0.0)
        var context = UIGraphicsGetCurrentContext()
        
        CGContextSetLineCap(context, kCGLineCapRound)   //a round point
        CGContextSetLineWidth(context, brush)   //changes size based on slider
        
        CGContextSetRGBStrokeColor(context, red, green, blue, 1.0)
        CGContextMoveToPoint(context, 45.0, 45.0)
        CGContextAddLineToPoint(context, 45.0, 45.0)
        CGContextStrokePath(context)
        imageViewBrush.image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        UIGraphicsBeginImageContextWithOptions(imageViewBrush.frame.size, false, 0.0)
        context = UIGraphicsGetCurrentContext()
        
        CGContextSetLineCap(context, kCGLineCapRound)
        CGContextSetLineWidth(context, 20)
        CGContextMoveToPoint(context, 45.0, 45.0)
        CGContextAddLineToPoint(context, 45.0, 45.0)
        
        CGContextAddLineToPoint(context, 45.0, 45.0)
        
        CGContextSetRGBStrokeColor(context, red, green, blue, opacity)
        CGContextStrokePath(context)
        imageViewOpacity.image = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
    }
    
    //Shows all saved values settings in the section
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        //Sets all values and shows the text for each label
        sliderBrush.value = Float(brush)
        //Format each value and cast it as a String
        labelBrush.text = String(format: "%.1f", brush.native)
        
        sliderOpacity.value = Float(opacity)
        labelOpacity.text = String(format: "%.2f", opacity.native)
        
        sliderRed.value = Float(red * 255.0)
        labelRed.text = String(format: "%d", Int(sliderRed.value))
        
        sliderGreen.value = Float(green * 255.0)
        labelGreen.text = String(format: "%d", Int(sliderGreen.value))
        
        sliderBlue.value = Float(blue * 255.0)
        labelBlue.text = String(format: "%d", Int(sliderBlue.value))
        
        drawPreview()
        //println("Paintbrush and labels loaded.")
    }

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
  // Get the new view controller using segue.destinationViewController.
  // Pass the selected object to the new view controller.
  }
  */

}
