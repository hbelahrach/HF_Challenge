
import UIKit
import SDWebImage
import Foundation



class AlbumItem : UICollectionViewCell {
    
    @IBOutlet var albumTitle: UILabel!
    @IBOutlet var image: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setAlbum(id: String, title: String){
        self.albumTitle.text = title
        setImage(id: id)
    }
    
    private func setImage(id: String) {
        // set link
        var url = K.facebook.photoLink
        url = url.replacingOccurrences(of: "{album-id}", with: id)
        url = url.replacingOccurrences(of: "{token-id}", with: PreferencesManager.getToken())
        
        // set image
        self.image.sd_setImage(with: URL(string: url), placeholderImage: UIImage(named: "placeholder.png"))
        self.image.layer.cornerRadius = 8.0
        self.image.clipsToBounds = true
    }
}
