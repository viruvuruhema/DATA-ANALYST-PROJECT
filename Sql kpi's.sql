create database BankAnalytics;

-- Merge both tables
CREATE TABLE loan_data AS
SELECT f1.id,
       f1.loan_amnt,
       f1.term,
       f1.int_rate,
       f1.grade,
       f1.sub_grade,
       f1.emp_length,
       f1.home_ownership,
       f1.annual_inc,
       f1.verification_status,
       f1.purpose,
       f1.addr_state,
       f1.dti,
       f1.issue_d,
       f1.Issue_year,
       f1.loan_status,
       f2.earliest_cr_line,
       f2.total_pymnt,
       f2.total_rec_late_fee,
       f2.last_pymnt_d,
       f2.last_paymnt_year,
       f2.last_credit_pull_d,
       f2.earlist_year,
       f2.revol_bal
FROM finance1 f1
JOIN finance2 f2
  ON f1.id = f2.id;
  
  
  -- Year wise loan amount stats
SELECT Issue_year,
       ROUND(SUM(loan_amnt)/1000000, 2) AS total_loan_amount_million
FROM loan_data
WHERE Issue_year IS NOT NULL
GROUP BY Issue_year
ORDER BY Issue_year;


-- Grade and Sub-grade wise revolving balance
SELECT grade,
       sub_grade,
       ROUND(SUM(revol_bal)/1000000, 2) AS total_revol_bal_million
FROM loan_data
GROUP BY grade, sub_grade
ORDER BY grade, sub_grade;


-- Verified vs Non-Verified Total Payment
SELECT verification_status,
       ROUND(SUM(total_pymnt)/1000000, 2) AS total_payment_million
FROM loan_data
GROUP BY verification_status;


-- State wise and Month wise loan status
SELECT addr_state,
       Issue_year,
       loan_status,
       count(*) AS loan_count
FROM loan_data
WHERE Issue_year IS NOT NULL
GROUP BY addr_state, Issue_year, loan_status
ORDER BY addr_state, Issue_year;


-- Home ownership vs Last Payment Date
SELECT home_ownership,
       last_paymnt_year,
       ROUND(SUM(total_pymnt)/1000000, 2) AS total_payment_million
FROM loan_data
WHERE last_paymnt_year IS NOT NULL
GROUP BY home_ownership, last_paymnt_year
ORDER BY home_ownership, last_paymnt_year;

-- Total Customers
SELECT COUNT(*) AS total_rows
FROM loan_data;

-- Toatl loan amount
SELECT ROUND(SUM(loan_amnt)/1000000, 2) AS total_loan_amount_million
FROM loan_data;

-- Average Dti
SELECT AVG(CAST(REPLACE(dti, '%', '') AS DECIMAL(5,2))) AS average_dti
FROM loan_data;

-- Average revolve balance
SELECT SUM(revol_bal) AS total_revolving_balance
FROM loan_data;

-- Average Int Rate
SELECT AVG(CAST(REPLACE(int_rate, '%', '') AS DECIMAL(5,2))) AS average_interest_rate
FROM loan_data;










