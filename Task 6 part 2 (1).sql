/* Keaton Kaess, Zak, Kyle Mosier
Group 6 Section-3
*/

CREATE OR REPLACE VIEW CustomerBought AS
SELECT
FirstName || ' ' || LastName AS "Name",
Phone AS "Phone Number"
FROM Salesinvoice si
JOIN Customer c on si.CustomerID = c.customerID;


CREATE OR REPLACE VIEW CustomersByCity AS
SELECT 
City AS "City",
COUNT(*) AS "Customers in City"
FROM Customer 
Group by City;

/* works but we dont have any unique customers in both views so no data */
CREATE OR REPLACE VIEW CustomersNotServiced AS
SELECT 
    c.FirstName || ' ' || c.LastName AS "Customer Name", 
    c.Phone AS "Phone"
FROM 
    Customer c
JOIN 
    SalesInvoice sai ON c.CustomerID = sai.CustomerID
LEFT JOIN 
    ServiceInvoice si on sai.SaleVehVIN = si.SerVehVIN
WHERE 
    si.SerVehVIN IS NULL;

CREATE OR REPLACE VIEW PorscheInterested AS
SELECT
c.FirstName || ' ' || c.LastName AS "Name",
c.Phone AS "Phone Number",
vp.EndDate AS "PreferenceEndDate"
FROM VehiclePreference vp
JOIN Customer c ON c.CustomerID = vp.CustomerID
WHERE vp.VehMake = 'Porsche';

/**5**/
CREATE OR REPLACE VIEW CustomerBoughtNoTradeIn AS
SELECT
c.FirstName || ' ' || c.LastName AS "Customer Name"
From
Customer C
Join 
SalesInvoice sai on c.CustomerID = sai.CustomerID
Where
sai.TradeVehVIN is Null;





/**6**/
Create or Replace View BestCustomer As
Select
c.FirstName || ' ' || c.LastName AS "Customer Name",
Count(sai.SaleVehVIN) AS "Number of Cars Purchased"
From Customer C
Join 
SalesInvoice sai on C.CustomerID = sai.CustomerID
Group by
c.FirstName, c.LastName
order by
Count(sai.SaleVehVIN) Desc
FETCH FIRST 1 ROW ONLY;

Create or Replace View BestCustomerProfit As
Select
c.FirstName || ' ' || c.LastName AS "Customer Name",
sum(sv.Vehlistprice - sai.Discount) AS "Total Profit"
From 
Customer C
Join 
SalesInvoice sai on C.CustomerID = sai.CustomerID
Join
SalesVehicle sv on sai.SaleVehVIN = sv.VehVIN
Group by 
c.FirstName, c.LastName
Order by
sum(sv.Vehlistprice - sai.Discount) desc
FETCH FIRST 1 ROW ONLY;

/**7**/
Create or Replace View ManufacturePaid As
Select
v.CompanyName as "Manufacturer Name",
sum(sv.vehlistprice + sv.vehlistprice * 0.004 + sv.vehlistprice * 0.825) as "Total Amount Paid"
From 
Vendor v
Join
PurchaseOrder po On v.CompanyName = po.CompanyName
Join 
SalesVehicle sv on po.SaleVehVIN = sv.VehVIN
Group by 
v.CompanyName
Order by 
sum(sv.vehlistprice + sv.vehlistprice * 0.004 + sv.vehlistprice * 0.825) desc
FETCH FIRST 1 ROW ONLY;

/**8**/
Create or Replace View ManufacturerSold As
Select
v.CompanyName as "Manufacturer Name",
count(po.PONumber) AS "total number of cars sold to use"
From
Vendor v
Join
PurchaseOrder po On v.CompanyName = po.CompanyName
Group by
v.CompanyName
Order by
count(po.PONumber) desc
FETCH FIRST 1 ROW ONLY;

/**9**/
Create or Replace View CarsSoldByUs As
Select
sv.VehVIN as "VIN",
sv.VehMake as "Make",
sv.VehModel as "Model",
sv.VehListPrice as "List Price"
From 
SalesVehicle sv
Join 
SalesInvoice sai on sv.VehVIN = sai.SaleVehVIN
Where 
sai.DateApproved >= Sysdate - 30;

/**10**/
Create or Replace View PopularMakeSold As
Select
sv.VehMake as "Make",
count(sai.SaleVehVIN)
From 
SalesVehicle sv
Join
SalesInvoice sai on sv.VehVIN = sai.SaleVehVIN
Group by
sv.VehMake
Order by 
count(sai.SaleVehVIN) desc
FETCH FIRST 1 ROW ONLY;

/**11**/
Create or Replace View TotalProfitCarSales As
Select
Sum(sv.VehPurchasePrice - sv.VehListPrice - sai.Discount) as "Amount"
From 
SalesVehicle sv
Join
SalesInvoice sai on sv.VehVIN = sai.SaleVehVIN;


/**12** don't know exactly if this is correct for the sum doesn't look too clean??**/
Create or Replace View SalesPerson As
Select
e.FirstName || ' ' || e.LastName as "Sales Person",
sum((sv.VehlistPrice + si.discount + si.purchaseprice - si.discount + si.purchaseprice + si.misccost + si.purchaseprice * 0.076)*e.CommissionPct) as "Total Commissions"
From 
SalesInvoice si
Join
Employee e on si.EmployeeID = e.EmployeeID
Join
SalesVehicle sv on si.SaleVehVIN = sv.VehVIN
Group by
e.firstname, e.lastname
Order by 
sum((sv.VehlistPrice + si.discount + si.purchaseprice - si.discount + si.purchaseprice + si.misccost + si.purchaseprice * 0.076)*e.CommissionPct) desc
FETCH FIRST 1 ROW ONLY;




Create or Replace View CarSold As
Select
e.FirstName || ' ' || e.LastName as "Sales Person",
count(sai.SaleVehVIN) as "Number of Vehicles Sold"
From
SalesInvoice sai
Join
Employee e on sai.EmployeeID = e.EmployeeID
Group by
e.firstname, e.lastname
Order by
count(sai.SaleVehVIN) desc
FETCH FIRST 1 ROW ONLY;

/**13**/
Create or Replace View SumOfProfits As
Select
s.Sercode as "Service Code",
s.SerDescription as "Service Name",
sum(S.Serprice - s.SerCost) as "Total Profit"
From
Services s
Group by
s.Sercode, s.SerDescription;



/**14**/
Create or Replace View SumOfProfitzz As
Select
p.PartCode as "Part Code",
p.PartDescription as "Part Name",
sum(P.PartPrice - p.PartCost) as "Total Profit"
From 
Part p
Group by
p.PartCode, p.PartDescription;