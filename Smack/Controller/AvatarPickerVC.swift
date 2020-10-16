//
//  AvatarPickerVC.swift
//  Smack
//
//  Created by Mahesh on 16/10/20.
//  Copyright © 2020 Sheliya Infotech. All rights reserved.
//

import UIKit

class AvatarPickerVC: UIViewController {
    @IBOutlet weak var colView: UICollectionView!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    var avatarType = AvatarType.dark
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("AvatarType: \(avatarType)")
        
        self.colView.dataSource = self
        self.colView.delegate = self
        
    }
    
    @IBAction func segmentControlChanged(_ sender: Any) {
        switch segmentControl.selectedSegmentIndex {
        case 1:
            avatarType = .light
        default:
            avatarType = .dark
        }
        self.colView.reloadData()
    }
    
    @IBAction func backPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}
extension AvatarPickerVC : UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 28
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "avatarCell", for: indexPath) as? AvatarCell {
            
            cell.configureCell(index: indexPath.row, type: avatarType)
            
            return cell
        }
        
        return AvatarCell()
    }
    
}

extension AvatarPickerVC : UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if avatarType == .dark {
            UserDataService.instance.setAvatarName(avatarName: "dark\(indexPath.row)")
        } else {
            UserDataService.instance.setAvatarName(avatarName: "light\(indexPath.row)")
        }
        print("dark\(indexPath.row)")
        print("UserDataService.instance : ", UserDataService.instance.avatarName)
        self.dismiss(animated: true, completion: nil)
    }
}

extension AvatarPickerVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        var numberOfColumns : CGFloat = 3
        if UIScreen.main.bounds.size.width > 320 {
            numberOfColumns = 4
        }
        
        let spaceBetweenCells : CGFloat = 10
        let padding : CGFloat = 40
        
        let widthAfterPadding = collectionView.bounds.size.width - padding
        let totalSpaceBetweenCell = (numberOfColumns - 1) * spaceBetweenCells
        
        let widthAfterSpaceBetweenCellsAndPadding = widthAfterPadding - totalSpaceBetweenCell
        
        let cellDimension = widthAfterSpaceBetweenCellsAndPadding / numberOfColumns
//        print(cellDimension)
        return CGSize(width: cellDimension, height: cellDimension)
    }
}
