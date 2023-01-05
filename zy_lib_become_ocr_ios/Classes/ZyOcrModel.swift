//
//  ZyOcrModel.swift
//  zy-lib-become-ocr-ios
//
//  Created by Edwin on 04/27/2022.
//

import Foundation
import Microblink
import UIKit

public struct ZyOcrRequest {
    public init(){}
    
    //public var clienId:String?
    public var timeout: String?
    public var token: String?
    public var contractId: String?
    public var userId: String?
    public var fullFrontImage: UIImage?
    public var backImage: UIImage?
    public var barcodeResult: String?
    public var barcodeResultData: Data?
    
    public var allowLibraryLoading: Bool = false
    public var formatoFecha: String = "yyyy-MM-dd"
    public var stringTextName:String?
    public var becomePais:String?
    public var becomeNroDoc:String?
    public var rawValue:Int?
    public var typeDoc:MBType?
    public var isoAlpha2CountryCode:String?
    public var nationality:String?

    
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
    public var dateOfIssue: String?
    public var mrzText: String?
    public var sex: String?
    var barcodeResult: String?
    var barcodeResultData: Data?
    public var frontImage: UIImage?
    public var backImage: UIImage?
    public var fullFronImage: UIImage?
    public var fullBackImage: UIImage?
    public var rawValue:Int?
    public var typeDoc:MBType?
    public var nationality: String?
    
    var message: String?
    public var qualityScore:String?
    public var livenessScore:String?
    public var livenessProbability:String?
    public var statusCode:String?
    var IsFirstTransaction: Bool?
    public var responseStatus: String?
    public var documentNumber: String?
    public var ocrPais: String?
    public var ocrIsoAlpha2CountryCode: String?
    public var ocrIsoAlpha3CountryCode: String?
    public var ocrIsoNumericCountryCode: String?
    public var placeOfBirth: String?
    public var zyRegistraduria: ZyRegistraduria?
}

public struct ZyRegistraduria{
    public var coErrorRegistraduria:Int? 
    public var deErrorRegistraduria:String? = ""
    
    public var registraduriaAgeRange:String? = ""
    public var registraduriaBankAccountsCount:String? = ""
    public var registraduriaCommercialIndustryDebtsCount:String? = ""
    public var registraduriaDocumentNumber:String? = ""
    public var registraduriaEmissionDate:String? = ""
    public var registraduriaFinancialIndustryDebtsCount:String? = ""

    public var registraduriaFullName:String? = ""
    public var registraduriaGender:String? = ""
    public var registraduriaIssuePlace:String? = ""
    public var registraduriaName:String? = ""

    public var registraduriaMiddleName:String? = ""
    public var registraduriaSurname:String? = ""
    public var registraduriaSecondSurname:String? = ""
    public var registraduriaSavingAccountsCount:String? = ""
    public var registraduriaSolidarityIndustryDebtsCount:String? = ""
    public var registraduriaServiceIndustryDebtsCount:String? = ""

    
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

public struct ZyLibOcrError{
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
    case PARAMETROS_INCOMPLETOS_USERID = 9201
    case PARAMETROS_INCOMPLETOS_TOKEN = 9202
    case PARAMETROS_INCOMPLETOS_CONTRACTID = 9203
    case CAPTURA_OCR_ERROR_EN_CAPTURA_DOC = 9800
    case CAPTURA_OCR_ERROR_FRONT_IMG_EMPTY = 9801
    case CAPTURA_OCR_ERROR_WS_BECOME = 9802
    case CAPTURA_OCR_ERROR_EN_VALIDACION_DOC = 9803
    case NO_SIMULADOR = 9804
    case NO_BIO_PAIS = 9805
    case BIOPAIS_NO_FOUND = 9806
    case OCR_NRO_DOC_NO_ENCONTRADO = 9807
    case BECOME_TOKEN_EXPIRED = 9808
    case BECOME_WS_TIMEOUT = 9809
    case BECOME_WS_BECOME_NO_REGISTRY = 9812
    case BECOME_BECOME_REGISTRADURIA_DOCUMENTO_NO_COLOMBIA = 9813
    case BECOME_ERROR_DOC_PAIS_NO_SOPORTADO = 9814
    case BECOME_ERROR_BECOME_NOREGISTRY_DATA = 9816
    case BECOME_ERROR_REVISAR_DESCRIPCION = 9817

    
    
    var descripcion:String {
        switch self {
            
        case .CAPTURA_OCR_ERROR_EN_CAPTURA_DOC:
            return "\(self.rawValue):Error en la libreria OCR BECOME REVISAR MENSAJE"
            
        case .CAPTURA_OCR_ERROR_FRONT_IMG_EMPTY:
            return "\(self.rawValue):Error de obtencion OCR , no se obtuvo imagen deontal del documento"
            
        case .CAPTURA_OCR_ERROR_WS_BECOME:
            return "\(self.rawValue):Documento no legile , wsBecome no response - timeOut become"
            
        case .CAPTURA_OCR_ERROR_EN_VALIDACION_DOC:
            return "\(self.rawValue):Error en WS Validacion Documento , WS OCR_BECOME"
        case .BECOME_WS_TIMEOUT:
            return "\(self.rawValue):Error en servicio de WS de BECOME , WS OCR_BECOME"
            
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
        case .NO_BIO_PAIS:
            return "\(self.rawValue):Ingrese el PAIS correcto"
        case .BIOPAIS_NO_FOUND:
            return "\(self.rawValue):No se encontrò el còdigo de pais ingresado"
        case .OCR_NRO_DOC_NO_ENCONTRADO:
            return "\(self.rawValue):No se puedo extraer el número de documento"
        case .BECOME_TOKEN_EXPIRED:
            return "\(self.rawValue):Token para inicializar OCR become Expirado"
        case .BECOME_WS_BECOME_NO_REGISTRY:
            return "\(self.rawValue):Data de registraduria nula"
        case .BECOME_ERROR_DOC_PAIS_NO_SOPORTADO:
            return "\(self.rawValue):CODIGO DE PAIS NO SOPORTADO"
            
        case .BECOME_BECOME_REGISTRADURIA_DOCUMENTO_NO_COLOMBIA:
            return "\(self.rawValue):Documento no es Colombiano"
        case .BECOME_ERROR_BECOME_NOREGISTRY_DATA:
            return "\(self.rawValue):No hay Data de registraduria"
            
        case .PARAMETROS_INCOMPLETOS_USERID:
            return "\(self.rawValue):Become UserId invalido"
            
        case .PARAMETROS_INCOMPLETOS_TOKEN:
            return "\(self.rawValue):Become token invalido"
            
        case .PARAMETROS_INCOMPLETOS_CONTRACTID:
            return "\(self.rawValue):Become contractId invalido"
        case .BECOME_ERROR_REVISAR_DESCRIPCION:
            return "\(self.rawValue):error Become : Revisar Descripcion : "
            
        default:
            return ""
        }
    }
}
