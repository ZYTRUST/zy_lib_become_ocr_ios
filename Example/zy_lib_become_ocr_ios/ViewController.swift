//
//  ViewController.swift
//  zy-lib-become-ocr-ios
//
//  Created by Edwin Sanchez on 04/26/2022.
//  Copyright (c) 2022 Edwin Sanchez. All rights reserved.
//

import UIKit
import zy_lib_become_ocr_ios
import Alamofire


class ViewController: UIViewController {

    @IBAction func capturarButtonPressed(_ sender: Any){
        capturar()
    }
    
    @IBAction func enviarButtonPressed(_ sender: Any) {
        //enviar()
    }
    
    @IBOutlet weak var tvResult: UITextView!
    @IBOutlet weak var tvFirstName: UITextField!
    @IBOutlet weak var tvLastName: UITextField!
    
    @IBOutlet weak var tvMrz: UITextView!
    @IBOutlet weak var tvDateExp: UITextField!
    @IBOutlet weak var tvSex: UITextField!
    @IBOutlet weak var tvDateBirth: UITextField!
    @IBOutlet weak var tvAge: UITextField!
    
    @IBOutlet weak var imageFront: UIImageView!
    
    @IBOutlet weak var imageRear: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tvResult.layer.borderWidth=2
        tvResult.layer.borderColor=UIColor.red.cgColor
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    let token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2NTM0OTAyODQsIm5iZiI6MTY1MzQ5MDI4NCwianRpIjoiY2RmMTFlNjUtMjVhYi00MWY0LThkMjUtNDc5M2E4MGYwZWFmIiwiZXhwIjoxNjUzNDkzODg0LCJpZGVudGl0eSI6eyJjbGllbnRfaWQiOiJ6eXRydXN0X3Rlc3QiLCJjb21wYW55X2lkIjozOCwiaXNfZGFzaGJvYXJkX3VzZXIiOmZhbHNlLCJpc19yZXZpZXdlciI6ZmFsc2UsInJvbGVfaWQiOjEsImNvbXBhbnlfaW5mbyI6eyJjb21wYW55X2NvdW50cnkiOiJDMCIsImNvbXBhbnlfc3RhdGUiOiIiLCJjb21wYW55X2FkZHJlc3MiOiJOQSIsImNvbXBhbnlfbGVnYWxfcmVwcmVzZW50YXRpdmUiOiJOQSIsImNvbXBhbnlfcGhvbmUiOiIwIn19LCJmcmVzaCI6ZmFsc2UsInR5cGUiOiJhY2Nlc3MifQ.MTT92gz4aQ8zPbceooxy4BngArBPt3vOHARe3f22YB8"
    
    func capturar(){
        
        let ocrBio = ZyOcr(onView: self)
        
        var ocrRequest = ZyOcrRequest()
        ocrRequest.contractId = "46"
        ocrRequest.token = token
        ocrRequest.userId = "3046"
        ocrRequest.formatoFecha = "dd/MM/yy"
        ocrRequest.allowLibraryLoading = true
        
        ocrBio.capturar(request: ocrRequest, validarAutenticidad: true)
        { (result:(ZyOcrResult<ZyOcrResponse, ZyOcrError>)) in
            switch result {
                case .success(let response):
                
                    let ocr = response.zyBecomeOcr
                
                    self.imageFront.image = response.zyBecomeOcr.frontImage?.imageFromBase64
                    self.imageRear.image = response.zyBecomeOcr.backImage?.imageFromBase64
                    
                
                    self.tvFirstName.text = ocr.firstName
                    self.tvLastName.text = ocr.lastName
                    self.tvSex.text = ocr.sex
                    self.tvAge.text = ocr.age
                    self.tvDateExp.text = ocr.dateOfExpiry
                    self.tvDateBirth.text = ocr.dateOfBirth
                    self.tvMrz.text = ocr.mrzText
                    
                    self.tvResult.text = "statusCode:\(ocr.statusCode) qualityScore:\(ocr.qualityScore) livenessScore:\(ocr.livenessScore)  livenessProbability:\(ocr.livenessProbability) apPaterno:\(ocr.apPaterno) apMaterno:\(ocr.apMaterno)   "
                
                
                case .error(let error):
                    self.tvResult.text = error.deError
            }
        }
        
    }
    
    func enviar(image:String){
        
        let ocrBio = ZyOcr(onView: self)
        
        var ocrRequest = ZyOcrRequest()
        ocrRequest.contractId = "46"
        ocrRequest.token = token
        ocrRequest.userId = "3042"
        ocrRequest.fullFrontImage = image
#if !targetEnvironment(simulator)

        ocrBio.enviar(request: ocrRequest, zyOcrResponse: nil)
        { (result:(ZyOcrResult<ZyOcrResponse, ZyOcrError>)) in
            switch result {
                case .success(let response):
                    let ocr = response.zyBecomeOcr
                    self.tvResult.text = "statusCode:\(ocr.statusCode) qualityScore:\(ocr.qualityScore) livenessScore:\(ocr.livenessScore)  livenessProbability:\(ocr.livenessProbability) "
                
                case .error(let error):
                    self.tvResult.text = error.deError
            }
        }
        #endif
        
        
    }

}

extension String {
    
    var imageFromBase64: UIImage? {
        
        guard let imageData = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
            return nil
        }
        return UIImage(data: imageData)
    }
}
