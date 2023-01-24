
import Foundation
#if !targetEnvironment(simulator)
import BecomeDigitalV
#endif

public class ZyOcr {
    public typealias CallbackOcr = (ZyOcrResult<ZyOcrResponse, ZyOcrError>) -> Void
    private var vc: UIViewController
    private var validaAutenticidad:Bool
#if !targetEnvironment(simulator)
    private let apiOcr:ZyBecomeOcr
    var sv:UIView
#endif
    
    public init(onView:UIViewController){
        self.vc = onView
#if !targetEnvironment(simulator)
        //let viewc = vc.view.window?.rootViewController
        apiOcr = ZyBecomeOcr()
        self.vc.present(apiOcr, animated: true,completion: {})
        
        //let top = UIApplication.shared.keyWindow?.rootViewController
        //top?.present(apiOcr, animated: true, completion: {})
        self.validaAutenticidad = false
        
        self.sv = UIView.init()
#else
        self.validaAutenticidad = false
        
#endif
        
    }
    
    
    
    public func capturar(request:ZyOcrRequest,validarAutenticidad:Bool,
                         completion:@escaping CallbackOcr){
#if !targetEnvironment(simulator)
        guard let _ = request.userId else {
            
            completion(.error(ZyOcrError(coError: ZyOcrErrorEnum.PARAMETROS_INCOMPLETOS_USERID.rawValue,
                                         deError: ZyOcrErrorEnum.PARAMETROS_INCOMPLETOS_USERID.descripcion)))
            return;
        }
        guard let _ = request.token else {
            
            completion(.error(ZyOcrError(coError: ZyOcrErrorEnum.PARAMETROS_INCOMPLETOS_TOKEN.rawValue,
                                         deError: ZyOcrErrorEnum.PARAMETROS_INCOMPLETOS_TOKEN.descripcion)))
            return;
        }
        guard let _ = request.contractId else {
            
            completion(.error(ZyOcrError(coError: ZyOcrErrorEnum.PARAMETROS_INCOMPLETOS_CONTRACTID.rawValue,
                                         deError: ZyOcrErrorEnum.PARAMETROS_INCOMPLETOS_CONTRACTID.descripcion)))
            return;
        }
        
        self.validaAutenticidad = validarAutenticidad
        
        if(request.allowLibraryLoading){
            sv = UIViewController.displaySpinner(onView: vc.view)
        }
        
        apiOcr.capturar(request: request)
        { (result:(ZyOcrResult<ZyOcrResponse, ZyLibOcrError>)) in
            
            if(request.allowLibraryLoading){
                UIViewController.removeSpinner(spinner: self.sv)
            }
            
            switch result {
            case .success(let response):
                if validarAutenticidad{
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                        var secondRequest = request
                        secondRequest.becomeNroDoc = response.zyBecomeOcr.documentNumber
                        secondRequest.fullFrontImage = response.zyBecomeOcr.fullFronImage!
                        secondRequest.backImage = response.zyBecomeOcr.backImage
                        secondRequest.barcodeResult = response.zyBecomeOcr.barcodeResult
                        secondRequest.barcodeResultData = response.zyBecomeOcr.barcodeResultData
                        secondRequest.rawValue = response.zyBecomeOcr.rawValue
                        secondRequest.typeDoc = response.zyBecomeOcr.typeDoc
                        secondRequest.isoAlpha2CountryCode = response.zyBecomeOcr.ocrIsoAlpha2CountryCode
                        secondRequest.nationality = response.zyBecomeOcr.nationality
                        self.enviar(request:secondRequest ,zyOcrResponse:response ,completion:completion)

                    }
                    
                }else{
                    self.vc.dismiss(animated: false)
                    completion(.success(response))
                }
                
                
            case .error(let error):
                self.vc.dismiss(animated: false)
                completion(.error(ZyOcrError(coError: error.coError,
                                             deError: error.deError)))
            }
        }
#else
        completion(.error(ZyOcrError(coError: ZyOcrErrorEnum.NO_SIMULADOR.rawValue,
                                     deError: ZyOcrErrorEnum.NO_SIMULADOR.descripcion)))
#endif
        
    }
    
#if !targetEnvironment(simulator)
    public func enviar(request:ZyOcrRequest,zyOcrResponse:ZyOcrResponse?,
                       completion:@escaping CallbackOcr){
        
        guard let _ = request.userId,
              let _ = request.token,
              let _ = request.fullFrontImage,
              let _ = request.backImage,
              let _ = request.barcodeResult,
              let _ = request.rawValue,
              let _ = request.contractId else {
            
            completion(.error(ZyOcrError(coError: ZyOcrErrorEnum.PARAMETROS_INCOMPLETOS.rawValue,
                                         deError: ZyOcrErrorEnum.PARAMETROS_INCOMPLETOS.descripcion)))
            return;
        }
        
        if(request.allowLibraryLoading){
            sv = UIViewController.displaySpinner(onView: vc.view)
        }
        
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            self.apiOcr.enviarImagen(request: request, zyOcrResponse:zyOcrResponse)
            { (result:(ZyOcrResult<ZyOcrResponse, ZyLibOcrError>)) in
                if(request.allowLibraryLoading){
                    UIViewController.removeSpinner(spinner: self.sv)
                }
                switch result {
                case .success(let response):
                    self.vc.dismiss(animated: false)
                    completion(.success(response))
                    
                case .error(let error):
                    self.vc.dismiss(animated: false)
                    completion(.error(ZyOcrError(coError: error.coError,
                                                 deError: error.deError)))
                }
            }
        }
        
    }
    
#endif
}
