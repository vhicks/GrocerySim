# GrocerySim
## Veronica Hicks
#

Functionality as directed: <br />

1) The number of registers is specified by the problem inputs; registers are numbered 1, 2, 3, ..., n for n registers.<br />
2) Time is measured in minutes. <br />
3) The grocery store always has a single cashier in training. This cashier is always assigned to the highest numbered register.<br />
4) Regular registers take one minute to process each customer's item. The register
staffed by the cashier in training takes two minutes for each item. So a customer with n items at a regular register takes n minutes to check out. However, if the customer ends up at the last register, it will take 2n minutes to check out.<br />
5) The simulation starts at t=0 . At that time all registers are empty (no customers in line).<br />
6) Two types of customers arrive at the registers:<br />
a. Customer Type A always chooses the register with the shortest line (fewest
number of customers in line).<br />
b. Customer Type B looks at the last customer in each line, and always chooses
to be behind the customer with the fewest number of items left to check out, regardless of how many other customers are in the line or how many items they have. Customer Type B will always choose an empty line before a line with any customers in it.<br />
7) Customers just finishing checking out do not count as being in line (for either kind of Customer).<br />
8) If two or more customers arrive at the same time, those with fewer items choose registers before those with more, and if they have the same number of items then type A's choose before type B's.<br />
<br />
Input Format:<br />
Input is in the form of a single integer (number of registers), followed by a list of pairs. Each pair specifies the time in minutes (from a fixed offset) when a customer arrives to the set of registers, and how many items that customer has. Each pair appears white-space separated on a line by itself in the input file; see below for a sample input and output.<br />
<br />
For the following input:<br />
1 <br />
A 1 2 <br />
A 2 1<br />
<br />
<br />
The following highlights occur:<br />
• t=0 : Simulation starts with one register, which is a training register.<br />
• t=1 : Customer #1 (type A) arrives with 2 items and goes to register #1 which starts
servicing him.<br />
• t=2 : Customer #2 (type A) arrives with 1 item and goes to register #1, behind
Customer #1.<br />
• t=3 : (Customer #1 now has one item left, since the first item took two minutes). • t=5 : Customer #1 leaves and register #1 starts servicing Customer #2.<br />
• t=7 : Customer #2 leaves.<br />
<br />
CheckViewController displays: Simulation Time: 7 m<br />
<br />
✅ Input entered into UITextView in ViewController<br />
✅ CheckOut UIButton selected, segues to CheckViewController<br />
✅ CheckViewController contains register/customer methods to return Total Time<br />
✅  Register.Swift Class<br />
✅  Customer.Swift Class<br />


