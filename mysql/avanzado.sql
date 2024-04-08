-- Clasificación de Filas Basada en un Criterio de Orden Específico


SELECT 
  employee_id,
  last_name,
  first_name,
  salary,
  RANK() OVER (ORDER BY salary DESC) as ranking
FROM employee
ORDER BY ranking


-- Listar las Primeras 5 Filas de un Conjunto de Resultados

WITH employee_ranking AS (
  SELECT
    employee_id,
    last_name,
    first_name,
    salary,
    RANK() OVER (ORDER BY salary DESC) as ranking
  FROM employee
)
SELECT
  employee_id,
  last_name,
  first_name,
  salary
FROM employee_ranking
WHERE ranking <= 5
ORDER BY ranking


-- Listar la segunda fila más alta de un conjunto de resultados

WITH employee_ranking AS (
  SELECT
    employee_id,
    last_name,
    first_name,
    salary,
    RANK() OVER (ORDER BY salary DESC) as ranking
  FROM employee
)
SELECT
  employee_id,
  last_name,
  first_name,
  salary
FROM employee_ranking
WHERE ranking = 2


-- Listar el Segundo Salario Más Alto por Departamento

WITH employee_ranking AS (
  SELECT
    employee_id,
    last_name,
    first_name,
    salary,
    dept_id
    RANK() OVER (PARTITION BY dept_id ORDER BY salary DESC) as ranking
  FROM employee
)
SELECT
  dept_id,
  employee_id,
  last_name,
  first_name,
  salary
FROM employee_ranking
WHERE ranking = 2
ORDER BY dept_id, last_name



-- Listar las Primeras 50% Filas en un Conjunto de Resultados

WITH employee_ranking AS (
  SELECT
    employee_id,
    last_name,
    first_name,
    salary,
    NTILE(2) OVER (ORDER BY salary ) as ntile
  FROM employee
)
SELECT
  employee_id,
  last_name,
  first_name,
  salary
FROM employee_ranking
WHERE ntile = 1
ORDER BY salary



-- Listar el último 25% de filas en un conjunto de resultados

WITH employee_ranking AS (
  SELECT
    employee_id,
    last_name,
    first_name,
    salary,
    NTILE(4) OVER (ORDER BY salary) as ntile
  FROM employee
)
SELECT
  employee_id,
  last_name,
  first_name,
  salary
FROM employee_ranking
WHERE ntile = 4
ORDER BY salary



--  Numerar las filas de un conjunto de resultados

SELECT
  employee_id,
  last_name,
  first_name,
  salary,
  ROW_NUMBER() OVER (ORDER BY employee_id) as ranking_position
FROM employee



-- Listar Todas las Combinaciones de Filas de Dos Tablas

SELECT
  grain.product_name,
  box_size.description,
  grain.price_per_pound * box_size.box_weight
FROM product
CROSS JOIN  box_sizes



--  Unir una Tabla a Sí Misma

SELECT 
  e1.first_name ||’ ‘|| e1.last_name AS manager_name,
  e2.first_name ||’ ‘|| e2.last_name AS employee_name
FROM employee e1
JOIN employee e2
ON e1.employee_id = e2.manager_id



-- Mostrar Todas las Filas con un Valor por Encima del Promedio

SELECT
  first_name,
  last_name,
  salary
FROM employee 
WHERE salary > ( SELECT AVG(salary) FROM employee )



-- Empleados con Salarios Mayores al Promedio de su Departamento

SELECT
  first_name,
  last_name,
  salary
FROM employee e1
WHERE salary >
    (SELECT AVG(salary)
     FROM employee e2
     WHERE e1.departmet_id = e2.department_id)


    
-- Obtener Todas las Filas Donde un Valor Está en el Resultado de una Subconsulta

SELECT 
  first_name,
  last_name
FROM employee e1
WHERE department_id IN (
   SELECT department_id
   FROM department
   WHERE manager_name=‘John Smith’)



-- Encontrar Filas Duplicadas en SQL

SELECT 
  employee_id,
  last_name,
  first_name,
  dept_id,
  manager_id,
  salary
FROM employee
GROUP BY   
  employee_id,
  last_name,
  first_name,
  dept_id,
  manager_id,
  salary
HAVING COUNT(*) > 1



-- Contar Filas Duplicadas

SELECT 
  employee_id,
  last_name,
  first_name,
  dept_id,
  manager_id,
  salary,
  COUNT(*) AS number_of_rows
FROM employee
GROUP BY
  employee_id,
  last_name,
  first_name,
  dept_id,
  manager_id,
  salary
HAVING COUNT(*) > 1



-- Encontrar Registros Comunes entre Tablas

SELECT
  last_name,
  first_name
FROM employee
INTERSECT
SELECT
  last_name,
  first_name
FROM employee_2020_jan



--  Agrupación de Datos con ROLLUP

SELECT 
  dept_id,
  expertise,
  SUM(salary) total_salary
FROM    employee
GROUP BY dept_id, expertise


SELECT
  dept_id,
  expertise,
  SUM(salary) total_salary
FROM employee
GROUP BY ROLLUP (dept_id, expertise)



-- Sumatoria Condicional

SELECT
  SUM (CASE
    WHEN dept_id IN (‘SALES’,’HUMAN RESOURCES’)
    THEN salary
    ELSE 0 END) AS total_salary_sales_and_hr,
  SUM (CASE
    WHEN dept_id IN (‘IT’,’SUPPORT’)
    THEN salary
    ELSE 0 END) AS total_salary_it_and_support
FROM employee



-- Agrupar Filas por un Rango

SELECT
  CASE
    WHEN salary <= 750000 THEN ‘low’
    WHEN salary > 750000 AND salary <= 100000 THEN ‘medium’
    WHEN salary > 100000 THEN ‘high’
  END AS salary_category,
  COUNT(*) AS number_of_employees
FROM    employee
GROUP BY
  CASE
    WHEN salary <= 750000 THEN ‘low’
    WHEN salary > 750000 AND salary <= 100000 THEN ‘medium’
    WHEN salary > 100000 THEN ‘high’
END



-- Calcular un Total Corrido en SQL

SELECT
  day,
  daily_amount,
  SUM (daily_amount) OVER (ORDER BY day) AS running_total
FROM sales



-- Calcular una Media Móvil en SQL

SELECT
  day,
  daily_amount,
  AVG (daily_amount) OVER (ORDER BY day ROWS 6 PRECEDING)
    AS moving_average
FROM sales



--  Calcular una diferencia interanual

WITH year_metrics AS (
  SELECT
    extract(year from day) as year,
    SUM(daily_amount) as year_amount
  FROM sales
  GROUP BY year)
SELECT
  year,
  year_amount,
  LAG(year_amount) OVER (ORDER BY year) AS revenue_previous_year,
  year_amount - LAG(year_amount) OVER (ORDER BY year) as yoy_diff_value,
  ((year_amount - LAG(year_amount) OVER (ORDER BY year) ) /
     LAG(year_amount) OVER (ORDER BY year)) as yoy_diff_perc
FROM year_metrics
ORDER BY 1



-- Utilizar Consultas recursivas y expresiones de tabla comunes para Gestionar Jerarquías de Datos

WITH RECURSIVE subordinate AS (
 SELECT 
   employee_id,
   first_name,
   last_name,
   manager_id
  FROM employee
  WHERE employee_id = 110 -- id of the top hierarchy employee (CEO)
  
  UNION ALL
  
  SELECT 
    e.employee_id,
    e.first_name,
    e.last_name,
    e.manager_id
  FROM employee e
  JOIN subordinate s
  ON e.manager_id = s.employee_id
)
SELECT 
  employee_id,
  first_name,
  last_name,
  manager_id
FROM subordinate ;



-- Encontrar la Longitud de una Serie Usando Funciones de ventana

WITH data_series AS (
  SELECT   
    RANK() OVER (ORDER BY day) AS row_number,
    day,
    day - RANK() OVER (ORDER BY day) AS series_id
 FROM   user_registration )
SELECT 
  MIN(day) AS series_start_day,
  MAX(day) AS series_end_day,
  MAX(day) - MIN (day) + 1 AS series_length
FROM    data_series
GROUP BY series_id
ORDER BY series_start_date
