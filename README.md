# 🎮 Game Engagement Analytics Warehouse 
(Right now only Game Engagement Analytics Warehouse is done, will soon do Game Sales Analytics Warehouse and marts made by merging both Engagement and Sales Warehouses)

**Analytics Engineering Project (dbt + SQL + Power BI)**

---

## 📌 Project Overview

This project is an end-to-end Analytics Engineering implementation focused on modeling and analyzing video game engagement data.

The goal was not just to build dashboards, but to design a properly structured, testable, and production-style analytics warehouse using dimensional modeling best practices.

This repository demonstrates:

- Structured ELT using dbt  
- Explicit grain definition at every layer  
- Dimensional modeling (Star Schema)  
- Many-to-many relationship handling using bridge tables  
- Custom data-cleaning macros  
- Referential integrity testing  
- Business-ready mart layer  
- Power BI visualizations built on modeled data  

---

# 🏗 Architecture

The warehouse follows a layered architecture:

Raw → Staging → Intermediate → Core (Dimensions + Facts + Bridges) → Marts → Dashboard

Each layer has a clearly defined responsibility.

---

## 🔹 Raw Layer

Contains the original engagement dataset (`games.csv`) with minimal handling.

**Raw Grain:**  
1 row = 1 game

Raw data characteristics:
- Multi-valued genres
- Multi-valued teams
- Mixed date formats
- Numeric values stored as text (k/m/b abbreviations)
- Placeholder values (N/A, -, NULL)

---

## 🔹 Staging Layer

**Model:** `stg_engagement_focused`  
**Grain:** 1 row = 1 game  

Purpose: Clean and standardize raw inputs without altering grain.

Key cleaning operations:
- Standardized numeric values
- Cleaned percentage fields
- Normalized date formats
- Preserved multi-valued fields for controlled explosion downstream

Custom dbt macros were implemented to handle messy real-world data safely and consistently.

---

## 🔹 Custom Macros

Reusable macros were created to standardize ingestion logic:

### `clean_numeric`
- `"1.2k"` → 1200  
- `"3m"` → 3,000,000  
- Handles N/A, NULL, and placeholder values  

### `clean_percentage`
- `"75%"` → 0.75  
- Strips non-numeric characters safely  

### `clean_date_int`
- Extracts integer-based year values from messy text  

### `clean_date_all`
Parses:
- `YYYY-MM-DD`
- `Mon DD, YYYY`

Returns NULL for unsupported formats to prevent incorrect casting.

---

## 🔹 Intermediate Layer

Purpose: Normalize multi-valued fields into relational structures.

Models:
- `int_genre_exploded`
- `int_team_exploded`

**Grain:**
- 1 row = 1 game × 1 genre  
- 1 row = 1 game × 1 team  

This layer prepares the dataset for proper many-to-many modeling.

---

## 🔹 Core Layer (Star Schema)

### Fact Table

`fact_engagement`

**Grain:** 1 row = 1 game  

Metrics:
- rating
- times_listed
- number_of_reviews
- plays
- playing
- backlogs
- wishlist

---

### Dimensions

#### `dim_title`
**Grain:** 1 row = 1 game  

Attributes:
- title
- release_date
- summary
- reviews

---

#### `dim_date`
**Grain:** 1 row = 1 calendar date  

Attributes:
- year
- month
- day

---

#### `dim_genre`
**Grain:** 1 row = 1 genre  

---

#### `dim_team`
**Grain:** 1 row = 1 team  

---

### Bridge Tables

Because genres and teams are many-to-many relationships:

#### `bridge_game_genre`
Grain: 1 row = 1 game × 1 genre  

#### `bridge_game_team`
Grain: 1 row = 1 game × 1 team  

Composite uniqueness is enforced on bridge keys to prevent duplication and metric inflation.

---

# 🧪 Data Testing Strategy

Testing is applied intentionally at each layer.

### Staging
- Primary key uniqueness

### Core
- Unique primary keys in dimensions
- Not-null enforcement
- Foreign key relationship tests
- Composite uniqueness tests in bridges

All tests are executed using:

```bash
dbt test
