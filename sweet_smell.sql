/*Student: Henrique Vieira de Oliveira ID:20190611*/

/*Question One - Section B*/

CREATE database Sweet_Smell;

USE Sweet_Smell;
CREATE TABLE Staff (
StaffID INTEGER NOT NULL,
sFName VARCHAR(10),
sLName VARCHAR(10),
sAddress VARCHAR (15),
sBirthDate DATE,
wage INTEGER NOT NULL,
PRIMARY KEY (StaffID),
UNIQUE (sFNAme, sLName)
);

CREATE TABLE Customer(
customerID INTEGER NOT NULL,
cFName VARCHAR(10),
cLName VARCHAR(10),
cAddress VARCHAR(15),
cBirthDate DATE,
PRIMARY KEY (CustomerID),
UNIQUE (cFNAme, cLName)
);

CREATE TABLE Order_(
orderID INTEGER NOT NULL,
oDate DATE,
paymentStatus VARCHAR(10),
paymentDate DATE,
oStatus VARCHAR(10),
customerID INTEGER NOT NULL,
staffID INTEGER NOT NULL,
PRIMARY KEY (orderID),
FOREIGN KEY (customerID) REFERENCES Customer(customerID),
FOREIGN KEY (staffID) REFERENCES Staff(staffID)
);

CREATE TABLE item(
itemID INTEGER NOT NULL,
iName VARCHAR(10),
stockQuantity INTEGER,
PRIMARY KEY (itemID)
);

CREATE TABLE Supplier(
supplierID INTEGER NOT NULL,
sName VARCHAR(10),
sLocation VARCHAR (10),
PRIMARY KEY (supplierID),
UNIQUE (sName)
);

CREATE TABLE Order_has_item(
orderID INTEGER NOT NULL,
itemID INTEGER NOT NULL,
iPrice INTEGER,
iQuantity INTEGER,
FOREIGN KEY (orderID) REFERENCES Order_(orderID),
FOREIGN KEY (itemID) REFERENCES Item(itemID)
);

CREATE TABLE Supplies(
supplierID INTEGER NOT NULL,
itemID INTEGER NOT NULL,
sQuantity INTEGER,
sPrice INTEGER,
FOREIGN KEY (supplierID) REFERENCES Supplier(supplierID),
FOREIGN KEY (itemID) REFERENCES Item(itemID)
);

/*Populating the data base*/
INSERT INTO Staff 
(staffID, sFName, sLName, sAddress, sBirthDate, wage) 
VALUES 
(101, "John", "Boo", "325 ST ROAD", "1990-03-03", 3000),
(102, "Marta", "Xu", "123 main road", "1994-02-02", 4000),
(103, "Luke", "Lars", "568 st Louis", "1992-02-03", 3030),
(104, "Peter", "Grand", "2938 the road", "1989-02-04", 3000),
(105, "Oisin", "Olive", "13 grafthon", "1994-02-05", 5000);

INSERT INTO Customer 
(customerID, cFName, cLName, cAddress, cBirthDate) 
VALUES
(201, "Kay", "Kir", "12 Road", "1994-02-05"),
(202, "Lay", "Kira", "13 Road", "1994-02-06"),
(203, "Lu", "Mint", "14 Road", "1994-02-07"),
(204, "Xiao", "Link", "15 Road", "1994-02-08"),
(205, "Henry", "Beaut", "16 Road", "1994-02-09");

INSERT INTO Order_ 
(orderID, oDate, paymentStatus, paymentDate, oStatus, customerID, staffID) 
VALUES
(301, "2021-01-01", "OPEN", NULL, "WAITING", 201, 101),
(302, "2021-02-02", "PAID", "2021-02-02", "WAITING", 202, 102),
(303, "2021-03-03", "PAID", "2021-03-03", "WAITING", 203, 103),
(304, "2021-04-04", "OPEN", NULL, "WAITING", 204, 104),
(305, "2021-05-05", "OPEN", NULL, "WAITING", 205, 105);

INSERT INTO Item 
(itemID, iName, stockQuantity) 
VALUES
(401, "A PERFUME", 200),
(402, "B PERFUME", 400),
(403, "C PERFUME", 600),
(404, "D PERFUME", 800),
(405, "E PERFUME", 1000);

INSERT INTO Supplier 
(supplierID, sName, sLocation) 
VALUES
(501, "LAB", "IRELAND"),
(502, "LABO", "FRANCE"),
(503, "LABT", "GERMANY"),
(504, "LABS", "IRELAND"),
(505, "LABOT", "IRELAND");

INSERT INTO Order_has_item 
(orderID, itemID, iPrice, iQuantity) 
VALUES
(301, 401, 20, 300),
(302, 402, 30, 400),
(303, 403, 40, 500),
(304, 404, 50, 600),
(305, 405, 60, 700);

INSERT INTO Supplies
(supplierID, itemID, sQuantity, sPrice) 
VALUES
(501, 401, 450, 15),
(502, 402, 550, 25),
(503, 403, 650, 35),
(504, 404, 750, 45),
(505, 405, 850, 55);

/*Question Two*/

/*A query which returns a view containing the total value of all sales within the last 30 days*/
CREATE VIEW SALESLAST30 AS 
SELECT SUM((ohi.iPrice * ohi.iQuantity)) AS total_sales_30d
FROM Order_ o
INNER JOIN Order_has_item ohi
ON ohi.orderID = o.orderID
WHERE TIMESTAMPDIFF(DAY, oDate, current_date())<30;

/*	A view that shows all items which have a current stock quantity of 200 or less*/
CREATE VIEW STOCKQUANTITY AS 
SELECT *
FROM Item
WHERE stockQuantity<=200;

/*A query that returns a view for suppliers based outside Ireland*/
CREATE VIEW SUPPLIERSBASED AS 
SELECT *
FROM supplier
WHERE sLocation<>"IRELAND";

/*A query that returns information from a two table join*/
SELECT *
FROM Order_ o
INNER JOIN Order_has_item ohi
ON ohi.orderID = o.orderID;

/*A query that returns purchased items quantity sorting by lowest to highest*/
SELECT i.iName, s.sQuantity
FROM item i
INNER JOIN Supplies s
ON s.itemID = i.itemID
ORDER BY s.sQuantity ASC;

/*A query that returns all stock items which have a quantity of 600 and above sorting by item title in alphabetical order*/
SELECT *
FROM item
WHERE stockQuantity >= 600
ORDER BY iName ASC;

/*A view which displays all orders which are not paid*/
CREATE VIEW ORDERSNOTPAID AS
SELECT *
FROM Order_
WHERE paymentStatus = "OPEN";

/*A query that shows all items ordered by any one customer for one order. So show for example what customer no 1 ordered in order no 1*/
SELECT o.orderID, c.cFName, c.cLname, i.iName, ohi.iQuantity
FROM Customer c
INNER JOIN Order_ o
ON o.customerID = c.customerID
INNER JOIN Order_has_item ohi
ON ohi.orderID = o.orderID
INNER JOIN Item i
ON i.itemID = ohi.itemID
ORDER BY o.orderID ASC;

/*Updates the price of one product throughout the whole products table*/
UPDATE Order_has_item
SET iPrice = 15
WHERE iPrice = 20;

/*Increase all staff wages by 5%*/
UPDATE Staff
SET wage = wage*1.05;

/*Delete all orders which have not been paid and that are older than 60 days*/
ALTER TABLE Order_has_item DROP FOREIGN KEY order_has_item_ibfk_1;
DELETE FROM Order_
WHERE paymentStatus = "OPEN" AND TIMESTAMPDIFF(DAY, oDate, current_date())>30;

/*Set all orders that are paid to have a status of dispatched*/
UPDATE Order_
SET oStatus = "dispatched"
WHERE paymentStatus = "PAID";

