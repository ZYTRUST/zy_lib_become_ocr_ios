//
//  Extension.swift
//  zy-lib-become-ocr-ios
//
//  Created by Edwin on 04/27/2022.
//

import Foundation
import UIKit
extension UIViewController{
    
    func showConfirm(withTitle title: String?,
                     message: String?,
                     okLabel: String?,
                     okCompletion: (() -> Void)? = nil,
                     cancelLabel: String?,
                     cancelCompletion: (() -> Void)? = nil) {
        
        self.dismiss(animated: true, completion: nil)
        
        let alertView = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: okLabel,
                                     style: .cancel)
        { (isAction) in
            guard let okCompletion = okCompletion else { return }
            okCompletion()
        }
        alertView.addAction(OKAction)
        
        let CancelAction = UIAlertAction(title: cancelLabel,
                                         style: .default)
        { (isAction) in
            guard let cancelCompletion = cancelCompletion else { return }
            cancelCompletion()
        }
        alertView.addAction(CancelAction)
        
        self.present(alertView, animated: true, completion: nil)
    }
    
    func showAlert(withTitle title: String?,
                   message: String?,
                   delay:Double? = nil,
                   completion: (() -> Void)? = nil) {
        
        let alertView = UIAlertController(title: title,
                                          message: message,
                                          preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK",
                                     style: .cancel)
        { (isAction) in
            guard let completion = completion else { return }
            completion()
        }
        alertView.addAction(OKAction)
        if let del = delay {
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + del)
            {
                self.present(alertView, animated: true, completion: nil)
            }
        }
        else
        {
            self.present(alertView, animated: true, completion: nil)
        }
    }
    
    class func displaySpinner(onView : UIView) -> UIView {
        let spinnerView = UIView.init(frame: onView.bounds)
        spinnerView.backgroundColor = UIColor.init(red: 0.5, green: 0.5, blue: 0.5, alpha: 0.5)
        let ai = UIActivityIndicatorView.init(activityIndicatorStyle: .whiteLarge)
        ai.startAnimating()
        ai.center = spinnerView.center

        DispatchQueue.main.async {
            spinnerView.addSubview(ai)
            onView.addSubview(spinnerView)
        }

        return spinnerView
    }

    class func removeSpinner(spinner :UIView) {
        DispatchQueue.main.async {
            spinner.removeFromSuperview()
        }
    }
}
extension Date {
    var millisecondsSince1970:Double {
        //        return 1000
        //  return Int((self.timeIntervalSince1970 * 1000.0).rounded())
        let doubleValue = (self.timeIntervalSince1970 * 1000.0).rounded()
        return doubleValue
    }
    init(milliseconds:Int) {
        self = Date(timeIntervalSince1970: TimeInterval(milliseconds / 1000))
    }
    func stringByFormatter(format:String) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
}
extension FileManager {
    func listFiles(path: String) -> [URL] {
        let baseurl: URL = URL(fileURLWithPath: path)
        var urls = [URL]()
        enumerator(atPath: path)?.forEach({ (e) in
            guard let s = e as? String else { return }
            let relativeURL = URL(fileURLWithPath: s, relativeTo: baseurl)
            let url = relativeURL.absoluteURL
            urls.append(url)
        })
        return urls
    }
}
extension String {
    func stringByRemovingAll(characters: [Character]) -> String {
        return String(self.filter({ !characters.contains($0) }))
    }
    func stringByRemovingAll(subStrings: [String]) -> String {
        var resultString = self
        _ = subStrings.map { resultString =
            resultString.replacingOccurrences(of: $0, with: "")}
        return resultString
    }
    var imageFromBase64: UIImage? {
        
        guard let imageData = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
            return nil
        }
        return UIImage(data: imageData)
    }
    var dataFromBase64: Data? {
        
        guard let imageData = Data(base64Encoded: self, options: .ignoreUnknownCharacters) else {
            return nil
        }
        return imageData
    }
}

extension UIImage {
    var jpegBase64: String? {
        //self.jpegData(compressionQuality: 1)?.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
        
        let img = self.jpegData(compressionQuality: 1)! as Data
        return img.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
    
    var pngBase64: String? {
        //self.jpegData(compressionQuality: 1)?.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
        
        let img = self.pngData()! as Data
        return img.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
}
