//
//  validacionController.swift
//  ANViajero
//
//  Created by Juan Carlos Quispe on 3/5/21.
//

import UIKit

class validacionController{
    
    func esEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }

    func esFecha(testStr:String) -> Bool {
        let fecha = testStr.components(separatedBy: "/")
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        let fechaHoy = formatter.string(from: date)
        
        if (fecha[0].count == 2 &&  fecha[1].count == 2 && fecha[2].count == 4){
            if fecha[0].rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil || fecha[1].rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil || fecha[2].rangeOfCharacter(from: CharacterSet.decimalDigits.inverted) != nil{
                return false
            }
            else{
                let hoysis = formatter.date(from: fechaHoy)
                let hoyusu = formatter.date(from: testStr)
                if hoyusu! < hoysis! || hoyusu! == hoysis! {
                    return true
                }
                else{
                    return false
                }
            }
        }
        else{
            return false
        }

    }
    
    func esAlfanumcaracter(testStr:String) -> Bool {
        let set = CharacterSet(charactersIn: "ABCDEFGHIJKLKMNÑOPQRSTUVWXYZÁÉÍÓÚabcdefghijklmnñopqrstuvwxyzáéíóú0123456789#.,-\" ")
        if testStr.rangeOfCharacter(from: set.inverted) != nil {
            return false
        }
        else{
            return true
        }
    }
    
    func esAlfamail(testStr:String) -> Bool {
        let set = CharacterSet(charactersIn: "abcdefghijklmnopqrstuvwxyz0123456789.-_@ ")
        if testStr.rangeOfCharacter(from: set.inverted) != nil {
            return false
        }
        else{
            return true
        }
    }
    
    func esAlfanumerico(testStr:String) -> Bool {
        let set = CharacterSet(charactersIn: "ABCDEFGHIJKLKMNÑOPQRSTUVWXYZÁÉÍÓÚ0123456789 ")
        if testStr.rangeOfCharacter(from: set.inverted) != nil {
            return false
        }
        else{
            return true
        }
    }
    
    func esNumerico(testStr:String) -> Bool {
        let set = CharacterSet(charactersIn: "0123456789")
        if testStr.rangeOfCharacter(from: set.inverted) != nil {
            return false
        }
        else{
            return true
        }
    }
    
    func esNumfecha(testStr:String) -> Bool {
        let set = CharacterSet(charactersIn: "0123456789/")
        if testStr.rangeOfCharacter(from: set.inverted) != nil {
            return false
        }
        else{
            return true
        }
    }
    
    func esAlfabetico(testStr:String) -> Bool {
        let set = CharacterSet(charactersIn: "ABCDEFGHIJKLKMNÑOPQRSTUVWXYZÁÉÍÓÚ ")
        if testStr.rangeOfCharacter(from: set.inverted) != nil {
            return false
        }
        else{
            return true
        }
    }
    
    func esDocumento(testStr:String) -> Bool {
        let set = CharacterSet(charactersIn: "ABCDEFGHIJKLKMNOPQRSTUVWXYZ0123456789-")
        if testStr.rangeOfCharacter(from: set.inverted) != nil {
            return false
        }
        else{
            return true
        }
    }
    
    func esModelo(testStr:String) -> Bool {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let gestion = formatter.string(from: date)
        
        if Int(testStr)! > Int(gestion)!+1 {
            return false
        }
        else{
            return true
        }
    }
    
    func esFabricacion(testStr:String) -> Bool {
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        let gestion = formatter.string(from: date)
        
        if Int(testStr)! > Int(gestion)! {
            return false
        }
        else{
            return true
        }
    }
}
