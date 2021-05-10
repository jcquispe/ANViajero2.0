//
//  DivisaTableViewController.swift
//  ANViajero
//
//  Created by Juan Carlos on 3/5/21.
//

import UIKit

class DivisaTableViewController: UITableViewController {

    var indice: Int64 = 0
    var tipo: String = ""
    var dbc: dbController = dbController()
    var valid: validacionController = validacionController()
    var gen: AlertController = AlertController()
    let lang = Bundle.main.preferredLocalizations.first
    var mostrar = true
    
    @IBOutlet weak var divisasSwitch: UISwitch!
    @IBOutlet weak var usdText: UITextField!
    @IBOutlet weak var monto1Text: UITextField!
    @IBOutlet weak var monto2Text: UITextField!
    @IBOutlet weak var moneda1Text: UITextField!
    @IBOutlet weak var moneda2Text: UITextField!
    @IBOutlet weak var origenDivisasText: UITextField!
    @IBOutlet weak var detinoDivisasText: UITextField!
    
    @IBAction func divisasAction(_ sender: UISwitch) {
        if divisasSwitch.isOn {
            dbc.setCampo("mayor", indice, "S")
            mostrar = false
        }
        else{
            dbc.setCampo("mayor", indice, "N")
            mostrar = true
            dbc.setCampo("montousd", indice, "")
            dbc.setCampo("importe1", indice, "")
            dbc.setCampo("moneda1", indice, "")
            dbc.setCampo("importe2", indice, "")
            dbc.setCampo("moneda2", indice, "")
            dbc.setCampo("origen", indice, "")
            dbc.setCampo("destino", indice, "")
            viewDidAppear(true)
        }
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        usdText.delegate = self
        monto1Text.delegate = self
        monto2Text.delegate = self
        moneda1Text.delegate = self
        moneda2Text.delegate = self
        origenDivisasText.delegate = self
        detinoDivisasText.delegate = self
        usdText.addTarget(self, action: #selector(usdText(_:)), for: .editingChanged)
        monto1Text.addTarget(self, action: #selector(montoText1(_:)), for: .editingChanged)
        moneda1Text.addTarget(self, action: #selector(monedaText1(_:)), for: .editingChanged)
        monto2Text.addTarget(self, action: #selector(montoText2(_:)), for: .editingChanged)
        moneda2Text.addTarget(self, action: #selector(monedaText2(_:)), for: .editingChanged)
        origenDivisasText.addTarget(self, action: #selector(origenText(_:)), for: .editingChanged)
        detinoDivisasText.addTarget(self, action: #selector(destinoText(_:)), for: .editingChanged)
        tableView.tableFooterView = UIView()
        self.hideKeyboardWhenTappedAround()
        
        
        tableView.delegate = self
        tableView.dataSource = self
                
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(notification:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(notification:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc private func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardSize.height + tableView.rowHeight, right: 0)
        }
    }

    @objc private func keyboardWillHide(notification: NSNotification) {
        tableView.contentInset = .zero
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if tipo == "S"{
            /*if lang == "es-419"{
                enunciado.text = "¿Llevo dinero en efectivo por una cantidad mayor a los $us 10.000 o su equivalente en otras monedas?"
                enunciado2.text = "Si su respuesta fue afirmativa, declare la cantidad que lleva:"
            }
            else{
                enunciado.text = "I carry cash for an amount upper than USD 10.000 or its equivalnet in other currencies"
                enunciado2.text = "If your answer was affirmative, declare the amount you carrie:"
            }*/
        }
        
        let query = dbc.getSelect("divisas", indice)
        if query[0] == "" {
            dbc.setCampo("mayor", indice, "N")
        }
        else{
            if query[0] == "S" {
                divisasSwitch.setOn(true, animated: true)
                mostrar = false
            }else{
                divisasSwitch.setOn(false, animated: true)
                mostrar = true
            }
            usdText.text = query[1]
            monto1Text.text = query[2]
            moneda1Text.text = query[3]
            monto2Text.text = query[4]
            moneda2Text.text = query[5]
            origenDivisasText.text = query[6]
            detinoDivisasText.text = query[7]
            tableView.reloadData()
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        if mostrar {
            switch section {
            case 1:
                return 0.0
            case 2:
                return 0.0
            case 3:
                return 0.0
            case 4:
                return 0.0
            default:
                return 50.0
            }
        }
        else{
            return 50.0
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if mostrar {
            switch section{
            case 1:
                return 0
            case 2:
                return 0
            case 3:
                return 0
            case 4:
                return 0
            default:
                return super.tableView(tableView, numberOfRowsInSection: section)
            }
        }
        else{
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
}

extension DivisaTableViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        switch textField{
        case usdText:
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 5
        case monto1Text:
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 8
        case monto2Text:
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 8
        case moneda1Text:
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 30
        case moneda2Text:
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 30
        case origenDivisasText:
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 60
        case detinoDivisasText:
            guard let text = textField.text else { return true }
            let newLength = text.count + string.count - range.length
            return newLength <= 60
        default:
            return false
        }
    }
    
    @objc func usdText(_ textField: UITextField) {
        if valid.esNumerico(testStr: textField.text!.uppercased()) {
            if textField.text != ""{
                if Int(textField.text!)! > 99999 {
                    usdText.text = ""
                    if lang == "es-419" {
                        let alerta = gen.alert("Verifique", "Monto máximo: 99999", "Aceptar")
                        self.present(alerta, animated: true, completion: nil)
                    }
                    else{
                        let alerta = gen.alert("Verify", "Maximum amount: 99999", "OK")
                        self.present(alerta, animated: true, completion: nil)
                    }
                    dbc.setCampo("montousd", indice, textField.text!)
                }
                else{
                    dbc.setCampo("montousd", indice, textField.text!)
                }
            }
            else{
                dbc.setCampo("montousd", indice, textField.text!)
            }
        }
        else{
            textField.text!.remove(at: (textField.text?.index(before: (textField.text?.endIndex)!))!)
            usdText.text = textField.text
        }
    }
    
    @objc func montoText1(_ textField: UITextField) {
        if valid.esNumerico(testStr: textField.text!.uppercased()) {
            dbc.setCampo("importe1", indice, textField.text!)
        }
        else{
            textField.text!.remove(at: (textField.text?.index(before: (textField.text?.endIndex)!))!)
            monto1Text.text = textField.text
        }
    }
    
    @objc func montoText2(_ textField: UITextField) {
        if valid.esNumerico(testStr: textField.text!.uppercased()) {
            dbc.setCampo("importe2", indice, textField.text!)
        }
        else{
            textField.text!.remove(at: (textField.text?.index(before: (textField.text?.endIndex)!))!)
            monto2Text.text = textField.text
        }
    }
    
    @objc func monedaText1(_ textField: UITextField) {
        if valid.esAlfabetico(testStr: textField.text!.uppercased()) {
            dbc.setCampo("moneda1", indice, textField.text!.uppercased())
        }
        else{
            textField.text!.remove(at: (textField.text?.index(before: (textField.text?.endIndex)!))!)
            moneda1Text.text = textField.text
        }
    }
    
    @objc func monedaText2(_ textField: UITextField) {
        if valid.esAlfabetico(testStr: textField.text!.uppercased()) {
            dbc.setCampo("moneda2", indice, textField.text!.uppercased())
        }
        else{
            textField.text!.remove(at: (textField.text?.index(before: (textField.text?.endIndex)!))!)
            moneda2Text.text = textField.text
        }
    }
    
    @objc func origenText(_ textField: UITextField) {
        if valid.esAlfabetico(testStr: textField.text!.uppercased()){
            dbc.setCampo("origen", indice, textField.text!.uppercased())
        }
        else{
            textField.text!.remove(at: (textField.text?.index(before: (textField.text?.endIndex)!))!)
            origenDivisasText.text = textField.text?.uppercased()
        }
    }
    
    @objc func destinoText(_ textField: UITextField) {
        if valid.esAlfabetico(testStr: textField.text!.uppercased()){
            dbc.setCampo("destino", indice, textField.text!.uppercased())
        }
        else{
            textField.text!.remove(at: (textField.text?.index(before: (textField.text?.endIndex)!))!)
            detinoDivisasText.text = textField.text?.uppercased()
        }
    }
}
