# Window Function in PostgreSQL

## window function - 

**Ranking rows according to their values**

### 1. ROW_NUMBER() - Always assign unique number, even if two rows are identical.

#### syntax - 

ROW_NUMBER(column_name) OVER(partition by column_name ORDER BY column_name) AS rn;

### 2. RANK() - 



### 3. DENSE_RANK() - 



### 4. LEAD() - 



### 5. LAG() - 
