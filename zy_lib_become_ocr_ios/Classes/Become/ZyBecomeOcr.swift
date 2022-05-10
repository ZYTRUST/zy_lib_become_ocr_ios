//
//  ZyBecomeOcr.swift
//  zy-lib-become-ocr-ios
//
//  Created by Edwin on 04/27/2022.
// 

import Foundation
import BecomeDigitalV

class ZyBecomeOcr: UIViewController, BDIVDelegate {
    
    private var vc: UIViewController!
    typealias CallbackOcr = ((ZyOcrResult<ZyOcrResponse, ZyOcrErrorEnum>)) -> Void
    private var callback:CallbackOcr!
    private var zyOcrResponseCapturar:ZyOcrResponse?
    
    weak var delegate: BDIVDelegate?
    
    var request:ZyOcrRequest!
    
    func capturar(request:ZyOcrRequest,
                  completion:@escaping CallbackOcr){
        
        self.request = request
        
        self.callback = completion
        
        let bdivConfig = BDIVConfig(token: request.token!,
                                    contractId: request.contractId!,
                                    userId: request.userId!,
                                    ItFirstTransaction: true)
        
        print("bdivConfig \(String(describing: bdivConfig))")
        
        BDIVCallBack.sharedInstance.delegate = self
        BDIVCallBack.sharedInstance.register(bdivConfig: bdivConfig)
    }
    
    func enviarImagen(request:ZyOcrRequest,
                      zyOcrResponse:ZyOcrResponse?,completion:@escaping CallbackOcr){
        
        //print(String(describing: request))
        
        self.callback = completion
        self.zyOcrResponseCapturar = zyOcrResponse
        
        let bdivConfig = BDIVConfig(token: request.token!,
                                    contractId: request.contractId!,
                                    userId: request.userId!,
                                    ItFirstTransaction: false,
                                    imgData: (request.fullFrontImage?.dataFromBase64)! )
        
        //imgData: (UIImagePNGRepresentation((request.fullFronImage?.imageFromBase64!)!)!))
        print("bdivConfig \(String(describing: bdivConfig))")
        
        BDIVCallBack.sharedInstance.delegate = self
        BDIVCallBack.sharedInstance.register(bdivConfig: bdivConfig)
    }

    public  func BDIVResponseSuccess(bdivResult: AnyObject) {
        let responseIV = bdivResult as! ResponseIV
        
        print(String(describing: responseIV))
        var zyBecomeOcr = ZyBecomeOcrResponse()
        if (self.zyOcrResponseCapturar != nil){
            zyBecomeOcr = self.zyOcrResponseCapturar?.zyBecomeOcr ?? zyBecomeOcr
        }
        
        if(responseIV.IsFirstTransaction){
            zyBecomeOcr.frontImage = responseIV.frontImage?.jpegBase64
            zyBecomeOcr.backImage = responseIV.backImage?.jpegBase64
            zyBecomeOcr.fullBackImage = responseIV.fullBackImage?.pngBase64
            zyBecomeOcr.fullFronImage = responseIV.fullFronImage?.pngBase64
            
            zyBecomeOcr.firstName = responseIV.firstName
            zyBecomeOcr.lastName = responseIV.lastName
            zyBecomeOcr.dateOfExpiry = responseIV.dateOfExpiry.stringByFormatter(format: self.request.formatoFecha)
            zyBecomeOcr.dateOfBirth = responseIV.dateOfBirth.stringByFormatter(format: self.request.formatoFecha)
            zyBecomeOcr.age = String(responseIV.age)
            zyBecomeOcr.sex = responseIV.sex
            zyBecomeOcr.mrzText = responseIV.mrzText
            zyBecomeOcr.barcodeResult = responseIV.barcodeResult
            zyBecomeOcr.responseStatus = String(describing: responseIV.responseStatus)
        }
        else{
            let validacion = responseIV.documentValidation
            if let quality_score = validacion["quality_score"] as? String {
                zyBecomeOcr.qualityScore = quality_score
            }
            if let liveness_score = validacion["liveness_score"] as? String {
                zyBecomeOcr.livenessScore = liveness_score
            }
            if let liveness_probability = validacion["liveness_probability"] as? String {
                zyBecomeOcr.livenessProbability = liveness_probability
            }
            if let status_code = validacion["status_code"] as? String {
                zyBecomeOcr.statusCode = status_code
            }
        }
        
        let response = ZyOcrResponse(zyBecomeOcr: zyBecomeOcr)
        
        
        callback(.success(response))
    }
    
    public  func BDIVResponseError(error: String) {
        let errorNoSpace = error.stringByRemovingAll(subStrings: [" "]).uppercased()
        print("zyttt \(errorNoSpace)")
        
        //TOKENHASEXPIRED
        if errorNoSpace == "CANCELEDBYUSER"{
            callback(.error(.CAPTURA_CANCELADA))
        }
        else if errorNoSpace == "INCORRECTSDKCONFIGURATION" {
            callback(.error(.INICIALIZACION_ERROR))
        }
        callback(.error(.INICIALIZACION_ERROR))
        
    }
    
}
