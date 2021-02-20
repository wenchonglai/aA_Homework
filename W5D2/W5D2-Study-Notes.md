# W5D2 SQL Notes

## Learning Goals
- why we need database
- Relational DB Mgmt System
- Be able to access and manipulate data

---

## Databases

- different models of databases
  - differ in how they store data and how data can be accesed

- Relational Databse Model
  - ***Relational*** refers to the use of table to store and organize data
  - Each table is referred to as a relation as it is a collection of related data entries
  - A relational database are like an excel spreadsheet with collection of related tables

## two ways to store & access data
  - db managment system
    an pplication that stores data at a scale and can be queried for data
  the querying language
    language to interact w/ db mgmt sys to create db, insert data, & query for data

## ***Relational Database Management System (RDBMS)***
- an application that stores data at scale & organizes the data in tables
we will be using
- postgres SQL (open source)
- SQLite (open source)

----

## SQL
The way to communicate with database
- SQL stands for Structured Query LAnguage
- It is a ***_Domain Specific Language (DSL)_*** for relational databases (other DSLs: HTML, RSpec)
- https://insights.stackoverflow.com/survey/2020#technology-programming-scripting-and-markup-languages-all-respondents

### What can SQL do?
- create new dbs
- create new tables in a db
- insert records in a db
- update records in a db
- delete records in a db
- retrieve data from a db

### Column Types
every column must have a datatype specified. some common types:
- `VARCHAR` / `VARCHAR(255)`
  - **[caveat] strings in SQL must be declared with `'` single quotes; `"` double quotes will not work**
  - **[caveat] to include a `'` quote in an SQL string, use `''` instead**  
  i.e. ```'Trader Joe''s'```
- `BOOLEAN`
- `INTEGER`
- `FLOAT`
- `DATE`
- many more

Other column attributes:
- `PRIMARY KEY`: always not null
- `NOT NULL`: avoids null values

### PostgreSQL
- **`$ psql`** - enter into the psql REPL
- **`CREATE DATABASE db_name_singular;`**
- **`$psql db_name_singular`**
- **`\d`** - list tables
- **`\d table_name`** - show ***schema*** *(how the table is setup)* for `table_name`
  - *[note] case is not important*
- `\?` - list meta commands
  - similar to show-doc in pry
  - too many commands; not very useful
- end queries with a `;`
- `quit` - quit
- [shortcut] use `.sh` file to batch execute terminal commands

## The Basics of SQL Queries
- `SELECT` choose which cols to extract data from
- `FROM` specifies the *relation* (table) the data is grom
- `WHERE`/`WHERE NOT`: filters the data according to a logical expression
  - `=`, `>=`, `<=`, `>`, `<`, `<>`/`!=`
  - `AND`, `OR`
  - `IN` (includes),
    
    `BETWEEN` (between values),
    
  - `LIKE` (regexp check),
    
    - wild cards
      - `%` replaces **zero** or more characters
      - `_` replaces exactly one characters
- code samples
  ```sql
  SELECT * 
  FROM table_name
  WHERE column_name = value
  ``` 

  ```sql
  SELECT name 
  FROM instructors
  WHERE name LIKE 'M%'
  ``` 

## Common Filters and Commands
- `ORDER BY`: sorts results based on a specified column
  - `ASC` *(default)* / `DESC`: ascending or desending
- `LIMIT`: limit the numbers of rows in the result
- `OFFSET`: the number of rows to be skipped from the top
- `DISTINCT`: remove duplicated values (like `Array#uniq`)
  - typically used in `SELECT`:
    - `SELECT DISTINCT name, type`
    - `SELECT COUNT(DISTINCT name)`

### **NULL**
- comparison to `NULL` don't work in SQL
- `NULL` represents an unknown value
  - it is **NOT** a value; it is a ***non-value***
- Use `IS NULL` and `IS NOT NULL` to check for null values

---

## Performing Calculations on Data

### Aggregate functions
- ***Aggregate funtions*** combine data from a column to a single value
- **[caveat] should ALWAYS use an alias with aggregate functions to make for clearer results**
  - `SELECT AVG(cost) `**`AS avg_cost`** `FROM table_name` 
- `COUNT`, `SUM`, `AVG`, `MIN`/`MAX`, and more

### GROUP BY
- `GROUP BY` groups rows with matching values for the given column
  - collapses each group of rows into a single row
- **[caveat] `SELECT` and `GROUP BY`**
  - When 
    1.  `GROUP BY` is present, **OR**: 
    2.  any aggregate functions are present:
    
    `SELECT` cannot refer to `col_name_1` that is not specified in `GROUP BY`, EXCEPT when:
    1.  `col_name_1` is within an aggregate function, **OR**:
    2.  there exists a ***functional dependency*** - if `col_name` in `GROUP BY` is the **primary key** of the table containing `col_name_1`
    
    Otherwise, more than one value could persist in the `col_name_1` column after grouping, which leads to an error.
- Aggregation functions in `SELECT` will apply to the invidivual groups 
  ```sql
  SELECT
    type, COUNT(id) AS num_of_items
  FROM
    table_name
  GROUP BY
    type
  ```

### WHERE vs HAVING
- `HAVING` works like `WHERE` but:
  - `WHERE` gets evaluaged ***before*** `GROUP BY`
    - grouped entries ***cannot*** be filtered by `WHERE`
    - Aggregate function not allowed `WHERE`
  - `HAVING` gets evaluated ***after*** `GROUP BY`
    - Applied to grouped entries
    - Aggregate functions allowed in `HAVING`

## Order of Operation Execution in SQL
  1. `FROM`
  2. `JOIN`
  3. `WHERE`
  4. `GROUP BY`
  5. `HAVING`
  6. `SELECT`
  7. `ORDER BY`
  8. `OFFSET`/`LIMIT`

  ```sql
  SELECT
    type, COUNT(*) AS count
  FROM
    table_name
  GROUP BY
    type
  HAVING
    COUNT(*) > 5 # cannot use count here because HAVING precedes SELECT
  ```

### Use of a Subquery
Use the result of a query inside another query
- Most commonly used n the `WHERE` clause
  - `WHERE col_name = (Subquery)`
  - `WHERE col_name IN (Subquery here)`
  - `WHERE col_name NOT IN (Subquery here)`
- When using a subquery:
  - follow the logit of "given A, what it B?"

- Can also be used in the FROM statement
  - [caveat] **MUST alias the subquery**
  
    have to name the subquery to **create a reference** so that further constraints on the results can be added

---

## JOIN

### JOINS
- Combine data from mutiple tables into one relation using a JOIN
- Types of relationship between tables
  - one-to-many(hierarchical)
  - many-to-may (horizontal)
- Double Joins
  ```sql
  SELECT
    *
  FROM
    table
  JOIN
    table_1 on cond_1
  JOIN
    table_2 on cond_2
  ```

### Most Common Types of JOINS
- `INNER JOIN`
  return only rows from `table1` & `table2` that match each other
- `LEFT OUTER JOIN`
  return all rows in `table1` whether or not they match `table2`
- `FULL OUTER JOIN`
  return all rows in `table1` and `table2`
### When to join tables rather than using a subquery?
- lots of data across many tables
- when CPU is the bottleneck
  - [note] subqueries use less memory but more than joins
  - may differ from SQL engines

## Self Join
- Joins a table back agains itself
  - **[caveat] Must alias the table names using descriptive aliases** 

  ```sql
  SELECT
    col_name
  FROM
    table AS alias1
  JOIN
    table AS alias2
    ON condition
  ```

  
