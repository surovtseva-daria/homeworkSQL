CREATE TABLE IF NOT EXISTS university_students (
    student_id SERIAL PRIMARY KEY,
    name VARCHAR(100),
    gpa NUMERIC
);

CREATE TABLE IF NOT EXISTS instructors (
    instructor_id SERIAL PRIMARY KEY,
    name VARCHAR(100)
);

CREATE TABLE IF NOT EXISTS enrollments (
    enrollment_id SERIAL PRIMARY KEY,
    student_id INT REFERENCES university_students(student_id),
    course_id INT,
    semester VARCHAR(20),
    is_passed BOOLEAN
);

CREATE TABLE IF NOT EXISTS courses (
    course_id SERIAL PRIMARY KEY,
    code VARCHAR(20),
    title VARCHAR(100)
);

COPY university_students FROM 'https://raw.githubusercontent.com/surovtseva-daria/homework_SQL/main/university_students.csv' DELIMITER ',' CSV HEADER;
COPY instructors FROM 'https://raw.githubusercontent.com/surovtseva-daria/homework_SQL/main/university_instructors.csv' DELIMITER ',' CSV HEADER;
COPY enrollments FROM 'https://raw.githubusercontent.com/surovtseva-daria/homework_SQL/main/university_enrollments.csv' DELIMITER ',' CSV HEADER;
COPY courses FROM 'https://raw.githubusercontent.com/surovtseva-daria/homework_SQL/main/university_courses.csv' DELIMITER ',' CSV HEADER;

-- ЗАДАНИЕ 1:
SELECT 
    c.code, 
    c.title, 
    COUNT(e.enrollment_id) AS total, 
    SUM(CASE WHEN e.is_passed THEN 1 ELSE 0 END) AS passed,
    (SUM(CASE WHEN e.is_passed THEN 1 ELSE 0 END) * 100.0 / COUNT(e.enrollment_id)) AS passed_percent
FROM 
    courses c
JOIN 
    enrollments e ON c.course_id = e.course_id
GROUP BY 
    c.code, c.title
HAVING 
    (SUM(CASE WHEN e.is_passed THEN 1 ELSE 0 END) * 100.0 / COUNT(e.enrollment_id)) < 60;

-- ЗАДАНИЕ 2:
WITH course_enrollments AS (
    SELECT 
        semester, 
        course_id, 
        COUNT(*) AS enrollments_count
    FROM 
        enrollments
    GROUP BY 
        semester, course_id
)
SELECT 
    semester, 
    course_id, 
    enrollments_count,
    RANK() OVER (PARTITION BY semester ORDER BY enrollments_count DESC) AS rank
FROM 
    course_enrollments;

-- ЗАДАНИЕ 3:
WITH ranked_students AS (
    SELECT 
        s.student_id,
        s.name,
        s.gpa,
        ROW_NUMBER() OVER (PARTITION BY s.department ORDER BY s.gpa DESC) AS rank
    FROM 
        university_students s
)
SELECT 
    student_id, 
    name, 
    gpa
FROM 
    ranked_students
WHERE 
    rank <= 3;

-- ЗАДАНИЕ 4:
CREATE INDEX idx_enrollments_semester_passed ON enrollments (semester, is_passed);
CREATE INDEX idx_enrollments_course_id ON enrollments (course_id);

EXPLAIN (ANALYZE, BUFFERS)
SELECT * FROM enrollments
WHERE semester='Fall 2023' AND is_passed=false
ORDER BY course_id;

-- ЗАДАНИЕ 5:
EXPLAIN ANALYZE
SELECT s.student_id, COUNT(e.enrollment_id) AS total_enrollments
FROM university_students s
JOIN enrollments e ON s.student_id = e.student_id
GROUP BY s.student_id;
