import Foundation
import UIKit

class CustomizacaoView: UIView {
    
    func BordaView(_ viewCambio: UIView) {
        viewCambio.layer.borderWidth = 1
        viewCambio.layer.cornerRadius = 15
        viewCambio.layer.borderColor = UIColor.white.cgColor
    }
}
