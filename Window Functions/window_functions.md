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


For better understanding run the [file 1](https://github.com/SaibalPatraDS/PostgreSQL/blob/main/Window%20Functions/create_table_employee.sql), [file 2](https://github.com/SaibalPatraDS/PostgreSQL/blob/main/Window%20Functions/window_function.sql) and one can go through the tutorial, [video](https://youtu.be/Ww71knvhQ-s)


### 6. FIRST_VALUE() - The `first_value()` function in PostgreSQL returns the first value in an ordered set.

#### syntax - 

          FIRST_VALUE(expression) OVER(PARTITION BY partition_column ORDER BY sort_column DESC) AS first_value

  * expression: The value to be evaluated.
  * PARTITION BY: Optional clause that divides the result set into partitions.
  * ORDER BY: Specifies the order in which the values are sorted.
  * window_frame_clause: Optional clause that defines the window frame within the partition.

### 6. LAST_VALUE() - The `last_value()` function in PostgreSQL returns the last value in an ordered set.

#### syntax - 

          LAST_VALUE(expression) 
          OVER(PARTITION BY partition_column 
               ORDER BY sort_column DESC
               RANGE BETWEEN UNBOUNDED PREDEDING AND UNBOUNDED FOLLOWING) AS last_value

  * expression: The value to be evaluated.
  * PARTITION BY: Optional clause that divides the result set into partitions.
  * ORDER BY: Specifies the order in which the values are sorted.
  * window_frame_clause: Optional clause that defines the window frame within the partition.
  * Range between unbounded preceding and current row means the during searching, 
    the search will be done between prior rows and current rows

### 7. NTH_VALUE() - The `NTH_VALUE()` function will return the nth(2nd, 3rd, or any) value in an ordered set. 

#### syntax - 

           NTH_VALUE(column_name, #num)
           OVER(PARTITION BY partition_column
                   ORDER BY sort_column DESC
                   RANGE BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING) AS nth_value
