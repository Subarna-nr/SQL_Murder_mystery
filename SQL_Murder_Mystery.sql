-- Employees Table
CREATE TABLE employees (
    employee_id INT PRIMARY KEY,
    name VARCHAR(50),
    department VARCHAR(50),
    role VARCHAR(50)
);
INSERT INTO employees VALUES
(1, 'Alice Johnson', 'Engineering', 'Software Engineer'),
(2, 'Bob Smith', 'HR', 'HR Manager'),
(3, 'Clara Lee', 'Finance', 'Accountant'),
(4, 'David Kumar', 'Engineering', 'DevOps Engineer'),
(5, 'Eva Brown', 'Marketing', 'Marketing Lead'),
(6, 'Frank Li', 'Engineering', 'QA Engineer'),
(7, 'Grace Tan', 'Finance', 'CFO'),
(8, 'Henry Wu', 'Engineering', 'CTO'),
(9, 'Isla Patel', 'Support', 'Customer Support'),
(10, 'Jack Chen', 'HR', 'Recruiter');
-- Keycard Logs Table
CREATE TABLE keycard_logs (
    log_id INT PRIMARY KEY,
    employee_id INT,
    room VARCHAR(50),
    entry_time TIMESTAMP,
    exit_time TIMESTAMP
);
INSERT INTO keycard_logs VALUES
(1, 1, 'Office', '2025-10-15 08:00', '2025-10-15 12:00'),
(2, 2, 'HR Office', '2025-10-15 08:30', '2025-10-15 17:00'),
(3, 3, 'Finance Office', '2025-10-15 08:45', '2025-10-15 12:30'),
(4, 4, 'Server Room', '2025-10-15 08:50', '2025-10-15 09:10'),
(5, 5, 'Marketing Office', '2025-10-15 09:00', '2025-10-15 17:30'),
(6, 6, 'Office', '2025-10-15 08:30', '2025-10-15 12:30'),
(7, 7, 'Finance Office', '2025-10-15 08:00', '2025-10-15 18:00'),
(8, 8, 'Server Room', '2025-10-15 08:40', '2025-10-15 09:05'),
(9, 9, 'Support Office', '2025-10-15 08:30', '2025-10-15 16:30'),
(10, 10, 'HR Office', '2025-10-15 09:00', '2025-10-15 17:00'),
(11, 4, 'CEO Office', '2025-10-15 20:50', '2025-10-15 21:00'); -- killer

-- Calls Table
CREATE TABLE calls (
    call_id INT PRIMARY KEY,
    caller_id INT,
    receiver_id INT,
    call_time TIMESTAMP,
    duration_sec INT
);

INSERT INTO calls VALUES
(1, 4, 1, '2025-10-15 20:55', 45),
(2, 5, 1, '2025-10-15 19:30', 120),
(3, 3, 7, '2025-10-15 14:00', 60),
(4, 2, 10, '2025-10-15 16:30', 30),
(5, 4, 7, '2025-10-15 20:40', 90);

-- Alibis Table
CREATE TABLE alibis (
    alibi_id INT PRIMARY KEY,
    employee_id INT,
    claimed_location VARCHAR(50),
    claim_time TIMESTAMP
);


INSERT INTO alibis VALUES
(1, 1, 'Office', '2025-10-15 20:50'),
(2, 4, 'Server Room', '2025-10-15 20:50'), -- false alibi
(3, 5, 'Marketing Office', '2025-10-15 20:50'),
(4, 6, 'Office', '2025-10-15 20:50');

-- Evidence Table
CREATE TABLE evidence (
    evidence_id INT PRIMARY KEY,
    room VARCHAR(50),
    description VARCHAR(255),
    found_time TIMESTAMP
);

INSERT INTO evidence VALUES
(1, 'CEO Office', 'Fingerprint on desk', '2025-10-15 21:05'),
(2, 'CEO Office', 'Keycard swipe logs mismatch', '2025-10-15 21:10'),
(3, 'Server Room', 'Unusual access pattern', '2025-10-15 21:15');

SELECT evidence_id, room, description, found_time
FROM evidence
ORDER BY found_time;

SELECT k.log_id, k.employee_id, e.name, k.room, k.entry_time, k.exit_time
FROM keycard_logs k
JOIN employees e ON k.employee_id = e.employee_id
WHERE (k.room ILIKE '%CEO%' OR k.room = 'CEO Office')
  AND (
       (k.entry_time BETWEEN TIMESTAMP '2025-10-15 20:30:00' AND TIMESTAMP '2025-10-15 21:30:00')
    OR (k.exit_time  BETWEEN TIMESTAMP '2025-10-15 20:30:00' AND TIMESTAMP '2025-10-15 21:30:00')
    OR (k.entry_time <= TIMESTAMP '2025-10-15 20:30:00' AND k.exit_time >= TIMESTAMP '2025-10-15 21:30:00')
  )
ORDER BY k.entry_time;

SELECT a.alibi_id, a.employee_id, e.name,
       a.claimed_location, a.claim_time,
       k.room AS actual_room, k.entry_time, k.exit_time
FROM alibis a
JOIN employees e ON a.employee_id = e.employee_id
JOIN keycard_logs k
  ON a.employee_id = k.employee_id
 AND a.claim_time BETWEEN k.entry_time AND k.exit_time
ORDER BY a.claim_time;

SELECT c.call_id, c.caller_id, caller.name AS caller_name,
       c.receiver_id, receiver.name AS receiver_name,
       c.call_time, c.duration_sec
FROM calls c
LEFT JOIN employees caller ON c.caller_id = caller.employee_id
LEFT JOIN employees receiver ON c.receiver_id = receiver.employee_id
WHERE c.call_time BETWEEN TIMESTAMP '2025-10-15 20:50:00' AND TIMESTAMP '2025-10-15 21:00:00'
ORDER BY c.call_time;

SELECT c.call_id, c.caller_id, caller.name AS caller_name,
       c.receiver_id, receiver.name AS receiver_name,
       c.call_time, c.duration_sec
FROM calls c
LEFT JOIN employees caller ON c.caller_id = caller.employee_id
LEFT JOIN employees receiver ON c.receiver_id = receiver.employee_id
WHERE c.call_time BETWEEN TIMESTAMP '2025-10-15 20:50:00' AND TIMESTAMP '2025-10-15 21:00:00'
ORDER BY c.call_time;

SELECT e.name, k.employee_id, k.entry_time, k.exit_time, v.found_time
FROM evidence v
JOIN keycard_logs k
  ON (k.room ILIKE '%CEO%' OR k.room = 'CEO Office')
 AND k.entry_time <= v.found_time
 AND (k.exit_time IS NULL OR k.exit_time >= v.found_time)
JOIN employees e ON e.employee_id = k.employee_id
ORDER BY v.found_time, k.entry_time;

WITH access AS (
    SELECT DISTINCT employee_id
    FROM keycard_logs
    WHERE (room ILIKE '%CEO%' OR room = 'CEO Office')
      AND (
           (entry_time BETWEEN TIMESTAMP '2025-10-15 20:30:00' AND TIMESTAMP '2025-10-15 21:30:00')
        OR (exit_time  BETWEEN TIMESTAMP '2025-10-15 20:30:00' AND TIMESTAMP '2025-10-15 21:30:00')
        OR (entry_time <= TIMESTAMP '2025-10-15 20:30:00' AND exit_time >= TIMESTAMP '2025-10-15 21:30:00')
      )
),
false_alibi AS (
    SELECT DISTINCT a.employee_id
    FROM alibis a
    JOIN keycard_logs k
      ON a.employee_id = k.employee_id
     AND a.claim_time BETWEEN k.entry_time AND k.exit_time
     AND (k.room ILIKE '%CEO%' OR k.room = 'CEO Office')
),
suspicious_calls AS (
    SELECT DISTINCT caller_id AS employee_id
    FROM calls
    WHERE call_time BETWEEN TIMESTAMP '2025-10-15 20:50:00' AND TIMESTAMP '2025-10-15 21:00:00'
    UNION
    SELECT DISTINCT receiver_id AS employee_id
    FROM calls
    WHERE call_time BETWEEN TIMESTAMP '2025-10-15 20:50:00' AND TIMESTAMP '2025-10-15 21:00:00'
)
SELECT name AS killer
FROM employees
WHERE employee_id IN (SELECT employee_id FROM access)
  AND employee_id IN (SELECT employee_id FROM false_alibi)
  AND employee_id IN (SELECT employee_id FROM suspicious_calls)
LIMIT 1;

-- Q1: Accesses to CEO Office around 20:30 - 21:30 on murder date
SELECT k.log_id,
       k.employee_id,
       emp.name,
       k.room,
       k.entry_time,
       k.exit_time
FROM keycard_logs k
JOIN employees emp ON k.employee_id = emp.employee_id
WHERE (k.room ILIKE '%CEO%' OR k.room ILIKE '%Chief Executive%' OR k.room = 'CEO Office')
  AND (
       (k.entry_time BETWEEN TIMESTAMP '2025-10-15 20:30:00' AND TIMESTAMP '2025-10-15 21:30:00')
    OR (k.exit_time  BETWEEN TIMESTAMP '2025-10-15 20:30:00' AND TIMESTAMP '2025-10-15 21:30:00')
    OR (k.entry_time <= TIMESTAMP '2025-10-15 20:30:00' AND k.exit_time >= TIMESTAMP '2025-10-15 21:30:00')
  )
ORDER BY k.entry_time;

-- Q2: Alibis that contradict keycard presence in CEO Office at claim_time
SELECT a.alibi_id,
       a.employee_id,
       emp.name,
       a.claimed_location,
       a.claim_time,
       k.room AS actual_room,
       k.entry_time,
       k.exit_time
FROM alibis a
JOIN employees emp ON a.employee_id = emp.employee_id
JOIN keycard_logs k
  ON a.employee_id = k.employee_id
 AND a.claim_time BETWEEN k.entry_time AND k.exit_time
WHERE (k.room ILIKE '%CEO%' OR k.room = 'CEO Office')
  AND (a.claimed_location NOT ILIKE '%CEO%' AND a.claimed_location NOT ILIKE '%Chief Executive%')
ORDER BY a.claim_time;

-- Q3: Calls between 20:50 and 21:00 on murder date
SELECT c.call_id,
       c.call_time,
       c.duration_sec,
       c.caller_id, caller.name AS caller_name,
       c.receiver_id, receiver.name AS receiver_name
FROM calls c
LEFT JOIN employees caller   ON c.caller_id   = caller.employee_id
LEFT JOIN employees receiver ON c.receiver_id = receiver.employee_id
WHERE c.call_time BETWEEN TIMESTAMP '2025-10-15 20:50:00' AND TIMESTAMP '2025-10-15 21:00:00'
ORDER BY c.call_time;

-- Q4: Evidence found in the CEO Office
SELECT evidence_id, room, description, found_time
FROM evidence
WHERE room ILIKE '%CEO%' OR room ILIKE '%Chief Executive%' OR room = 'CEO Office'
ORDER BY found_time;

-- Q5: Combined suspicious profile: access + false alibi + call activity
WITH access AS (
  SELECT DISTINCT k.employee_id,
         MIN(k.entry_time) AS first_entry,
         MAX(k.exit_time)  AS last_exit
  FROM keycard_logs k
  WHERE (k.room ILIKE '%CEO%' OR k.room = 'CEO Office')
    AND (
         (k.entry_time BETWEEN TIMESTAMP '2025-10-15 20:30:00' AND TIMESTAMP '2025-10-15 21:30:00')
      OR (k.exit_time  BETWEEN TIMESTAMP '2025-10-15 20:30:00' AND TIMESTAMP '2025-10-15 21:30:00')
      OR (k.entry_time <= TIMESTAMP '2025-10-15 20:30:00' AND k.exit_time >= TIMESTAMP '2025-10-15 21:30:00')
    )
  GROUP BY k.employee_id
),
false_alibi AS (
  -- alibi where the claim_time falls inside a CEO Office presence interval (i.e., claimed elsewhere but was in CEO Office)
  SELECT DISTINCT a.employee_id, a.claimed_location, a.claim_time
  FROM alibis a
  JOIN keycard_logs k
    ON a.employee_id = k.employee_id
   AND a.claim_time BETWEEN k.entry_time AND k.exit_time
  WHERE (k.room ILIKE '%CEO%' OR k.room = 'CEO Office')
),
calls_in_window AS (
  SELECT DISTINCT caller_id AS employee_id, call_time
  FROM calls
  WHERE call_time BETWEEN TIMESTAMP '2025-10-15 20:50:00' AND TIMESTAMP '2025-10-15 21:00:00'
  UNION
  SELECT DISTINCT receiver_id AS employee_id, call_time
  FROM calls
  WHERE call_time BETWEEN TIMESTAMP '2025-10-15 20:50:00' AND TIMESTAMP '2025-10-15 21:00:00'
)
SELECT emp.employee_id,
       emp.name,
       a.first_entry,
       a.last_exit,
       fa.claimed_location,
       fa.claim_time,
       MIN(c.call_time) AS example_call_time
FROM employees emp
JOIN access a            ON emp.employee_id = a.employee_id
JOIN false_alibi fa      ON emp.employee_id = fa.employee_id
JOIN calls_in_window c   ON emp.employee_id = c.employee_id
GROUP BY emp.employee_id, emp.name, a.first_entry, a.last_exit, fa.claimed_location, fa.claim_time
ORDER BY example_call_time NULLS LAST;









