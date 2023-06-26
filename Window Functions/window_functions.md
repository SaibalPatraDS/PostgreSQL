# Window Function in PostgreSQL

## window function - 

**Ranking rows according to their values**

### 1. ROW_NUMBER() - Always assign unique number, even if two rows are identical.

#### syntax - 

        ROW_NUMBER() OVER(partition by column_name ORDER BY column_name`) AS rn;

### 2. RANK() -  Assigns the same number to identical values and skipping over the next number in such cases. 

#### syntax - 

        RANK()  OVER(PARTITION BY column_name ORDER BY column_name`) AS rnk;



### 3. DENSE_RANK() - 



### 4. LEAD() - 



### 5. LAG() - 
