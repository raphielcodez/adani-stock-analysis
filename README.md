# **Adani Group Stock Market Analysis**

An end-to-end data analytics project analyzing historical stock market data for companies within the Adani Group using **Python, SQL, and Tableau**.

The project focuses on historical price performance, daily returns, volatility, trading activity, company-level comparisons, and stock-market behavior surrounding **January 24, 2023**.

## **📊 Project Overview**

This project demonstrates a complete data analytics workflow, starting with raw historical stock data and progressing through data cleaning, feature engineering, exploratory analysis, SQL-based analysis, and interactive Tableau dashboards.

The goal was to answer questions such as:

- How have Adani Group companies performed over time?
- How volatile are the different companies?
- Which companies experienced the highest trading activity?
- How frequently did companies record positive trading days?
- How did stock prices and trading activity vary across companies?
- What happened around January 24, 2023?
- Which companies experienced the largest positive and negative daily movements?

The project combines **Python for data preparation and exploratory analysis, SQL for structured analytical queries, and Tableau for interactive visualization.**

## **🎯 Objectives**

The main objectives of this project were to:

1. Clean and prepare historical stock market data for analysis.
2. Examine price and trading-volume trends across Adani Group companies.
3. Calculate daily returns and other performance metrics.
4. Measure and compare stock volatility.
5. Analyze cumulative performance across companies.
6. Compare trading activity and positive trading-day frequency.
7. Investigate stock behavior around January 24, 2023.
8. Build interactive Tableau dashboards to communicate the findings.
9. Develop an end-to-end data analytics workflow suitable for a portfolio project.

## **🗂️ Dataset**

The project uses a historical stock market dataset containing daily observations for Adani Group companies.

The dataset includes fields such as:

| **Column**   | **Description**                         |
| ------------ | --------------------------------------- |
| timestamp    | Original timestamp for the observation  |
| symbol       | Stock/company symbol                    |
| company      | Company name                            |
| open         | Opening price                           |
| high         | Highest price during the trading period |
| low          | Lowest price during the trading period  |
| close        | Closing price                           |
| volume       | Trading volume                          |
| dividends    | Dividend information                    |
| stock_splits | Stock split information                 |

After cleaning and preparation, additional analytical fields were created, including:

- Daily return
- Intraday return
- Daily price range percentage
- Volume change percentage
- 30-day rolling volatility
- Cumulative return
- Year
- Month

**Dataset Coverage**

The original dataset contains approximately **40,000+ observations** covering multiple Adani Group companies over a long historical period.

The analysis identified **11 unique company symbols** in the dataset.

One company, **Sanghi Industries**, contained only a single observation and was therefore not suitable for meaningful long-term performance comparisons.

## **🛠️ Technologies & Tools**

**  
Python**

Used for:

- Data cleaning
- Data validation
- Data transformation
- Feature engineering
- Exploratory data analysis
- Statistical calculations
- Data visualization

Main Python libraries:

- Pandas
- NumPy
- Matplotlib
- Seaborn

**  
SQL**

Used for:

- Dataset profiling
- Data-quality checks
- Company-level analysis
- Price analysis
- Trading-volume analysis
- Daily return analysis
- Volatility analysis
- Ranking companies
- Event-window analysis
- Window functions

**  
Tableau**

Used to create interactive dashboards for:

- Historical closing-price trends
- Daily stock returns
- Trading volume
- Cumulative performance
- Annualized volatility
- Positive trading-day percentage
- January 2023 event analysis

## **🔄 Project Workflow**

Raw Historical Stock Data
│
▼
Python / Pandas
│
├── Data Cleaning
├── Data Validation
├── Feature Engineering
└── Exploratory Analysis
│
▼
Cleaned Dataset
│
▼
SQL
│
├── Price Analysis
├── Return Analysis
├── Volatility
├── Trading Volume
├── Company Rankings
└── Event Analysis
│
▼
Tableau
│
├── Executive Overview
├── Company Performance
└── January 2023 Event Analysis
│
▼

Portfolio Insights

## **🧹 Data Cleaning & Preparation**

The raw dataset was inspected and prepared before analysis.

The cleaning process included:

- Inspecting dataset dimensions and data types
- Checking missing values
- Checking for duplicate observations
- Converting timestamps into readable dates
- Sorting observations by company and date
- Removing duplicate company-date observations
- Examining company coverage
- Identifying companies with insufficient historical observations
- Creating analytical features

**  
Missing Data**

The dataset contained a small number of missing closing-price observations.

These observations were considered when calculating return and performance metrics to avoid introducing misleading calculations.

## **📈 Feature Engineering**

Several analytical metrics were created using Python.

**  
Daily Return**

Daily return measures the percentage change in closing price from one trading day to the next.

df["daily_return"] = ( 
    df.groupby("symbol")["close"] 
    .pct_change(fill_method=None) 
)


**  
Intraday Return**

Measures the percentage change between the opening and closing price during the trading period.

df["intraday_return"] = ( 
    (df["close"] - df["open"]) / df["open"] 
)


**  
Daily Price Range**

Measures the size of the daily high-low range relative to the opening price.

df["daily_range_pct"] = ( 
    (df["high"] - df["low"]) / df["open"] 
)


**  
Volume Change**

Measures the percentage change in trading volume between consecutive observations.

df["volume_change_pct"] = ( 
    df.groupby("symbol")["volume"] 
    .pct_change(fill_method=None) 
)


**  
30-Day Annualized Rolling Volatility**

A 30-day rolling standard deviation of daily returns was calculated and annualized using the square root of 252 trading days.

df["rolling_volatility_30d"] = ( 
    df.groupby("symbol")["daily_return"] 
    .transform( 
        lambda x: x.rolling( 
            window=30, 
            min_periods=20 
        ).std() * np.sqrt(252) 
    ) 
)


**  
Cumulative Return**

Cumulative return was calculated to compare performance over time.

df["cumulative_return"] = ( 
    df.groupby("symbol")["close"] 
    .transform( 
        lambda x: 
        x / x.dropna().iloc[0] - 1 
    ) 
)


## **🧮 SQL Analysis**

SQL was used to perform structured analysis on the cleaned dataset.

The SQL analysis includes:

**Dataset Profiling**

- Number of observations
- Date coverage
- Company coverage
- Missing values
- Duplicate records

**  
Price Analysis**

- Average closing price
- Minimum and maximum prices
- Daily price ranges
- Yearly performance

**  
Return Analysis**

- Daily returns
- Positive and negative trading days
- Percentage of positive trading days
- Largest positive daily returns
- Largest negative daily returns

**  
Volatility Analysis**

Companies were compared using annualized volatility based on daily returns.

**  
Trading Activity**

The analysis examined:

- Average trading volume
- Highest-volume trading days
- Company-level trading activity
- Changes in trading activity

**  
Ranking Analysis**

SQL window functions were used to rank companies by:

- Volatility
- Average trading volume
- Percentage of positive trading days
- Largest daily movements

## **📅 January 24, 2023 Event Analysis**

A dedicated section of the analysis examines stock-market behavior around **January 24, 2023**.

The analysis uses an event window surrounding the date to compare stock behavior before and after the event.

Metrics examined include:

- Average daily return
- Return volatility
- Average trading volume
- Large daily price movements
- Company-level performance

The event analysis was visualized in Tableau using a dedicated dashboard and date marker to make the event easier to interpret alongside stock-price and return movements.

**Important:** The analysis identifies relationships and changes in market behavior around the selected date. It does not establish that the event itself caused a particular stock-market outcome.

## **📊 Tableau Dashboards**

The Tableau component converts the analysis into interactive visualizations.

**1\. Executive Overview**

The Executive Overview dashboard provides a high-level view of:

- Closing-price trends
- Daily stock returns
- Trading volume
- Company selection
- Date-based analysis



**2\. Company Performance**

The Company Performance dashboard compares companies using:

- Cumulative return
- Annualized volatility
- Positive trading-day percentage
- Average daily trading volume

This allows users to compare companies from multiple perspectives rather than relying on price performance alone.


**3\. January 2023 Event Analysis**

The January 2023 dashboard focuses on stock behavior surrounding January 24, 2023.

It combines:

- Closing-price movement
- Daily returns
- Trading volume
- Event-date visualization
- Company-level comparisons

The event-date marker allows the viewer to visually compare the period before and after January 24, 2023.


## **🔎 Key Analytical Questions**

The project was designed around several analytical questions:

**  
Performance**

- Which companies experienced the strongest long-term price growth?
- How did cumulative performance differ between companies?

**  
Risk & Volatility**

- Which companies experienced the greatest return volatility?
- Did periods of strong price movement coincide with higher volatility?

**  
Trading Activity**

- Which companies had the highest average trading volume?
- Were unusually large price movements associated with changes in trading activity?

**  
Consistency**

- Which companies recorded the highest percentage of positive trading days?

**  
January 2023**

- How did returns change around January 24, 2023?
- Did trading volume change around the event window?
- Which companies experienced the largest movements?

## **💡 Key Insights**

The analysis should be interpreted across multiple metrics rather than relying on a single measure of performance.

The project demonstrates that:

- Company performance varied considerably across the dataset.
- Volatility differed across Adani Group companies.
- Trading activity provided a different perspective from price performance.
- Positive trading-day frequency does not necessarily indicate the strongest overall return.
- Periods of large price movements can be investigated alongside changes in trading volume and volatility.
- The January 2023 event window provides a useful example of event-based financial analysis.

**Note:** Numerical findings and rankings should be interpreted directly from the SQL results and Tableau dashboards rather than generalized across all companies.

## **📁 Project Structure**

adani-stock-analysis/
│
├── data/
│ └── adani_cleaned.csv
│
├── notebooks/
│ └── 01_adani_stock_analysis.ipynb
│
├── src/
│ └── analysis.py
│
├── sql/
│ └── analysis_queries.sql
│
├── outputs/
│ ├── company_summary.csv
│ ├── data_quality.json
│ └── figures/
│
├── tableau/
│ └── Adani_Stock_Analysis.twbx
│
├── README.md
├── requirements.txt
└── .gitignore


## **▶️ How to Reproduce the Analysis**


**1\. Clone the repository**

git clone <https://github.com/raphielcodez/adani-stock-analysis.git>

cd adani-stock-analysis

**2\. Create a virtual environment**

**Windows**

python -m venv .venv

.venv\\Scripts\\activate

**  
macOS/Linux**

python3 -m venv .venv

source .venv/bin/activate

**3\. Install dependencies**

pip install -r requirements.txt

**4\. Run the Python analysis**

Open:

notebooks/01_adani_stock_analysis.ipynb

Run the notebook from beginning to end.

The notebook uses the cleaned project data and generates analytical outputs used throughout the project.

**5\. Run the SQL analysis**

Open:

sql/analysis_queries.sql

Load:

data/adani_cleaned.csv

into your preferred SQL database/environment and execute the queries.

SQL syntax may require minor adjustments depending on the database system being used.

**6\. Open the Tableau dashboard**

Open:

tableau/Adani_Stock_Analysis.twbx

using Tableau Desktop.

## **⚠️ Limitations**

This project has several limitations that should be considered when interpreting the results.

**Historical Data  
<br/>**The analysis is based on historical market data and does not predict future stock performance.

**Event Analysis  
<br/>**The January 24, 2023 analysis identifies changes in stock behavior around a selected date but does not establish causation.

Other market factors, company announcements, investor sentiment, macroeconomic conditions, and broader market movements may have influenced stock prices.

**Dataset Coverage  
<br/>**Companies do not necessarily have identical historical coverage. Comparisons should therefore consider differences in available trading history.

**Sanghi Industries  
<br/>**Sanghi Industries has insufficient observations in the dataset for meaningful long-term trend analysis and should not be interpreted alongside companies with substantial historical coverage.

**Financial Interpretation  
<br/>**This project is an educational data-analysis project and should not be considered financial advice or an investment recommendation.

## **🚀 Future Improvements**

Possible extensions to this project include:

- Add market benchmark comparisons such as NIFTY 50
- Calculate Sharpe ratios
- Analyze maximum drawdown
- Add sector/industry comparisons
- Perform correlation analysis against broader market indices
- Conduct more formal event-study analysis
- Add statistical significance testing
- Build automated data pipelines
- Connect Tableau to a live or regularly updated database
- Add machine-learning models for exploratory forecasting

## **📚 Skills Demonstrated**

This project demonstrates practical experience with:

**  
Data Analysis**

- Data cleaning
- Exploratory data analysis
- Statistical analysis
- Feature engineering
- Time-series analysis

**  
Python**

- Pandas
- NumPy
- Matplotlib
- Seaborn
- Data transformation
- Grouped analysis

**  
SQL**

- Aggregations
- CTEs
- Window functions
- Ranking
- Time-based analysis
- Data-quality analysis

**  
Data Visualization**

- Tableau
- Interactive dashboards
- Filters
- Calculated fields
- Time-series visualization
- Comparative analysis

**  
Analytics Thinking**

- Business-question formulation
- KPI development
- Event-based analysis
- Data interpretation
- Communicating analytical findings
- Identifying limitations

## **👤 Author**

**  
Raphiel Collins**

Data Analytics | Python | SQL | Tableau

This project was created as part of my data analytics portfolio to demonstrate an end-to-end workflow for transforming raw data into analytical insights and interactive visualizations.

## **⭐ Project Takeaway**

This project demonstrates the complete process of taking a raw financial dataset and turning it into a structured analytical product:

Question
↓
Raw Data
↓
Python Cleaning
↓
Feature Engineering
↓
SQL Analysis
↓
Tableau Visualization
↓
Insights
↓
Business Communication


The emphasis of the project is not simply on producing charts, but on demonstrating how **data preparation, analytical reasoning, SQL, Python, and visualization can work together to answer meaningful questions from real-world data.**