//
//  ExtranjeroViewController.swift
//  ANViajero
//
//  Created by Juan Carlos Quispe on 3/5/21.
//

import UIKit

class ExtranjeroViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var paisesTableView: UITableView!
    
    var indice: Int64 = 0
    var seleccionado: String = ""
    var paises: [String] = [String]()
    var searchActive: Bool = false
    var filtrado: [String] = []
    var dbc: dbController = dbController()
    let lang = Bundle.main.preferredLocalizations.first
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchBar.delegate = self
        paisesTableView.delegate = self
        paisesTableView.dataSource = self
        
        if lang == "es-419" {
            paises = dbc.getSelect("paises", 0)
        }
        else{
            paises = dbc.getSelect("paises_en", 0)
        }
    }
}

extension ExtranjeroViewController: UISearchBarDelegate {
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        filtrado = paises.filter({ (text) -> Bool in
            let tmp: String = text
            let range = tmp.range(of: searchText, options: String.CompareOptions.caseInsensitive)
            if range != nil{
                return true
            }
            else{
                return false
            }
        })
        if(filtrado.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.paisesTableView.reloadData()
    }
}

extension ExtranjeroViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            cell.accessoryType = .checkmark
            if lang == "es-419"{
                dbc.setCampo("nacionalidad", indice, dbc.getPais("pais", (cell.textLabel?.text)!))
            }
            else{
                dbc.setCampo("nacionalidad", indice, dbc.getPais("pais_en", (cell.textLabel?.text)!))
            }
        }
        self.navigationController?.popViewController(animated: true)
    }
}

extension ExtranjeroViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if searchActive {
            return filtrado.count
        }
        return paises.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if(searchActive){
            cell.textLabel?.text = filtrado[indexPath.row]
            if seleccionado == filtrado[indexPath.row]{
                cell.accessoryType = .checkmark
            }
            else{
                cell.accessoryType = .none
            }
        }
        else{
            cell.textLabel?.text = paises[indexPath.row]
            if seleccionado == paises[indexPath.row]{
                cell.accessoryType = .checkmark
            }
            else{
                cell.accessoryType = .none
            }
        }
        return cell
    }
}
