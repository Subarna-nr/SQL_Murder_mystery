🕵️‍♀️ SQL Murder Mystery — Who Killed the CEO of TechNova Inc.? 🔍

Welcome to my SQL capstone project — a crime investigation solved entirely using SQL queries.
The challenge: uncover who murdered the CEO, where, and how, using nothing but data stored in a relational database.

🧠 Project Story

On October 15, 2025 at 9:00 PM, the CEO of TechNova Inc. was found dead in their office.
Every clue was hidden inside the company’s internal systems — and my task as the data analyst was to solve the mystery using pure SQL.

No guessing.
No assumptions.
Only data-driven deduction.

🗂️ Database Tables Used
Table	Purpose
employees	Employee profiles
keycard_logs	Entry/exit tracking across rooms
calls	Internal phone call history
alibis	Claimed locations of employees
evidence	Items found around the crime scene

These datasets together formed the trail that ultimately exposed the murderer.

🔍 Investigation Steps
Step	Objective	SQL Concepts
1	Identify crime location & timing	WHERE, filtering
2	Track anyone near the CEO’s office	JOIN, BETWEEN
3	Validate alibis vs actual movement	JOIN, subqueries
4	Review suspicious calls	filtering, JOIN
5	Link evidence to suspects	JOIN, comparison
6	Final suspect intersection	INTERSECT, multi-join

Each query reduced the suspect list — until only one person matched every clue.

🏁 Final Output

The last query returns a single-column, single-row result:

killer
Full Name of the murderer (from employees.name)

This result confirms the murderer beyond doubt, backed by movement logs, timestamps, call activity, and evidence correlations.

💡 Skills Strengthened

✔ Analytical SQL problem-solving
✔ Multi-table joins for real-world logic
✔ Log & timestamp pattern interpretation
✔ Investigative thinking using relational databases
✔ Query optimization using subqueries & CTEs

This project goes beyond typical CRUD — it mirrors real business investigations where truth lies across multiple datasets.

🏗️ Tech Stack
Component	Technology
Database	PostgreSQL (pgAdmin)
Language	SQL
Tools	pgAdmin / Workbench
Dataset	Custom-generated for project
🚀 How to Run the Project

1️⃣ Clone the repository
2️⃣ Open the .sql file in pgAdmin / MySQL Workbench
3️⃣ Run the full script to create tables & insert sample data
4️⃣ Execute queries step-by-step from the Investigation folder
5️⃣ Run the Final Case Solved Query to reveal the killer

📌 Conclusion

This project was not just about writing SQL —
it was about thinking critically, connecting datasets, and letting data tell the truth.

An incredibly fun and analytical challenge that boosted my:
🔹 SQL expertise
🔹 Logical reasoning
🔹 Attention to detail with real datasets
