import Foundation
import UIKit

class Carteira {
    
    var saldo: Double
    var saldoDisponivel: String {
        let formatador = NumberFormatter()
        formatador.numberStyle = .currency
        formatador.currencyCode = "BRL"
        if let resultado = formatador.string(from: NSNumber(value: saldo)) {
            return resultado
        }
        return "R$0.00"
    }
    
    var precoTotalCompra: Double
    var precoTotalCompraFormatado: String {
        let formatador = NumberFormatter()
        formatador.numberStyle = .currency
        formatador.currencyCode = "BRL"
        if let resultado = formatador.string(from: NSNumber(value: precoTotalCompra)) {
            return resultado
        }
        return "R$0.00"
    }
    
    var precoTotalVenda: Double
    var precoTotalVendaFormatado: String {
        let formatador = NumberFormatter()
        formatador.numberStyle = .currency
        formatador.currencyCode = "BRL"
        if let resultado = formatador.string(from: NSNumber(value: precoTotalVenda)) {
            return resultado
        }
        return "R$0.00"
    }
    
    let siglaMoedasAPI = ["USD", "EUR", "GBP", "ARS", "AUD", "BTC", "CAD", "CNY", "JPY"]
    var carteiraPessoal: [String: Int]
    
    init() {
        var carteiraUsuario = [String: Int]()
        
        // inicia todas as siglas em 0
        for sigla in siglaMoedasAPI {
            carteiraUsuario[sigla] = 0
        }
        
        self.saldo = 1000
        self.carteiraPessoal = carteiraUsuario
        self.precoTotalVenda = 0
        self.precoTotalCompra = 0
    }
    
    func comprarVender(quantidade: Int, sigla: String, valor: Double, botaoTag: Int, moeda: Currency) {
        guard let saldoMoeda = carteiraPessoal[sigla] else {return}
        
        if botaoTag == 0 {
            guard let precoCompraMoeda = moeda.buy else {return}
            
            let valorTotalCompra = precoCompraMoeda * Double(quantidade)
            carteiraPessoal[sigla] = saldoMoeda + quantidade
            saldo -= valorTotalCompra
            
            precoTotalCompra = valorTotalCompra
        } else {
            guard let precoVendaMoeda = moeda.sell else {return}
            
            let valorTotalVenda = precoVendaMoeda * Double(quantidade)
            carteiraPessoal[sigla] = saldoMoeda - quantidade
            saldo += valorTotalVenda
            
            precoTotalVenda = valorTotalVenda
        }
    }
}
