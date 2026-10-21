# The Borrowed Coat

*Tracking women's health evidence with open data: where it is improving, what is driving it, and what others can copy.*

In Isaac Bashevis Singer's story, Yentl puts on a man's coat to get into the room where learning happens. For decades, medicine asked women to do something similar: doses, side effects, and "typical" symptoms were worked out mostly in men, and the result was handed to women, a coat cut for someone else. Women's work in science has often been borrowed too, with the credit going to the men around them.

This series measures where that is still true, and where it is changing.

## Why I'm building this

For decades, many drugs were tested mainly on men. From 1977 until 1993, FDA guidance recommended keeping women who could become pregnant out of early drug trials ([1]). The effects showed up later: of 10 prescription drugs withdrawn from the US market between 1997 and 2000, 8 posed greater health risks for women ([2]). In 2013, the FDA lowered the recommended starting dose of the sleep drug zolpidem for women to 5 mg, because of next-morning impairment ([3]). And women's pain is still too often doubted: a 2024 study of more than 21,000 emergency department patients in the US and Israel found that women were less likely than men with the same pain score to be given pain medication, and less likely to have their pain score recorded at all ([4]). I want to show, with data, where this is still happening and where it is getting better.

**The gap is real, and mostly invisible.** Many trials that enroll both women and men never report their results separately. A review of 277 published stroke trials found that 36% did ([5]). Without that split, a drug can be approved on data that never shows how it works in women. You can't fix a gap you can't see.

**The data is already public; it just isn't tracked.** Trial results, research funding, and side-effect reports are all open. Past studies checked one field at a time, once. This project measures them across all fields, keeps the numbers current, and puts them in one place.

**It's measurement, not grievance.** Every number comes with its method and confidence interval, so anyone can check it. And it looks for the fields and sponsors that already do this well, so others can copy them.

## The parts

| Part | Question | Status |
|---|---|---|
| [Split the Data](part1_split_the_data/) | How often do clinical trials report results by sex? | In progress |
| The Overlooked Burden | Which women's conditions get research attention relative to how much illness they cause? | Planned |
| The Second Fit | Does the post-market safety net catch sex differences that trials missed? | Planned |

## Data

All parts use public, de-identified, or aggregate data only. Part 1 uses [AACT](https://aact.ctti-clinicaltrials.org/), a database copy of the full ClinicalTrials.gov registry maintained by the Clinical Trials Transformation Initiative.

## Notes

- Findings are associations, not causes.
- Nothing here is medical advice.
- Prior research is credited in each part's README.

## Sources

1. [Embryo Project Encyclopedia: FDA "Guideline for the Study and Evaluation of Gender Differences in the Clinical Evaluation of Drugs" (1993)](https://embryo.asu.edu/pages/guideline-study-and-evaluation-gender-differences-clinical-evaluation-drugs-july-1993-united)
2. [US GAO, "Drug Safety: Most Drugs Withdrawn in Recent Years Had Greater Health Risks for Women" (GAO-01-286R, 2001)](https://www.gao.gov/products/GAO-01-286R)
3. [FDA Drug Safety Communication on zolpidem label changes and dosing (May 2013)](https://www.fda.gov/drugs/drug-safety-and-availability/fda-drug-safety-communication-fda-approves-new-label-changes-and-dosing-zolpidem-products-and)
4. [Guzikevits et al., "Sex bias in pain management decisions," PNAS (2024)](https://doi.org/10.1073/pnas.2401331121) ([summary: AHRQ PSNet](https://psnet.ahrq.gov/issue/sex-bias-pain-management-decisions))
5. [Carcel et al., "Trends in recruitment of women and reporting of sex differences in large-scale published randomized controlled trials in stroke," International Journal of Stroke (2019)](https://doi.org/10.1177/1747493019851292)

## License

MIT
