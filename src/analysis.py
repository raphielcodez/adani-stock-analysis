import pandas as pd
import numpy as np

def load_data(file_path):
    """Load the cleaned stock dataset."""
    return pd.read_csv(
        file_path,
        parse_dates=["date"]
    )

def calculate_returns(df):
    """Calculate daily stock returns."""

    df = df.copy()

    df["daily_return"] = (
        df.groupby("symbol")["close"]
            .pct_change(fill_method=None)
    )

    return df

def calculate_volatility(df):
    """Calculate annualized historical volatility."""

    return (
        df.groupby("symbol")["daily_return"]
            .std() *
            np.sqrt(252)
    )
