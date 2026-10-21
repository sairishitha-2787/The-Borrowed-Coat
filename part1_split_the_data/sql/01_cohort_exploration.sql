-- The Borrowed Coat: Split the Data
-- 01_cohort_exploration.sql
-- Exploration queries from Session 1, run on the live AACT database on Oct 15, 2026.
-- Results in the comments are from that date; the live database changes daily.

-- 1. Completed interventional trials with posted results
-- Result: 62,763
SELECT COUNT(*)
FROM ctgov.studies
WHERE study_type ILIKE 'interventional'
  AND overall_status ILIKE 'completed'
  AND results_first_posted_date IS NOT NULL;

-- 2. Trials by type and status (shows values are stored in capitals)
-- Result: 23 rows; top row INTERVENTIONAL + COMPLETED = 259,735
SELECT study_type, overall_status, COUNT(*)
FROM ctgov.studies
GROUP BY study_type, overall_status
ORDER BY COUNT(*) DESC;

-- 3. Columns in eligibilities (the sex column is named "gender")
-- Result: 14 columns
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'ctgov'
  AND table_name = 'eligibilities'
ORDER BY ordinal_position;

-- 4. Trials with posted results, by eligible sex
-- Result: ALL 55,197 | FEMALE 5,084 | MALE 2,472 | null 10 (sums to 62,763)
SELECT e.gender, COUNT(*)
FROM ctgov.studies s
JOIN ctgov.eligibilities e ON e.nct_id = s.nct_id
WHERE s.study_type = 'INTERVENTIONAL'
  AND s.overall_status = 'COMPLETED'
  AND s.results_first_posted_date IS NOT NULL
GROUP BY e.gender
ORDER BY COUNT(*) DESC;

-- 5. Gender-based eligibility among mixed-sex trials
-- Result: true 184 | null 55,013 (no false values: null is not false)
SELECT e.gender_based, COUNT(*)
FROM ctgov.studies s
JOIN ctgov.eligibilities e ON e.nct_id = s.nct_id
WHERE s.study_type = 'INTERVENTIONAL'
  AND s.overall_status = 'COMPLETED'
  AND s.results_first_posted_date IS NOT NULL
  AND e.gender = 'ALL'
GROUP BY e.gender_based;

-- 6. Sample of gender-based descriptions
-- Result: some "ALL" trials are effectively single-sex (e.g. NCT01241318, pregnant women only)
SELECT e.nct_id, e.gender_description
FROM ctgov.studies s
JOIN ctgov.eligibilities e ON e.nct_id = s.nct_id
WHERE s.study_type = 'INTERVENTIONAL'
  AND s.overall_status = 'COMPLETED'
  AND s.results_first_posted_date IS NOT NULL
  AND e.gender = 'ALL'
  AND e.gender_based IS TRUE
LIMIT 20;

-- 7. Mixed-sex trials by completion year
-- Result: 37 rows; 2008-2023 = 47,449 trials; 2024 = 3,421; 2025-2026 incomplete; 442 with no date
SELECT EXTRACT(YEAR FROM s.completion_date) AS completion_year,
       COUNT(*) AS trials,
       COUNT(*) FILTER (WHERE s.completion_date_type = 'ACTUAL') AS actual_date
FROM ctgov.studies s
JOIN ctgov.eligibilities e ON e.nct_id = s.nct_id
WHERE s.study_type = 'INTERVENTIONAL'
  AND s.overall_status = 'COMPLETED'
  AND s.results_first_posted_date IS NOT NULL
  AND e.gender = 'ALL'
GROUP BY completion_year
ORDER BY completion_year;

-- 8. Columns in outcome_measurements and result_groups
-- Result: classification, category, title confirmed; result_groups.result_type separates outcome groups
SELECT table_name, column_name
FROM information_schema.columns
WHERE table_schema = 'ctgov'
  AND table_name IN ('outcome_measurements', 'result_groups')
ORDER BY table_name, ordinal_position;
