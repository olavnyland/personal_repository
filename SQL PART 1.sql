

Ex. 1 

select CompanyName, City 
from Customers
where ContactName = 'Hanna Moos'


Ex. 2


select ProductName, UnitPrice 
from Products
where ProductName like '%Syrup' or 
QuantityPerUnit like '%jars%'

Ex. 3

select ContactName, City
from Customers
where (Country = 'UK' and Region is not null) or
PostalCode like 'WX%'

Ex. 4

select distinct e.FirstName firstname, e.lastname lastname, e.HireDate
from Orders o 
join Employees e on e.EmployeeID = o.EmployeeID
where ShippedDate < '1996-10-1'
order by e.HireDate


Ex. 5

select p.ProductName, p.QuantityPerUnit, p.UnitPrice
from Products p
where p.CategoryID = (select c.CategoryID 
					  from Categories c, Products p
					  where c.CategoryID = p.CategoryID and
					  p.ProductName = 'Queso Cabrales'
					  )

Ex. 6

select p.ProductName, od.Discount
from OrderDetails od 
join Orders o on o.OrderID = od.OrderID
join Employees e on e.EmployeeID = o.EmployeeID
join Products p on p.ProductID = od.ProductID
where e.Title = 'Sales Representative' and
od.Discount > 0.10



Ex. 7

select count(distinct od.OrderID) NumberOfOrdersPlacedForSeafood
from OrderDetails od 
join (
	select p.ProductID
	from Categories c
	join Products p on p.CategoryID = c.CategoryID
	where CategoryName = 'Seafood') s 
on s.ProductID = od.ProductID



Ex. 8

select e.FirstName + ' ' + e.LastName fullname, s.TotalOrders
from Employees e
join (
select EmployeeID, count(*) TotalOrders
from Orders 
group by EmployeeID) s
on s.EmployeeID = e.EmployeeID
order by s.TotalOrders desc


Ex. 9

select avg(s.nrColumns) avgNrOfColumns
from (
		select max(isc.ORDINAL_POSITION) nrColumns
		from INFORMATION_SCHEMA.COLUMNS isc
		join INFORMATION_SCHEMA.TABLES  ist
		on ist.TABLE_NAME = isc.TABLE_NAME
		where ist.TABLE_TYPE = 'BASE TABLE'
		group by isc.TABLE_NAME
) s

Ex. 10

select top 1 c.CompanyName, p.ProductName, sum(od.UnitPrice*Quantity*(1-od.Discount)) MoneySpent
from Customers c
join Orders o on o.CustomerID = c.CustomerID
join OrderDetails od on od.OrderID = o.OrderID
join Products p on p.ProductID = od.ProductID
where od.ProductID = (
						select p.ProductID
						from Products p
						where p.UnitsInStock*p.UnitPrice = (select max(UnitPrice*UnitsInStock)
															from Products)
						and p.Discontinued = 0
					 )
group by c.CompanyName, p.ProductName
order by MoneySpent desc


Ex. 11

-- Check if CustomerId is in the export table. 
-- -> if not, update the export table with the new customerid and lastupdate
-- If the customerid is in export table but the last update is different

select *
from Customer c 
join Export e on e.CustomerId = c.CustomerId
where c.CustomerId <> e.CustomerId or
	  c.LastUpdate <> e.LastUpdate

