import os
from pathlib import Path

import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import create_engine, text
from sqlalchemy.engine import URL

# Load environment variables
load_dotenv()

# Project directories
PROJECT_DIR = Path(__file__).resolve().parent.parent
RAW_DIR = PROJECT_DIR / "data" / "raw"

# Connect to PostgreSQL
connection_url = URL.create(
	drivername="postgresql+psycopg2",
	username=os.getenv("DB_USER"),
	password=os.getenv("DB_PASSWORD"),
	host=os.getenv("DB_HOST"),
	port=int(os.getenv("DB_PORT")),
	database=os.getenv("DB_NAME"),
)

engine = create_engine(connection_url)

# Create raw schema
with engine.begin() as connection:
	connection.execute(text("CREATE SCHEMA IF NOT EXISTS raw;"))

# Load CSV files into PostgreSQL
datasets = {
	"customers": "customers.csv",
	"products": "products.csv",
	"sales_reps": "sales_reps.csv",
	"transactions": "transactions.csv",
	"revenue_targets": "revenue_targets.csv",
}

for table_name, filename in datasets.items():
	file_path = RAW_DIR / filename
	dataframe = pd.read_csv(file_path)

	dataframe.to_sql(
		name=table_name,
		con=engine,
		schema="raw",
		if_exists="replace",
		index=False,
	)

	print(f"Loaded raw.{table_name}: {len(dataframe):,} rows")

engine.dispose()

print("\nAll datasets successfully loaded into PostgreSQL!")
