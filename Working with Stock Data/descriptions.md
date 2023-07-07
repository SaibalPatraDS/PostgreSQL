# Table Description: meta

The `meta` table represents financial market data with daily information about stock prices. It has the following columns:

- `Date` (DATE): The date of the stock market data. It serves as the primary key of the table.
- `Open` (NUMERIC(10,6)): The opening price of the stock on the given date.
- `High` (NUMERIC(10,6)): The highest price reached by the stock during the day.
- `Low` (NUMERIC(10,6)): The lowest price reached by the stock during the day.
- `Close` (NUMERIC(10,6)): The closing price of the stock on the given date.
- `Adj_Close` (NUMERIC(10,6)): The adjusted closing price of the stock, taking into account any corporate actions such as dividends or stock splits.
- `Volume` (INTEGER): The number of shares or contracts traded on the given date.

The table is designed to store daily stock market data, allowing for analysis and insights into price movements, trading volumes, and more. The primary key constraint on the `Date` column ensures uniqueness and easy retrieval of data for specific dates.

**Note**: The data types chosen for the columns (`NUMERIC` and `INTEGER`) are suitable for representing decimal numbers with high precision and whole numbers, respectively. These data types provide flexibility for handling financial data accurately.

