# Case 1 – Funnel Analysis by Product Category

## Business Question
How can we identify high-impact product categories and diagnose funnel constraints to guide growth decisions?

## Decision
Prioritize scaling traffic and optimization for categories with strong end-to-end conversion, while deprioritizing low-signal categories until more data is available.

## Data
- Event-level user interaction data
- Public Kaggle dataset (anonymized)

## Analysis Overview
- SQL used to construct a user-level funnel across product categories (view → cart → purchase).
- Python used to aggregate funnel metrics, group low-volume categories, and visualize conversion performance.

## Key Findings
- Revenue and conversions are concentrated in a small number of high-performing categories.
- Several categories show meaningful traffic but weak downstream conversion, indicating funnel friction.
- Low-volume categories lack sufficient signal and are classified as “more data required.”

## Repo Structure
- `sql/core_analysis.sql` – Core funnel query
- `python/core_analysis.ipynb` – Funnel aggregation and visualization
- `outputs/share_of_total_views_by_category.png` – Category share of total views
- `outputs/view_to_purchase_conversion_by_category.png` – View → purchase conversion by category

## Notes
This repository focuses on analysis logic and decision-making.  
Environment setup, data ingestion, and execution steps are intentionally omitted.

## Portfolio Link
<https://portfolio-home.notion.site/Case-1-Index-Page-2e5bf1a14b498016914af20065074e77/>
