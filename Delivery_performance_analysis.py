import pandas as pd
import matplotlib.pyplot as plt

# Load data
df = pd.read_csv(r"C:\Users\jayvi\Desktop\Project\Ecommerce_Delivery_Analytics_New (1).csv", encoding='latin1')

pd.set_option('display.max_columns', None)

# Fix column names
df.columns = df.columns.str.strip().str.replace(" ", "_").str.replace("&", "and")

# Remove duplicates
df = df.drop_duplicates()

# Rename columns
df.rename(columns={'Delivery_Time_(Minutes)': 'Delivery_Time','Order_Value_(INR)': 'Order_Value'}, inplace=True)

# Convert Order time properly
df['Order_Date_and_Time'] = pd.to_datetime(df['Order_Date_and_Time'],format='%H:%M:%S', errors='coerce')

# Convert numeric columns
df['Delivery_Time'] = pd.to_numeric(df['Delivery_Time'], errors='coerce')
df['Service_Rating'] = pd.to_numeric(df['Service_Rating'], errors='coerce')
df['Order_Value'] = pd.to_numeric(df['Order_Value'], errors='coerce')

# Handle missing values
df['Service_Rating'] = df['Service_Rating'].fillna(df['Service_Rating'].mean())

df = df.dropna(subset=['Order_Date_and_Time', 'Delivery_Time'])

# Delivery Status
df['Delivery_Status'] = df['Delivery_Delay'].map({'Yes': 'Late', 'No': 'On-Time'})

# Time features
df['Hour'] = df['Order_Date_and_Time'].dt.hour

#       KPI
print("------ KPI SUMMARY ------")
print("Total Orders:", len(df))
print("Avg Delivery Time:", round(df['Delivery_Time'].mean(), 2))
print("Avg Rating:", round(df['Service_Rating'].mean(), 2))
print("Late Delivery %:", round((df['Delivery_Status'] == 'Late').mean() * 100, 2))
print("Refund %:", round((df['Refund_Requested'] == 'Yes').mean() * 100, 2))

# Analysis platforms performance
print("\nPlatform Performance:")
print(df.groupby('Platform')['Delivery_Time'].mean().sort_values())

# Delivery Status vs Rating
print("\nRating by Delivery Status:")
print(df.groupby('Delivery_Status')['Service_Rating'].mean())

# Best and Worst Platform
platform_perf = df.groupby('Platform')['Delivery_Time'].mean()
print("\nBest Platform:", platform_perf.idxmin())
print("Worst Platform:", platform_perf.idxmax())

# Visualizations

# Platform vs Delivery Time
df.groupby('Platform')['Delivery_Time'].mean().plot(kind='bar')
plt.title("Platform vs Delivery Time")
plt.xlabel("Platform")
plt.ylabel("Avg Delivery Time")
plt.xticks(rotation=0)
plt.tight_layout()
plt.show()


# Order Value vs Delivery Time
plt.scatter(df['Order_Value'], df['Delivery_Time'], alpha=0.5)
plt.title("Order Value vs Delivery Time")
plt.xlabel("Order Value")
plt.ylabel("Delivery Time")
plt.show()

# Delivery Status Pie
df['Delivery_Status'].value_counts().plot(kind='pie', autopct='%1.1f%%')
plt.title("Delivery Status")
plt.show()

print(df[['Delivery_Time','Order_Value','Service_Rating']].corr())


# Save Clean Data
df.to_csv("cleaned_data_delivery.csv", index=False)

# connect Sql with python
from sqlalchemy import create_engine

engine = create_engine("mysql+mysqlconnector://root:root@localhost/delivery_analysis")

df.to_sql("delivery", engine, if_exists="replace", index=False)


