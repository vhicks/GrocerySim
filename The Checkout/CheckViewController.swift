//
//  CheckViewController.swift
//  The Checkout
//
//
//  Run simulation based on number of registers and customers

import UIKit

class CheckViewController: UIViewController {
    
    // MARK: - Properties
    var registers = [Register]()
    var customers = [Customer]()
    var assignedCusts = 0
    var completedCusts = 0
    
    var time = 0
    var emptyRegs = [Int]()
    var endSim = false

    @IBOutlet var timeLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // style
        let attrs = [
            NSForegroundColorAttributeName : UIColor.darkGray(),
            NSFontAttributeName : UIFont(name: "Avenir Next Condensed", size: 18)!
        ]
        UINavigationBar.appearance().titleTextAttributes = attrs
        
        print(registers.count)
        print(customers.count)
        assignToRegisters()
        
        for r in registers {
            let custs = r.custList?.count
            print("Register: \(r.regNum) has \(custs) customers")
        }
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        clearAll()
    }
    
    func clearAll() {
        registers.removeAll()
        customers.removeAll()
    }
    

    
    // Assign customer to register
    func assignToRegisters() {
        incrementTime()
        // Run while customers still available
        if completedCusts != customers.count {
            // Check that all ending customers are removed
            // Check current time and arrival times
            for c in customers {
                
                // Assign customers with current arrival time to register
                if c.arrival == self.time {
                    // Check that last customer is not holding position in line
                    noLine()
                    
                    // Find Available Register
                    if openRegisters().count != 0 {
                        let firstAvailReg = openRegisters()[0]
                        
                        // Assign customer to first available register
                        c.registerAssignment = firstAvailReg.regNum
                        print("i. Assigned customer to register: \(c.registerAssignment) at \(self.time)")
                        
                        // Update register queue and occupancy NEED BOTH???
                        //firstAvailReg.customers = 1
                        firstAvailReg.custList?.append(c)
                        //firstAvailReg.occupied = true
                        
                    } else {
                        // No open registers now looks at type of current customer
                        if c.type == "A" {
                            // Type A looks for less customers in line
                            let leastReg = leastLineRegister()
                            
                            c.registerAssignment = leastReg.regNum
                            print("ii. Assigned customer to register: \(c.registerAssignment) at \(self.time)")

                            leastReg.custList?.append(c)
                            
                        } else if c.type == "B" {
                            // Type B looks for less items for last customer
                            let leastItemReg = leastItemCart()
                            
                            c.registerAssignment = leastItemReg.regNum
                            print("iii. Assigned customer to register: \(c.registerAssignment) at \(self.time)")
                            leastItemReg.custList?.append(c)
                        } else {
                            print("Invalid user type, do not assign")
                        }
                        
                    }
                    // Check assigned customers
                    assignedCusts += 1
                    
                }
                
            }
            // Check out process
            checkOutCustomers()
            
            // If customers not checked out assign to registers
            if !endSim {
                assignToRegisters()
            } else {
                return
            }
        }
    }
    
    
    /**
     * Register methods
     * maintains customer list in queue
     * counter - amount of time for current customer to check out
     **/
    
    // Remove customer in front of line and make available
    func removeEmpty (r: Register) {
        r.custList?.removeFirst()
        completedCusts += 1
        r.occupied = false
    }
    
    // Keeps empty customers out of queue
    // Customers just finishing checking out do not count as being in line
    func noLine() {
        for r in registers {
            if r.counter <= 1 && r.occupied
            {
                r.counter = 0
                removeEmpty(r: r)
            }
        }
    }
    

    // Decrements counter and for new time and Changes to next available Customer
    func checkOutCustomers() {
        // Each register has customer list
        // take current time and determine index 0 customer
        for r in registers {
            // set Counters
                // if there are customers left and register is available
            if (!r.occupied) {
                    if (r.custList?.count != 0) {
                        nextCustomer(r: r)
                        print("i. Register: \(r) next customer")
                }
            }
           else {
                if r.counter != 0 {
                    // if Occupied, decrement counter
                    r.counter! -= 1
                    if r.counter == 0 {
                        removeEmpty(r: r)
                        
                        // if next customer then
                        if(r.custList?.count != 0) {
                            nextCustomer(r: r)
                            print("ii. Register: \(r) next customer")
                        }

                    }
                } else {
                    //remove current customer in Register Cust List
                    removeEmpty(r: r)

                    // if next customer then
                    if(r.custList?.count != 0) {
                        nextCustomer(r: r)
                        print("iii. Register: \(r) next customer")
                    }
                }
            }
            
            endSimulation()
            
        }
     }
    

    func registersDone() -> Int {
        var countsComplete = 0
    
        for r in registers {
            if r.counter == 0 {
                countsComplete += 1
            }
        }
    
        return countsComplete
    }
    
    
    func nextCustomer(r: Register) {
        // Set current counter
        let currentCustItems = r.custList?[0].items
        
        // Assign to counter based on register type and occupy
        r.counter = r.trainee ? (currentCustItems! * 2) : currentCustItems!
        r.occupied = true
        
        // Initial item
        //r.counter! -= 1
    }

    
    func openRegisters() -> [Register]{

        var availRegisters = [Register]()
        // Add registers with num of customers = 0 to availRegisters
        for a in registers {
            if a.custList?.count == 0 {
                availRegisters.append(a)
            }
        }
        return availRegisters
    }
    
    /**
     * Customer methods
     * maintains customer list in queue
     * counter - amount of time for current customer to check out
     **/
    
    
    // Type A always chooses the register with the shortest line (fewest
    // number of customers in line)
    func leastLineRegister() -> Register{
        
        var custArray = [Int]()
        for r in registers {
            let regCount = r.custList?.count
            custArray.append(regCount!)
        }
        var shortRegister: Register?
        
        // check number of customers for each register and find the min
        // then return registers number
        let minNum = custArray.min()
        
        for a in registers {
            if a.custList?.count == minNum {
                shortRegister = a
                break
            }
        }
        
        return shortRegister!
    }
    
    // Type B looks at the last customer in each line, and always chooses
    // to be behind the customer with the fewest number of items left to check out
    func leastItemCart() -> Register{
        
        var leastItemReg: Register?
        var lastItemNums = [Int]()

        
        for r in registers {
            
            if r.custList?.count > 0 {
                let lastCustIndex = r.custList?.count
            
                let cust = r.custList?[(lastCustIndex!-1)]
                lastItemNums.append((cust?.items)!)
            } else {
                lastItemNums.append(0)
            }
            
        }
        // Set compare min item num to index of Last items count array and set relevant register for return
        let minItems = lastItemNums.min()
        for i in 0...(lastItemNums.count-1) {
            if lastItemNums[i] == minItems {
                leastItemReg = registers[i]
            }
        }
        
        return leastItemReg!
    }
    
    // Increment time
    func incrementTime() {
        self.time+=1
        print("Registers count at \(self.time)")
        for r in registers{
            print("Register: \(r) has \(r.custList?.count) with count \(r.counter)")
            
        }
    }
    
    func endSimulation() {
        
        if (completedCusts == customers.count) {
            if registersDone() == registers.count {
                print("FINAL TIME = \(self.time)")
                timeLabel.text = "Simulation Time: \(self.time) m"
                endSim = true
                clearAll()
                return
            }
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
