# Bank Marketing Campaign & Term Deposit Analytics

## Overview

This project analyzes a bank's direct-marketing campaign data to understand customer behavior, campaign execution patterns, and factors associated with term-deposit subscriptions.

The project is intentionally focused on **Data Analytics rather than Machine Learning**. It combines Python-based exploratory analysis with PostgreSQL business queries to move from raw campaign data to practical recommendations.

## Business Problem

The bank wants to understand which customer groups and campaign patterns are associated with stronger term-deposit subscription rates. The analysis focuses on customer profile, contact method, campaign frequency, previous campaign outcomes, timing, and post-contact behavior.

## Objectives

- Assess data quality and prepare an analysis-ready dataset.
- Compare subscription rates across customer segments.
- Evaluate contact-channel performance.
- Investigate campaign-frequency patterns and possible diminishing effectiveness.
- Understand the relationship between previous campaign outcomes and current subscription.
- Explore month and weekday patterns.
- Separate post-contact measures such as call duration from pre-contact campaign planning.
- Translate findings into practical campaign recommendations.

## Dataset

- Rows in raw dataset: 41,188
- Columns: 21
- Target: `y`
- `yes` = term deposit subscribed
- `no` = term deposit not subscribed

The dataset contains customer attributes, campaign history, contact information, and economic indicators.

## Tools & Technologies

- Python
- Pandas
- NumPy
- Matplotlib
- Seaborn
- PostgreSQL
- SQL
- Jupyter Notebook

## Analytical Approach

1. **Data quality** — missing values, `unknown` categories, 12 exact duplicate rows, data types and distributions; duplicate removal leaves 41,176 analysis rows.
2. **Customer profiling** — job, age, education, marital status, housing and loan indicators.
3. **Campaign analysis** — contact method, number of campaign contacts and timing.
4. **Contact-frequency analysis** — grouped campaign contacts to examine diminishing response at higher frequencies.
5. **Previous campaign analysis** — historical campaign outcomes and prior-contact status.
6. **Combined segmentation** — campaign frequency with previous outcome and other segment dimensions.
7. **Post-contact analysis** — call duration is analyzed separately because it is known only during/after the interaction.
8. **SQL analytics** — CTEs, conditional aggregation, window functions, ranking, benchmark comparisons and business scorecards.

## Key Findings

The analysis identifies several clear patterns:

- Overall subscription is a minority outcome, so subscription rate is used as the main segment-comparison metric.
- Previous campaign outcome is a strong separator of observed subscription performance.
- Cellular contacts have a higher observed subscription rate than telephone contacts.
- Subscription rate declines across higher current-campaign contact-frequency groups.
- Customer segments differ materially by job and age.
- Segment scale matters: high conversion rate does not automatically mean high contribution to total subscribers.
- Call duration is associated with subscription outcome but is treated as a post-contact indicator rather than a pre-contact targeting variable.
- Campaign timing shows variation, but timing patterns should be considered alongside customer mix and campaign volume.

## Business Recommendations

- Prioritize historically responsive customer groups when reviewing campaign lists.
- Review repeated-contact strategies where observed conversion weakens at higher contact frequency.
- Evaluate contact-channel allocation using historical performance while accounting for customer mix.
- Consider both segment conversion rate and customer volume when prioritizing campaign opportunities.
- Use previous campaign outcomes as behavioral context for campaign planning.
- Treat call duration as a post-contact performance measure rather than a pre-contact targeting feature.
- Validate timing-related hypotheses with future campaign testing.

## Repository Structure

```text
bank-marketing-campaign-analytics/
│
├── data/
│   └── bank_marketing.csv
│
├── notebooks/
│   └── Bank_Marketing_Campaign_Analysis.ipynb
│
├── sql/
│   └── bank_marketing_analysis.sql
│
├── README.md
├── requirements.txt
└── .gitignore
```

## PostgreSQL Setup

Load the CSV into a PostgreSQL table named `bank_marketing`.

The SQL file assumes this table name and uses PostgreSQL-compatible syntax.

Do not commit database credentials. Use environment variables or a local configuration file that is excluded from Git.

## Limitations

- The data is observational, so association does not establish causation.
- Some categorical fields contain `unknown` values.
- Small segments can produce unstable rates.
- Historical campaign behavior may not generalize directly to a future campaign.
- `duration` is a post-contact variable and should not be treated as a pre-contact targeting feature.

## Project Note

This project is designed to demonstrate practical Data Analyst skills: data cleaning, exploratory analysis, business-oriented visualization, advanced SQL, segmentation and evidence-based recommendations.
