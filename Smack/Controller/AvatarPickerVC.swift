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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.colView.dataSource = self
        self.colView.delegate = self
    }
    
    @IBAction func segmentControlChanged(_ sender: Any) {
        
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
            return cell
        }
        
        return AvatarCell()
    }
}

extension AvatarPickerVC : UICollectionViewDelegate {
    
}

extension AvatarPickerVC : UICollectionViewDelegateFlowLayout {
    
}
