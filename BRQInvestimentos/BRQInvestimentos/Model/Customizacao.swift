import Foundation
import UIKit

extension CambioViewController {
    // MARK: - Funções Customização.
    
    func BordaView() {
        viewCambio.layer.borderWidth = 1
        viewCambio.layer.cornerRadius = 15
        viewCambio.layer.borderColor = UIColor.white.cgColor
        
    }
    
    func BordaQuantidade() {
        quantidadeTextField.layer.borderWidth = 1
        quantidadeTextField.layer.cornerRadius = 10
        quantidadeTextField.layer.borderColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1).cgColor
        quantidadeTextField.attributedPlaceholder = NSAttributedString(string: "Quantidade", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)])
    }
    
    func BordaBotao(_ botao: UIButton) {
        botao.layer.masksToBounds = true
        botao.layer.cornerRadius = 15
    }
    
    func BotaoHabilitado(_ botao: UIButton) {
        botao.isEnabled = true
        botao.alpha = 1
    }
    
    func BotaoDesabilitado( _ botao: UIButton) {
        botao.isEnabled = false
        botao.alpha = 0.5
    }
}
