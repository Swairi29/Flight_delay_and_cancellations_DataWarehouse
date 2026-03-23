import pandas as pd

df = pd.read_csv("flights_sample_3m.csv")
df.sample(10000).to_csv("flights_sample_10k.csv", index=False)