//
//  ScanVC.swift
//  CoreBluetoothDemo
//
//  Created by João Marcelo on 18/06/15.
//  Copyright (c) 2015 BEPiD. All rights reserved.
//

import UIKit
import CoreBluetooth

class ScanVC: UIViewController, CBCentralManagerDelegate {
    var centralManager: CBCentralManager!
    let serviceUUIDS = [CBUUID(string: "180D")]
    
    var peripherals = [CBPeripheral]()
    var peripheral:CBPeripheral!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        if(central.state  == .PoweredOn){
            centralManager.scanForPeripheralsWithServices(serviceUUIDS, options: nil)
        }
        else{
            centralManager.stopScan()
        }
        
    }
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        
        let myString:String = peripheral.identifier.description
        var myStringArray = myString.componentsSeparatedByString(" ")
        
        if (myStringArray[2] == "17940C7B-90BD-3D1E-EB70-16D3A6657258"){
            centralManager.stopScan()
            centralManager.connectPeripheral(peripheral, options: nil)
            peripherals.append(peripheral)
        }
    }

    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        print("Prefiférico pareado: \(peripheral)")
        self.peripheral = peripheral
        performSegueWithIdentifier("HeartMonitorVC", sender: self.peripheral)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let heartMonitorVC = segue.destinationViewController as! HeartMonitorVC
        heartMonitorVC.peripheral = self.peripheral
        heartMonitorVC.servicesUIIDs = self.serviceUUIDS
    }
}
