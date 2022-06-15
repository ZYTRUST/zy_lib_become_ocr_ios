//
//  ZyBecomeOcr.swift
//  zy-lib-become-ocr-ios
//
//  Created by Edwin on 04/27/2022.
// 

import Foundation
#if !targetEnvironment(simulator)
import BecomeDigitalV
#endif

#if !targetEnvironment(simulator)
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
        
        var  nameStringFile = request.stringTextName ?? "zyLocalizable"
        
        let bdivConfig = BDIVConfig(token: request.token!,
                                    contractId: request.contractId!,
                                    userId: request.userId!,
                                    ItFirstTransaction: true ,
                                    customLocalizationFileName: nameStringFile )
        
        print("bdivConfig \(String(describing: bdivConfig))")
        
        BDIVCallBack.sharedInstance.delegate = self
        BDIVCallBack.sharedInstance.register(bdivConfig: bdivConfig)
    }
    
    func enviarImagen(request:ZyOcrRequest,
                      zyOcrResponse:ZyOcrResponse?,completion:@escaping CallbackOcr){
        
        //print(String(describing: request))
        var bdivConfig:BDIVConfig? = nil
        
        self.callback = completion
        self.zyOcrResponseCapturar = zyOcrResponse
        
        if(request.becomePais != nil && request.becomePais != ""){
            
            bdivConfig = BDIVConfig(token: request.token!,
                                        contractId: request.contractId!,
                                        userId: request.userId!,
                                        documentNumber: request.becomeNroDoc! ,
                                        ItFirstTransaction: false,
                                    imgData: (request.fullFrontImage!.pngData()!))
         
        } else{
            callback(.error(.NO_BIO_PAIS))
            return
            
        }
    
        
        //imgData: (UIImagePNGRepresentation((request.fullFronImage?.imageFromBase64!)!)!))
        print("bdivConfig \(String(describing: bdivConfig))")
        
        BDIVCallBack.sharedInstance.delegate = self
        BDIVCallBack.sharedInstance.register(bdivConfig: bdivConfig!)
        
    }
    
#if !targetEnvironment(simulator)
    public  func BDIVResponseSuccess(bdivResult: AnyObject) {
        let responseIV = bdivResult as! ResponseIV
        
        print(String(describing: responseIV))
        var zyBecomeOcr = ZyBecomeOcrResponse()
        if (self.zyOcrResponseCapturar != nil){
            zyBecomeOcr = self.zyOcrResponseCapturar?.zyBecomeOcr ?? zyBecomeOcr
        }
        
        if(responseIV.IsFirstTransaction){
            zyBecomeOcr.frontImage = responseIV.frontImage
            zyBecomeOcr.backImage = responseIV.backImage
            zyBecomeOcr.fullBackImage = responseIV.fullBackImage
            zyBecomeOcr.fullFronImage = responseIV.fullFronImage
            
            zyBecomeOcr.firstName = responseIV.firstName
            zyBecomeOcr.lastName = responseIV.lastName
            zyBecomeOcr.documentNumber = responseIV.documentNumber
            zyBecomeOcr.ocrPais = responseIV.countryName
            zyBecomeOcr.ocrIsoAlpha2CountryCode = responseIV.isoAlpha2CountryCode
            zyBecomeOcr.ocrIsoAlpha3CountryCode = responseIV.isoAlpha2CountryCode
            zyBecomeOcr.ocrIsoNumericCountryCode = responseIV.isoNumericCountryCode

            do{
                if (responseIV.lastName != nil && responseIV.lastName != ""){
                    let apellidos = responseIV.lastName.components(separatedBy: "\n")
                    let arrayNumber = apellidos.count
                    if (arrayNumber >= 1){
                        zyBecomeOcr.apPaterno = try? apellidos[0]
                    }
                    if (arrayNumber >= 2){
                        zyBecomeOcr.apMaterno = try? apellidos[1]
                    }
                }
            
                
            } catch{
                zyBecomeOcr.apPaterno = ""
                zyBecomeOcr.apPaterno = ""
                
            }
            
            
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
            if let quality_score = validacion["quality_score"] as? Double {
                zyBecomeOcr.qualityScore = String(format: "%f", quality_score)
                
            }
            if let liveness_score = validacion["liveness_score"] as? Double {
                zyBecomeOcr.livenessScore = String(format: "%f", liveness_score)
            }
            if let liveness_probability = validacion["liveness_probability"] as? Double {
                zyBecomeOcr.livenessProbability = String(format: "%f", liveness_probability)
            }
            if let status_code = validacion["status_code"] as? String {
                zyBecomeOcr.statusCode = status_code
            }
        }
        
        let response = ZyOcrResponse(zyBecomeOcr: zyBecomeOcr)
        
        
        callback(.success(response))
    }
#endif
    
    public  func BDIVResponseError(error: String) {
        let errorNoSpace = error.stringByRemovingAll(subStrings: [" "]).uppercased()
        print("zyttt \(errorNoSpace)")
        
        //TOKENHASEXPIRED
        if errorNoSpace == "CANCELEDBYUSER"{
            callback(.error(.CAPTURA_CANCELADA))
            return
        }
        else if errorNoSpace == "INCORRECTSDKCONFIGURATION" {
            callback(.error(.INICIALIZACION_ERROR))
            return
        }
        else if errorNoSpace == "TOKENHASEXPIRED" {
            callback(.error(.BECOME_TOKEN_EXPIRED))
            return
        }
        callback(.error(.INICIALIZACION_ERROR))
        
    }
    
}
#endif
