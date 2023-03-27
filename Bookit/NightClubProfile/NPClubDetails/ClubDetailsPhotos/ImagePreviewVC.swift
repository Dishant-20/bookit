//
//  ImagePreviewVC.swift
//  Bookit
//
//  Created by Ranjan on 24/02/22.
//

import UIKit

class ImagePreviewVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout  {
    
    var myCollectionView: UICollectionView!
    var PhotoArray:NSMutableArray = []
    var passedContentOffset = IndexPath()
    var button:UIButton = UIButton()
    
    var str_from:String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.view.backgroundColor=UIColor.black
        
        let layout = UICollectionViewFlowLayout()
        layout.sectionInset = UIEdgeInsets(top: 40, left: 0, bottom: 0, right: 0)
        layout.minimumInteritemSpacing = 0
        layout.minimumLineSpacing = 0
        layout.scrollDirection = .horizontal
        
        print(passedContentOffset as Any)
        
        myCollectionView = UICollectionView(frame: self.view.frame, collectionViewLayout: layout)
        myCollectionView.delegate=self
        myCollectionView.dataSource=self
        myCollectionView.register(ImagePreviewFullViewCell.self, forCellWithReuseIdentifier: "Cell")
        myCollectionView.isPagingEnabled = true
        // myCollectionView.scrollToItem(at: passedContentOffset, at: .left, animated: true)
        
        self.view.addSubview(myCollectionView)
        
        //button
        
        //        let button = self.makeButton(title: "Back", titleColor: .blue, font: UIFont.init(name: "Arial", size: 18.0), background: .white, cornerRadius: 3.0, borderWidth: 2, borderColor: UIColor.black)
        //                view.addSubview(button)
        //                // Adding Constraints
        //                button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        //                button.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 40).isActive = true
        //                button.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -40).isActive = true
        //                button.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -400).isActive = true
        //               // button.addTarget(self, action: #selector(pressed(_ :)), for: .touchUpInside)
        
        let button = UIButton(frame: CGRect(x: 8, y: 34, width: 40, height: 40))
        // button.le = view.center
        button.backgroundColor = .white
        button.setTitle("", for: .normal)
        button.setImage(UIImage.init(systemName: "arrow.left"), for: .normal)
        button.addTarget(self, action:#selector(self.buttonClicked), for: .touchUpInside)
        self.view.addSubview(button)
        
        //
        
        
        myCollectionView.autoresizingMask = UIView.AutoresizingMask(rawValue: UIView.AutoresizingMask.RawValue(UInt8(UIView.AutoresizingMask.flexibleWidth.rawValue) | UInt8(UIView.AutoresizingMask.flexibleHeight.rawValue)))
    }
    
    // Define commmon method
    func makeButton(title: String? = nil,
                    titleColor: UIColor = .black,
                    font: UIFont? = nil,
                    background: UIColor = .clear,
                    cornerRadius: CGFloat = 0,
                    borderWidth: CGFloat = 0,
                    borderColor: UIColor = .clear) -> UIButton {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setTitle(title, for: .normal)
        button.backgroundColor = background
        button.setTitleColor(titleColor, for: .normal)
        button.titleLabel?.font = font
        button.layer.cornerRadius = 6.0
        button.layer.borderWidth = 2
        button.layer.borderColor = UIColor.red.cgColor
        return button
    }
    
    @objc func buttonClicked() {
        
        if self.str_from == "club_details" {
            self.navigationController?.popViewController(animated: false)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
        
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return PhotoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell=collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ImagePreviewFullViewCell
        
        if self.str_from == "club_details" {
            
            cell.imgView.sd_setImage(with: URL(string: (PhotoArray[indexPath.row]) as! String), placeholderImage: UIImage(named: "avatar"))
            
        } else {
            let item = PhotoArray[indexPath.row] as? [String:Any]
            print(item as Any)
            cell.imgView.sd_setImage(with: URL(string: (item!["image"] as! String)), placeholderImage: UIImage(named: "avatar"))
        }
        
        
        
        
        //cell.imgView.image=imgArray[indexPath.row]
        
        
        return cell
    }
    
    func scrollToIndex(index:Int) {
        
         let rect = self.myCollectionView.layoutAttributesForItem(at:IndexPath(row: index, section: 0))?.frame
         self.myCollectionView.scrollRectToVisible(rect!, animated: true)
     }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        guard let flowLayout = myCollectionView.collectionViewLayout as? UICollectionViewFlowLayout else { return }
        
        flowLayout.itemSize = myCollectionView.frame.size
        
        flowLayout.invalidateLayout()
        
        myCollectionView.collectionViewLayout.invalidateLayout()
        
        // scrollToIndex(index: 4)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let offset = myCollectionView.contentOffset
        let width  = myCollectionView.bounds.size.width
        
        let index = round(offset.x / width)
        let newOffset = CGPoint(x: index * size.width, y: offset.y)
        
        myCollectionView.setContentOffset(newOffset, animated: false)
        
        coordinator.animate(alongsideTransition: { (context) in
            self.myCollectionView.reloadData()
            
            self.myCollectionView.setContentOffset(newOffset, animated: false)
        }, completion: nil)
    }
    
}


class ImagePreviewFullViewCell: UICollectionViewCell, UIScrollViewDelegate {
    
    var scrollImg: UIScrollView!
    var imgView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        scrollImg = UIScrollView()
        scrollImg.delegate = self
        scrollImg.alwaysBounceVertical = false
        scrollImg.alwaysBounceHorizontal = false
        scrollImg.showsVerticalScrollIndicator = true
        scrollImg.flashScrollIndicators()
        
        scrollImg.minimumZoomScale = 1.0
        scrollImg.maximumZoomScale = 4.0
        
        let doubleTapGest = UITapGestureRecognizer(target: self, action: #selector(handleDoubleTapScrollView(recognizer:)))
        doubleTapGest.numberOfTapsRequired = 2
        scrollImg.addGestureRecognizer(doubleTapGest)
        
        self.addSubview(scrollImg)
        
        imgView = UIImageView()
        imgView.image = UIImage(named: "user3")
        scrollImg.addSubview(imgView!)
        imgView.contentMode = .scaleAspectFit
    }
    
    @objc func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer) {
        if scrollImg.zoomScale == 1 {
            scrollImg.zoom(to: zoomRectForScale(scale: scrollImg.maximumZoomScale, center: recognizer.location(in: recognizer.view)), animated: true)
        } else {
            scrollImg.setZoomScale(1, animated: true)
        }
    }
    
    func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imgView.frame.size.height / scale
        zoomRect.size.width  = imgView.frame.size.width  / scale
        let newCenter = imgView.convert(center, from: scrollImg)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return self.imgView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollImg.frame = self.bounds
        imgView.frame = self.bounds
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        scrollImg.setZoomScale(1, animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

