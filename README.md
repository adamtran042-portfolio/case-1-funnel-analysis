# Case 1 – Funnel Analysis by Product Category

## Business Question
How can we identify high-impact product categories and diagnose funnel constraints to guide growth decisions?

## Decision
Prioritize scaling traffic and optimization for categories with strong end-to-end conversion, while deprioritizing low-signal categories until more data is available.

## Data
- Event-level user interaction data
- Public Kaggle dataset (anonymized)

## Analysis Overview
- SQL used to construct a user-level category funnel (view → cart → purchase)
- Python used to aggregate funnel metrics, group low-volume categories, and visualize conversion performance

## Repo Structure
- `sql/core_analysis.sql` – core funnel query
- `python/core_analysis.ipynb` – Python analysis and visualization
- `outputs/` – figures referenced in the portfolio

## Notes
Environment setup, data ingestion, and database configuration steps are intentionally omitted.  
This repository focuses on analysis logic and decision-making.
## Portfolio Link
<https://portfolio-home.notion.site/Case-1-Index-Page-2e5bf1a14b498016914af20065074e77/>
