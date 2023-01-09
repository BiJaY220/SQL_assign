-- qn. 1 :

CREATE DATABASE dbl_data;
use  dbl_data;
CREATE TABLE tbl_Employee (
    Employee_Name varchar(255) PRIMARY KEY,
    Street varchar(255),
    City varchar(255)
);

CREATE TABLE tbl_Works (
    Employee_Name varchar(255),
    Company_Name varchar(255),
    Salary DECIMAL(10,2),
    PRIMARY KEY (Employee_Name, Company_Name),
    FOREIGN KEY (Employee_Name) REFERENCES tbl_Employee (Employee_Name)
);

CREATE TABLE tbl_Company (
    Company_Name varchar(255) PRIMARY KEY,
    City varchar(255)
);

CREATE TABLE tbl_Manages (
    Employee_Name varchar(255),
    Manager_Name varchar(255),
    PRIMARY KEY (Employee_Name, Manager_Name),
    FOREIGN KEY (Employee_Name) REFERENCES tbl_Employee(Employee_Name),
    FOREIGN KEY (Manager_Name) REFERENCES tbl_Employee(Employee_Name)
);

INSERT INTO tbl_Employee (Employee_Name, Street, City)
VALUES ('aayush', 'syambhu', 'yatra marga');

SELECT * FROM tbl_Employee;
UPDATE tbl_Employee
SET City = 'baneshwor'
WHERE Employee_Name = 'aayush';

INSERT INTO tbl_Employee (Employee_Name, Street, City)
VALUES
    ('kautuv', 'jonny street', 'kathmandu'),
    ('bobby', 'banepa sadak', 'dhulikhel'),
    ('anup', '45 road', 'bhaktapur'),
    ('subrat', '565 road', 'lalitpur'),
    ('bijay', 'high street', 'heaven'),
    ('jonny', 'low street', 'lele'),
    ('ponny', 'middle street', 'hetauda'),
    ('funny', 'tate city', 'texas'),
    ('bunny', 'gate', 'birjung'),
    ('sunny', 'pallo pul', 'pokhara'),
    ('tony', 'haridwar', 'nepal');
    


INSERT INTO tbl_Works (Employee_Name, Company_Name, Salary)
VALUES
    ('aayush', 'high rollers', 33000),
    ('kautuv', 'high rollers', 90000),
    ('bobby', 'high rollers', 57000),
    ('anup', 'high rollers', 66000),
    ('subrat', 'high rollers', 75000),
    ('bijay', 'high rollers', 80000);
    
    
INSERT INTO tbl_Works (Employee_Name, Company_Name, Salary)
VALUES
    ('jonny', 'small rollers', 35000),
    ('ponny', 'small rollers', 90660),
    ('funny', 'small rollers', 23000),
    ('bunny', 'small rollers', 56000),
    ('sunny', 'small rollers', 73000),
    ('tony', 'small rollers', 67000);
    
INSERT INTO tbl_Company (Company_Name, City)
VALUES ('high rollers', 'New York'),
      ('small rollers','baneshwor');

INSERT INTO tbl_Manages (Employee_Name, Manager_Name)
VALUES
    ('aayush', 'bijay'),
    ('kautuv', 'bijay'),
    ('anup', 'bijay'),
    ('subrat', 'bijay'),
    ('bijay', 'bijay');

INSERT INTO tbl_Employee (Employee_Name, Street, City)
VALUES ('Jonas', '45 jonny street', 'kalanki');

SELECT * FROM tbl_Employee;
UPDATE Employee
SET City = 'Newton'
WHERE Employee_Name = 'Jonas';


SELECT * FROM Works;

UPDATE Works
SET Salary = Salary + (Salary * 0.1);

/* 2. Consider the employee database of Figure 5, where the primary keys are underlined. Give
an expression in SQL for each of the following queries:*/

-- (a) Find the names of all employees who work for First Bank Corporation.
use dbl_data;
SELECT employee_name FROM tbl_works WHERE company_name = 'high rollers';  -- I used high rollers cause i made the database without "First Bank coorporation"

-- Note"::::::::: I have used "high rollers" instead of "First Bank coorporation" down below.

-- (b) Find the names and cities of residence of all employees who work for First Bank Corporation.

-- using subqueries
SELECT employee_name, city FROM tbl_employee WHERE employee_name IN
(SELECT employee_name FROM tbl_works WHERE company_name = 'high rollers'); 

-- using join
SELECT tbl_employee.employee_name, tbl_employee.city FROM tbl_employee
INNER JOIN tbl_works ON tbl_employee.employee_name = tbl_works.employee_name
WHERE tbl_works.company_name = 'high rollers';

-- (c)  Find the names, street addresses, and cities of residence of all employees who work for First Bank Corporation and earn more than $10,000.

-- using Subqueries
SELECT tbl_employee.employee_name, tbl_employee.street, tbl_employee.city FROM tbl_employee WHERE employee_name IN
(SELECT employee_name FROM tbl_works WHERE company_name = 'high rollers' AND salary > 10000); 

-- using join
SELECT tbl_employee.employee_name, tbl_employee.street, tbl_employee.city FROM tbl_employee
INNER JOIN tbl_works ON tbl_employee.employee_name = tbl_works.employee_name
WHERE tbl_works.company_name = 'high rollers' AND tbl_works.salary > 10000;

-- (d) Find all employees in the database who live in the same cities as the companies for which they work.

-- using subqueries
SELECT tbl_employee.employee_name, tbl_employee.city FROM tbl_employee  WHERE tbl_employee.city = 
(SELECT city FROM tbl_company  WHERE tbl_company.company_name = 
(SELECT company_name FROM tbl_works WHERE tbl_works.employee_name = tbl_employee.employee_name));

-- using join
SELECT tbl_employee.employee_name, tbl_employee.city FROM tbl_employee
INNER JOIN tbl_works ON tbl_employee.employee_name = tbl_works.employee_name
INNER JOIN tbl_company ON tbl_works.company_name = tbl_company.company_name
WHERE tbl_company.city = tbl_employee.city;




-- (f) Find all employees in the database who do not work for First Bank Corporation.
SELECT employee_name from tbl_works WHERE company_name != 'high rollers';

-- (g) Find all employees in the database who earn more than each employee of Small Bank Corporation.
SELECT e1.employee_name
FROM employee e1
INNER JOIN works w1 ON e1.employee_name = w1.employee_name
WHERE w1.salary > ALL (
  SELECT w2.salary
  FROM works w2
  INNER JOIN employee e2 ON w2.employee_name = e2.employee_name
  INNER JOIN company c ON w2.company_name = c.company_name
  WHERE c.company_name = 'small rollers'
);

-- (h) Assume that the companies may be located in several cities. Find all companies located in every city in which Small Bank Corporation is located.
SELECT * FROM tbl_company
WHERE tbl_company.city = (SELECT tbl_company.city FROM tbl_company WHERE tbl_company.company_name = 'small rollers');

-- (i) Find all employees who earn more than the average salary of all employees of their company.
SELECT tbl_works.employee_name, tbl_works.company_name FROM
(SELECT company_name, AVG(salary) AS average_salary
FROM tbl_works GROUP BY company_name) AS average
JOIN tbl_works ON average.company_name = tbl_works.company_name
WHERE tbl_works.salary > average.average_salary;

-- (j) Find the company that has the most employees.
SELECT company_name, employee_count FROM
(SELECT company_name, COUNT(employee_name) AS employee_count
FROM tbl_works GROUP BY company_name) as C1
ORDER BY employee_count DESC;


-- (k) Find the company that has the smallest payroll.
SELECT company_name, payroll FROM
(SELECT company_name, SUM(salary) AS payroll
 FROM tbl_works GROUP BY company_name) AS total_payroll
ORDER BY payroll ASC;

-- (l) Find those companies whose employees earn a higher salary, on average, than the average salary at First Bank Corporation
-- will be using Acme Inc instead of First Bank Corporation
select c.company_name
from tbl_company c join tbl_works w
on c.company_name = w.company_name
group by c.company_name
having avg(w.salary) > (select avg(w2.salary)
                        from tbl_company c2 join
                             tbl_works w2
                             on c2.company_name = w2.company_name
                        where c2.company_name = 'high rollers'
                       );

/* 3. Consider the relational database of Figure 5. Give an expression in SQL for each of the
following queries:
*/

-- (b) Give all employees of First Bank Corporation a 10 percent raise.

select * from tbl_works where company_name='Acme Inc';

-- update salary
UPDATE Tbl_works
SET salary=salary *1.1
Where company_name='high rollers';

-- NOTE::::::::::: using Acme Inc instead of First Bank Corporation
-- (c) Give all managers of First Bank Corporation a 10 percent raise.

UPDATE tbl_works 
SET salary = salary * 1.1
WHERE employee_name = ANY (SELECT DISTINCT manager_name  FROM tbl_manages) AND company_name = 'high rollers ';

select * from tbl_works where company_name='high rollers';

-- (d) Give all managers of First Bank Corporation a 10 percent raise unless the salary becomes greater than $100,000; in such cases, give only a 3 percent raise.
UPDATE tbl_works w
INNER JOIN (
  SELECT e.employee_name
  FROM tbl_employee e
  INNER JOIN tbl_works w ON e.employee_name = w.employee_name
  INNER JOIN tbl_company c ON w.company_name = c.company_name
  WHERE c.company_name = 'high rollers'
  AND e.employee_name IN (
    SELECT m.manager_name
    FROM tbl_manages m
  )
) m ON w.employee_name = m.employee_name
SET w.salary = 
  CASE WHEN w.salary * 1.1 <= 100000 THEN w.salary * 1.1
  ELSE w.salary * 1.03
  END;

-- (e) Delete all tuples in the works relation for employees of Small Bank Corporation.
DELETE w FROM works w
INNER JOIN company c ON w.company_name = c.company_name
WHERE c.company_name = 'small rollers';

