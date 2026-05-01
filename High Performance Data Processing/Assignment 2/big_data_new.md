# 📘 Assignment 2: Mastering Big Data Handling  

---

## 👥 Group Information  

**Group CC**  
- Chua Jia Lin (A23CS0069)  
- Joanne Ching Yin Xuan (A23CS0227)  

---

## 1. Dataset Description  

The dataset used in this assignment is the **Transactions Dataset** obtained from Kaggle.

- **Source**: https://www.kaggle.com/datasets/ismetsemedov/transactions/data  
- **File Size**: 2.73 GB  
- **Domain**: Finance 
- **Number of Records**: 7,483,766 rows  
- **Number of Columns**: 24
- **Dataset Columns Description**:
  | Column | Data Type | Description
  |--------|--------|--------|
  | transaction_id | object  | Unique identifier for each transaction |
  | customer_id | object  | Unique identifier for each customer in the dataset |
  | card_number  | int64  | Masked card number associated with the transaction |
  | timestamp | object  | Date and time of the transaction |
  | merchant_category  | object  | General category of the merchant (e.g., Retail, Grocery, Travel) |
  | merchant_type  | object  | Specific type within the merchant category (e.g., "online" for Retail) |
  | merchant | object  | Name of the merchant where the transaction took place |
  | amount  | float64 | Transaction amount (currency based on the country)|
  | currency  | object  | Currency used for the transaction (e.g., USD, EUR, JPY) |
  | country  | object  | Country where the transaction occurred |
  | city  | object  | City where the transaction took place |
  | city_size  | object  | Size of the city (e.g., medium, large) |
  | card_type  | object  | Type of card used (e.g., Basic Credit, Gold Credit) |
  | card_present  | bool  | Indicates if the card was physically present during the transaction (used in POS transactions) |
  | device  | object  | Device used for the transaction (e.g., Chrome, iOS App, NFC Payment) |
  | channel  | object  | Type of channel used for the transaction (web, mobile, POS) |
  | device_fingerprint  | object  | Unique fingerprint for the device used in the transaction |
  | ip_address | object  | IP address associated with the transaction |
  | distance_from_home  | int64  | Binary indicator showing if the transaction occurred outside the customer's home country |
  | high_risk_merchant  | bool  | Indicates if the merchant category is known for higher fraud risk (e.g., Travel, Entertainment) |
  | transaction_hour  | int64  | Hour of the day when the transaction was made |
  | weekend_transaction  | bool  | Boolean indicating if the transaction took place on a weekend |
  | velocity_last_hour | object  | Dictionary containing metrics on the transaction velocity, including: num_transactions (Number of transactions in the last hour for this customer), total_amount (Total amount spent in the last hour), unique_merchants (Count of unique merchants in the last hour), unique_countries (Count of unique countries in the last hour), and max_single_amount (Maximum single transaction amount in the last hour) |
  | is_fraud | bool  | Binary indicator showing if the transaction is fraudulent (True for fraudulent transactions, False for legitimate ones) |

This dataset contains detailed transaction-level information such as customer data, merchant details, transaction amounts, and fraud indicators. The large size of the dataset makes it suitable for evaluating big data handling strategies and performance optimization techniques. 
This dataset was selected because it provides: 
- A sufficiently large volume of data to simulate real-world big data challenges   
- Diverse data types suitable for optimization techniques   
- A practical use case in financial analytics and fraud detection   
 
Therefore, it is well-suited for comparing the performance of Pandas, Dask, and Polars under large-scale data processing conditions. 

---

## 2. Library Choices  

Three libraries were used in this assignment to compare traditional and scalable approaches to big data handling :


| Library | Purpose |
|--------|--------|
| **Pandas** | Baseline (single-threaded). It is widely adopted and easy to use, but operates in a single-threaded environment, limiting its performance on large datasets.  |
| **Dask** | Scalable parallel processing  that processes data in partitions. It is designed to handle datasets that exceed memory capacity and support distributed computing. |
| **Polars** | High-performance multi-threading. It offers fast execution using a Rust-based engine |


---

## 3. Data Loading and Inspection  

### 3.1 Loading Dataset  
To load the dataset into Google Collab, a few steps were taken:
- Uploaded the kaggle.json API key
- Moved the uploaded file to the newly created .kaggle directory and set proper permissions
- Fetched the dataset directly into the Google Colab environment using Kaggle CLI
- Extracted the dataset from its ZIP file

```python
from google.colab import files
files.upload()

!mkdir -p ~/.kaggle
!cp kaggle.json ~/.kaggle/
!chmod 600 ~/.kaggle/kaggle.json

!kaggle datasets download -d ismetsemedov/transactions
!unzip transactions.zip
```


### 3.2 Load Sample (1 Million Rows)
The dataset was fully loaded into memory using Pandas for inspection.

```python
import pandas as pd
df = pd.read_csv("synthetic_fraud_data.csv")
```


### 3.3 Inspect Dataset
Initial data exploration was performed to examine the dataset structure, including previewing sample records, checking dimensions, identifying data types, and verifying the absence of missing values.

```python
print("First 5 rows of the dataset:")
display(df.head())

print("\nDataset shape:", df.shape)

print("\nColumn Names and Data Types:\n", df.dtypes)

print("\nNumber of NULL records in each column:\n", df.isnull().sum())

```
Output:
- First 5 rows of dataset is displayed
- Dataset shape: (7483766, 24)
- Data types include: object, float64, int64, bool
- No missing values detected

### Discussion
The dataset consists of structured transaction data with no missing values. It includes multiple data types, making it suitable for applying different optimisation strategies.

## 4. Big Data Handling Strategies

In this notebook, five effective strategies are applied to handle large datasets.  
Part 1 focuses on implementing optimisation techniques using **Pandas** and scalable libraries such as **Polars** and **Dask**, while Part 2 compares the performance of three libraries: **Pandas, Dask, and Polars**.

---

### 🔹 Part 1: Big Data Handling Strategies
- Load Less Data  
- Use Chunking  
- Optimise Data Types  
- Sampling  
- Parallel Processing with Scalable Libraries (Polars and Dask)  


### 4.1 Load Less Data
This strategy reduces memory usage and improves performance by loading only the required columns and limiting the number of rows instead of reading the entire dataset.

```python
# Select only the necessary columns to reduce memory usage
selected_cols = ['transaction_id', 'customer_id', 'merchant', 'amount', 'currency', 'high_risk_merchant', 'is_fraud']

# Measure execution time
start_time = time.time()

# Load only the selected columns
df_selected = pd.read_csv('synthetic_fraud_data.csv', usecols=selected_cols)

# Execution time
exec_time = time.time() - start_time

# Display basic info
print("Dataset shape:", df_selected.shape)
print("First 5 records:\n", df_selected.head())

# Memory used
mem_used = df_selected.memory_usage(deep=True).sum() / (1024**2)  # in MiB
print("\nMemory usage:", round(mem_used, 2), "MiB")
print("Execution time:", round(exec_time, 2),  "seconds")
```

### Output
```python
Dataset shape: (7483766, 7)
Memory usage: 1708.32 MiB
Execution time: 35.95 seconds
```
### Discussion
Loading only necessary columns reduces memory usage and improves performance.

### 4.2 Chunking
This strategy processes the dataset in smaller chunks instead of loading it all at once, helping to manage memory usage when working with large datasets.

```python
chunksize = 200000
chunk_iter = pd.read_csv("synthetic_fraud_data.csv", chunksize=chunksize)

total_rows = 0
max_mem = 0
total_mem = 0   # sum of memory usage
num_chunks = 0  # count chunks

# Measure execution time
start_time = time.time()

for i, chunk in enumerate(chunk_iter):
    total_rows += len(chunk)

    mem_used = chunk.memory_usage(deep=True).sum() / (1024 ** 2)

    max_mem = max(max_mem, mem_used)
    total_mem += mem_used
    num_chunks += 1

print("Finished processing all chunks!")

# Execution time
exec_time = time.time() - start_time

# Calculate average memory
avg_mem = total_mem / num_chunks

print("Total rows processed:", total_rows)
print("Max memory usage:", round(max_mem, 2), "MiB")
print("Average memory usage:", round(avg_mem, 2), "MiB")
print("Total (sum) memory usage:", round(total_mem, 2), "MiB")
print("Execution time:", round(exec_time, 2), "seconds")

```

### Output
```python
Finished processing all chunks!
Total rows processed: 7483766
Max memory usage: 217.97 MiB
Average memory usage: 214.44 MiB
Total (sum) memory usage: 8148.61 MiB
Execution time: 104.22 seconds
```

### Explanation
Chunking helps process large datasets without exceeding memory limits but adds processing overhead.
________________________________________

### 4.3 Data Type Optimisation
This strategy reduces memory usage by converting columns to more efficient data types, such as smaller numeric types or categorical variables.

```python
# Start timing
start_time = time.time()

# Load the dataset
df = pd.read_csv("synthetic_fraud_data.csv")

# Optimize data types during loading
df["transaction_id"] = df["transaction_id"].astype("category")
df["customer_id"] = df["customer_id"].astype("category")
df["card_number"] = df["card_number"].astype("string")
df["merchant_category"] = df["merchant_category"].astype("category")
df["merchant_type"] = df["merchant_type"].astype("category")
df["merchant"] = df["merchant"].astype("category")
df["amount"] = df["amount"].astype("float32")
df["currency"] = df["currency"].astype("category")
df["country"] = df["country"].astype("category")
df["city"] = df["city"].astype("category")
df["city_size"] = df["city_size"].astype("category")
df["card_type"] = df["card_type"].astype("category")
df["device"] = df["device"].astype("category")
df["channel"] = df["channel"].astype("category")
df["distance_from_home"] = df["distance_from_home"].astype("int16")
df["transaction_hour"] = df["transaction_hour"].astype("int8")

# Execution time
exec_time = time.time() - start_time

# Measure memory usage
mem_used = df.memory_usage(deep=True).sum() / (1024**2)

# Output
print("\nMemory usage:", round(mem_used, 2), "MiB")
print("Execution time:", round(exec_time, 2),  "seconds")
print("\nColumn Names and Data Types:\n", df.dtypes)
print("\nFirst 5 rows:\n", df.head(5))
```
### Output
```python
Memory usage: 4353.15 MiB
Execution time: 151.82 seconds
```

### Discussion
Data type optimisation can reduce memory usage in theory, but in this case it resulted in higher memory consumption and slower execution due to conversion overhead and intermediate processing.

________________________________________
### 4.4 Sampling
Sampling is used to reduce the size of a dataset by selecting a representative subset. This allows faster processing and analysis while maintaining the overall structure and characteristics of the data. It is commonly used during development and testing to avoid long execution times on large datasets.

```python
import pandas as pd
import time

start_time = time.time()

# Load dataset
df_full = pd.read_csv("synthetic_fraud_data.csv")

# Apply sampling (10%)
df_sample = df_full.sample(frac=0.1, random_state=42)

sampling_time = time.time() - start_time

# Memory usage
mem_sampling = df_sample.memory_usage(deep=True).sum() / (1024**2)

print("Original rows:", df_full.shape[0])
print("Sampled rows:", df_sample.shape[0])
print("Memory usage (sample):", round(mem_sampling, 2), "MiB")
print("Execution time:", round(sampling_time, 2), "seconds")

df_sample.head()
```

### Output
```python
Original rows: 7483766
Sampled rows: 748377
Memory usage (sample): 820.57 MiB
Execution time:  84.64 seconds
```

### Discussion
Sampling significantly reduces the dataset size, resulting in faster execution time and lower memory usage compared to processing the full dataset. This makes it highly useful during the development and testing phase, where quick iterations are required.

However, sampling may not capture all patterns present in the full dataset, especially for rare events such as fraud cases. Therefore, while it improves efficiency, it should be used carefully and complemented with full dataset analysis for final results.
________________________________________

### 4.5 Parallel Processing with Scalable Libraries
Parallel processing improves performance by executing multiple operations simultaneously using multiple CPU cores instead of sequential processing. This is especially important for large datasets where single-threaded processing becomes slow and inefficient.

**Library Used:**
- Polars
- Dask
________________________________________

**Library Used: Polars**  
Polars is used as it supports multi-threaded execution by default. Unlike Pandas, which is single-threaded, Polars distributes operations across multiple CPU cores, resulting in faster and more efficient data processing.

```python
import polars as pl
import time

print("\n--- Parallel Processing using Polars ---")

# Start timing
start_time = time.time()

# Load dataset (multi-threaded internally)
df = pl.read_csv("synthetic_fraud_data.csv")

# Parallel operations
result = (
    df
    .filter(pl.col("amount") > 100)
    .group_by("merchant_category")
    .agg([
        pl.col("amount").mean().alias("avg_amount"),
        pl.col("amount").count().alias("transaction_count")
    ])
)

# End timing
end_time = time.time()

# Memory usage (MiB)
mem_used = df.estimated_size() / (1024 ** 2)

# Output
print(result.head())
print("\nExecution Time:", round(end_time - start_time, 2), "seconds")
print("Memory Usage:", round(mem_used, 2), "MiB")
```

### Output
```python
--- Parallel Processing using Polars ---
shape: (5, 3)
┌───────────────────┬───────────────┬───────────────────┐
│ merchant_category ┆ avg_amount    ┆ transaction_count │
│ ---               ┆ ---           ┆ ---               │
│ str               ┆ f64           ┆ u32               │
╞═══════════════════╪═══════════════╪═══════════════════╡
│ Travel            ┆ 103689.051458 ┆ 877865            │
│ Gas               ┆ 47508.213689  ┆ 892307            │
│ Education         ┆ 47224.419946  ┆ 890712            │
│ Grocery           ┆ 37274.256656  ┆ 888026            │
│ Healthcare        ┆ 47036.427565  ┆ 893878            │
└───────────────────┴───────────────┴───────────────────┘

Execution Time: 14.06 seconds
Memory Usage: 2528.16 MiB
```
_________________________________

**Library Used: Dask** 
Dask is used as a parallel computing library that enables scalable data processing through lazy evaluation and task-based execution. Unlike Pandas, which loads and processes data in memory sequentially, Dask splits operations into parallel tasks and computes them efficiently when .compute() is called.

```python
import dask.dataframe as dd
import time

# Start timing
start_time = time.time()

# Load data using Dask
df = dd.read_csv("synthetic_fraud_data.csv")

# Trigger computation
df = df.compute()

# End timing
end_time = time.time()

# Memory usage in MiB
mem_used = df.memory_usage(deep=True).sum() / (1024**2)

print(df.head())
print("Execution time:", round(end_time - start_time, 2), "seconds")
print("Memory usage:", round(mem_used, 2), "MiB")
```

### Output
```python
Execution time: 91.01 seconds
Memory usage: 3523.78 MiB
```

### Discussion
In this study, two scalable libraries (Polars and Dask) were evaluated to understand their performance differences in terms of execution time and memory usage.

Polars demonstrated strong performance in single-machine parallel processing. Using a multi-threaded Rust-based engine, it efficiently executed filtering and aggregation operations across the dataset. It achieved an execution time of 14.06 seconds, showing fast computation for transformation tasks. However, memory usage was relatively higher at 2528.16 MiB, as Polars prioritises in-memory columnar processing for speed and efficiency. Overall, Polars provides excellent performance for high-speed data processing on a single machine.

On the other hand, Dask follows a lazy, task-based execution model where operations are first converted into a computation graph and only executed when .compute() is called. While this design supports scalability, it introduces overhead from task scheduling and coordination. In this implementation, Dask recorded a significantly higher execution time of 91.01 seconds and memory usage of 3523.78 MiB, indicating that the overhead outweighs its benefits for this dataset size and workload.

Overall, the results show that Polars is more efficient for single-machine parallel processing, offering faster execution with reasonable memory usage. Meanwhile, Dask is better suited for large-scale or distributed environments, where its scalability advantages become more meaningful. This comparison highlights that the effectiveness of a parallel processing tool depends not only on its architecture but also on the dataset size and execution context.
________________________________________
### 🔹 Part 2: Loading Dataset with Different Libraries
This approach loads the entire dataset into memory using Pandas without applying any optimisation techniques. It represents the traditional method of handling data and serves as a baseline for comparison with other big data handling strategies.

- Pandas  
- Dask  
- Polars

### 1. 📦 Full Load Using Pandas (Traditional Approach)

```python
import pandas as pd
import time

start = time.time()

# Load complete dataset
df_pandas = pd.read_csv("synthetic_fraud_data.csv")

end = time.time()

# Calculate memory usage
mem_pandas = df_pandas.memory_usage(deep=True).sum() / (1024**2)

# Output
print(df_pandas.head(5))
print("Shape:", df_pandas.shape)
print(f"Execution Time: {end - start:.2f} seconds")
print(f"Memory usage: {mem_pandas:.2f} MiB")

```

### Output
```python
Shape: (7483766, 24)
Execution Time: 83.33 seconds
Memory usage: 8148.61 MiB
```

### Discussion
The full load approach using Pandas results in high memory consumption (~8148 MiB) and long execution time (~83 seconds). This is because the entire dataset is loaded into memory at once and processed using a single-threaded approach.

While this method is simple and easy to implement, it is not suitable for large datasets as it can quickly exhaust available memory and significantly slow down processing. This highlights the limitations of traditional data processing methods and the need for optimisation strategies such as chunking, sampling, and parallel processing.
________________________________________
### 2. 📦 Full Load Using Dask
This approach uses Dask to load and process the full dataset. Dask supports lazy evaluation, meaning data is not immediately loaded into memory. Instead, operations are deferred until explicitly executed. In this case, the `.compute()` function is used to force the dataset to be fully loaded into memory for comparison purposes.
```python
import dask.dataframe as dd
import time

start = time.time()

# Load dataset lazily
ddf = dd.read_csv("synthetic_fraud_data.csv")

# Force full load into memory
df_dask = ddf.compute()

end = time.time()

# Calculate memory usage
mem_dask = df_dask.memory_usage(deep=True).sum() / (1024**2)

# Output
print(df_dask.head(5))
print("Shape:", df_dask.shape)
print(f"Execution Time: {end - start:.2f} seconds")
print(f"Memory usage: {mem_dask:.2f} MiB")
```
### Output
```python
Shape: (7483766, 24)
Execution Time: 107.73 seconds
Memory usage: 3523.78 MiB
```

### Discussion
The Dask implementation shows lower memory usage (~3524 MiB) compared to Pandas, as it processes data in partitions rather than loading everything at once initially. However, the execution time (~108 seconds) is slower due to overhead from task scheduling and coordination.

When .compute() is called, the full dataset is still brought into memory, which reduces some of the advantages of Dask's lazy evaluation in this scenario. This explains why performance is slower compared to Pandas despite improved memory efficiency.

Overall, Dask is more suitable for handling larger-than-memory datasets and distributed computing environments. However, in a single-machine setup with limited resources, its overhead can result in slower performance.
________________________________________
### 3. 📦 Full Load Using Polars
This approach uses Polars to load the full dataset into memory. Polars is designed for high-performance data processing and uses a Rust-based engine with built-in multi-threading. This allows it to process data faster and more efficiently compared to traditional single-threaded libraries.

```python
# Measure execution time
start_time = time.time()

# Load complete dataset
df_polars = pl.read_csv("synthetic_fraud_data.csv")

# Execution time
exec_time = time.time() - start_time

# Measure memory usage
mem_used = df_polars.estimated_size() / (1024**2)

# Show basic info
print("First 5 rows:", df_polars.head(5))
print("Shape:", df_polars.shape)
print("Execution Time:", round(exec_time, 2), "seconds")
print("Memory usage:", round(mem_used, 2), "MiB")
```

### Output 
```python
Shape: (7483766, 24)
Execution Time: 11.44 seconds
Memory usage: 2528.16 MiB
```

### Discussion
Polars demonstrates significantly faster performance (~12 seconds) compared to Pandas and Dask due to its multi-threaded execution and efficient Rust-based engine. It is able to process large datasets quickly by utilising multiple CPU cores.

The memory usage (~2528 MiB) is also lower than Pandas, indicating more efficient memory management. Compared to Dask, Polars achieves better speed while still maintaining relatively low memory usage.

Overall, Polars is highly suitable for high-performance data processing on a single machine. However, like Pandas, it operates within a single-node environment, and for extremely large datasets, distributed frameworks such as Dask or Apache Spark may be more appropriate.
________________________________________

### **📊 Overall Comparison**

The full dataset results show clear performance differences among the three libraries.

- 🐼 **Pandas** → Highest memory usage and slower execution due to single-threaded processing  
- ⚙️ **Dask** → Lower memory usage but slower execution due to scheduling overhead  
- ⚡ **Polars** → Fastest execution and lowest memory usage with multi-threaded processing  

**💡 Insight:**  
Polars is the most efficient for single-machine processing, while Dask is better suited for scalable, distributed environments.
________________________________________
## 5. Comparative Analysis
### 🔍 **Part 1: Comparison between Big Data Handling Strategies**
- Load Less Data
- Use Chunking
- Optimize Data Types
- Sampling
- Parallel Processing using Polars
- - Parallel Processing using Dask

Two bar charts are generated:
-One compares the execution time (in seconds).
-The other compares the memory usage (in MB).

This analysis helps to identify which strategy offers the best trade-off between speed and memory efficiency when using traditional vs. parallelized approaches.

#### ⚡ Big Data Handling Strategies Performance Comparison

| Strategy | Execution Time (s) | Memory Usage (MiB) |
|--------|------------------|-------------------|
| Load Less Data | 35.95 | 1708.32 |
| Use Chunking   | 104.22 | 214.44  |
| Optimize Data Types | 151.82 | 4353.15 |
| Sampling   | 84.64 | 820.57  |
| Parallel Processing with Polars | 14.06 | 2528.16  |
| Parallel Processing with Dask | 91.01 | 3523.78  |

#### 📈 Visualisation
<img width="989" height="501" alt="strategy_time" src="https://github.com/user-attachments/assets/0ea8af0e-c7f5-44e8-ab69-477ce3177e46" />
<img width="989" height="501" alt="strategy_memory" src="https://github.com/user-attachments/assets/b52df366-396f-4da4-b466-1d8ad43c926e" />

#### 📊 Performance Analysis
* **Execution Time**
  - Parallel Processing with Polars (14.06s) is the fastest overall strategy among the advanced methods due to its highly optimized multi-threaded engine.
  - Load Less Data (35.95s) performs relatively well because reducing input columns decreases processing workload significantly.
  - Sampling (84.64s) is slower than expected due to the overhead of loading the full dataset before sampling is applied.
  - Parallel Processing with Dask (91.01s) shows higher execution time due to scheduling and computation overhead in .compute().
  - Use Chunking (104.22s) is slower because data is processed iteratively in multiple passes, increasing I/O overhead.
  - Optimize Data Types (151.82s) is the slowest strategy due to the additional cost of repeated type conversions across many columns.

* **Memory Usage**
  - Load Less Data (1708.32 MiB) is the most memory-efficient Pandas-based strategy since fewer columns are loaded.
  - Sampling (820.57 MiB) reduces memory usage significantly by working on a subset of the dataset.
  - Use Chunking (214.44 MiB) shows low peak memory usage because only portions of the dataset are processed at a time.
  - Parallel Processing with Polars (2528.16 MiB) uses higher memory due to in-memory columnar storage and multi-threaded execution.
  - Parallel Processing with Dask (3523.78 MiB) consumes more memory because of task scheduling overhead and full dataset computation.
  - Optimize Data Types (4353.15 MiB) results in the highest memory usage due to multiple intermediate conversions and full dataset loading.

* **Processing Efficiency**
  - Load Less Data is simple and efficient but risks losing important information by reducing dataset size.
  - Sampling is fast and useful for exploratory analysis but may not represent the full dataset accurately.
  - Chunking is suitable for large datasets but introduces significant processing overhead due to repeated iterations.
  - Optimize Data Types improves storage format but is costly in runtime due to repeated conversions.
  - Polars (Parallel Processing) is highly efficient and easy to implement, offering strong performance but with moderate memory usage.
  - Dask (Parallel Processing) is scalable and flexible but introduces overhead from lazy evaluation and task scheduling.

Overall, Polars demonstrates the best balance between speed and scalability, while Dask provides stronger long-term scalability at the cost of higher overhead. Traditional Pandas-based strategies remain useful for targeted optimisations, but are less efficient when handling full-scale datasets.
________________________________________

### 🔍 **Part 2: Compare between 3 library**
In this section, the performance of three data processing libraries is evaluated:
- Pandas
- Polars
- Dask
This analysis provides insight into the trade-offs between performance, memory efficiency, and scalability across different libraries. The results are presented using tables and visualisations to clearly highlight performance differences.

#### ⚡ Library Performance Comparison

| Library | Execution Time (s) | Memory Usage (MiB) |
|--------|------------------|-------------------|
| Pandas | 1.96 | 217.97 |
| Dask   | 2.77 | 92.85  |
| Polars | 0.39 | 64.62  |

#### ⚙️ Processing Efficiency

The three libraries show clear differences in ease of implementation, performance behaviour, and scalability.

- 🐼 **Pandas**
  - **Ease of implementation:** Very straightforward with simple and intuitive syntax. No additional configuration is required.
  - **Handling dataset:** Successfully processes the dataset without errors, but performance is limited by single-threaded execution.
  - **Limitations:** High memory usage and slower performance when handling large datasets.
  - **Scalability:** Not suitable for very large datasets as it relies entirely on available memory in a single machine.

- ⚙️ **Dask**
  - **Ease of implementation:** More complex than Pandas due to lazy evaluation. Requires the use of `.compute()` to trigger execution.
  - **Handling dataset:** Efficiently handles large datasets by splitting data into partitions, reducing memory pressure.
  - **Limitations:** Introduces overhead from task scheduling, which can lead to slower performance in smaller environments.
  - **Scalability:** Highly scalable and suitable for distributed computing across multiple machines or clusters.

- ⚡ **Polars**
  - **Ease of implementation:** Relatively easy to use with syntax similar to Pandas, requiring minimal additional configuration.
  - **Handling dataset:** Processes the dataset efficiently with fast execution and low memory usage using built-in multi-threading.
  - **Limitations:** Primarily designed for single-machine processing and less flexible for distributed systems compared to Dask.
  - **Scalability:** Scales well on a single machine using parallel processing, but not intended for large distributed environments.
 
💡 Pandas is the easiest to use but least efficient for large-scale data processing.Dask offers strong scalability but introduces additional complexity and overhead.  
Polars provides the best balance of performance and ease of use, making it the most efficient choice for high-performance processing on a single machine.

---

#### 📈 Visualisation
<img width="1038" height="412" alt="image" src="https://github.com/user-attachments/assets/8b43095b-54ab-49ad-a932-6936356b89f7" />


#### 📊 Performance Analysis

- 🐼 **Pandas**
  - Execution Time: ~2.42 s  
  - Memory Usage: ~218 MiB  
  - Uses single-threaded processing → slower and more memory-intensive  

- ⚙️ **Dask**
  - Execution Time: ~2.12 s  
  - Memory Usage: ~93 MiB  
  - More memory-efficient due to partitioning  
  - Slight overhead from task scheduling, especially in small environments  

- ⚡ **Polars**
  - Execution Time: ~0.31 s (fastest)  
  - Memory Usage: ~65 MiB (lowest)  
  - Uses multi-threading → very efficient and fast  

#### 🔄 Scalability

- Dask is designed for distributed systems and can scale across multiple machines  
- Polars is optimised for single-machine performance  
- Pandas is limited to smaller datasets due to memory constraints  

#### 💡 Overall Insight

Polars provides the best performance and efficiency.  
Pandas is the simplest but least efficient for large data.  
Dask offers good scalability but comes with additional complexity and overhead.
________________________________________
## 6. Conclusion
This study compared different strategies for handling large datasets and evaluated the performance of Pandas, Dask, and Polars in terms of processing efficiency and memory usage.

The results show that Polars achieved the best overall performance, especially in execution speed and memory efficiency due to its multi-threaded architecture and efficient columnar processing model. Pandas, while simple and easy to use, showed higher memory consumption and slower performance due to its single-threaded design. Dask provided better memory efficiency and offers strong scalability, but its performance was affected by task scheduling overhead in this environment.

In terms of practical application, the choice of library depends on the scale and context of the use case. Pandas is suitable for smaller datasets, Dask is ideal for distributed and large-scale processing, and Polars is the most efficient option for high-performance processing on a single machine.

From a scalability perspective, the current 2.73 GB dataset is already a relatively large workload that begins to test the limits of single-machine processing. Pandas may struggle with memory usage since it loads data into memory all at once, while Polars performs more efficiently due to its columnar, multi-threaded design. Dask can be used to load larger datasets than Pandas by enabling more flexible memory handling.

If the dataset increased to 10 GB or 100 GB, in-memory approaches would become increasingly impractical. Polars would still perform well with optimisation, while Dask would become more necessary for handling data that exceeds memory limits. At around 1 TB, single-machine solutions would no longer be sufficient, and distributed systems like Apache Spark or cloud-based platforms would be required.

Overall, as data size grows, the key limitation shifts from the choice of library to the underlying system architecture, with distributed computing becoming essential at very large scales.
________________________________________

## 7. Reflection
**Joanne:**

Throughout this assignment, several practical challenges were encountered, particularly when working with large datasets. One key issue was the limitation of Google Colab’s RAM, which caused the system to crash when attempting to load the full dataset using Pandas. This highlighted the importance of using efficient data handling strategies such as sampling, chunking, and alternative libraries.

This experience helped improve my understanding of how different data processing libraries manage memory and performance. I also learned the importance of selecting the right tool based on the dataset size and system constraints. For example, while Pandas is easy to use, it is not suitable for large-scale data processing, whereas Polars provides a more efficient solution for high-performance tasks.

Overall, this assignment strengthened my practical skills in handling big data and improved my ability to evaluate trade-offs between performance, memory usage, and scalability in real-world scenarios.

**Chua Jia Lin:**

At the beginning of this assignment, I thought that parallel processing using scalable libraries such as Polars and Dask would always perform better than traditional Pandas-based approaches such as Sampling and Chunking. I assumed that distributing work across multiple CPU cores would result in faster and more efficient performance. However, the result showed that Dask did not perform as efficiently as expected in this situation due to processing and scheduling overhead. I realise that not every strategy is suitable for every scenario.

Besides, I also learned that reducing the amount of data being processed is often one of the most effective strategies. Approaches such as Load Less Data and Sampling performed better in terms of balancing the execution time and memory usage. On the other hand, the Optimize Data Types strategy introduced additional preprocessing steps, which increased both execution time and memory usage instead of improving overall efficiency.

Overall, this assignment showed me that choosing the right data processing strategy is more important than simply using the most advanced method. The best approach depends on the dataset size, the task requirements, and the trade-offs between speed, memory, and complexity.
________________________________________

## References

Pandas Development Team. (2025). *pandas: Python Data Analysis Library*.  
https://pandas.pydata.org/

Dask Development Team. (2025). *Dask: Parallel Computing Library*.  
https://www.dask.org/

Polars Development Team. (2025). *Polars: Fast DataFrame Library*.  
https://pola.rs/

Python Software Foundation. (2025). *Python Documentation (time module)*.  
https://docs.python.org/3/library/time.html

Python Software Foundation. (2025). *tracemalloc — Trace memory allocations*.  
https://docs.python.org/3/library/tracemalloc.html

Kaggle. (n.d.). *Synthetic Fraud Detection Dataset*.  
https://www.kaggle.com/datasets/ismetsemedov/transactions/data  

---







