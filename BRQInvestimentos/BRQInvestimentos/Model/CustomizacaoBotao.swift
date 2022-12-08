import Foundation
import UIKit

class CustomizacaoBotao: UIButton {
    
    func BordaBotao(_ botao: UIButton) {
        botao.layer.masksToBounds = true
        botao.layer.cornerRadius = 15
    }
    
    func BotaoHabilitado(_ botao: UIButton) {
        botao.isEnabled = true
        botao.alpha = 1
    }
    
    func BotaoDesabilitado(_ botao: UIButton) {
        botao.isEnabled = false
        botao.alpha = 0.5
    }
}
