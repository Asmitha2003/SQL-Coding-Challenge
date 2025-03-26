//create database
create database carRental;
use carRental;

//create vehicle table
create table Vehicle (
    carID int auto_increment primary key,
    make varchar(50),
    model varchar(50),
    year int,
    dailyRate decimal(10,2),
    status enum('0', '1'),
    passengerCapacity int,
    engineCapacity int
);

//create customer table
create table Customer (
    customerID int auto_increment primary key,
    firstName varchar(50),
    lastName varchar(50),
    email varchar(100),
    phoneNumber varchar(15) 
);

//create lease table
create table Lease (
    leaseID int auto_increment primary key,
    carID int,
    customerID int,
    startDate date,
    endDate date,
    type enum('Daily', 'Monthly'),
    foreign key (carID) references Vehicle(carID) on delete cascade,
    foreign key (customerID) references Customer(customerID) on delete cascade
);

//create payment table
create table Payment (
    paymentID int primary key,
    leaseID int,
    paymentDate date,
    amount decimal(10,2),
    foreign key (leaseID) references Lease(leaseID)
);

//insert values into vehicle table
insert into Vehicle (carID, make, model, year, dailyRate, status, passengerCapacity, engineCapacity) values
(1, 'Toyota', 'Camry', 2022, 50.00, '1', 4, 1450),
(2, 'Honda', 'Civic', 2023, 45.00, '1', 7, 1500),
(3, 'Ford', 'Focus', 2022, 48.00, '0', 4, 1400),
(4, 'Nissan', 'Altima', 2023, 52.00, '1', 7, 1200),
(5, 'Chevrolet', 'Malibu', 2022, 47.00, '1', 4, 1800),
(6, 'Hyundai', 'Sonata', 2023, 49.00, '0', 7, 1400),
(7, 'BMW', '3 Series', 2023, 60.00, '1', 7, 2499),
(8, 'Mercedes', 'C-Class', 2022, 58.00, '1', 8, 2599),
(9, 'Audi', 'A4', 2022, 55.00, '0', 4, 2500),
(10, 'Lexus', 'ES', 2023, 54.00, '1', 4, 2500);

//insert values into customer table
insert into Customer (customerID, firstName, lastName, email, phoneNumber) values
(1, 'John', 'Doe', 'johndoe@example.com', '555-555-5555'),
(2, 'Jane', 'Smith', 'janesmith@example.com', '555-123-4567'),
(3, 'Robert', 'Johnson', 'robert@example.com', '555-789-1234'),
(4, 'Sarah', 'Brown', 'sarah@example.com', '555-456-7890'),
(5, 'David', 'Lee', 'david@example.com', '555-987-6543'),
(6, 'Laura', 'Hall', 'laura@example.com', '555-234-5678'),
(7, 'Michael', 'Davis', 'michael@example.com', '555-876-5432'),
(8, 'Emma', 'Wilson', 'emma@example.com', '555-432-1098'),
(9, 'William', 'Taylor', 'william@example.com', '555-321-6547'),
(10, 'Olivia', 'Adams', 'olivia@example.com', '555-765-4321');

//insert values into lease table
insert into Payment (paymentID, leaseID, paymentDate, amount) values
(1, 1, '2023-01-03', 200.00),
(2, 2, '2023-02-20', 1000.00),
(3, 3, '2023-03-12', 75.00),
(4, 4, '2023-04-25', 900.00),
(5, 5, '2023-05-07', 60.00),
(6, 6, '2023-06-18', 1200.00),
(7, 7, '2023-07-03', 40.00),
(8, 8, '2023-08-14', 1100.00),
(9, 9, '2023-09-09', 80.00),
(10, 10, '2023-10-25', 1500.00);

//1.Update the daily rate for a Mercedes car to 68
update Vehicle 
set dailyRate = 68.00 
where make = 'Mercedes';

//2.Delete a specific customer and all associated leases and payments
delete Payment 
from Payment 
join Lease on Payment.leaseID = Lease.leaseID 
where Lease.customerID = 3;
delete from Lease where customerID = 3;
delete from Customer where customerID = 3;

//3.Rename the paymentDate column in the Payment table to transactionDate
alter table Payment 
change column paymentDate transactionDate date;

//4.Find a specific customer by email
select * from Customer 
where email = 'johndoe@example.com';

//5.Get active leases for a specific customer
select * from Lease 
where customerID = 2 and endDate>=curdate();

//6.Find all payments made by a customer with a specific phone number
select p.* from Payment p
join Lease l on p.leaseID = l.leaseID
join Customer c on l.customerID = c.customerID
where c.phoneNumber = '555-123-4567'; 

//7.Calculate the average daily rate of all available cars (status = '1' for available cars)
select avg(dailyRate) as averageDailyRate 
from Vehicle 
where status = '1';

//8.Find the car with the highest daily rate
select * from Vehicle 
order by dailyRate desc
limit 1;

//9.Retrieve all cars leased by a specific customer
select v.*from Vehicle v
join Lease l on v.carID = l.carID
where l.customerID = 4;

//10.Find the details of the most recent lease
select * from Lease 
order by startDate desc
limit 1;

//11.List all payments made in the year 2023
select * from Payment 
where year(transactionDate) = 2023;

//12.Retrieve customers who have not made any payments
select c.* from Customer c
left join Lease l on c.customerID = l.customerID
left join Payment p on l.leaseID = p.leaseID
where p.paymentID is null;

//13.Retrieve Car Details and Their Total Payments
select v.*, SUM(p.amount) as totalPayments 
from Vehicle v 
join Lease l on v.carID = l.carID
join Payment p on l.leaseID = p.leaseID 
group by v.vehicleID;

//14.Calculate Total Payments for Each Customer
select c.*, SUM(p.amount) as totalPayments
from Customer c
join Lease l on c.customerID = l.customerID
join Payment p on l.leaseID = p.leaseID
group by c.customerID;

//15.List Car Details for Each Lease
select l.*, v.* 
from Lease l
join Vehicle v on l.carID = v.carID;

//16.Retrieve Details of Active Leases with Customer and Car Information
select l.*, c.*, v.*
from Lease l
join Vehicle v on l.carID = v.carID
where l.endDate >= curdate();

//17.Find the Customer Who Has Spent the Most on Leases
select c.*, SUM(p.amount) as totalSpent
from Customer c
join Lease l on c.customerID = l.customerID
join Payment p on l.leaseID = p.leaseID
group by c.customerID, c.firstName, c.lastName
order by totalSpent desc 
limit 1;

//18.List All Cars with Their Current Lease Information
select v.*, l.startDate, l.endDate 
from Vehicle v 
left join Lease l on v.carID = l.carID;





