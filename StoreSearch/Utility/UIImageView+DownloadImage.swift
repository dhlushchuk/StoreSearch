//
//  UIImageView+DownloadImage.swift
//  StoreSearch
//
//  Created by Dzmitry Hlushchuk on 2.07.24.
//

import UIKit

extension UIImageView {
    func loadImage(url: URL) -> URLSessionDownloadTask {
        let session = URLSession.shared
        let downloadTask = session.downloadTask(with: url) { [weak self] url, _, error in
            if error == nil, let url,
                let data = try? Data(contentsOf: url), 
                let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    guard let self else { return }
                    self.image = image
                }
            }
        }
        downloadTask.resume()
        return downloadTask
    }
}
