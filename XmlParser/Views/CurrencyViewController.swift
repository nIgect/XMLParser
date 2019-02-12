//  Created by iOS on 11.02.2019.
//

import UIKit

class CurrencyViewController: UIViewController {

    // MARK: - Properties

    var parser = XMLParser()
    var currencyArray = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = String()
    var currencyModel = Currency()

    fileprivate enum SectionType: Int {
        case currency
    }

    // MARK: - Outlets

    @IBOutlet weak var currencyTableView: UITableView!

    // MARK: - Life cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        currencyTableView.tableFooterView = UIView()
        parsingDataFromUrl()
        currencyTableView.isEditing = true
        currencyTableView.rowHeight = UITableView.automaticDimension
    }

    func parsingDataFromUrl() {
        currencyArray = []
        parser = XMLParser(contentsOf: URL(string: CurrencyManager.shared.url)!)!
            parser.delegate = self
            parser.parse()
        if parser.parserError != nil {
             parseErrorAlert()
        } else {
            currencyTableView.reloadData()
        }
    }

    // MARK: - Helpers

    func parseErrorAlert() {
        let alert = UIAlertController(title: "", message: "", preferredStyle: .alert)
        let message = "Ошибка обработки данных."
        let attribute = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)]
        let attributeString = NSAttributedString(string: message, attributes: attribute)
        alert.setValue(attributeString, forKey: "attributedMessage")
        let actionOK = UIAlertAction(title: "Ок", style: .default, handler: nil)
        alert.addAction(actionOK)
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

// MARK: - UITableViewDataSource

extension CurrencyViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if  let sectionType = SectionType(rawValue: section) {
            switch sectionType {
            case .currency:
                return currencyArray.count
            }
        }
        return 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let section = SectionType(rawValue: indexPath.section) {
            switch section {
            case .currency:
                if let cell = tableView.dequeueReusableCell(withIdentifier: "CurrencyCell",
                                                            for: indexPath) as? CurrencyCell {
                    cell.currency.text = (currencyArray.object(at: indexPath.row) as AnyObject)
                        .value(forKey: "CharCode") as? String
                    cell.rate.text = (currencyArray.object(at: indexPath.row) as AnyObject)
                        .value(forKey: "Rate") as? String
                    cell.currencyName.text = (currencyArray.object(at: indexPath.row) as AnyObject)
                        .value(forKey: "Name") as? String
                    cell.scale.text =  (currencyArray.object(at: indexPath.row) as AnyObject)
                        .value(forKey: "Scale") as? String 
                    return cell
                }
            }
        }
        return UITableViewCell()
    }

    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .none
    }

    func tableView(_ tableView: UITableView, shouldIndentWhileEditingRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedObject = self.currencyArray[sourceIndexPath.row]
        currencyArray.remove(sourceIndexPath.row)
        currencyArray.insert(movedObject, at: destinationIndexPath.row)
    }
}

// MARK: - UITableViewDelegate

extension CurrencyViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if let section = SectionType(rawValue: indexPath.section) {
            switch section {
            case .currency:
                return UITableView.automaticDimension
            }
        }
        return CGFloat()
  }
}

extension CurrencyViewController: XMLParserDelegate {
    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String : String] = [:]) {
        element = elementName
        if element == "Currency" {
            elements = [:]
            currencyModel.charCode = ""
            currencyModel.name = ""
            currencyModel.rate = ""
            currencyModel.scale = ""
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element == "CharCode" {
            currencyModel.charCode.append(string)
        } else if element == "Scale" {
            currencyModel.scale.append(string)
        } else if element == "Name" {
            currencyModel.name.append(string)
        } else if element == "Rate" {
            currencyModel.rate.append(string)
        }
    }
    func parser(_ parser: XMLParser,
                didEndElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?) {
        if elementName == "Currency" {
            if currencyModel.charCode != "" {
                elements.setObject(currencyModel.charCode, forKey: "CharCode" as NSCopying)
            }
            if currencyModel.scale != "" {
                elements.setObject(currencyModel.scale, forKey: "Scale" as NSCopying)
            }
            if currencyModel.name != "" {
                elements.setObject(currencyModel.name, forKey: "Name" as NSCopying)
            }
            if currencyModel.rate != "" {
                elements.setObject(currencyModel.rate, forKey: "Rate" as NSCopying)
            }
            currencyArray.add(elements)
        }
    }
}
