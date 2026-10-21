# Definitions

*The Borrowed Coat: Split the Data. How often clinical trials report results by sex. Draft, Oct 15, 2026.*

This file says exactly which trials are counted and what counts as "reporting results by sex," so every number in the project can be checked.

## Data source

- **AACT** (Aggregate Analysis of ClinicalTrials.gov), run by the Clinical Trials Transformation Initiative (CTTI). It is a daily-refreshed Postgres copy of the full ClinicalTrials.gov registry.
- Tables are in the `ctgov` schema. Trials are linked across tables by `nct_id`.
- Exploration uses the live `aact` database (queried Oct 15, 2026).
- Snapshot downloaded: AACT flat text files, **updated Oct 15, 2026** (snapshot ID 4447). **v1 numbers will be pinned to one snapshot date: Oct 15, 2026, unless a later snapshot is chosen before release.**

## Cohort

A trial is in the cohort if all of these are true:

| Rule | Column | Why |
|---|---|---|
| Interventional | `studies.study_type = 'INTERVENTIONAL'` | Only interventional trials test a treatment and post outcome results in this form. |
| Completed | `studies.overall_status = 'COMPLETED'` | Terminated, withdrawn, and unknown-status trials may have partial or no results. |
| Results posted | `studies.results_first_posted_date IS NOT NULL` | The project measures results posted on ClinicalTrials.gov. |
| Open to both sexes | `eligibilities.gender = 'ALL'` | A single-sex trial has nothing to report "by sex." |
| Completed 2008–2023 | `EXTRACT(YEAR FROM studies.completion_date)` | See "Completion years" below. |

Excluded along the way (Oct 15, 2026 counts):

- 7,556 single-sex trials (5,084 female-only, 2,472 male-only) and 10 with no sex recorded.
- 1,381 trials completed before 2008, 442 with no completion date, and 2,504 completed in 2025–2026.

Working cohort: **47,449 trials** completed 2008–2023, plus **3,421** completed in 2024, reported separately as provisional.

**Note on wording:** AACT's column is named `gender`, but it records which **sex** may enroll. This project says "sex" throughout.

## Completion years

- **Start: 2008.** The ClinicalTrials.gov results database began in 2008, and cohort counts jump from 603 trials (2007) to 2,068 (2008).
- **Main trend ends at 2023.** Results are usually posted a year or more after a trial ends, so recent years are incomplete: 2025 has 2,163 trials and 2026 has 341, against about 3,500 a year for 2022–2023.
- **2024 is provisional** and is re-checked at each monthly refresh.
- `completion_date_type` is `ACTUAL` for almost every trial in the cohort, so completion dates are reliable.

## Mixed-sex enrollment

Eligibility "ALL" does not guarantee that both sexes enrolled. Examples from the cohort:

- NCT01241318: enrolled pregnant women only.
- NCT04596540: limited to women of non-childbearing potential.
- NCT03771638: limited to participants who self-identify as men.

So the final cohort keeps only trials where each sex makes up at least **[X]%** of enrolled participants, using the sex counts in the baseline results. **The threshold X is still to be decided.**

The `eligibilities.gender_based` flag (true for 184 cohort trials, 0.3%) is not used: it is filled in inconsistently, sometimes describing enrollment balance rather than gender identity.

## Sex-stratified result

A trial **reports results by sex** if at least one outcome measure in its posted ClinicalTrials.gov results shows its values separately for female and male participants.

**How it appears in the data.** When sponsors post results, each outcome measure can be split into rows:

- **Classes**: subgroups within an outcome, stored in `outcome_measurements.classification` (AACT's name for ClinicalTrials.gov's "Outcome Class Title"). A class titled "Female" or "Women" is the clearest sign of a sex-stratified result.
- **Categories**: the response options within an outcome (e.g. "Improved" / "Not improved"), stored in `outcome_measurements.category`. Occasionally sponsors put sex here instead.
- **Groups**: usually the trial's treatment arms, stored in `result_groups.title` and linked through `outcome_measurements.result_group_id`. `result_groups` also holds baseline and other groups, so only outcome groups are checked (`result_groups.result_type`; values to confirm). Rarely, arms are defined by sex (e.g. "Drug A, women").
- **Outcome title**: sometimes the split is only named in the title (e.g. "Change in blood pressure by sex"), stored in `outcome_measurements.title`.

A trial counts if any of these splits an outcome into female and male parts.

**Counts:**

- Any outcome type: primary, secondary, or other. The type of the sex-split outcome is recorded, so primary-outcome reporting can be shown separately.
- Female and male values given for the same outcome, even if no statistical comparison between them is posted.

**Does not count:**

- **Sex in the baseline characteristics table.** That describes who enrolled, not the results.
- **Outcomes about a sex-specific topic** that are not split by sex (e.g. a "female sexual function" score, or a pregnancy outcome).
- **A split by something else that mentions sex in passing** (e.g. classes named "Sexually active" / "Not sexually active").
- **Only one sex shown** (e.g. a "Women" class with no matching men's class).
- **Sex reported only in a journal article** (see "What this does not measure").

**How this compares with published audits.** Carcel et al. (2019), the stroke audit, reviewed **published papers** of 277 stroke trials and found that 36% reported results according to sex. Their source is the journal article, so a trial can count there by reporting sex in the text or a subgroup figure. This project counts only results posted on ClinicalTrials.gov, which are more structured but usually less detailed. Expect lower rates here, and compare the two only as context, not as like-for-like numbers.

## What this does not measure

- **Journal publications.** A trial may report by sex in a paper but not on ClinicalTrials.gov. Published audits often review papers, so their rates are not directly comparable.
- **Trials that never posted results.** Only about 24% of completed interventional trials have posted results (62,763 of 259,735, Oct 15, 2026).

## Known limitations

- **Results-posting bias.** Posting is legally required mainly for US, FDA-regulated trials, so the cohort leans toward US, industry, and FDA-regulated trials.
- **Results lag.** In recent years, trials that post fastest are over-represented, which may make those years look better.
- **Classifier accuracy.** Sex-stratified results are detected automatically; precision and recall are measured on a hand-labeled sample and reported alongside every rate.
