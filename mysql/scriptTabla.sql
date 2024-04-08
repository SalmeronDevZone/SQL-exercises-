-- Crear tabla employees
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    dept_id VARCHAR(10),
    manager_id INT,
    salary INT,
    expertise VARCHAR(20)
);

-- Inserts de datos
INSERT INTO employees (employee_id, first_name, last_name, dept_id, manager_id, salary, expertise) VALUES
(100, 'John', 'White', 'IT', 103, 120000, 'Senior'),
(101, 'Mary', 'Danner', 'Account', 109, 80000, 'Junior'),
(102, 'Ann', 'Lynn', 'Sales', 107, 140000, 'Semisenior'),
(103, 'Peter', 'O''connor', 'IT', 110, 130000, 'Senior'),
(106, 'Sue', 'Sanchez', 'Sales', 107, 110000, 'Junior'),
(107, 'Marta', 'Doe', 'Sales', 110, 180000, 'Senior'),
(109, 'Ann', 'Danner', 'Account', 110, 90000, 'Senior'),
(110, 'Simon', 'Yang', 'CEO', NULL, 250000, 'Senior'),
(111, 'Juan', 'Graue', 'Sales', 102, 37000, 'Junior');
