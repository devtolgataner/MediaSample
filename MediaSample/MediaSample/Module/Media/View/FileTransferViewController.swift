//
//  ViewController.swift
//  MediaSample
//
//  Created by Tolga Taner on 17.10.2020.
//

import UIKit.UIViewController

final class FileTransferViewController: UIViewController {

    @IBOutlet private weak var selectedImageView: UIImageView!
    @IBOutlet private weak var peripharelsTableView: UITableView!
    
    
    private var viewModel:FileTransferViewModel = FileTransferViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "File Transfer"
        viewModel.delegate = self
        peripharelsTableView.delegate = self
        peripharelsTableView.dataSource = self
        peripharelsTableView.tableFooterView = UIView()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        viewModel.disconnect()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        viewModel.scanPeripherals()
    }
    
    @IBAction private func chooseImageButtonDidTapped(_ sender: Any) {
        viewModel.openGallery(parentViewController: self)
    }
    
    @IBAction private func sendImageButtonDidTapped(_ sender: Any) {
        viewModel.connectSelectedPeripheral()
    }
    
}

extension FileTransferViewController: FileTransferViewModelDelegate {
    
    func fileTransferViewModelFailureOnConnection() {
        showAlert(title: "",
             message: "Turn on your bluetooth",
                              alertStyle: .alert,
                              actionTitles: ["Okay"],
                              actionStyles: [.default],
                              actions: [
                                  {_ in
                                  },
                                  {_ in
                                  }
                             ])
    }
    
    func fileTransferViewModel(failureOn error: Error?) {
        guard let error = error else { return }
        showAlert(title: "",
             message: error.localizedDescription,
                              alertStyle: .alert,
                              actionTitles: ["Okay"],
                              actionStyles: [.default],
                              actions: [
                                  {_ in
                                  },
                                  {_ in
                                  }
                             ])
    }
    
    func peripheralListDidUpdated() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            self.peripharelsTableView.reloadData()
        }
    }
    
    func fileTransferViewModel(pickedImage image: UIImage) {
        selectedImageView.image = image
        viewModel.selectedImage = image
    }
    
}

extension FileTransferViewController: UITableViewDelegate,UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedPeripheral = viewModel.peripherals[indexPath.row]
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.peripherals.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = UITableViewCell()
        cell.textLabel?.text = viewModel.peripherals[indexPath.row].name ?? "Unknown Device"
        return cell
    }
    
}
