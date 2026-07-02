COPY university_students(student_id, first_name, last_name, gpa, department_id)
FROM '/path/to/university_students.csv'
WITH (FORMAT csv, HEADER true);

-- ЗАДАНИЕ 1:
SELECT s.student_id, s.first_name, s.last_name
FROM students s
JOIN departments d ON s.department_id = d.department_id
WHERE d.name = 'Computer Science';

-- ЗАДАНИЕ 2:
SELECT c.code, c.title
FROM courses c
JOIN departments d ON c.department_id = d.department_id
WHERE d.name = 'Mathematics'
ORDER BY c.code;

-- ЗАДАНИЕ 3:
SELECT s.student_id, s.first_name, s.last_name, s.gpa
FROM students s
WHERE s.gpa < 2.5
ORDER BY s.gpa ASC;

-- ЗАДАНИЕ 4:
SELECT s.first_name, s.last_name, e.semester, c.code
FROM enrollments e
JOIN students s ON e.student_id = s.student_id
JOIN courses c ON e.course_id = c.course_id
WHERE e.grade IS NOT NULL;

-- ЗАДАНИЕ 5:
SELECT s.student_id, s.first_name, s.last_name, s.gpa
FROM students s
ORDER BY s.gpa DESC
LIMIT 10;
