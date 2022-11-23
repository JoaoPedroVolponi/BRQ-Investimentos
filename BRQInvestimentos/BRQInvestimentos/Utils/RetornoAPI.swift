import Foundation
import UIKit

struct Results: Codable {
    let currencies: Currencies
}

struct Currencies: Codable {
    let source: String
    let USD, EUR, GBP, ARS, AUD, BTC, CAD, CNY, JPY: Currency
}

struct Currency: Codable {
    let name: String
    let buy: Double?
    let sell: Double?
    let variation: Double
    var variationString: String {
        return String(format: "%.2f", variation) + "%"
    }
    
    var compraString: String {
        if let compra = buy {
            let numeroCompra = NSNumber(value: compra)
            let formato = formatacaoBRL()
            if let resultado = formato.string(from: numeroCompra) {
                return resultado
            }
        }
        return "R$0.00"
    }
    
    var vendaString: String {
        if let venda = sell {
            let numeroVenda = NSNumber(value: venda)
            let formato = formatacaoBRL()
            if let resultado = formato.string(from: numeroVenda) {
                return resultado
            }
        }
        return "R$0.00"
    }
    
    func formatacaoBRL() -> NumberFormatter {
        let formato = NumberFormatter()
        formato.numberStyle = .currency
        formato.currencyCode = "BRL"
        return formato
    }
}


