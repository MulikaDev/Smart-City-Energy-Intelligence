Smart City Energy Performance Dashboard ⚡📊

  This project analyzes energy production and consumption in a Smart City district. The goal was to understand how much of the energy demand can be covered by local solar generation and where the district still depends on the external power grid.The project covers the full workflow: from data in a SQL database to building an interactive Power BI dashboard for analysis.

Business Goal

  The main objective was to evaluate the self-sufficiency of the district's energy system.
Even though the area produces a good amount of solar energy during the day, the analysis shows that the district still relies heavily on the grid during the evening hours.Key finding:
  About 76% of energy demand during peak hours is covered by the external grid.
  This indicates that storing excess solar energy during the day (for example with battery systems) could significantly reduce grid dependency.
  
🖼️ Dashboard Preview

![Dashboard Mockup](assets/image.png)

Tech Stack

  SQL / PostgreSQL – data storage and transformations
  Power BI – dashboard creation and data visualization
  DAX – calculations and performance metrics
  
Data Workflow

Raw smart meter data → PostgreSQL database → SQL data transformations → Aggregated dataset → Power BI dashboard

What I Did

Designed a simple relational structure to store smart meter data
Used SQL queries to clean and prepare the dataset
Built a Power BI dashboard to visualize production and consumption
Created DAX measures to calculate key indicators such as energy self-sufficiency and average energy cost

Key Insights

Low energy autonomy
Only about 19% of total energy demand is covered by local solar production.
Evening peak dependency
The district relies most on the external grid between 18:00 and 21:00.
Unused solar potential
Around 24% of solar production is not used locally, which suggests that energy storage could improve efficiency.

Possible Improvements

Simulate the impact of Battery Energy Storage Systems (BESS)
Add forecasting for energy demand
