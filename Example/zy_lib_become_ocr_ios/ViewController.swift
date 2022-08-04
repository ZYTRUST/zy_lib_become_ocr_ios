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
    
    let token = "eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpYXQiOjE2NTk1ODU1NzIsIm5iZiI6MTY1OTU4NTU3MiwianRpIjoiMDUxNzA4MDAtZTM1Ni00NjQzLWExNWQtYjFjNWQ1NWZiZWRjIiwiZXhwIjoxNjU5NTg5MTcyLCJpZGVudGl0eSI6eyJjbGllbnRfaWQiOiJ6eXRydXN0X3Rlc3QiLCJjb21wYW55X2lkIjozOCwiaXNfZGFzaGJvYXJkX3VzZXIiOmZhbHNlLCJpc19yZXZpZXdlciI6ZmFsc2UsInJvbGVfaWQiOjEsInBlcm1pc3Npb24iOm51bGwsImNvbXBhbnlfaW5mbyI6eyJjb21wYW55X2NvdW50cnkiOiJDMCIsImNvbXBhbnlfc3RhdGUiOiIiLCJjb21wYW55X2FkZHJlc3MiOiJOQSIsImNvbXBhbnlfbGVnYWxfcmVwcmVzZW50YXRpdmUiOiJOQSIsImNvbXBhbnlfcGhvbmUiOiIwIn19LCJmcmVzaCI6ZmFsc2UsInR5cGUiOiJhY2Nlc3MifQ.5KZvK2fNmm21okSA2RtCirFmzz-kpFu-x1vbHOYyiB4"
    
    func capturar(){
        
        let ocrBio = ZyOcr(onView: self)
        
        var ocrRequest = ZyOcrRequest()
        ocrRequest.contractId = "46"
        ocrRequest.token = token
        let mytime = Date()
        let format = DateFormatter()
        format.dateFormat = "yyMMddHHmmss"
        
        ocrRequest.userId = "3046" + "_" + format.string(from: mytime)
        ocrRequest.becomePais = "CO"
        ocrRequest.formatoFecha = "dd/MM/yy"
        ocrRequest.allowLibraryLoading = true
        ocrRequest.stringTextName = "zyLocalizable"
        print("userId : \(ocrRequest.userId)")
        ocrBio.capturar(request: ocrRequest, validarAutenticidad: true)
        { (result:(ZyOcrResult<ZyOcrResponse, ZyOcrError>)) in
            switch result {
                case .success(let response):
                
                    let ocr = response.zyBecomeOcr
                
                self.imageFront.image = response.zyBecomeOcr.frontImage
                
                self.imageRear.image = response.zyBecomeOcr.backImage
                
                
                    self.tvFirstName.text = ocr.firstName
                    self.tvLastName.text = ocr.lastName
                    self.tvSex.text = ocr.sex
                    self.tvAge.text = ocr.age
                    self.tvDateExp.text = ocr.dateOfExpiry
                    self.tvDateBirth.text = ocr.dateOfBirth
                    self.tvMrz.text = ocr.mrzText
                    
                self.tvResult.text = "statusCode:\(ocr.statusCode) qualityScore:\(ocr.qualityScore) livenessScore:\(ocr.livenessScore)  livenessProbability:\(ocr.livenessProbability) apPaterno:\(ocr.apPaterno) apMaterno:\(ocr.apMaterno) placeBirth:\(ocr.placeOfBirth) DateOfIssue:\(ocr.dateOfIssue) registraduriaName:\(ocr.zyRegistraduria?.registraduriaName) registraduriaNuDocu:\(ocr.zyRegistraduria?.registraduriaDocumentNumber) tipo:\(ocr.typeDoc?.rawValue)"
                
                print("\(response.zyBecomeOcr)")

                case .error(let error):
                    self.tvResult.text = error.deError
            }
        }
        
    }
    
    func enviar(image:UIImage){
        
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
                    print("\(response.zyBecomeOcr)")
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
