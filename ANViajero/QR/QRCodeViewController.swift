//
//  QRCodeViewController.swift
//  ANViajero
//
//  Created by Juan Carlos Quispe on 5/5/21.
//

import UIKit

class QRCodeViewController: UIViewController {

    var indice: Int64 = 0
    var mensaje : String = ""
    var dbc: dbController = dbController()
    
    @IBOutlet weak var qrImage: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(indice)
        let query = dbc.getSelect("ddjj", indice)
        for que in query{
            mensaje = mensaje + que + "|"
        }
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            mensaje = mensaje + "IOS:"+version+"|"
        }
        mensaje = mensaje + "$"
        print(mensaje)
        let image = generateQRCode(from: mensaje)
        qrImage.image = image
        navigationItem.title = "Form 250"
    }
    

    func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.isoLatin1)
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            
            guard let qrCodeImage = filter.outputImage else {return nil}
            let scaleX = qrImage.frame.size.width / qrCodeImage.extent.size.width
            let scaleY = qrImage.frame.size.height / qrCodeImage.extent.size.height
            
            let transform = CGAffineTransform(scaleX: scaleX, y: scaleY)
            
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }
}
