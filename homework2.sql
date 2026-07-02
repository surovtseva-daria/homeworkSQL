COPY university_students(student_id, first_name, last_name, attendance, gpa, major_department)
FROM 'https://raw.githubusercontent.com/surovtseva-daria/homeworkSQL/main/university_students.csv'
WITH (FORMAT csv, HEADER true);
COPY instructors(instructor_id, first_name, last_name, salary)
FROM 'https://raw.githubusercontent.com/surovtseva-daria/homeworkSQL/main/university_instructors.csv'
WITH (FORMAT csv, HEADER true);
COPY enrollments(student_id, course_id, is_passed, grade)
FROM 'https://raw.githubusercontent.com/surovtseva-daria/homeworkSQL/main/university_enrollments.csv'
WITH (FORMAT csv, HEADER true);
COPY v_student_course_enrollments(student_id, course_id, grade)
FROM 'https://raw.githubusercontent.com/surovtseva-daria/homeworkSQL/main/university_courses.csv'
WITH (FORMAT csv, HEADER true);

-- ЗАДАНИЕ 1: 
WITH avg_attendance AS (
    SELECT student_id, 
           first_name || ' ' || last_name AS full_name,
           AVG(attendance) AS avg_attendance
    FROM university_students
    GROUP BY student_id, first_name, last_name
)
SELECT student_id, full_name, avg_attendance
FROM avg_attendance
WHERE avg_attendance >= 85;

-- ЗАДАНИЕ 2: 
WITH avg_gpa AS (
    SELECT major_department,
           AVG(gpa) AS avg_gpa
    FROM university_students
    GROUP BY major_department
    ORDER BY avg_gpa DESC
    LIMIT 3
)
SELECT major_department, avg_gpa
FROM avg_gpa;

-- ЗАДАНИЕ 3:
CREATE VIEW v_instructor_salary_level AS
SELECT *,
       CASE 
           WHEN salary >= 100000 THEN 'high'
           WHEN salary >= 70000 THEN 'mid'
           ELSE 'low'
       END AS salary_level
FROM instructors;

SELECT salary_level, COUNT(*) AS count_instructors
FROM v_instructor_salary_level
GROUP BY salary_level;

-- ЗАДАНИЕ 4:
CREATE TEMP TABLE tmp_failed_enrollments AS
SELECT course_id,
       COUNT(*) AS failed_count
FROM enrollments
WHERE is_passed = false
GROUP BY course_id
ORDER BY failed_count DESC
LIMIT 10;

SELECT * FROM tmp_failed_enrollments;

-- ЗАДАНИЕ 5:
WITH failed_students AS (
    SELECT student_id,
           first_name || ' ' || last_name AS full_name,
           COUNT(*) AS count_f
    FROM v_student_course_enrollments
    WHERE grade = 'F'
    GROUP BY student_id, first_name, last_name
)
SELECT student_id, full_name, count_f
FROM failed_students
WHERE count_f >= 2;
                                                                                                                                                                                    WHERE count_f >= 2;
