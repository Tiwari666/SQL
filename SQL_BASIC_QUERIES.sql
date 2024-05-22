/*SELECT Statement  
SELECT Clause : This is the part where you list the columns you want to retrieve from the table.
One can specify individual column names or use the wildcard * to select all columns.

FROM Clause : This specifies the table or tables from which you want to retrieve data. 
If we need data from multiple tables, we can join them using the appropriate join types 
(INNER JOIN, LEFT JOIN, RIGHT JOIN, etc.) which we will cover in further articles.


WHERE Clause : This is an optional part that allows us to filter the rows returned based on specified conditions.
It uses comparison operators like =, <>, <, >, <=, and >=, as well as logical operators such as AND, OR, and NOT.


The basic syntax of the SELECT statement is as follows :

SELECT column1, column2, ... FROM table_name WHERE condition;
*/


-- Create tables


CREATE DATABASE Learning;
USE Learning;


CREATE TABLE students (
    student_id INT PRIMARY KEY,
    name VARCHAR(50),
    age INT,
    gender VARCHAR(10)
);

CREATE TABLE grades (
    student_id INT,
    subject VARCHAR(50),
    grade INT,
    FOREIGN KEY (student_id) REFERENCES students(student_id)
);

INSERT INTO students VALUES
    (5, 'Eva', NULL, 'Female'), -- Null value for age
    (6, 'Alice', 20, 'Female'),  -- Duplicate name
    (7, 'Frank', 25, NULL),  -- Null value for gender
    (8, 'Grace', 22, 'Female'),
    (9, 'Helen', 23, 'Female'),
    (10, 'Ivan', 22, 'Male'),
    (11, 'Alice', 20, 'Female'); -- Duplicate name


Select * from students;

INSERT INTO grades VALUES
    (5, 'Math', 78),
    (5, 'Science', NULL), -- Null value for grade
    (6, 'Math', 85),
    (6, 'Science', 90),
    (7, 'Math', 78),
    (7, 'Science', 85),
    (8, 'Math', 92),
    (8, 'Science', 88),
    (9, 'Math', 80),
    (9, 'Science', 75),
    (10, 'Math', 85),
    (10, 'Science', 90),
    (11, 'Math', 78),
    (11, 'Science', 85),
    (11, 'Science', 85); -- Duplicate value for grade


	Select * from grades;
	Select * from students;


	--------------------------------------------------------------------------
-- Check for NULL values in name and age columns
SELECT *
FROM students
WHERE name IS NULL OR age IS NULL;

-- Check for duplicate values in name column
SELECT name, COUNT(*)
FROM students
GROUP BY name
HAVING COUNT(*) > 1;

-- Check for unique values in name column
SELECT name, COUNT(*)
FROM students
GROUP BY name
HAVING COUNT(*) = 1;

-- Check for duplicate values in age column
SELECT age, COUNT(*)
FROM students
GROUP BY age
HAVING COUNT(*) > 1;

-- Check for unique values in age column
SELECT age, COUNT(*)
FROM students
GROUP BY age
HAVING COUNT(*) = 1;




------------------------------------------------------------------------------

-- Add a new column to the students table
ALTER TABLE students
ADD email VARCHAR(100); -- Adding a new column for email


-----------------------------------
Select * from students;

Select * from grades;

----------------------------
-- Update records to add email addresses
UPDATE students
SET email = CONCAT(name, '@example.com')
WHERE email IS NULL; -- Update only records where email is not already filled


Select * from students;
---------------------------------------------------
-- Update records to set default age for NULL values
UPDATE students


------------------------------------
SET age = 18
WHERE age IS NULL; -- Update only records where age is NULL


Select * from students;
-------------------------------------------------------------------------

-- Update records to set gender based on majority gender in the existing data
UPDATE students
SET gender = (
    SELECT TOP 1 WITH TIES gender
    FROM students
    WHERE gender IS NOT NULL
    GROUP BY gender
    ORDER BY COUNT(*) DESC
)
WHERE gender IS NULL; -- Update only records where gender is NULL



Select * from students;
--------------------------------------------------------------------

------------------------------------
-- Update grades to their corresponding mean values only for NULL grades
UPDATE grades
SET grade = (
    SELECT AVG(grade) AS mean_grade
    FROM grades AS g
    WHERE g.subject = grades.subject
    GROUP BY g.subject
)
WHERE grade IS NULL;
----------------------------------------


Select * from grades;
-----------------------------------------------

-----------------------------------------ANALYSIS WITHOUT JOINING THE STUDENT AND GRADES TABLES---

-- SQL Basics: Select all columns from both tables
SELECT *
FROM students
JOIN grades ON students.student_id = grades.student_id;

-- SQL Statements: Select specific columns from both tables
SELECT students.student_id, students.name, students.age, students.gender, grades.subject, grades.grade
FROM students
JOIN grades ON students.student_id = grades.student_id;

-- LIMIT, DISTINCT, ORDER BY Clause: Select distinct student names ordered by age in descending order with a limit of 5
SELECT TOP 5 name
FROM (
    SELECT DISTINCT students.name
    FROM students
    JOIN grades ON students.student_id = grades.student_id
) AS unique_names
ORDER BY name;



-- SQL WHERE Statement: Select students who are older than 20 and got a grade higher than 80
SELECT students.name, students.age, grades.grade
FROM students
JOIN grades ON students.student_id = grades.student_id
WHERE students.age > 20 AND grades.grade > 80;

-- SQL Logical Operators: Select students who are either female or have an age less than 22
SELECT students.name, students.age, students.gender
FROM students
JOIN grades ON students.student_id = grades.student_id
WHERE students.gender = 'Female' OR students.age < 22;

-- SQL Joins: Select students along with their grades in Math
SELECT students.name, students.age, grades.grade
FROM students
JOIN grades ON students.student_id = grades.student_id
WHERE grades.subject = 'Math';

-- SQL Aggregation - 1: Count the number of students in each gender category
SELECT students.gender, COUNT(*) AS count_students
FROM students
JOIN grades ON students.student_id = grades.student_id
GROUP BY students.gender;

-- SQL Aggregation - 2: Calculate the average grade for each subject
SELECT grades.subject, AVG(grades.grade) AS average_grade
FROM students
JOIN grades ON students.student_id = grades.student_id
GROUP BY grades.subject;

-- SQL Aggregation - 3: Find the maximum grade achieved in each subject
SELECT grades.subject, MAX(grades.grade) AS max_grade
FROM students
JOIN grades ON students.student_id = grades.student_id
GROUP BY grades.subject;

-- SQL Sub-Queries and Window Function: Select students who achieved a grade higher than the average grade in Math
SELECT students.name, students.age, grades.grade
FROM students
JOIN grades ON students.student_id = grades.student_id
WHERE grades.subject = 'Math' AND grades.grade > (
    SELECT AVG(grade)
    FROM grades
    WHERE subject = 'Math'
);



-------------------------------------------------------------
-----------------------------------------ANALYSIS WITH JOINING THE STUDENT AND GRADES TABLES---
-- Joining the students and grades tables to form student_grades
CREATE VIEW student_grades AS
SELECT s.student_id, s.name, s.age, s.gender, g.subject, g.grade
FROM students s
JOIN grades g ON s.student_id = g.student_id;

-- SQL Basics: Select all columns from the combined table
SELECT *
FROM student_grades;

-- SQL Statements: Select specific columns from the combined table
SELECT student_id, name, age, gender, subject, grade
FROM student_grades;

-- LIMIT, DISTINCT, ORDER BY Clause: Select distinct student names ordered by age in descending order with a limit of 5
SELECT TOP 5 name
FROM (
    SELECT DISTINCT name
    FROM student_grades
) AS subquery
ORDER BY age DESC;

SELECT TOP 5 name
FROM (
    SELECT DISTINCT name, age
    FROM student_grades
) AS subquery
ORDER BY age DESC;



-- SQL WHERE Statement: Select students who are older than 20 and got a grade higher than 80
SELECT *
FROM student_grades
WHERE age > 20 AND grade > 80;

-- SQL Logical Operators: Select students who are either female or have an age less than 22
SELECT *
FROM student_grades
WHERE gender = 'Female' OR age < 22;

-- SQL Joins: Select students along with their grades in Math
SELECT *
FROM student_grades
WHERE subject = 'Math';

-- SQL Aggregation - 1: Count the number of students in each gender category
SELECT gender, COUNT(*) AS count_students
FROM student_grades
GROUP BY gender;

-- SQL Aggregation - 2: Calculate the average grade for each subject
SELECT subject, AVG(grade) AS average_grade
FROM student_grades
GROUP BY subject;

-- SQL Aggregation - 3: Find the maximum grade achieved in each subject
SELECT subject, MAX(grade) AS max_grade
FROM student_grades
GROUP BY subject;

-- SQL Sub-Queries and Window Function: Select students who achieved a grade higher than the average grade in Math
SELECT *
FROM student_grades
WHERE subject = 'Math' AND grade > (
    SELECT AVG(grade)
    FROM student_grades
    WHERE subject = 'Math'
);

---------------------------------------------