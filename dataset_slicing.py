import pandas as pd
import json
import numpy as np

# 1. Load the massive dataset
print("Loading data...")
df = pd.read_csv('flights_sample_3m.csv')

# 2. Define our Business Scope (Slicing)
target_airlines = ['Delta Air Lines Inc.', 'American Airlines Inc.', 'United Air Lines Inc.']
target_airports = ['JFK', 'LAX', 'ORD', 'DFW', 'ATL']

print("Slicing data...")
scoped_df = df[
    (df['AIRLINE'].isin(target_airlines)) & 
    (df['ORIGIN'].isin(target_airports)) & 
    (df['DEST'].isin(target_airports))
].copy()

# 3. Create Source 1: Airline Details (Excel)
print("Exporting Airlines to Excel...")
airlines_df = scoped_df[['AIRLINE_CODE', 'AIRLINE', 'AIRLINE_DOT', 'DOT_CODE']].drop_duplicates()
airlines_df.to_excel('Airlines_Source.xlsx', index=False)

# 4. Create Source 2: Airport Details (CSV for SQL Insert)
print("Exporting Airports to CSV...")
origins = scoped_df[['ORIGIN', 'ORIGIN_CITY']].rename(columns={'ORIGIN': 'AIRPORT_CODE', 'ORIGIN_CITY': 'CITY'})
dests = scoped_df[['DEST', 'DEST_CITY']].rename(columns={'DEST': 'AIRPORT_CODE', 'DEST_CITY': 'CITY'})
airports_df = pd.concat([origins, dests]).drop_duplicates()
airports_df.to_csv('Airports_Source.csv', index=False)

# 5. Create Source 3: Cancellation Codes (Text)
print("Exporting Cancel Codes to TXT...")
cancel_codes = pd.DataFrame({
    'CANCELLATION_CODE': ['A', 'B', 'C', 'D'],
    'CANCEL_DESCRIPTION': ['Carrier', 'Weather', 'National Air System', 'Security']
})
cancel_codes.to_csv('CancelCodes_Source.txt', sep='\t', index=False)

# 6. Create Source 4: Flight Status Reference (JSON)
print("Exporting Flight Status to JSON...")
# Creating a reference table for our Junk Dimension
status_data = [
    {"STATUS_CODE": "S1", "IS_CANCELLED": 0, "IS_DIVERTED": 0, "DELAY_CATEGORY": "On-Time"},
    {"STATUS_CODE": "S2", "IS_CANCELLED": 0, "IS_DIVERTED": 0, "DELAY_CATEGORY": "Minor Delay"},
    {"STATUS_CODE": "S3", "IS_CANCELLED": 0, "IS_DIVERTED": 0, "DELAY_CATEGORY": "Severe Delay"},
    {"STATUS_CODE": "S4", "IS_CANCELLED": 1, "IS_DIVERTED": 0, "DELAY_CATEGORY": "Cancelled"},
    {"STATUS_CODE": "S5", "IS_CANCELLED": 0, "IS_DIVERTED": 1, "DELAY_CATEGORY": "Diverted"}
]
with open('FlightStatus_Source.json', 'w') as f:
    json.dump(status_data, f, indent=4)

# 7. Create Source 5: Flight Transactions (CSV)
print("Exporting Flight Transactions to CSV...")
# Deriving the STATUS_CODE before exporting so it links to the JSON file
conditions = [
    (scoped_df['CANCELLED'] == 1),
    (scoped_df['DIVERTED'] == 1),
    (scoped_df['ARR_DELAY'] > 60),
    (scoped_df['ARR_DELAY'] > 15) & (scoped_df['ARR_DELAY'] <= 60)
]
choices = ['S4', 'S5', 'S3', 'S2']
scoped_df['STATUS_CODE'] = np.select(conditions, choices, default='S1')

# Drop redundant columns
flights_df = scoped_df.drop(columns=['AIRLINE', 'AIRLINE_DOT', 'DOT_CODE', 'ORIGIN_CITY', 'DEST_CITY'])
flights_df.to_csv('FlightData_Source.csv', index=False)



print("Exporting Routes to CSV...")
routes_df = scoped_df[['ORIGIN', 'DEST']].drop_duplicates()
routes_df['ROUTE_CODE'] = routes_df['ORIGIN'] + '-' + routes_df['DEST']
routes_df.to_csv('Routes_Source.csv', index=False)

print("Data prep complete!.")