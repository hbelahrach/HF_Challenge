
import UIKit
import SDWebImage
import Foundation



class PhotoItem : UICollectionViewCell {
    
    @IBOutlet var checkView: UIView!
    @IBOutlet var photoTitle: UILabel!
    @IBOutlet var image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setPhoto(id: String){
        setImage(id: id)
    }
    
    override var isSelected: Bool {
        didSet {
            checkView.isHidden = isSelected ? false : true
        }
    }
    
    private func setImage(id: String) {
        // set link
        var url = K.facebook.photoLink
        url = url.replacingOccurrences(of: "{album-id}", with: id)
        url = url.replacingOccurrences(of: "{token-id}", with: PreferencesManager.getToken())
        self.image.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "placeholder.png"))
        
        //set image
        self.image.layer.cornerRadius = 8.0
        self.image.clipsToBounds = true
        
        //set checkView
        self.checkView.layer.cornerRadius = self.checkView.layer.frame.size.width/2
        self.checkView.clipsToBounds = true
    }
}
