//
//  EquipajeTableViewController.swift
//  ANViajero
//
//  Created by Juan Carlos on 3/5/21.
//

import UIKit

class EquipajeTableViewController: UITableViewController {

    var indice: Int64 = 0
    let dbc: dbController = dbController()
    var valid: validacionController = validacionController()
    var paiSel: String = ""
    
    @IBOutlet weak var equipajeSwitch: UISwitch!
    @IBOutlet weak var cantidadEquipajeText: UITextField!
    
    @IBAction func equipajeAction(_ sender: UISwitch) {
        if equipajeSwitch.isOn {
            dbc.setCampo("articulosNo", indice, "S")
        }
        else {
            dbc.setCampo("articulosNo", indice, "N")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cantidadEquipajeText.delegate = self
        cantidadEquipajeText.addTarget(self, action: #selector(textEquipaje(_:)), for: .editingChanged)
        tableView.tableFooterView = UIView()
    }

    override func viewWillAppear(_ animated: Bool) {
        let query = dbc.getSelect("equipaje", indice)
        cantidadEquipajeText.text = query[0]
        
        if(!query[2].isEmpty){
            if query[2] == "S" {
                equipajeSwitch.setOn(true, animated: true)
            }else{
                equipajeSwitch.setOn(false, animated: true)
            }
        }else{
            dbc.setCampo("articulosNo", indice, "N")
            equipajeSwitch.setOn(false, animated: true)
        }
    }
}

extension EquipajeTableViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField{
        case cantidadEquipajeText:
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 2
        default:
            return false
        }
    }
    
    @objc func textEquipaje(_ textField: UITextField) {
        if valid.esNumerico(testStr: textField.text!.uppercased()) {
            dbc.setCampo("equipaje", indice, textField.text!)
        }
        else{
            textField.text!.remove(at: (textField.text?.index(before: (textField.text?.endIndex)!))!)
            cantidadEquipajeText.text = textField.text
        }
    }
}
