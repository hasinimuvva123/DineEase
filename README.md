# DineEase Project

## Introduction

The DineEase project is a software system designed to streamline operations for a restaurant, facilitating tasks such as order management, reservation handling, customer feedback collection, and inventory management.

## Business Rules, Restrictions, and Requirements

The DineEase project adheres to the following business rules, restrictions, and requirements:

- Customers can make multiple reservations, but each reservation is made by only one customer.
- Reservation details should include date, time, and any special requests.
- Service crew members can access reservation details for customers.
- Orders can be placed for delivery or pick-up.
- Orders can be placed by customers and taken by employees.
- Each order consists of multiple order items, representing individual menu items ordered.
- Customers can track the status of their orders after placing them.
- Order status must be updated in real-time to reflect accurate progress.
- Customers should receive notifications for significant order status updates (e.g., order confirmed, out for delivery).
- Service crew members can retrieve order details to update customers on order status.
- Order details should include itemized lists, quantities, and order status.
- Customers can provide feedback on their order experience.
- Feedback should be collected and analyzed regularly to identify areas for improvement.
- Responses to feedback should be prompt and appropriate.
- Customers can view their past orders for reference and review.
- Order history should be accessible and up-to-date.
- Cashiers are responsible for calculating the total amount due and itemized costs for orders.
- Cashiers must provide accurate receipts to customers.
- Managers can analyze item ratings to determine the popularity of dishes.
- Ratings should be aggregated and averaged to determine average ratings.
- Managers can analyze sales data to identify revenue patterns.
- Managers are responsible for monitoring employee performance to ensure operational efficiency.
- Employee performance metrics should be tracked and evaluated regularly.
- Kitchen crew members are responsible for preparing dishes in response to customer orders.
- Dishes should be prepared according to standardized recipes and quality standards.
- Kitchen crew members are responsible for updating inventory stock levels based on order requirements.
- Inventory levels should be monitored and restocked as needed to avoid shortages.

## Use Cases

### Customer
1. **Place Order for Food**: Customer explores menu options and places an order for delivery or pick-up.
2. **Track Order Status**: Customer checks the status of their order to monitor its progress.
3. **Provide Feedback on Order Experience**: Customer offers feedback to improve the overall order experience.
4. **View Order History**: Customer accesses past orders to reference and review previous purchases.

### Employees
1. **Identify Customer’s Reservation Details for a Given Customer**: Service crew checks reservation details for a given customer.
2. **Identify a Customer’s Order Details for a Given Customer**: Service crew retrieves order details to update customers on order status.
3. **Identify Total Amount Due and Amount for Each Item for a Given Order**: Cashier calculates total amount due and itemized costs for a given order.
4. **Analyze the Average Ratings of Items Based on Customer Reviews**: Manager analyzes item ratings to determine the most popular dish.
5. **Analyze Sales Performance on Specific Dates and Identify Patterns**: Manager evaluates sales data to identify revenue patterns.
6. **Monitor Employee Performance**: Manager monitors employee performance to ensure operational efficiency.
7. **Prepare Dishes for Order Fulfillment**: Kitchen crew prepares dishes in response to customer orders.
8. **Update Inventory Stock Levels per Order**: Kitchen crew updates inventory stock levels based on order requirements.

## Roles and Privileges

For effective management and control, the DineEase project defines the following roles with corresponding privileges:

- **manager_role**: Analyze item ratings, analyze sales data, monitor employee performance.
- **service_crew_role**: Access reservation details, retrieve order details, update order status.
- **cashier_role**: Calculate total amount due, provide accurate receipts.
- **kitchen_crew_role**: Prepare dishes, update inventory stock levels.
- **customer_role**: Place orders, provide feedback, view order history.

## Package: Order Management
Package File: Package/order_management.sql
Package Body File: Package/ordermanagement_body.sql

### Description
The Order Management package provides functionalities to handle orders placed by customers.
It includes the following functions and procedures:

PlaceOrderForFood: Allows customers to place orders for food items by specifying the item names and quantities.
CalculateTotalAmountDue: Calculates the total amount due and itemized costs for a given order.
ProcessPayment: Processes payments for orders, updating payment information in the Payments table and the status of the order in the Orders table.
UpdateOrderStatus: Updates the status of an order in the 'Orders' table to indicate that it has been provided to the kitchen crew.
PrepareDishesForOrder: Prepares dishes for an order by updating inventory and order status.
CancelOrder: Updates the status of an order in the 'Orders' table to indicate that it has been cancelled.
TrackOrderProgress: Updates the status of an order in the 'Orders' table to indicate that it has been provided to the kitchen crew.

### How to Execute
To execute the Order Management package, follow these steps:

1. Open SQL Developer or any other SQL execution tool.
2. Run the script Package/order_management.sql to create the package specifications.
3. Run the script Package/ordermanagement_body.sql to create the package body.
4. To execute the package, run the script Package/exec_order_management.sql.

## Package: User Management
Package File: Package/user_management.sql
Package Body File: Package/user_management_body.sql

### Description
The User Management package provides functionalities to create and delete customer records. It includes the following procedures:

create_customer: Creates a new customer record with the provided details.
delete_customer: Deletes an existing customer record based on the specified customer ID.

### How to Execute
To execute the User Management package, follow these steps:

1. Open SQL Developer or any other SQL execution tool.
2. Run the script Package/user_management.sql to create the package specifications, body and execute the package
## How to Run

1. Clone the DineEase repository to your local machine.
2. Create the restaurant_admin user from admin in SQL Developer
3. Log in as restaurant_admin to create tables, insert data, and add roles
4. Log in as users and try accessing the data relevant to the role of the user

## Contributors

- Sai Geeta Acharya
- Venkata Surya Saran Teja Dadi
- Hasini Muvva
- Kurapati Saihimaja Chowdary

## Functions and Procedures

##Functions
PlaceOrderForFood: Allows customers to place orders for food items by specifying the item names and quantities.
CalculateTotalAmountDue: Calculates the total amount due and itemized costs for a given order.
ProcessPayment: Processes payments for orders, updating payment information in the Payments table and the status of the order in the Orders table.

##Procedures
UpdateOrderStatus: Updates the status of an order in the 'Orders' table to indicate that it has been provided to the kitchen crew.
PrepareDishesForOrder: Prepares dishes for an order by updating inventory and order status.
CancelOrder: Updates the status of an order in the 'Orders' table to indicate that it has been cancelled.
TrackOrderProgress: Updates the status of an order in the 'Orders' table to indicate that it has been provided to the kitchen crew.



