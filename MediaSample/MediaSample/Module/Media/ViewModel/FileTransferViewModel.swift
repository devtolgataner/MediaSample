//
//  MediaViewModel.swift
//  MediaSample
//
//  Created by Tolga Taner on 17.10.2020.
//

import UIKit.UIImage
import CoreBluetooth

protocol FileTransferViewModelDelegate:class {
    func fileTransferViewModel(pickedImage image:UIImage)
    func peripheralListDidUpdated()
    func fileTransferViewModel(failureOn error:Error?)
    func fileTransferViewModelFailureOnConnection()
}

protocol FileTransferViewModelDatasource:class {
    func fileTransferViewModel(willSend imageData:Data,
                               dependsOnDiscoveredCharacterics service:CBService)
}

final class FileTransferViewModel {
    

    weak var datasource:FileTransferViewModelDatasource?
    weak var delegate:FileTransferViewModelDelegate?
    private lazy var mediaHelper:MediaHelper = MediaHelper()
    lazy var bluetoothHelper:BluetoothHelper = BluetoothHelper()
    var peripherals:[CBPeripheral] = [] {
        didSet{
            delegate?.peripheralListDidUpdated()
        }
    }
    var selectedPeripheral:CBPeripheral?
    var selectedImage:UIImage?
    
    init(){
        mediaHelper.delegate = self
        bluetoothHelper.delegate = self
        datasource = bluetoothHelper 
    }
    
    func openGallery(parentViewController controller:UIViewController) {
        mediaHelper.openAlbum(parentController: controller)
    }
    
    func disconnect(){
        guard let selectedPeripheral = selectedPeripheral else { return }
        bluetoothHelper.disconnect(selectedPeripheral)
    }
    
    func connectSelectedPeripheral(){
        guard let selectedPeripheral = selectedPeripheral
        else {
            delegate?.fileTransferViewModelFailureOnConnection()
        return
        }
        bluetoothHelper.connect(selectedPeripheral)
    }
    
    func scanPeripherals(){
        bluetoothHelper.scanForPeripherals()
    }
    
    
}

extension FileTransferViewModel:MediaHelperDelegate {
    
    func mediaHelper(didPickImage image: UIImage) {
        delegate?.fileTransferViewModel(pickedImage: image)
    }
    
}

extension FileTransferViewModel:BluetoothHelperDelegate {
    
    func bluetoothHelper(didDiscoverCharacteristics service: CBService) {
        guard let selectedImage = selectedImage else { return }
        datasource?.fileTransferViewModel(willSend: selectedImage.jpegData(compressionQuality: 0.8)!,
                                          dependsOnDiscoveredCharacterics: service)
    }
    
    func bluetoothHelper(didFailTo error: Error) {
        delegate?.fileTransferViewModel(failureOn: error)
    }
    
    func bluetoothHelper(didStateUpdated state: CBManagerState) {
        switch state {
        case .poweredOff,.resetting,.unknown,.unsupported,.unauthorized:
            disconnect()
            peripherals.removeAll()
        case .poweredOn: scanPeripherals()
        }
    }
    
    func bluetoothHelper(didFailToConnect error: Error?) {
        delegate?.fileTransferViewModel(failureOn: error)
    }
    
    func bluetoothHelper(didDisconnect error: Error?) {
        peripherals.removeAll()
    }
    
    func bluetoothHelper(didDiscover peripheral: CBPeripheral) {
        if !peripherals.contains(peripheral) {
            peripherals.append(peripheral)
        }
    }
    
}
