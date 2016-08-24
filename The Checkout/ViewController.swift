//
//  ViewController.swift
//  The Checkout
// Implements a grocery store / cashier line simulation.
// Customers in a grocery store arrive at a set of registers to check out. 
// Each register is run by a cashier who serves customers on a first-come, first-served basis. 
// The goal of the problem is to determine when all customers are done checking out.
//
//
//

import UIKit

class ViewController: UIViewController, UITextViewDelegate {

    // MARK: - Properties
    @IBOutlet var inputText: UITextView!
    var numRegisters = 0
    var numCustomers = 0
    
    
    var custStrings:[String]?
    var customers = [Customer]()
    var registers = [Register]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        inputText.delegate = self
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    func setGrocery() {
        // Create array of input
        let inputs = inputText.text.components(separatedBy: "\n")
        
        // Set number of registers
        numRegisters = Int(inputs[0])!
        print("Registers = \(numRegisters)")
        // Set number of customers
        numCustomers = inputs.count - 1
        print("Customers = \(numCustomers)")
        
        // Set customer array
        let custs = Array(inputs[1...(inputs.count-1)])
        custStrings = custs
        
        createCustomer()
        createRegisters()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Create array of customers sorted by arrival time and priority
    func createCustomer() {
        // reset customers
        self.customers.removeAll()
        
        for c in custStrings! {
            // Parse customer info 0:"Type" 1:"Arrival" 2:"items"
            var custRay = c.components(separatedBy: " ")
            let newCust = Customer(items: Int(custRay[2])!, type: custRay[0], arrival: Int(custRay[1])!, registerAssignment: 0)
            
            customers.append(newCust)
        }
        
        print("\(customers[0].type) \(customers[0].arrival) \(customers[0].items)")
        print("Now Sort")
        print("Customers count: \(customers.count)")
        // sort Customers by arrival time
        customers.sort { (Customer1, Customer2) -> Bool in
            return Customer1.arrival < Customer2.arrival ||
                (Customer1.arrival == Customer2.arrival) && custAPriority(c1: Customer1, c2: Customer2)
        }
        
        for i in 0...(customers.count-1) {
            print("\(customers[i].type) \(customers[i].arrival) \(customers[i].items)")
        }

    }
    
    func custAPriority(c1: Customer, c2: Customer) -> Bool {
        //  If two or more customers arrive at the same time, those with fewer items choose registers before those with more,
        //  and if they have the same number of items then type A's choose before type B's
        return (c1.items < c2.items) || c1.type == "A"
    }
    
    
    
    
    // Create array of registers with atleast 1 trainee, far right
    func createRegisters() {
        
        // reset registers
        self.registers.removeAll()
        
        var newRegister: Register?
        for i in 1...numRegisters {
            if i == numRegisters {
                // Sets final register as trainee
                newRegister = Register(regNum: i, trainee: true, counter: 0)
            } else {
                newRegister = Register(regNum: i, trainee: false, counter: 0)
            }
            
            registers.append(newRegister!)
        }
        
        print("Registers count: \(registers.count)")
    }

    // func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
    //    if(text == "\n") {
    //        textView.resignFirstResponder()
    //        return false
    //    }
    //    return true
    //}
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        setGrocery()
        let backItem = UIBarButtonItem()
        backItem.title = ""
        navigationItem.backBarButtonItem = backItem // This will show in the next view controller being pushed
        if segue.identifier == "checkoutSeg" {
            let vc = segue.destinationViewController as! CheckViewController
            vc.customers = self.customers
            vc.registers = self.registers
        }
     }
    
}

