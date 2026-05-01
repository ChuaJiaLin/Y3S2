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
Part 1 focuses on implementing optimisation techniques using **Pandas**, while Part 2 compares the performance of three libraries: **Pandas, Dask, and Polars**.

**Part 1** uses a subset of **1 million records** instead of the full dataset because loading the entire dataset causes runtime crashes due to memory limitations. Using a smaller subset reduces memory usage, improves processing speed, and allows demonstration of each strategy without overloading the system.

**Part 2** uses the **full dataset** for each library to ensure a fair and realistic performance comparison. Evaluating all libraries under the same conditions provides accurate measurements of execution time and memory usage, and better reflects real-world data processing scenarios.

---

### 🔹 Part 1: Big Data Handling Strategies
- Load Less Data  
- Use Chunking  
- Optimise Data Types  
- Sampling  
- Parallel Processing with Scalable Libraries (Polars)  


### 4.1 Load Less Data
This strategy reduces memory usage and improves performance by loading only the required columns and limiting the number of rows instead of reading the entire dataset.

```python
# Select only the necessary columns to reduce memory usage
selected_cols = ['transaction_id', 'customer_id', 'merchant', 'amount', 'currency', 'high_risk_merchant', 'is_fraud']

# Measure execution time
start_time = time.time()

# Load only the selected columns
df_selected = pd.read_csv('synthetic_fraud_data.csv', usecols=selected_cols, nrows=1000000)

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
Dataset shape: (1000000, 7)
Memory usage: 228.28 MiB
Execution time: 6.05 seconds
```
### Discussion
Loading only necessary columns reduces memory usage and improves performance.

### 4.2 Chunking
This strategy processes the dataset in smaller chunks instead of loading it all at once, helping to manage memory usage when working with large datasets.

```python
chunksize = 200000
chunk_iter = pd.read_csv("synthetic_fraud_data.csv", chunksize=chunksize, nrows=1000000)

total_rows = 0
max_mem = 0

# Measure execution time
start_time = time.time()

# Process chunks
for i, chunk in enumerate(chunk_iter):
    print("Chunk", i+1, ":", chunk.shape)
    print("First 5 rows of Chunk", i+1, ":\n", chunk.head())
    print("-" * 50)
    total_rows += len(chunk)
    mem_used = chunk.memory_usage(deep=True).sum() / (1024 ** 2)
    max_mem = max(max_mem, mem_used)

print("Finished processing all chunks!")

# Execution time
exec_time = time.time() - start_time

# Display basic info
print("Total rows processed:", total_rows)
print("\nMaximum memory used:", round(max_mem, 2), "MiB")
print("Total execution time:", round(exec_time, 2), "seconds")

```

### Output
```python
Finished processing all chunks!
Total rows processed: 1000000
Maximum memory used: 217.97 MiB
Total execution time: 15.97 seconds
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
df = pd.read_csv("synthetic_fraud_data.csv", nrows=1000000)

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
Memory usage: 580.79 MiB
Execution time: 17.8 seconds
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
df_full = pd.read_csv("synthetic_fraud_data.csv", nrows=1000000)

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
Original rows: 1000000
Sampled rows: 100000
Memory usage: 109.74 MiB
Execution time: 11.27 seconds
```

### Discussion
Sampling significantly reduces the dataset size, resulting in faster execution time and lower memory usage compared to processing the full dataset. This makes it highly useful during the development and testing phase, where quick iterations are required.

However, sampling may not capture all patterns present in the full dataset, especially for rare events such as fraud cases. Therefore, while it improves efficiency, it should be used carefully and complemented with full dataset analysis for final results.
________________________________________

### 4.5 Parallel Processing with Scalable Libraries
Parallel processing improves performance by executing multiple operations simultaneously using multiple CPU cores instead of sequential processing. This is especially important for large datasets where single-threaded processing becomes slow and inefficient.


**Library Used**  
Polars is used as it supports multi-threaded execution by default. Unlike Pandas, which is single-threaded, Polars distributes operations across multiple CPU cores, resulting in faster and more efficient data processing.

```python
import polars as pl
import time

print("\n--- Parallel Processing using Polars ---")

start_time = time.time()

# Load dataset (multi-threaded internally)
df = pl.read_csv("synthetic_fraud_data.csv", n_rows=1_000_000)

# Measure memory usage
mem_before = df.estimated_size("mb")

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

end_time = time.time()

print(result.head())
print("\nExecution Time:", round(end_time - start_time, 2), "seconds")
print("Memory Usage (Before):", round(mem_before, 2), "MiB")
```

### Output
```python
--- Parallel Processing using Polars ---
shape: (5, 3)
┌───────────────────┬──────────────┬───────────────────┐
│ merchant_category │ avg_amount   │ transaction_count │
├───────────────────┼──────────────┼───────────────────┤
│ Education         │ 48041.03     │ 118790            │
│ Retail            │ 65623.42     │ 119067            │
│ Restaurant        │ 30708.82     │ 107907            │
│ Entertainment     │ 32767.58     │ 111443            │
│ Gas               │ 49028.25     │ 119424            │
└───────────────────┴──────────────┴───────────────────┘

Execution Time: 12.08 seconds
Memory Usage (Before): 338.77 MiB
```

### Discussion
Polars efficiently processes large datasets using parallel processing. By leveraging multi-threading, operations such as filtering, grouping, and aggregation are executed simultaneously across multiple CPU cores, resulting in faster execution compared to sequential processing.

The memory usage (~338 MiB) remains reasonable for 1 million records, showing that Polars handles data efficiently on a single machine.

However, Polars is mainly designed for single-machine processing. For much larger datasets that exceed memory limits, distributed frameworks such as Dask or Apache Spark may be more suitable.

Overall, this strategy demonstrates how scalable libraries improve performance and efficiency when working with big data.
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
Execution Time: 96.43 seconds
Memory usage: 3523.78 MiB
```

### Discussion
The Dask implementation shows lower memory usage (~3524 MiB) compared to Pandas, as it processes data in partitions rather than loading everything at once initially. However, the execution time (~96 seconds) is slower due to overhead from task scheduling and coordination.

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
Execution Time: 16.17 seconds
Memory usage: 2528.16 MiB
```

### Discussion
Polars demonstrates significantly faster performance (~16 seconds) compared to Pandas and Dask due to its multi-threaded execution and efficient Rust-based engine. It is able to process large datasets quickly by utilising multiple CPU cores.

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
### 🔍 **Part 1: Comparison between 5 Big Data Handling Strategies**
- Load Less Data
- Use Chunking
- Optimize Data Types
- Sampling
- Parallel Processing using Polars

Two bar charts are generated:
-One compares the execution time (in seconds).
-The other compares the memory usage (in MB).

This analysis helps to identify which strategy offers the best trade-off between speed and memory efficiency when using traditional vs. parallelized approaches.

#### ⚡ Big Data Handling Strategies Performance Comparison

| Strategy | Execution Time (s) | Memory Usage (MiB) |
|--------|------------------|-------------------|
| Load Less Data | 6.05 | 228.28 |
| Use Chunking   | 15.97 | 217.97  |
| Optimize Data Types | 17.80 | 580.79 |
| Sampling   | 11.27 | 109.74  |
| Parallel Processing with Polars | 12.08 | 338.77  |

#### 📈 Visualisation
<img width="989" height="501" alt="comparison 5 strategy_time" src="https://github.com/user-attachments/assets/d88548f0-b7de-4d09-965b-65f4d02c5adf" />
<img width="989" height="501" alt="comparison 5 srategy_memory" src="https://github.com/user-attachments/assets/7fcfc13f-f749-44cf-a5a9-70c8a596a612" />


#### 📊 Performance Analysis
* **Execution Time**
  - Load Less Data (6.05s) is the fastest strategy because it reduces the amount of data processed, leading to lower computation time.
  - Sampling (11.27s) also performs efficiently, as it works on a smaller subset of the data while still providing approximate insights.
  - Parallel Processing using Polars (12.08s) shows competitive performance but is slightly slower due to parallel execution overhead.
  - Chunking (15.97s) is slower because it processes data in multiple iterations, introducing loop and I/O overhead.
  - Optimize Data Types (17.8s) is the slowest strategy due to the additional preprocessing required for type conversion.

* **Memory Usage**
  - Sampling (109.74 MiB) is the most memory-efficient strategy, as it operates on a significantly reduced subset of the dataset.
  - Chunking (217.97 MiB) and Load Less Data (228.28 MiB) show moderate memory usage, as they limit the amount of data processed at a time.
  - Parallel Processing using Polars (338.77 MiB) consumes more memory due to parallel execution overhead and internal data structures.
  - Optimize Data Types (580.79 MiB) results in the highest memory usage, likely due to intermediate transformations and data conversions.

* **Processing Efficiency**
  - Load Less Data is very easy to implement and highly efficient, but it may lead to loss of important information if too much data is excluded.
  - Sampling is simple and fast, making it useful for exploratory analysis, but results may not fully represent the entire dataset.
  - Chunking requires moderate effort to implement, as it involves iterative processing, but it is effective for handling datasets larger than memory.
  - Optimize Data Types requires careful handling and domain knowledge to avoid incorrect conversions, making it moderately complex and less efficient in this case.
  - Parallel Processing using Polars is easy to implement with built-in parallelism and provides good performance, but at the cost of higher memory usage.

In conclusion, Load Less Data is the fastest and most efficient strategy overall when data reduction is acceptable. Sampling provides the best memory efficiency and is ideal for exploratory analysis. Chunking is useful for large datasets that exceed memory limits but introduces processing overhead. Optimize Data Types is the least efficient in this scenario due to high memory usage and slower execution. Parallel processing using Polars offers good scalability and balanced performance, but it is not the most memory-efficient option in this comparison.
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







