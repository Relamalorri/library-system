# Jeddah Central Library Management System

A relational database system designed to automate and manage library operations 
including book inventory, member management, borrowing records, reservations, 
fees, and events.

> CPCS-241: Database I | King Abdulaziz University | Spring 2021  
> This was a group project for Database course
---

## The Problem

Manual library management is error-prone and inefficient. Tracking book 
availability, member borrowing history, overdue fees, and reservations manually 
leads to data loss and inconsistency. This system provides a fully automated 
database solution for all library operations.

---

## Database Design

The system manages 11 core entities:

| Entity | Description |
|---|---|
| Members | Library members with contact info |
| Books | Book inventory with ISBN and availability |
| Employees | Staff with roles, shifts, and salaries |
| Authors | Book authors linked via M-N relationship |
| Categories | Book genre classification |
| Borrowing Records | Full borrowing history with loan duration and condition |
| Reservations | Book reservation with 48-hour expiry rule |
| Fee Amount | Overdue and replacement fees |
| Book Purchases | Member book purchases (non-returnable) |
| Events | Library events organized by employees |
| Membership | Member registration and expiry tracking |

---

## Key Business Rules

- Books loaned for exactly 21 days
- Maximum 3 active loans per member
- Overdue fees calculated at $1 per day
- Fines must be settled before borrowing again
- Reservations expire after 48 hours if uncollected
- Only admin users can modify records
- Purchased books cannot be returned
- Lost or damaged books incur replacement fees

---

## Repository Contents

| Folder | Contents |
|---|---|
| `sql/` | All CREATE TABLE scripts, constraints, triggers, and queries |
| `diagrams/` | ER diagram and final schema diagram |
| `docs/` | Normalization documentation (1NF, 2NF, 3NF) |

---

## Tech Stack

Oracle SQL · Relational Database Design · ER Modelling · Normalization
