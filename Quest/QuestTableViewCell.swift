//
//  QuestTableViewCell.swift
//  Quest
//
//  Created by Yurii Troniak on 9/18/17.
//  Copyright © 2017 Yurii Troniak. All rights reserved.
//

import UIKit

class QuestTableViewCell: UITableViewCell {

    @IBOutlet weak var questName: UILabel!
    @IBOutlet weak var questStart: UILabel!
    @IBOutlet weak var questImage: UIImageView!
    
    private weak var imageDownloadTask: URLSessionDataTask?
    
    override func prepareForReuse() {
        questImage.image = nil
    }

    func setImage(withURL url: URL) {
        imageDownloadTask = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            if let error = error {
                print(error)
                return
            }
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    self.questImage.image = image
                }
            }
        })
        imageDownloadTask?.resume()
    }
    
    func cancelImageRequest() {
        imageDownloadTask?.cancel()
    }
}
