import pandas as pd

# Load the dataset from the GitHub repository
url = 'https://raw.githubusercontent.com/Krista07/datasets/main/Cats.csv'
cats_df = pd.read_csv(url)

# Display the first few rows of the DataFrame
print(cats_df.head())

# Check for missing values
print(cats_df.isnull().sum())

# Drop rows with missing values
cats_df.dropna(inplace=True)

# Reset index after dropping rows
cats_df.reset_index(drop=True, inplace=True)


import seaborn as sns
import matplotlib.pyplot as plt

sns.set_style("whitegrid")

plt.figure(figsize=(12, 8))
origin_counts = cats_df['Location of origin'].value_counts()
sns.barplot(y=origin_counts.index, x=origin_counts.values, palette='viridis')
plt.title('Distribution of Cat Breeds by Origin')
plt.xlabel('Number of Breeds')
plt.ylabel('Country of Origin')
plt.show()

plt.figure(figsize=(10, 6))
body_type_counts = cats_df['Body type'].value_counts()
sns.barplot(x=body_type_counts.index, y=body_type_counts.values, palette='muted')
plt.title('Distribution of Cat Body Types')
plt.xlabel('Body Type')
plt.ylabel('Number of Breeds')
plt.xticks(rotation=45)
plt.show()

plt.figure(figsize=(10, 6))
coat_type_counts = cats_df['Coat type and length'].value_counts()
sns.barplot(x=coat_type_counts.index, y=coat_type_counts.values, palette='pastel')
plt.title('Distribution of Cat Coat Types and Lengths')
plt.xlabel('Coat Type and Length')
plt.ylabel('Number of Breeds')
plt.xticks(rotation=45)
plt.show()

plt.figure(figsize=(12, 6))
coat_pattern_counts = cats_df['Coat pattern'].value_counts()
sns.barplot(x=coat_pattern_counts.index, y=coat_pattern_counts.values, palette='deep')
plt.title('Distribution of Cat Coat Patterns')
plt.xlabel('Coat Pattern')
plt.ylabel('Number of Breeds')
plt.xticks(rotation=90)
plt.show()
