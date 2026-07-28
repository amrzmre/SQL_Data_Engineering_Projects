/*==============================================================
DATA WAREHOUSE SCHEMA

Tables
1. job_postings_fact
   - Stores job posting details
   - Primary fact table

2. company_dim
   - Company information
   - One company can have many job postings

3. skills_dim
   - Master list of skills
   - One skill can appear in many job postings

4. skills_job_dim
   - Bridge table
   - Resolves many-to-many relationship between
     job_postings_fact and skills_dim

Relationships
company_dim
(company_id PK)
      1
      |
      | company_id (FK)
      V
job_postings_fact
(job_id PK)

job_postings_fact
(job_id PK)
      1
      |
      | job_id (PK/FK)
      V
skills_job_dim
(job_id PK/FK,
 skill_id PK/FK)
      ^
      | skill_id (PK/FK)
      |
      1
skills_dim
(skill_id PK)

Schema Summary

company_dim
├─ company_id (PK)
├─ name
├─ link
├─ link_google
└─ thumbnail

job_postings_fact
├─ job_id (PK)
├─ company_id (FK)
├─ job_title_short
├─ job_title
├─ job_location
├─ job_via
├─ job_schedule_type
├─ job_work_from_home
├─ search_location
├─ job_posted_date
├─ job_no_degree_mention
├─ job_health_insurance
├─ job_country
├─ salary_rate
├─ salary_year_avg
└─ salary_hour_avg

skills_job_dim
├─ job_id (PK/FK)
└─ skill_id (PK/FK)

skills_dim
├─ skill_id (PK)
├─ skills
└─ type
==============================================================*/



/*==============================================================
PROJECT #2: GIT WORKFLOW

Branch Strategy

main
└─ Production branch
   └─ Receives completed project after final merge

develop/project-2
└─ Integration branch
   ├─ Merge Warehouse
   ├─ Merge Flat DM
   ├─ Merge Skill DM
   ├─ Merge Priority DM
   └─ Project Merge → main

Feature Branches

feature/data-warehouse
├─ Create Tables
├─ Load Data
└─ Build Script

feature/flat-mart
├─ Build Flat
└─ Update Script

feature/skill-mart
├─ Build Skill DM
└─ Update Script

feature/priority-mart
├─ Build Priority DM
└─ Update Script

Workflow Timeline

main
└─ Initial Commit
      │
      ▼
develop/project-2
├─ Initial Commit
├─ Merge Warehouse
├─ Merge Flat DM
├─ Merge Skill DM
├─ Merge Priority DM
└─ Project Merge → main

Development Flow

feature/data-warehouse
Create Tables
      ↓
Load Data
      ↓
Build Script
      ↓
Merge Warehouse

feature/flat-mart
Build Flat
      ↓
Update Script
      ↓
Merge Flat DM

feature/skill-mart
Build Skill DM
      ↓
Update Script
      ↓
Merge Skill DM

feature/priority-mart
Build Priority DM
      ↓
Update Script
      ↓
Merge Priority DM

Summary

main
├─ Stable production branch

develop/project-2
├─ Integration branch
├─ Receives completed features
└─ Merged into main after project completion

feature/*
├─ Isolated development
├─ One feature per branch
└─ Merged into develop when complete
==============================================================*/

