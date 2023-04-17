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
        
        switch request.becomePais?.uppercased() {
        case "PE":
            let bdivConfig = BDIVConfig(isFirstTransaction: true,
                                        enableRecognitionModeFilter: true,
                                        token: request.token!,
                                        contractId: request.contractId!,
                                        userId: request.userId! ,
                                        customLocalizationFileName: nameStringFile )
            
            print("bdivConfig \(String(describing: bdivConfig))")
            
            BDIVCallBack.sharedInstance.delegate = self
            BDIVCallBack.sharedInstance.register(bdivConfig: bdivConfig)
            break
            
        case "CO":
            let bdivConfig = BDIVConfig(isFirstTransaction: true,
                                        enableRecognitionModeFilter: false,
                                        token: request.token!,
                                        contractId: request.contractId!,
                                        userId: request.userId! ,
                                        customLocalizationFileName: nameStringFile )
            
            print("bdivConfig \(String(describing: bdivConfig))")
            
            BDIVCallBack.sharedInstance.delegate = self
            BDIVCallBack.sharedInstance.register(bdivConfig: bdivConfig)
            break
            
        default:
            print("===>>> DEFAULT BECOME_ERROR_DOC_PAIS_NO_SOPORTADO")
            callback(.error(ZyLibOcrError(coError:ZyOcrErrorEnum.BECOME_ERROR_DOC_PAIS_NO_SOPORTADO.rawValue ,
                                          deError:ZyOcrErrorEnum.BECOME_ERROR_DOC_PAIS_NO_SOPORTADO.descripcion )))
            break
            
        }
        
    }
    
    func enviarImagen(request:ZyOcrRequest,
                      zyOcrResponse:ZyOcrResponse?,completion:@escaping CallbackOcr){
        
        //print(String(describing: request))
        //var bdivConfig:BDIVConfig?
        self.callback = completion
        self.zyOcrResponseCapturar = zyOcrResponse
        if(request.becomePais != nil && request.becomePais != ""){
            print("===>>>becomePais: \(request.becomePais)")
            switch (request.becomePais?.uppercased() ) {
            case "CO":
                print("===>>> DOCUMENTO COLOMBIA")
                let bdivConfigCo = BDIVConfig(isFirstTransaction: false,
                                        token: request.token!,
                                        contractId: request.contractId!,
                                        userId: request.userId!,
                                        documentNumber: request.becomeNroDoc!,
                                        isoAlpha2CountryCode: request.isoAlpha2CountryCode!,
                                        type: request.rawValue!,
                                        imgDataFullFront: (request.fullFrontImage!.pngData()!) ,
                                        imgDataCroppetBack:  request.backImage!.pngData()! ,
                                        barcodeResultData: request.barcodeResult!)
                BDIVCallBack.sharedInstance.delegate = self
                BDIVCallBack.sharedInstance.register(bdivConfig: bdivConfigCo)
                  
                break
            case "PE":
                print("===>>> DOCUMENTO PERU")
                let bdivConfigPe = BDIVConfig(isFirstTransaction: false,
                                        token: request.token!,
                                        contractId: request.contractId!,
                                        userId: request.userId!,
                                        isoAlpha2CountryCode: request.isoAlpha2CountryCode!,
                                        type: request.rawValue!,
                                        imgDataFullFront: (request.fullFrontImage!.pngData()!),
                                        imgDataCroppetBack:  request.backImage!.pngData()! ,
                                        barcodeResultData: request.barcodeResult!)
                BDIVCallBack.sharedInstance.delegate = self
                BDIVCallBack.sharedInstance.register(bdivConfig: bdivConfigPe)
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
            
            
            if(responseIV.isoAlpha2CountryCode.caseInsensitiveCompare("CO") == .orderedSame &&
               responseIV.nationality.caseInsensitiveCompare("COL") == .orderedSame){
                zyBecomeOcr.documentNumber = responseIV.personalIdNumber
            }else {
                zyBecomeOcr.documentNumber = responseIV.documentNumber
            }
            
            zyBecomeOcr.ocrPais = responseIV.countryName
            zyBecomeOcr.ocrIsoAlpha2CountryCode = responseIV.isoAlpha2CountryCode
            zyBecomeOcr.ocrIsoAlpha3CountryCode = responseIV.isoAlpha2CountryCode
            zyBecomeOcr.ocrIsoNumericCountryCode = responseIV.isoNumericCountryCode
            zyBecomeOcr.placeOfBirth = responseIV.placeOfBirth
            zyBecomeOcr.rawValue = responseIV.type.rawValue
            zyBecomeOcr.typeDoc = responseIV.type.rawValue
            zyBecomeOcr.typeDocDescription = responseIV.type.hashValue.description
            zyBecomeOcr.nationality = responseIV.nationality
            
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
        
        print("===>> tipo Documento Microblink \(String(describing: zyBecomeOcr.typeDoc))")
        if(zyBecomeOcr.typeDoc == 28){
            print("===>> Documento no es un Documento Nacional")
            
            zyBecomeOcr.zyRegistraduria?.coErrorRegistraduria = ZyOcrErrorEnum.BECOME_ERROR_BECOME_NOREGISTRY_DATA.rawValue
            zyBecomeOcr.zyRegistraduria?.deErrorRegistraduria = ZyOcrErrorEnum.BECOME_ERROR_BECOME_NOREGISTRY_DATA.descripcion
            return
        }
        if(zyBecomeOcr.typeDoc == 6){
            print("===>> Es un documento Nacional")
        }
        
        
        
        let registraduria = responseIV.registryInformation
        
        if (responseIV.registryInformation.isEmpty ){
            print("===>> responseIV.registryInformation isEmpty")
            zyBecomeOcr.zyRegistraduria?.coErrorRegistraduria = ZyOcrErrorEnum.BECOME_ERROR_BECOME_NOREGISTRY_DATA.rawValue
            zyBecomeOcr.zyRegistraduria?.deErrorRegistraduria = ZyOcrErrorEnum.BECOME_ERROR_BECOME_NOREGISTRY_DATA.descripcion
            
            return
        }
        
        print("===>> ParserData Registraduria: \(registraduria)")
        
        zyBecomeOcr.zyRegistraduria?.coErrorRegistraduria = ZyOcrErrorEnum.EXITO.rawValue
        zyBecomeOcr.zyRegistraduria?.deErrorRegistraduria = ZyOcrErrorEnum.EXITO.descripcion
        
        if let dataRegistraduria = registraduria as? NSDictionary {
            print("===========>>>>>> data Registraduria: \(registraduria)")
            
            if let registry_identity_id = dataRegistraduria["identity_id"] as? String {
                zyBecomeOcr.zyRegistraduria?.registry_identity_id = registry_identity_id
                print ("======>>>> registry_identity_id: \(registry_identity_id)")
            }
            if let registry_fechaHoraConsulta = dataRegistraduria["fechaHoraConsulta"] as? String {
                zyBecomeOcr.zyRegistraduria?.registry_fechaHoraConsulta = registry_fechaHoraConsulta
                print ("======>>>> registry_fechaHoraConsulta: \(registry_fechaHoraConsulta)")
            }
            if let registry_contract_id = dataRegistraduria["contract_id"] as? String {
                zyBecomeOcr.zyRegistraduria?.registry_contract_id = registry_contract_id
                print ("======>>>> registry_contract_id: \(registry_contract_id)")
            }
            if let registry_nuip = dataRegistraduria["nuip"] as? String {
                zyBecomeOcr.zyRegistraduria?.registry_nuip = registry_nuip
                print ("======>>>> registry_nuip: \(registry_nuip)")
            }
            if let registry_codError = dataRegistraduria["codError"] as? String {
                zyBecomeOcr.zyRegistraduria?.registry_codError = registry_codError
                print ("======>>>> registry_codError: \(registry_codError)")
            }
            if let registry_primerApellido = dataRegistraduria["primerApellido"] as? String {
                zyBecomeOcr.zyRegistraduria?.registry_primerApellido = registry_primerApellido
                print ("======>>>> registry_primerApellido: \(registry_primerApellido)")
            }
            if let registry_particula = dataRegistraduria["particula"] as? String {
                zyBecomeOcr.zyRegistraduria?.registry_particula = registry_particula
                print ("======>>>> registry_particula: \(registry_particula)")
            }
            if let registry_segundoApellido = dataRegistraduria["segundoApellido"] as? String {
                zyBecomeOcr.zyRegistraduria?.registry_segundoApellido = registry_segundoApellido
                print ("======>>>> registry_segundoApellido: \(registry_segundoApellido)")
            }
            if let registry_primerNombre = dataRegistraduria["primerNombre"] as? String {
                zyBecomeOcr.zyRegistraduria?.registry_primerNombre = registry_primerNombre
                print ("======>>>> registry_primerNombre: \(registry_primerNombre)")
            }
            if let registry_segundoNombre = dataRegistraduria["segundoNombre"] as? String {
                zyBecomeOcr.zyRegistraduria?.registry_segundoNombre = registry_segundoNombre
                print ("======>>>> registry_segundoNombre: \(registry_segundoNombre)")
            }
            if let registry_municipioExpedicion = dataRegistraduria["municipioExpedicion"] as? String {
                zyBecomeOcr.zyRegistraduria?.registry_municipioExpedicion = registry_municipioExpedicion
                print ("======>>>> registry_municipioExpedicion: \(registry_municipioExpedicion)")
            }
            if let registry_departamentoExpedicion = dataRegistraduria["departamentoExpedicion"] as? String {
                zyBecomeOcr.zyRegistraduria?.registry_departamentoExpedicion = registry_departamentoExpedicion
                print ("======>>>> registry_departamentoExpedicion: \(registry_departamentoExpedicion)")
            }
            if let registry_fechaExpedicion = dataRegistraduria["fechaExpedicion"] as? String {
                zyBecomeOcr.zyRegistraduria?.registry_fechaExpedicion = registry_fechaExpedicion
                print ("======>>>> registry_fechaExpedicion: \(registry_fechaExpedicion)")
            }
            if let registry_fechaNacimiento = dataRegistraduria["fechaNacimiento"] as? String {
                zyBecomeOcr.zyRegistraduria?.registry_fechaNacimiento = registry_fechaNacimiento
                print ("======>>>> registry_fechaNacimiento: \(registry_fechaNacimiento)")
            }
            if let registry_estadoCedula = dataRegistraduria["estadoCedula"] as? String {
                zyBecomeOcr.zyRegistraduria?.registry_estadoCedula = registry_estadoCedula
                print ("======>>>> registry_estadoCedula: \(registry_estadoCedula)")
            }
            if let registry_descripcionEstado = dataRegistraduria["descripcionEstado"] as? String {
                zyBecomeOcr.zyRegistraduria?.registry_descripcionEstado = registry_descripcionEstado
                print ("======>>>> registry_descripcionEstado: \(registry_descripcionEstado)")
            }
        }
        
        
        
    }
    
    public  func BDIVResponseError(error: String) {
        let errorNoSpace = error.stringByRemovingAll(subStrings: [" "]).uppercased()
        print("zy BECOME WS Response : \(errorNoSpace)")
        
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
        else if errorNoSpace == "THEREQUESTTIMEDOUT" {
            callback(.error(ZyLibOcrError(coError:ZyOcrErrorEnum.CAPTURA_OCR_ERROR_WS_BECOME.rawValue ,
                                          deError: ZyOcrErrorEnum.CAPTURA_OCR_ERROR_WS_BECOME.descripcion)))
            return
        }
        
        callback(.error(ZyLibOcrError(coError:ZyOcrErrorEnum.BECOME_ERROR_REVISAR_DESCRIPCION.rawValue ,
                                      deError: "\(ZyOcrErrorEnum.BECOME_ERROR_REVISAR_DESCRIPCION.descripcion) ,ErrorOrigen: \(errorNoSpace)" )))
    }
    
}
#endif
