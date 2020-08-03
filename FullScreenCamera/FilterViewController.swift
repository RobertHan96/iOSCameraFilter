import UIKit

class FilterViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var ciFilterNames : [String] = [
        "CIColorCrossPolynomial", "CIColorCube", "CIColorCubeWithColorSpace",
        "CIColorInvert", "CIColorMap", "CIColorMonochrome","CIColorPosterize",
        "CIFalseColor", "CIMaskToAlpha", "CIMaximumComponent", "CIMinimumComponent",
        "CIPhotoEffectChrome", "CIPhotoEffectFade", "CIPhotoEffectInstant",
        "CIPhotoEffectMono", "CIPhotoEffectNoir", "CIPhotoEffectProcess",
        "CIPhotoEffectTonal", "CIPhotoEffectTransfer", "CISepiaTone"
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
        filterPreviews.delegate = self
        filterPreviews.dataSource = self
        filterPreviews.register(UINib(nibName: "FilterPreViewCell", bundle: nil), forCellWithReuseIdentifier: "filterPreViewCell")
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filterPreViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterPreViewCell", for: indexPath) as! FilterPreViewCell
        filterImgPreview.image = filterPreViewCell.filterImgPreView.image
        self.view.layoutIfNeeded()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let cellWidth: CGFloat = (collectionView.bounds.width)/3
        let cellHeight: CGFloat = (collectionView.bounds.height)

        return CGSize(width: cellWidth, height: cellHeight)

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
