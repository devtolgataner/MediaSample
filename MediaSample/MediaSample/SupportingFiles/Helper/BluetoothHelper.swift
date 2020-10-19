//
//  BluetoothHelper.swift
//  MediaSample
//
//  Created by Tolga Taner on 17.10.2020.
//

import CoreBluetooth

protocol BluetoothHelperDelegate:class {
    func bluetoothHelper(didStateUpdated state:CBManagerState)
    func bluetoothHelper(didFailToConnect error:Error?)
    func bluetoothHelper(didDisconnect error:Error?)
    func bluetoothHelper(didDiscover peripheral:CBPeripheral)
    func bluetoothHelper(didDiscoverCharacteristics service:CBService)
    func bluetoothHelper(didFailTo error:Error)
}
final class BluetoothHelper:NSObject {
    
    fileprivate var manager: CBCentralManager?
    var targetPeripheral : CBPeripheral?
    
    weak var delegate:BluetoothHelperDelegate?

    
    override init() {
        super.init()
        manager = CBCentralManager(delegate: self,
                                   queue: .global(),
                                        options: nil)
        manager?.delegate = self
    }
    
    func connect(_ peripheral:CBPeripheral){
        manager?.connect(peripheral, options: nil)
    }
    
    func disconnect(_ peripheral:CBPeripheral){
        manager?.cancelPeripheralConnection(peripheral)
    }
    
    func scanForPeripherals() {
        if (manager?.isScanning ?? true){
            return
        }
        manager?.scanForPeripherals(withServices: nil, options: nil)
    }
    
}

extension BluetoothHelper:CBCentralManagerDelegate {
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        delegate?.bluetoothHelper(didStateUpdated: central.state)
    }
    
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        targetPeripheral = peripheral
        targetPeripheral?.delegate = self
        targetPeripheral?.discoverServices(nil)
    }
    

    
    func centralManager(_ central: CBCentralManager, didFailToConnect peripheral: CBPeripheral, error: Error?) {
        delegate?.bluetoothHelper(didFailToConnect:error)
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        delegate?.bluetoothHelper(didDisconnect: error)
    }
    
    func centralManager(_ central: CBCentralManager,
                        didDiscover peripheral: CBPeripheral,
                        advertisementData: [String : Any],
                        rssi RSSI: NSNumber) {
        delegate?.bluetoothHelper(didDiscover: peripheral)
    }
    
}


extension BluetoothHelper:CBPeripheralDelegate {
    
    func peripheral(_ peripheral: CBPeripheral, didWriteValueFor characteristic: CBCharacteristic, error: Error?) {
        
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        peripheral.discoverCharacteristics(nil, for: peripheral.services![0])
    }
    
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        delegate?.bluetoothHelper(didDiscoverCharacteristics: service)
    }
    func peripheral(_ peripheral: CBPeripheral, didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
    
    }
}

extension BluetoothHelper:FileTransferViewModelDatasource {
    
    func fileTransferViewModel(willSend imageData: Data,
                               dependsOnDiscoveredCharacterics service: CBService) {
        service.characteristics?.forEach {
            targetPeripheral?.writeValue(imageData, for: $0, type: .withResponse)
        }
    }
    
    
    
}
