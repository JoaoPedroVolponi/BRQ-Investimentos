import Foundation
import UIKit

class CustomizacaoTextField: UITextField {
    
    func BordaQuantidade(_ quantidadeTextField: UITextField) {
        quantidadeTextField.layer.borderWidth = 1
        quantidadeTextField.layer.cornerRadius = 10
        quantidadeTextField.layer.borderColor = UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1).cgColor
        quantidadeTextField.attributedPlaceholder = NSAttributedString(string: "Quantidade", attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 151/255, green: 151/255, blue: 151/255, alpha: 1)])
    }
}
