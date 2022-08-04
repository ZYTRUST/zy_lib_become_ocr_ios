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
        let bdivConfig = BDIVConfig(ItFirstTransaction: true,
                                    token: request.token!,
                                    contractId: request.contractId!,
                                    userId: request.userId! ,
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
                bdivConfig = BDIVConfig(ItFirstTransaction: false,
                                        token: request.token!,
                                        contractId: request.contractId!,
                                        userId: request.userId!,
                                        documentNumber: request.becomeNroDoc!,
                                        isoAlpha2CountryCode: request.isoAlpha2CountryCode!,
                                        type: request.rawValue!,
                                        imgDataFullFront: (request.fullFrontImage!.pngData()!) ,
                                        imgDataCroppetBack:  request.backImage!.pngData()! ,
                                        barcodeResultData: request.barcodeResult!)
                break
            case "PE":
                print("===>>> DOCUMENTO PERU")
                bdivConfig = BDIVConfig(ItFirstTransaction: false,
                                        token: request.token!,
                                        contractId: request.contractId!,
                                        userId: request.userId!,
                                        isoAlpha2CountryCode: request.isoAlpha2CountryCode!,
                                        type: request.rawValue!,
                                        imgDataFullFront: (request.fullFrontImage!.pngData()!),
                                        barcodeResultData: request.barcodeResult!)
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
            zyBecomeOcr.barcodeResult = responseIV.barcodeResult

            zyBecomeOcr.firstName = responseIV.firstName
            zyBecomeOcr.lastName = responseIV.lastName
            zyBecomeOcr.documentNumber = responseIV.documentNumber
            zyBecomeOcr.ocrPais = responseIV.countryName
            zyBecomeOcr.ocrIsoAlpha2CountryCode = responseIV.isoAlpha2CountryCode
            zyBecomeOcr.ocrIsoAlpha3CountryCode = responseIV.isoAlpha2CountryCode
            zyBecomeOcr.ocrIsoNumericCountryCode = responseIV.isoNumericCountryCode
            zyBecomeOcr.placeOfBirth = responseIV.placeOfBirth
            zyBecomeOcr.rawValue = responseIV.type.rawValue
            zyBecomeOcr.typeDoc = responseIV.type

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
            zyBecomeOcr.dateOfIssue =  responseIV.dateOfIssue.stringByFormatter(format: self.request.formatoFecha) 
            
            zyBecomeOcr.dateOfExpiry = responseIV.dateOfExpiry.stringByFormatter(format: self.request.formatoFecha)
            zyBecomeOcr.dateOfBirth = responseIV.dateOfBirth.stringByFormatter(format: self.request.formatoFecha)
            zyBecomeOcr.age = String(responseIV.age)
            zyBecomeOcr.sex = responseIV.sex
            zyBecomeOcr.mrzText = responseIV.mrzText
            
            zyBecomeOcr.barcodeResult = responseIV.barcodeResult
            zyBecomeOcr.barcodeResultData = responseIV.barcodeResultData
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
        
        if(zyBecomeOcr.typeDoc != .typeId){
            print("===>> Documento no es un Documento Nacional")
            
            zyBecomeOcr.zyRegistraduria?.coErrorRegistraduria = ZyOcrErrorEnum.BECOME_ERROR_BECOME_NOREGISTRY_DATA.rawValue
            zyBecomeOcr.zyRegistraduria?.deErrorRegistraduria = ZyOcrErrorEnum.BECOME_ERROR_BECOME_NOREGISTRY_DATA.descripcion
            return
        }
        
        
        let registraduria = responseIV.registryInformation

        if (responseIV.registryInformation.isEmpty ){
            print("===>> responseIV.registryInformation isEmpty")
            zyBecomeOcr.zyRegistraduria?.coErrorRegistraduria = ZyOcrErrorEnum.BECOME_ERROR_BECOME_NOREGISTRY_DATA.rawValue
            zyBecomeOcr.zyRegistraduria?.deErrorRegistraduria = ZyOcrErrorEnum.BECOME_ERROR_BECOME_NOREGISTRY_DATA.descripcion
                        
            return
        }
        
        print("===>> ParserData Registraduria: \(registraduria["data"] )")
        
        zyBecomeOcr.zyRegistraduria?.coErrorRegistraduria = ZyOcrErrorEnum.EXITO.rawValue
        zyBecomeOcr.zyRegistraduria?.deErrorRegistraduria = ZyOcrErrorEnum.EXITO.descripcion
        
        if let dataRegistraduria = registraduria["data"] as? NSDictionary {
            print("data Registraduria")
            if let ageRange = dataRegistraduria["ageRange"] as? String {
                zyBecomeOcr.zyRegistraduria?.registraduriaAgeRange = ageRange

            }
            
            if let documentNumber = dataRegistraduria["documentNumber"] as? String {
                zyBecomeOcr.zyRegistraduria?.registraduriaDocumentNumber =  documentNumber
                
            }
            if let emissionDate = dataRegistraduria["emissionDate"] as? String {
                zyBecomeOcr.zyRegistraduria?.registraduriaEmissionDate =  emissionDate
                
            }
            if let fullName = dataRegistraduria["fullName"] as? String {
                zyBecomeOcr.zyRegistraduria?.registraduriaFullName = fullName
                
            }
            if let gender = dataRegistraduria["gender"] as? String {
                zyBecomeOcr.zyRegistraduria?.registraduriaGender =  gender
                
            }
            if let issuePlace = dataRegistraduria["issuePlace"] as? String {
                zyBecomeOcr.zyRegistraduria?.registraduriaIssuePlace = issuePlace
                
            }
            if let middleName = dataRegistraduria["middleName"] as? String {
                zyBecomeOcr.zyRegistraduria?.registraduriaMiddleName = middleName
                
            }
            if let name = dataRegistraduria["name"] as? String {
                zyBecomeOcr.zyRegistraduria?.registraduriaName =  name
                
            }
            if let surname = dataRegistraduria["surname"] as? String {
                zyBecomeOcr.zyRegistraduria?.registraduriaSurname =  surname
                
            }
            if let secondSurname = dataRegistraduria["secondSurname"] as? String {
                zyBecomeOcr.zyRegistraduria?.registraduriaSecondSurname = secondSurname
                
            }
        }
        

        
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
