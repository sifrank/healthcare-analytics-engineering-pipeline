import os

from dotenv import load_dotenv
from sqlalchemy import create_engine, text
from sqlalchemy.engine import URL

load_dotenv()

connection_url = URL.create(
	drivername="postgresql+psycopg2",
	username=os.getenv("DB_USER"),
	password=os.getenv("DB_PASSWORD"),
	host=os.getenv("DB_HOST"),
	port=int(os.getenv("DB_PORT")),
	database=os.getenv("DB_NAME"),
)

engine = create_engine(connection_url)

try:
	with engine.connect() as connection:
		result = connection.execute(text("SELECT version();"))
		print("Successfully connected to PostgreSQL!")
		print(result.fetchone()[0])

except Exception as error:
	print("Database connection failed:")
	print(error)

finally:
	engine.dispose()
