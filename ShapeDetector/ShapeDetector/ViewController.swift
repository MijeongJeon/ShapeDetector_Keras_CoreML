//
//  ViewController.swift
//  ShapeDetector
//
//  Created by Mijeong Jeon on 30/10/2017.
//  Copyright © 2017 MijeonJeon. All rights reserved.
//

import UIKit
import CoreML

class ViewController: UIViewController {
    // MARK: - Properties
    @IBOutlet weak var drawView: DrawingView!
    @IBOutlet weak var resultLabel: UILabel!
    
    private var inputArray: MLMultiArray!
    
    // MARK: - App Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Init CoreML Array
        let tensorShape: [NSNumber] = [28, 28, 3]
        inputArray = try? MLMultiArray(shape: tensorShape, dataType: .float32)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    // MARK: - Botton Action
    @IBAction func clearTapped(_sender: UIButton) {
        let theDrawView: DrawingView = drawView
        theDrawView.lines = []
        theDrawView.setNeedsDisplay()
        self.resultLabel.text = "Result"
    }
    
    @IBAction func checkTapped(_sender: UIButton) {
        guard let pixelBuffer = getImagePixel() else {
            return
        }
        // ComreML Model create and get output
        let model = shape_detect_with_keras()
        guard let output: shape_detect_with_kerasOutput = try? model.prediction(image: pixelBuffer) else {
            return
        }
        // Get highest proportion
        var shape: String = String()
        var value: Double = 0.0
        
        for i in output.class_ {
            if i.value > value {
                shape = String(i.key)
            }
            value = i.value
        }
        self.resultLabel.text = shape
    }
    
    // Get Image Pixel from Drawing View
    func getImagePixel() -> CVPixelBuffer? {
        // Get image from view
        let theDrawView: DrawingView = drawView
        let imageSize: CGSize = CGSize(width: 28, height: 28)
        
        UIGraphicsBeginImageContextWithOptions(imageSize, false, 1)
        
        theDrawView.drawHierarchy(in: CGRect(x: 0, y: 0, width: imageSize.width, height: imageSize.height), afterScreenUpdates: true)
        var resizedImage = UIImage()
        resizedImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        let width: Int = Int(resizedImage.size.width)
        let height: Int = Int(resizedImage.size.height)
        
        // Change image to pixel
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, width, height, kCVPixelFormatType_32ARGB, attrs, &pixelBuffer)
        guard (status == kCVReturnSuccess) else {
            return nil
        }
        
        CVPixelBufferLockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer!)
        
        let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
        let context = CGContext(data: pixelData, width: width, height: height, bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer!), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
        
        context?.translateBy(x: 0, y: resizedImage.size.height)
        context?.scaleBy(x: 1.0, y: -1.0)
        
        UIGraphicsPushContext(context!)
        resizedImage.draw(in: CGRect(x: 0, y: 0, width: resizedImage.size.width, height: resizedImage.size.height))
        UIGraphicsPopContext()
        CVPixelBufferUnlockBaseAddress(pixelBuffer!, CVPixelBufferLockFlags(rawValue: 0))
        
        return pixelBuffer
    }
}
