//
//  ZyOcrModel.swift
//  zy-lib-become-ocr-ios
//
//  Created by Edwin on 04/27/2022.
//

import Foundation
import UIKit

public struct ZyOcrRequest {
    public init(){}
    
    //public var clienId:String?
    public var timeout: String?
    public var token: String?
    public var contractId: String?
    public var userId: String?
    public var fullFrontImage: String?
    public var allowLibraryLoading: Bool = false
    public var formatoFecha: String = "yyyy-MM-dd"
    //public var validationTypes: String = "VIDEO/DNI"
}

public enum ZyOcrResult <T,E> {
    case success(T)
    case error(E)
}

public struct ZyOcrResponse{
    public let coError:Int=8000
    public let deError:String="8000:OK"
    public let zyBecomeOcr:ZyBecomeOcrResponse
}

public struct ZyBecomeOcrResponse {
    public init(){}
    public var firstName: String?
    public var lastName: String?
    public var apPaterno: String?
    public var apMaterno: String?
    
    public var dateOfExpiry: String?
    public var age: String?
    public var dateOfBirth: String?
    public var mrzText: String?
    public var sex: String?
    var barcodeResult: String?
    var barcodeResultData: String?
    public var frontImage: String?
    public var backImage: String?
    public var fullFronImage: String?
    public var fullBackImage: String?
    var message: String?
    public var qualityScore:String?
    public var livenessScore:String?
    public var livenessProbability:String?
    public var statusCode:String?
    var IsFirstTransaction: Bool?
    public var responseStatus: String?
    
    /*init(firstName: String? = nil,
     lastName: String? = nil,
     dateOfExpiry: String? = nil,
     age: String? = nil,
     dateOfBirth: String? = nil,
     mrzText: String? = nil,
     sex: String? = nil,
     barcodeResult: String? = nil,
     barcodeResultData: String? = nil,
     frontImage: String? = nil,
     backImage: String? = nil,
     fullFronImage: UIImage? = nil,
     fullBackImage: UIImage? = nil,
     message: String? = nil,
     documentValidation: [String: Any]? = nil,
     IsFirstTransaction: Bool? = nil,
     responseStatus: String? = nil){
     
     self.firstName = firstName
     self.lastName = lastName
     self.dateOfExpiry = dateOfExpiry
     self.age = age
     self.dateOfBirth = dateOfBirth
     self.mrzText = mrzText
     self.sex = sex
     self.barcodeResult = barcodeResult
     self.barcodeResultData = barcodeResultData
     self.frontImage = frontImage
     self.backImage = backImage
     self.fullFronImage = fullFronImage
     self.fullBackImage = fullBackImage
     self.message = message
     self.documentValidation = documentValidation
     self.IsFirstTransaction = IsFirstTransaction
     self.responseStatus = responseStatus
     }*/
}


enum typeEstatus {
    case SUCCES
    case ERROR
    case PENDING
}

public struct ZyOcrError{
    public let coError:Int
    public let deError:String
}

enum ZyOcrErrorEnum:Int {
    case EXITO = 8000
    case CREDENCIAL_INCORRECTA = 9101
    case DNI_BLOQUEADO = 8150
    case TERMINAL_BLOQUEADO = 8151
    case DNI_TERMINAL_BLOQUEADO = 8154
    case CAPTURA_CANCELADA = 9104
    case NO_DATA = 9105
    case INICIALIZACION_ERROR = 9106
    case IMAGE_ERROR = 9107
    case ERROR_ACCESO = 9108
    case ERROR_LICENCIA_EXPIRADA = 9109
    case ERROR_TIMEOUT = 9116
    case ERROR_BAD_CAPTURE = 9118
    case PARAMETROS_INCOMPLETOS = 9200
    case CAPTURA_OCR_ERROR_EN_CAPTURA_DOC = 9800
    case CAPTURA_OCR_ERROR_FRONT_IMG_EMPTY = 9801
    case CAPTURA_OCR_ERROR_OBTENER_VALIDACION_DOC = 9802
    case CAPTURA_OCR_ERROR_EN_VALIDACION_DOC = 9803
    case NO_SIMULADOR = 9804
    
    
    var descripcion:String {
        switch self {
            
        case .CAPTURA_OCR_ERROR_EN_CAPTURA_DOC:
            return "\(self.rawValue):Error en la libreria OCR BECOME REVISAR MENSAJE"
            
        case .CAPTURA_OCR_ERROR_FRONT_IMG_EMPTY:
            return "\(self.rawValue):Error de obtencion OCR , no se obtuvo imagen deontal del documento"
            
        case .CAPTURA_OCR_ERROR_OBTENER_VALIDACION_DOC:
            return "\(self.rawValue):Documento no legile , wsBecome no response"
            
        case .CAPTURA_OCR_ERROR_EN_VALIDACION_DOC:
            return "\(self.rawValue):Error en WS Validacion Documento , WS OCR_BECOME"
            
        case .EXITO:
            return "\(self.rawValue):Exito"
        case .CREDENCIAL_INCORRECTA:
            return "\(self.rawValue):Credenciales incorrectas"
        case .CAPTURA_CANCELADA:
            return "\(self.rawValue):El usuario cancelo la operacion"
        case .NO_DATA:
            return "\(self.rawValue):La captura no retorno data"
        case .INICIALIZACION_ERROR:
            return "\(self.rawValue):Error en la inicializacion de la captura"
        case .IMAGE_ERROR:
            return "\(self.rawValue):Error al obtener la imagen de la camara"
        case .ERROR_ACCESO:
            return "\(self.rawValue):Error de acceso a la libreria"
        case .ERROR_LICENCIA_EXPIRADA:
            return "\(self.rawValue):Licencia caducada"
        case .ERROR_TIMEOUT:
            return "\(self.rawValue):Finalizo el tiempo de captura"
        case .ERROR_BAD_CAPTURE:
            return "\(self.rawValue):Captura insatisfactoria"
        case .PARAMETROS_INCOMPLETOS:
            return "\(self.rawValue):Uno o mas parametros incorrectos"
        case .NO_SIMULADOR:
            return "\(self.rawValue):Libreria no corre en simulador"
        default:
            return ""
        }
    }
}
