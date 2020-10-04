import UIKit
import Photos

class FilterViewController : UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    @IBOutlet weak var filterImgPreview: UIImageView!
    @IBOutlet weak var filterPreviews: UICollectionView!
    @IBOutlet weak var imageSaveBtn: UIButton!
    var originImage : UIImage?
    var ciFilterNames : [String] = [
        "CIColorInvert", "CIColorMonochrome","CIColorPosterize",
        "CIFalseColor", "CIMaskToAlpha", "CIMaximumComponent", "CIMinimumComponent",
        "CIPhotoEffectChrome", "CIPhotoEffectFade", "CIPhotoEffectInstant",
        "CIPhotoEffectMono", "CIPhotoEffectNoir", "CIPhotoEffectProcess",
        "CIPhotoEffectTonal", "CIPhotoEffectTransfer", "CISepiaTone"
    ]
    
    let filterNamesForDisplay : [ String ] = [
            "색 반전", "모노","포스터",
            "황색", "알파", "맥시멈", "미니멈",
            "크롬", "페이드", "인스턴트",
            "모노", "노이어", "사진첩",
            "토날", "트랜스퍼", "세피아"
        ]

    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupFlowLayout()
    }
    
    @IBAction func imageSave(_ sender: Any) {
        if let img = filterImgPreview.image {
            savePhotoLibrary(image: img)
        }
        print("clicked")
    }
    
    private func savePhotoLibrary(image: UIImage) {
        // TODO: capture한 이미지 포토라이브러리에 저장
        PHPhotoLibrary.requestAuthorization { status in
            if status == .authorized {
                PHPhotoLibrary.shared().performChanges({
                    PHAssetChangeRequest.creationRequestForAsset(from: image)
                }, completionHandler: { (_, error) in
                    DispatchQueue.main.async {
                        self.filterImgPreview.image = self.originImage
                    }
                })
            } else {
                print(" error to save photo library")
            }
        }
    }
    func setupUI() {
        filterImgPreview.image = originImage
        filterPreviews.delegate = self
        filterPreviews.dataSource = self
        filterPreviews.register(UINib(nibName: "FilterPreViewCell", bundle: nil), forCellWithReuseIdentifier: "filterPreViewCell")
    }
 
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let filterPreViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterPreViewCell", for: indexPath) as! FilterPreViewCell
        if let img = originImage {
            DispatchQueue.main.async {
                self.displayFilterdImage(image: img, filterName: self.ciFilterNames[indexPath.row])
                self.view.layoutIfNeeded()
            }
        }
    }

    private func setupFlowLayout() {
        let flowLayout = UICollectionViewFlowLayout()
        flowLayout.sectionInset = UIEdgeInsets.zero
        flowLayout.minimumInteritemSpacing = 0
        flowLayout.minimumLineSpacing = 10
        
        let halfWidth = UIScreen.main.bounds.width / 5
        flowLayout.itemSize = CGSize(width: halfWidth * 0.9 , height: halfWidth * 0.9)
        self.filterPreviews.collectionViewLayout = flowLayout
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ciFilterNames.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let filterPreViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: "filterPreViewCell", for: indexPath) as? FilterPreViewCell
        else { return UICollectionViewCell() }
        filterPreViewCell.filterName.text = filterNamesForDisplay[indexPath.row]
        let exampleImage = UIImage(named: "office")
        filterPreViewCell.display(image: exampleImage!, filterName: ciFilterNames[indexPath.row])
        return filterPreViewCell
    }

    private func displayFilterdImage(image : UIImage, filterName : String) {
       let orientation = image.imageOrientation
        let ciContext = CIContext(options: nil)
        let coreImage = CIImage(image: image)
        if let filter = CIFilter(name: filterName) {
            filter.setDefaults()
            filter.setValue(coreImage, forKey: kCIInputImageKey)
            if let filteredImageData = filter.value(forKey: kCIOutputImageKey) as? CIImage,
                let filteredImageRef = ciContext.createCGImage(filteredImageData, from: filteredImageData.extent) {
                let image = UIImage(cgImage: filteredImageRef, scale: 1.0, orientation: orientation)
                filterImgPreview.image = image
            }
        }
    }
    
}
