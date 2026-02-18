# 🎮 Game Engagement Analytics Warehouse 

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

## 📊 Engagement Mart Layer

Engagement marts were built to answer business questions such as:

- What are the top-rated games by user reviews?
- Which developers (Teams) have the highest average ratings?
- What are the most common genres in the dataset?
- Which games have the highest backlog compared to wishlist?
- What is the game release trend across years?
- What is the distribution of user ratings?
- What are the top 10 most wishlisted games?
- What’s the average number of plays per genre?
- Which developer studios are the most productive and impactful?


All marts respect grain alignment and avoid unsafe fact-to-fact joins.

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

dbt test

---

## 📌 Project Overview

After completing the Engagement warehouse, a second warehouse was built for video game sales data using the same architectural discipline and grain-first modeling approach.

This warehouse is independent from Engagement but follows the same layered structure and dimensional modeling standards.

The goal was not just to compute totals, but to design a clean, atomic, fully additive fact model using dimensional modeling best practices.

This repository demonstrates:

- Structured ELT using dbt  
- Explicit grain definition at every layer  
- Dimensional modeling (Star Schema)  
- Proper atomic fact design  
- Surrogate key strategy  
- Additive metric handling  
- Business-ready mart layer  

---

# 🏗 Architecture

The sales warehouse follows a layered architecture:

Raw → Staging → Core (Dimensions + Fact) → Marts

Each layer has a clearly defined responsibility.

---

## 🔹 Raw Layer

Contains the original sales dataset (`vgsales.csv`) with minimal handling.

**Raw Grain:**  
1 row = 1 game × 1 platform × 1 year  

Raw data characteristics:

- Regional sales split across multiple columns  
- Periodic snapshot sales data (not transactional)  
- Single-valued genre and publisher attributes  

---

## 🔹 Staging Layer

**Model:** `stg_sales_focused_grain`  
**Grain:** 1 row = 1 game × 1 platform × 1 year  

Purpose: Preserve raw grain while validating structural integrity.

Key responsibilities:

- Preserve raw grain exactly  
- Clean numeric inconsistencies  
- Validate uniqueness of (name, platform, year)  
- Avoid premature aggregation  

No surrogate keys are created in staging.  
Surrogate keys are introduced in dimensional models only.

---

## 🔹 Core Layer (Star Schema)

The sales warehouse was intentionally designed with one atomic fact table only to avoid redundancy and grain confusion.

---

### Fact Table

`fact_sales_by_region`

**Grain:** 1 row = 1 release × 1 region  

Metrics:

- sales  

Foreign Keys:

- release_id → dim_release  
- region_id → dim_region  

Regional sales columns (`na_sales`, `eu_sales`, `jp_sales`, `other_sales`) were unpivoted into row format to create a fully additive fact table.

This ensures:

- Correct aggregation behavior  
- No metric inflation  
- Clean dimensional joins  

---

### Dimensions

#### `dim_release`

**Grain:** 1 row = 1 game × 1 platform × 1 year  

Attributes:

- name  
- platform  
- year  
- genre  
- publisher  

Surrogate Key:

- release_id  

This dimension represents the business identity of a release.

---

#### `dim_region`

**Grain:** 1 row = 1 region  

Regions modeled:

- NA  
- EU  
- JP  
- Other  

Surrogate Key:

- region_id  

Region is treated as a measurement context, not part of release identity.

---

## 🔹 Mart Layer

Sales marts were built to answer business questions such as:

- Which region generates the most sales?  
- What are the best-selling platforms?  
- What are the top 5 best-selling games per platform?  
- What is the yearly sales trend?  
- What are regional genre preferences?  
- What is the yearly sales change per region?  
- What is the average sales per publisher?  

All marts respect grain alignment and avoid unsafe fact-to-fact joins.

---

## 🔁 Future: Merging Engagement + Sales

The architecture allows safe merging of both warehouses.

Before joining:

- Sales (release × region grain) must be collapsed  
- Engagement (game grain) must remain atomic  

Grain alignment is enforced before computing non-additive metrics such as averages.

This prevents:

- Metric duplication  
- Region-level inflation  
- Incorrect aggregations

---

# 🧪 Data Testing Strategy

Tests haven't been added yet but, will do soon

---

# Game Sales Core and Marts Completed. Future work includes merging with Engagement Warehouse.