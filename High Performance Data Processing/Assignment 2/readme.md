# 📘 Assignment 2: Mastering Big Data Handling

<div align="center">

|Name|Matric Number|
|----|-----|
|Chua Jia Lin|A23CS0069|
|Joanne Ching Yin Xuan| A23CS0227|
</div>

## 📁 Project Files

<div align="center">

| File Name        | Description                                             | Link |
|------------------|---------------------------------------------------------|------|
| `big_data.md`    | Markdown file with detailed write-up for Assignment 2   |<a href="big_data.md"><img src="https://img.shields.io/badge/View-Markdown-blue?logo=markdown&logoColor=white" /></a>|
| `big_data.ipynb` | Colab notebook exploring various data loading and optimization techniques |<a href="big_data.ipynb"><img src="https://img.shields.io/badge/Open-Notebook-green?logo=jupyter&logoColor=white" /></a>|
</div>

## 📖 Introduction
In the modern era of digital payments and online commerce, financial institutions generate massive volumes of transaction data every day. This data is essential for identifying suspicious behavior and preventing fraud. Efficiently handling this kind of data requires specialized tools and techniques.

Our project focuses on mastering scalable big data techniques using tools such as Pandas, Dask, and Polars. We applied various optimization strategies to load and process a large real-world dataset, then conducted performance benchmarking on memory usage and execution time.

## 📊 Dataset Overview
- **Name:** Transaction  
- **Source:** [Kaggle – ismetsemedov](https://www.kaggle.com/datasets/ismetsemedov/transactions)
- **Domain:** Finance
- **File Size:** 2.73GB
- **Shape:** 7,483,766 rows x 24 columns

## 📄 Description
This project examines efficient big data handling strategies using the Transaction Dataset (2.73GB, over 7 million records). The objective is to evaluate and compare the performance of three popular Python data processing libraries which are Pandas, Dask, and Polars when working with large-scale datasets.

To achieve this, we applied and benchmarked the following big data handling strategies:
- **Load Less Data:** Load only relevant columns to reduce memory usage and improve efficiency.
- **Use Chunking:** Process the dataset in smaller chunks to prevent memory overload.
- **Optimize Data Types:** Convert data columns' data types to more memory-efficient data types (e.g., category, float32, int8).
- **Sampling:** Randomly sample a subset of the data to enable faster prototyping.
- **Parallel Processing with Polars:** Leverage Polars’ built-in multithreading and columnar execution engine for fast and scalable data processing.
- **Parallel Processing with Dask:** Use a task-based parallel computing framework that enables lazy evaluation and scalable processing through distributed-like execution using .compute().

The project is divided into two comparative analyses:
- Strategy-level comparison (using Pandas, Polars, and Dask) to measure how each strategy affects performance.
- Library-level comparison of Pandas, Dask, and Polars focusing on the performance of full dataset loading.

---

## 🎓 Reflection

This assignment provided valuable exposure to handling large-scale datasets and applying big data techniques in a practical environment. By working with a real-world dataset exceeding 2.7GB, the project highlighted the challenges associated with memory limitations, processing time, and efficient data handling.

Through the implementation of various strategies such as loading selective columns, chunking, optimizing data types, and sampling, the importance of resource management became more apparent. These techniques demonstrated how performance can be significantly improved by reducing unnecessary data processing and optimizing memory usage.

In addition, the comparison between Pandas, Dask, and Polars offered deeper insights into the strengths and limitations of each library. Pandas was observed to be suitable for smaller datasets due to its simplicity, while Dask and Polars showed better scalability and performance when handling large datasets. The use of parallel processing in Dask and Polars also emphasized the importance of leveraging modern computing capabilities for efficient big data processing.

This project also strengthened analytical thinking and evaluation skills by requiring performance benchmarking based on execution time and memory efficiency. It reinforced the importance of selecting appropriate tools and strategies depending on the data size and application requirements.

Overall, the assignment enhanced understanding of big data handling concepts and provided practical experience in optimizing data workflows. It also highlighted the relevance of scalable solutions in real-world applications, particularly in domains such as finance where large volumes of transaction data are generated continuously.
