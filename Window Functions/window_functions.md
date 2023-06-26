# Window Function in PostgreSQL

## window function - 

**Ranking rows according to their values**

### 1. ROW_NUMBER() - Always assign unique number, even if two rows are identical.

#### syntax - 

        ROW_NUMBER() OVER(partition by column_name ORDER BY column_name`) AS rn;

### 2. RANK() -  Assigns the same number to identical values and skipping over the next number in such cases. 

#### syntax - 

        RANK()  OVER(PARTITION BY column_name ORDER BY column_name`) AS rnk;


### 3. DENSE_RANK() - Assigns the same number to the identical values by doesnot skip to the next number in such cases. 

#### syntax - 

        DENSE_RANK() OVER(PARTITION BY column_name ORDER BY column_name`) AS dense_rnk


**Relative Values as output**

### 4. LEAD() - Returns the columns value at the row n rows after the current row.

#### syntax - 

       LEAD(column_name, n, #num) 
Here, column_name indicating the column on which you want to apply `LEAD()` function, and `n` is the number of rows to take into consideration for `LEAD()` function and `#num` is any arbitary number set by user in replacement of `NULL` values.



### 5. LAG() - Returns the columns value at the row n rows before the current row.

#### syntax - 

       LAG(column_name, n, #num) 
Here, column_name indicating the column on which you want to apply `LAG()` function, and `n` is the number of rows to take into consideration for `LAG()` function and `#num` is any arbitary number set by user in replacement of `NULL` values.