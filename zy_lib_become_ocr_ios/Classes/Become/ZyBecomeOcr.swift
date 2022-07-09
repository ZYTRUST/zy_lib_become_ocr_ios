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
    typealias CallbackOcr = ((ZyOcrResult<ZyOcrResponse, ZyLibOcrError>)) -> Void
    private var callback:CallbackOcr!
    private var zyOcrResponseCapturar:ZyOcrResponse?
    private var zyBecomeOcr = ZyBecomeOcrResponse()
    
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
            print("===>>>becomePais: \(request.becomePais)")
            switch (request.becomePais?.uppercased() ) {
            case "CO":
                print("===>>> DOCUMENTO COLOMBIA")
                bdivConfig = BDIVConfig(token: request.token!,
                                        contractId: request.contractId!,
                                        userId: request.userId!,
                                        documentNumber: request.becomeNroDoc!,
                                        ItFirstTransaction: false,
                                        imgData: (request.fullFrontImage!.pngData()!))
                break
            case "PE":
                print("===>>> DOCUMENTO PERU")
                bdivConfig = BDIVConfig(token: request.token!,
                                        contractId: request.contractId!,
                                        userId: request.userId!,
                                        ItFirstTransaction: false,
                                        imgData: (request.fullFrontImage!.pngData()!))
                break
            default:
                print("===>>> DEFAULT ERROR")
                callback(.error(ZyLibOcrError(coError:ZyOcrErrorEnum.BECOME_ERROR_DOC_PAIS_NO_SOPORTADO.rawValue ,
                                              deError:ZyOcrErrorEnum.BECOME_ERROR_DOC_PAIS_NO_SOPORTADO.descripcion )))
                return
            }
            
            
        } else {
            callback(.error(ZyLibOcrError(coError:ZyOcrErrorEnum.NO_BIO_PAIS.rawValue ,
                                          deError:ZyOcrErrorEnum.NO_BIO_PAIS.descripcion )))
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
        else {
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
            
            self.analisisRegistraduria(responseIV:responseIV)
            
            
            
        }
        
        let response = ZyOcrResponse(zyBecomeOcr: zyBecomeOcr)
        
        
        callback(.success(response))
    }
#endif
    
    private func analisisRegistraduria( responseIV:ResponseIV){
        print("===>> Informacion de Registraduria")
        print("===>> Informacion de Registraduria CO: -> \(responseIV.registryInformation)")
        zyBecomeOcr.zyRegistraduria =  ZyRegistraduria()

        if (zyBecomeOcr.ocrIsoAlpha2CountryCode != "CO"){
            print("===>> BECOME_BECOME_REGISTRADURIA_DOCUMENTO_NO_COLOMBIA")
            
            zyBecomeOcr.zyRegistraduria?.coErrorRegistraduria = ZyOcrErrorEnum.BECOME_BECOME_REGISTRADURIA_DOCUMENTO_NO_COLOMBIA.rawValue
            zyBecomeOcr.zyRegistraduria?.deErrorRegistraduria = ZyOcrErrorEnum.BECOME_BECOME_REGISTRADURIA_DOCUMENTO_NO_COLOMBIA.descripcion
            return
        }
        
        if (responseIV.registryInformation.isEmpty ){
            print("===>> responseIV.registryInformation isEmpty")
            zyBecomeOcr.zyRegistraduria?.coErrorRegistraduria = ZyOcrErrorEnum.BECOME_ERROR_BECOME_NOREGISTRY_DATA.rawValue
            zyBecomeOcr.zyRegistraduria?.deErrorRegistraduria = ZyOcrErrorEnum.BECOME_ERROR_BECOME_NOREGISTRY_DATA.descripcion
            
            print("===>> responseIV.registryInformation DUMMY")
            zyBecomeOcr.zyRegistraduria?.registraduriaAgeRange = "30-40"
            zyBecomeOcr.zyRegistraduria?.registraduriaDocumentNumber = "00000000"
            zyBecomeOcr.zyRegistraduria?.registraduriaEmissionDate = "12/23/22"
            zyBecomeOcr.zyRegistraduria?.registraduriaFullName = "CACERES ZEVALLOS IVAN ALEXANDRE"
            zyBecomeOcr.zyRegistraduria?.registraduriaGender = "F"
            zyBecomeOcr.zyRegistraduria?.registraduriaIssuePlace = "BOGOTA DC"
            zyBecomeOcr.zyRegistraduria?.registraduriaName = "IVAN"
            zyBecomeOcr.zyRegistraduria?.registraduriaMiddleName = "ALEXANDRE"
            zyBecomeOcr.zyRegistraduria?.registraduriaSurname = "CACERES"
            zyBecomeOcr.zyRegistraduria?.registraduriaSecondSurname = "ZEVALLOS"
            
            return
        }
        
        print("===>> ParserData Registraduria")
        
        zyBecomeOcr.zyRegistraduria?.coErrorRegistraduria = ZyOcrErrorEnum.EXITO.rawValue
        zyBecomeOcr.zyRegistraduria?.deErrorRegistraduria = ZyOcrErrorEnum.EXITO.descripcion
        
        zyBecomeOcr.zyRegistraduria?.registraduriaAgeRange = "30-40"
        zyBecomeOcr.zyRegistraduria?.registraduriaDocumentNumber = "00000000"
        zyBecomeOcr.zyRegistraduria?.registraduriaEmissionDate = "12/23/22"
        zyBecomeOcr.zyRegistraduria?.registraduriaFullName = "CACERES ZEVALLOS IVAN ALEXANDRE"
        zyBecomeOcr.zyRegistraduria?.registraduriaGender = "F"
        zyBecomeOcr.zyRegistraduria?.registraduriaIssuePlace = "BOGOTA DC"
        zyBecomeOcr.zyRegistraduria?.registraduriaName = "IVAN"
        zyBecomeOcr.zyRegistraduria?.registraduriaMiddleName = "ALEXANDRE"
        zyBecomeOcr.zyRegistraduria?.registraduriaSurname = "CACERES"
        zyBecomeOcr.zyRegistraduria?.registraduriaSecondSurname = "ZEVALLOS"

        
    }
    
    public  func BDIVResponseError(error: String) {
        let errorNoSpace = error.stringByRemovingAll(subStrings: [" "]).uppercased()
        print("zyttt \(errorNoSpace)")
        
        //TOKENHASEXPIRED
        if errorNoSpace == "CANCELEDBYUSER"{
            callback(.error(ZyLibOcrError(coError:ZyOcrErrorEnum.CAPTURA_CANCELADA.rawValue ,deError: ZyOcrErrorEnum.CAPTURA_CANCELADA.descripcion)))
            return
        }
        else if errorNoSpace == "INCORRECTSDKCONFIGURATION" {
            callback(.error(ZyLibOcrError(coError:ZyOcrErrorEnum.INICIALIZACION_ERROR.rawValue ,deError: ZyOcrErrorEnum.INICIALIZACION_ERROR.descripcion)))
            return
        }
        else if errorNoSpace == "TOKENHASEXPIRED" {
            callback(.error(ZyLibOcrError(coError:ZyOcrErrorEnum.BECOME_TOKEN_EXPIRED.rawValue ,deError: ZyOcrErrorEnum.BECOME_TOKEN_EXPIRED.descripcion)))
            return
        }
        else if errorNoSpace == "NORESULTSWEREFOUNDINTHECOLOMBIANREGISTRADURIADATABASE" {
            callback(.error(ZyLibOcrError(coError:ZyOcrErrorEnum.BECOME_WS_BECOME_NO_REGISTRY.rawValue ,
                                          deError: ZyOcrErrorEnum.BECOME_WS_BECOME_NO_REGISTRY.descripcion)))
            return
        }
        
        callback(.error(ZyLibOcrError(coError:ZyOcrErrorEnum.INICIALIZACION_ERROR.rawValue ,
                                      deError: "\(ZyOcrErrorEnum.INICIALIZACION_ERROR.descripcion) ,ErrorOrigen: \(errorNoSpace)" )))
    }
    
}
#endif
