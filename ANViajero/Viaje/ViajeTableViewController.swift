//
//  ViajeTableViewController.swift
//  ANViajero
//
//  Created by Juan Carlos Quispe on 30/4/21.
//

import UIKit

class ViajeTableViewController: UITableViewController {

    var indice: Int64 = 0
    let dbc: dbController = dbController()
    var valid: validacionController = validacionController()
    let lang = Bundle.main.preferredLocalizations.first
    var paiSel: String = ""
    var motSel: String = ""
    
    @IBOutlet weak var entrySwitch: UISwitch!
    @IBOutlet weak var departureSwitch: UISwitch!
    @IBOutlet weak var countryLabel: UILabel!
    @IBOutlet weak var companyText: UITextField!
    @IBOutlet weak var flightText: UITextField!
    @IBOutlet weak var reasonLabel: UILabel!
    
    @IBAction func entryAction(_ sender: UISwitch) {
        if entrySwitch.isOn {
            departureSwitch.isOn = false
            dbc.setCampo("tipo", indice, "I")
        }
    }
    
    @IBAction func departureAction(_ sender: UISwitch) {
        if departureSwitch.isOn {
            entrySwitch.isOn = false
            dbc.setCampo("tipo", indice, "S")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.tableFooterView = UIView()
        companyText.delegate = self
        flightText.delegate = self
        companyText.addTarget(self, action: #selector(textEmpresa(_:)), for: .editingChanged)
        flightText.addTarget(self, action: #selector(textVuelo(_:)), for: .editingChanged)
    }

    override func viewWillAppear(_ animated: Bool) {
        let query = dbc.getSelect("ingresosalida", indice)
        if query[0].isEmpty {
            entrySwitch.isOn = false
            departureSwitch.isOn = false
        }
        else {
            if query[0] == "I" {
                entrySwitch.isOn = true
            }
            if query[0] == "S" {
                departureSwitch.isOn = true
            }
        }
        
        if query[1].isEmpty {
            if lang == "es-419"{
                countryLabel.text = "Seleccione"
            }
            else{
                countryLabel.text = "Select"
            }
            paiSel = ""
        }
        else{
            if lang == "es-419"{
                print(dbc.getPais("descripcion", query[1]))
                countryLabel.text = dbc.getPais("descripcion", query[1])
            }
            else{
                countryLabel.text = dbc.getPais("descripcion_en", query[1])
            }
            paiSel = query[1]
        }
        companyText.text = query[2]
        flightText.text = query[3]
        if query[4].isEmpty {
            if lang == "es-419"{
                reasonLabel.text = "Seleccione"
            }
            else{
                reasonLabel.text = "Select"
            }
            paiSel = ""
        }
        else{
            if lang == "es-419"{
                switch query[4]{
                    case "T": reasonLabel.text = "Turismo"
                    case "R": reasonLabel.text = "Retorno"
                    case "N": reasonLabel.text = "Negocios"
                    case "S": reasonLabel.text = "Salud"
                    case "O": reasonLabel.text = query[5]
                default: break
                }
            }
            else{
                switch query[4]{
                    case "T": reasonLabel.text = "Turism"
                    case "S": reasonLabel.text = "Health"
                    case "N": reasonLabel.text = "Business"
                    case "R": reasonLabel.text = "Return"
                    case "O": reasonLabel.text = query[5]
                default: break
                }
            }
            motSel = query[4]
        }
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 2 {
            performSegue(withIdentifier: "countrySegue", sender: self)
        }
        if indexPath.row == 5 {
            performSegue(withIdentifier: "reasonSegue", sender: self)
        }
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "countrySegue" {
            let destination = segue.destination as! PaisViewController
            destination.indice = indice
        }
        if segue.identifier == "reasonSegue" {
            let destination = segue.destination as! MotivoTableViewController
            destination.indice = indice
        }
    }

}

extension ViajeTableViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField{
        case companyText:
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 40
        case flightText:
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 10
        default:
            return false
        }
    }
    
    @objc func textEmpresa(_ textField: UITextField) {
        if valid.esAlfabetico(testStr: textField.text!.uppercased()) {
            dbc.setCampo("transportadora", indice, textField.text!.uppercased())
        }
        else{
            textField.text!.remove(at: (textField.text?.index(before: (textField.text?.endIndex)!))!)
            companyText.text = textField.text
        }
    }
    
    @objc func textVuelo(_ textField: UITextField) {
        if valid.esAlfanumerico(testStr: textField.text!.uppercased()) {
            dbc.setCampo("vuelo", indice, textField.text!.uppercased())
        }
        else{
            textField.text!.remove(at: (textField.text?.index(before: (textField.text?.endIndex)!))!)
            flightText.text = textField.text
        }
    }
}
