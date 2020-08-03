import UIKit

class FilterViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    var ciFilterNames : [String] = [
    "CISepiaTone"
    ]
    
    @IBOutlet weak var filterImgPreview: UIImageView!
    @IBOutlet weak var filterPreviews: UICollectionView!
    
    var image : UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    func setupUI() {
        filterImgPreview.image = image
    }
    
    func display(image : UIImage, filterName : String) {
        let ciContext = CIContext(options: nil)
        let coreImage = CIImage(image: image)
        if let filter = CIFilter(name: filterName) {
            filter.setDefaults()
            filter.setValue(image, forKey: kCIInputImageKey)
            if let filteredImageData = filter.value(forKey: kCIOutputImageKey) as? CIImage,
                let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent) {
                let image = UIImage(cgImage: filteredImageRef)
                filterImgPreview.image = image
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ciFilterNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let filterPreViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterPreViewCell", for: indexPath) as? FilterPreViewCell
        else { return UICollectionViewCell() }
        filterPreViewCell.filterName.text = ciFilterNames[indexPath.row]
        filterPreViewCell.filterImgPreView.image = filterImgPreview.image
        
        return filterPreViewCell
    }

}
