//
//  DetailViewController.swift
//  StoreSearch
//
//  Created by Dzmitry Hlushchuk on 2.07.24.
//

import UIKit
import MessageUI

class DetailViewController: UIViewController {
    
    enum AnimationStyle {
        case slide
        case fade
    }
    
    var dismissStyle: AnimationStyle = .fade
    var searchResult: SearchResult! {
        didSet {
            if isViewLoaded {
                updateUI()
            }
        }
    }
    var downloadTask: URLSessionDownloadTask?
    var dimmingView: GradientView!
    var isPopUp = false
    
    @IBOutlet weak var popupView: UIView!
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistNameLabel: UILabel!
    @IBOutlet weak var kindLabel: UILabel!
    @IBOutlet weak var genreLabel: UILabel!
    @IBOutlet weak var priceButton: UIButton!
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        transitioningDelegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        if isPopUp {
            setupUI()
            let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(close))
            gestureRecognizer.cancelsTouchesInView = false
            gestureRecognizer.delegate = self
            dimmingView.addGestureRecognizer(gestureRecognizer)
        } else {
            view.backgroundColor = .systemBackground
            popupView.isHidden = true
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .action, target: self, action: #selector(showPopover))
        }
        if searchResult != nil {
            updateUI()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        popupView.transform = CGAffineTransform(scaleX: 0.7, y: 0.7)
        UIView.animateKeyframes(withDuration: 0.4, delay: 0, options: .calculationModeCubic) {
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.334) {
                self.popupView.transform = CGAffineTransform(scaleX: 1.2, y: 1.2)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.334, relativeDuration: 0.33) {
                self.popupView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
            }
            UIView.addKeyframe(withRelativeStartTime: 0.666, relativeDuration: 0.333) {
                self.popupView.transform = CGAffineTransform(scaleX: 1, y: 1)
            }
        }
    }
    
    deinit {
        downloadTask?.cancel()
    }
    
    @IBAction func close() {
        dismissStyle = .slide
        UIView.animate(withDuration: 0.3, animations: {
            self.popupView.transform = CGAffineTransform(
                translationX: 0,
                y: -self.view.frame.height * 1.5
            ).concatenating(CGAffineTransform(scaleX: 0.5, y: 0.5))
        }, completion: { _ in
            self.dismiss(animated: true)
        })
    }
    
    private func setupUI() {
        view.backgroundColor = .clear
        dimmingView = GradientView(frame: .zero)
        dimmingView.frame = view.bounds
        view.insertSubview(dimmingView, at: 0)
        popupView.layer.cornerRadius = 10
        popupView.layer.shadowColor = UIColor.black.cgColor
        popupView.layer.shadowOpacity = 0.1
        popupView.layer.shadowOffset = CGSize(width: 2, height: 2)
        popupView.layer.masksToBounds = false
    }
    
    private func updateUI() {
        if let imageURL = URL(string: searchResult.imageLarge) {
            downloadTask = artworkImageView.loadImage(url: imageURL)
        }
        nameLabel.text = searchResult.name
        if searchResult.artist.isEmpty {
            artistNameLabel.text = NSLocalizedString("Unknown", comment: "Localized artist name label: Unknown")
        } else {
            artistNameLabel.text = searchResult.artist
        }
        kindLabel.text = searchResult.type
        genreLabel.text = searchResult.genre
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = searchResult.currency
        let priceText: String
        if searchResult.price == 0 {
            priceText = NSLocalizedString("Free", comment: "Localized price text: Free")
        } else if let text = formatter.string(from: searchResult.price as NSNumber) {
            priceText = text
        } else {
            priceText = ""
        }
        priceButton.setTitle(priceText, for: .normal)
        popupView.isHidden = false
    }

    @IBAction func openInStore() {
        if let url = URL(string: searchResult.storeURL) {
            UIApplication.shared.open(url, options: [:])
        }
    }
    
    @objc func showPopover(_ sender: UIBarButtonItem) {
        guard let popover = storyboard?.instantiateViewController(withIdentifier: "PopoverView") as? MenuViewController else { return }
        popover.modalPresentationStyle = .popover
        if let ppc = popover.popoverPresentationController {
            ppc.barButtonItem = sender
        }
        popover.delegate = self
        present(popover, animated: true)
    }
    
}

// MARK: - UIGestureRecognizerDelegate
extension DetailViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(
        _ gestureRecognizer: UIGestureRecognizer,
        shouldReceive touch: UITouch
    ) -> Bool {
        return touch.view === self.dimmingView
    }
}

// MARK: - UIViewControllerTransitioningDelegate
extension DetailViewController : UIViewControllerTransitioningDelegate {
//    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
//        return BounceAnimationController()
//    }
//    
//    func animationController(forDismissed dismissed: UIViewController) -> (any UIViewControllerAnimatedTransitioning)? {
//        switch dismissStyle {
//        case .slide:
//            return SlideOutAnimationController()
//        case .fade:
//            return FadeOutAnimationController()
//        }
//    }
}

// MARK: - MenuViewControllerDelegate
extension DetailViewController: MenuViewControllerDelegate {
    func menuViewControllerSendEmail(_ controller: MenuViewController) {
        dismiss(animated: true) {
            if MFMailComposeViewController.canSendMail() {
                let controller = MFMailComposeViewController()
                controller.mailComposeDelegate = self
                controller.setSubject("Support Request")
                controller.setToRecipients(["your@email-address-here.com"])
                self.present(controller, animated: true)
            }
        }
    }
}

// MARK: - MFMailComposeViewControllerDelegate
extension DetailViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: (any Error)?) {
        dismiss(animated: true)
    }
}
