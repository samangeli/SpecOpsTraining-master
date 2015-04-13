//
//  styles.swift
//  Out of Sight
//
//  Created by Sam Angeli on 15/02/2015.
//  Copyright (c) 2015 Sam Angeli. All rights reserved.
//

import Foundation
import UIKit
import CoreImage




//Buttons

class YellowButtonStyle: UIButton {

        required init(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
            self.layer.cornerRadius = 0;
            self.layer.borderColor = UIColor(red: (245/255.0), green: (166/255.0), blue: (35/255.0), alpha: 1.0).CGColor
            self.layer.borderWidth = 2.0
            self.backgroundColor = UIColor(red:(13/255.0), green: (14/255.0), blue: (18/255.0), alpha: 0.6)
            self.tintColor = UIColor.clearColor()
            self.setTitleColor(UIColor(red: (245/255.0), green: (166/255.0), blue: (35/255.0), alpha: 1.0), forState: UIControlState.Normal)
            
    }
    
    
    override var highlighted: Bool {
        didSet {
            
            if (highlighted) {
                self.backgroundColor = UIColor(red: (245/255.0), green: (166/255.0), blue: (35/255.0), alpha: 0.6)
            }
            else {
                self.backgroundColor =  UIColor(red:(13/255.0), green: (14/255.0), blue: (18/255.0), alpha: 0.6)
            }
            
        }
    }
}


class GreenButtonStyle: UIButton {
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.cornerRadius = 0;
        self.layer.borderColor = UIColor(red: (126/255.0), green: (211/255.0), blue: (33/255.0), alpha: 1.0).CGColor
        self.layer.borderWidth = 2.0
        self.backgroundColor = UIColor(red:(13/255.0), green: (14/255.0), blue: (18/255.0), alpha: 0.6)
        self.tintColor = UIColor.clearColor()
        self.setTitleColor(UIColor(red: (126/255.0), green: (211/255.0), blue: (33/255.0), alpha: 1.0), forState: UIControlState.Normal)
        
    }
    
    
    override var highlighted: Bool {
        didSet {
            
            if (highlighted) {
                self.backgroundColor = UIColor(red: (126/255.0), green: (211/255.0), blue: (33/255.0), alpha: 0.6)
            }
            else {
                self.backgroundColor =  UIColor(red:(13/255.0), green: (14/255.0), blue: (18/255.0), alpha: 0.6)
            }
            
        }
    }
}

class MainButtonAccent: UIImageView {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor(red: (245/255.0), green: (166/255.0), blue: (35/255.0), alpha: 1.0)
    }

}

class MainButtonAccentGreen: UIImageView {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor(red: (126/255.0), green: (211/255.0), blue: (33/255.0), alpha: 1.0)
    }
    
}


// Styles Mission Briefing

class UnlockBar: UIImageView {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor(red:(245/255.0), green: (166/255.0), blue: (35/255.0), alpha: 1.0)
    }
    
}

class Unlocked: UIImageView {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.layer.borderColor = UIColor(red: (245/255.0), green: (166/255.0), blue: (35/255.0), alpha: 1.0).CGColor
        self.layer.borderWidth = 1.0
    }
    
}

//Borders


class BorderBottom: UIImageView {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        var border = CALayer()
        var width = CGFloat(1.0)
        border.borderColor = UIColor(red: (105/255), green: (107/255), blue: (115/255), alpha: 0.2).CGColor
        border.frame = CGRect(x: 0, y: self.frame.size.height - width, width: self.frame.size.width, height: self.frame.size.height)
        border.borderWidth = width
        self.layer.addSublayer(border)
        self.layer.masksToBounds = true

    }

}

class Border: UIImageView {
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.backgroundColor = UIColor(red: (105/255), green: (107/255), blue: (115/255), alpha: 0.2)
    
    }
}




















































