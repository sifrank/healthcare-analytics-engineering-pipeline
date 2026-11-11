import random
from pathlib import Path
from datetime import date

import pandas as pd
from faker import Faker

# Reproducibility: generate the same data each time
random.seed(42)
Faker.seed(42)
fake = Faker()

# Project directories
PROJECT_DIR = Path(__file__).resolve().parent.parent
RAW_DIR = PROJECT_DIR / "data" / "raw"
RAW_DIR.mkdir(parents=True, exist_ok=True)

# Business dimensions
regions = ["Northeast", "Southeast", "Midwest", "Southwest", "West"]
segments = ["Hospital", "Outpatient Center", "Private Practice"]

products = [
	{"product_id": 101, "product_name": "Treatment System", "category": "Equipment", "unit_price": 45000},
	{"product_id": 102, "product_name": "Treatment Chair", "category": "Equipment", "unit_price": 12000},
	{"product_id": 103, "product_name": "Consumable Kit", "category": "Consumables", "unit_price": 850},
	{"product_id": 104, "product_name": "Replacement Component", "category": "Parts", "unit_price": 1250},
	{"product_id": 105, "product_name": "Service Package", "category": "Services", "unit_price": 5000},
]

# 1. CUSTOMERS
customers = []

for customer_id in range(1, 501):
	customers.append({
		"customer_id": customer_id,
		"customer_name": f"{fake.city()} Medical Center {customer_id}",
		"region": random.choice(regions),
		"account_segment": random.choice(segments),
		"onboarding_date": fake.date_between(
			start_date="-5y",
			end_date="-30d"
		)
	})

customers_df = pd.DataFrame(customers)

# 2. PRODUCTS
products_df = pd.DataFrame(products)

# 3. SALES REPRESENTATIVES
sales_reps = []

for rep_id in range(1, 31):
	sales_reps.append({
		"sales_rep_id": rep_id,
		"sales_rep_name": fake.name(),
		"region": random.choice(regions),
		"hire_date": fake.date_between(
			start_date="-8y",
			end_date="-90d"
		)
	})

sales_reps_df = pd.DataFrame(sales_reps)

# Match each customer to a representative
rep_by_region = {}

for region in regions:
	regional_reps = sales_reps_df[
		sales_reps_df["region"] == region
	]["sales_rep_id"].tolist()

	rep_by_region[region] = regional_reps or sales_reps_df[
		"sales_rep_id"
	].tolist()

# 4. REVENUE TRANSACTIONS
transactions = []

for transaction_id in range(1, 18001):
	customer = customers_df.sample(1).iloc[0]
	product = random.choice(products)
	sales_rep_id = random.choice(
		rep_by_region[customer["region"]]
	)

	transaction_date = fake.date_between(
    start_date=date(2024, 1, 1),
    end_date=date(2025, 12, 31)
)

	units = random.randint(1, 15)
	discount_pct = random.choice([0, 0.05, 0.10, 0.15])

	gross_revenue = units * product["unit_price"]
	net_revenue = round(
		gross_revenue * (1 - discount_pct), 2
	)

	transactions.append({
		"transaction_id": transaction_id,
		"customer_id": customer["customer_id"],
		"product_id": product["product_id"],
		"sales_rep_id": sales_rep_id,
		"transaction_date": transaction_date,
		"units_sold": units,
		"unit_price": product["unit_price"],
		"discount_pct": discount_pct,
		"revenue": net_revenue
	})

transactions_df = pd.DataFrame(transactions)

# 5. MONTHLY REVENUE TARGETS
targets = []

for month in pd.date_range(
	start="2024-01-01",
	end="2025-12-01",
	freq="MS"
):
	for region in regions:
		targets.append({
			"target_month": month.date(),
			"region": region,
			"revenue_target": random.randint(150000, 350000)
		})

targets_df = pd.DataFrame(targets)

# Export CSV files
datasets = {
	"customers.csv": customers_df,
	"products.csv": products_df,
	"sales_reps.csv": sales_reps_df,
	"transactions.csv": transactions_df,
	"revenue_targets.csv": targets_df
}

for filename, dataframe in datasets.items():
	dataframe.to_csv(RAW_DIR / filename, index=False)
	print(f"Created {filename}: {len(dataframe):,} rows")

print("\nAll synthetic datasets generated successfully!")
print(f"Output directory: {RAW_DIR}")
