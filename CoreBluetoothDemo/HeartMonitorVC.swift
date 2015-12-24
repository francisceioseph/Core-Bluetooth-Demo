//
//  HeartMonitorVC.swift
//  CoreBluetoothDemo
//
//  Created by João Marcelo on 18/06/15.
//  Copyright (c) 2015 BEPiD. All rights reserved.
//

import UIKit
import CoreBluetooth

class HeartMonitorVC: UIViewController, CBPeripheralDelegate {
    
    @IBOutlet weak var hrmLabel: UILabel!
    
    var peripheral:CBPeripheral?
    var servicesUIIDs: [CBUUID]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        peripheral!.delegate = self
        peripheral!.discoverServices(self.servicesUIIDs)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        
        if let _ = error {
            self.dismissViewControllerAnimated(true, completion: nil)
            return
        }
        
        if let characteristics = service.characteristics as [CBCharacteristic]! {
            for characteristic in characteristics{
                if (characteristic.UUID.UUIDString == "2A37"){
                    peripheral.setNotifyValue(true, forCharacteristic: characteristic)
            
                }
            }
            
        }
    }
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        
        if let _ = error {
            return
        }
        
        if let value = characteristic.value {
            displayHeartRateMeasurement(value)

        }
    }
    
    func displayHeartRateMeasurement(value: NSData){
        var buffer = [UInt8] (count: value.length, repeatedValue: 0x00)
        value.getBytes(&buffer, length: buffer.count)
        var bpm:UInt16?
        
        if buffer[0] & 0x01 == 0 {
            bpm = UInt16(buffer[1])
        }
        else{
            bpm = UInt16(buffer[1]) << 8
            bpm = bpm! | UInt16(buffer[2])
        }
        
        if let hrm = bpm {
            hrmLabel.text = "\(hrm)"
        }
    }
    
}
