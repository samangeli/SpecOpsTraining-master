//
//  TheMissionViewController.swift
//  Out of Sight
//
//  Created by Sam Angeli on 11/02/2015.
//  Copyright (c) 2015 Sam Angeli. All rights reserved.
//


import UIKit
import MapKit


class TheMissionViewController: UIViewController, MKMapViewDelegate {


    @IBOutlet var Map: MKMapView!

  //  @IBOutlet var imageView: UIImageView!


        override func viewDidLoad() {
        super.viewDidLoad()
            
        /*    let fileURL = NSBundle.mainBundle().URLForResource("testoverlay", withExtension: "png")
            
            // 2
            let beginImage = CIImage(contentsOfURL: fileURL)
            
            // 3
            let filter = CIFilter(name: "CISepiaTone")
            filter.setValue(beginImage, forKey: kCIInputImageKey)
            filter.setValue(0.5, forKey: kCIInputIntensityKey)
            
            // 1
            let context = CIContext(options:nil)
            
            // 2
            let cgimg = context.createCGImage(filter.outputImage, fromRect: filter.outputImage.extent())
            
            // 3
            let newImage = UIImage(CGImage: cgimg)
            self.imageView.image = newImage*/
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
            
            
    
         // Do any additional setup after loading the view.

}