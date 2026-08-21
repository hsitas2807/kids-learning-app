# Database Schema

## Local Storage Schema

This project currently uses SharedPreferences-backed JSON models instead of a generated database layer so the repository stays buildable without code generation.

### child_profile
| Field | Type | Description |
|------|------|-------------|
| id | INTEGER | Local profile identifier |
| name | TEXT | Child nickname |
| age | INTEGER | Age 3-8 |
| avatarId | INTEGER | Selected avatar index |
| learningLevel | INTEGER | 1=Beginner, 2=Explorer, 3=Champion |
| ageGroup | TEXT | '3-4', '5-6', '7-8' |

### rewards_{childId}
| Field | Type | Description |
|------|------|-------------|
| childId | INTEGER | Profile identifier |
| stars | INTEGER | Total stars |
| coins | INTEGER | Total coins |
| streakDays | INTEGER | Current streak |

### progress_{childId}
| Field | Type | Description |
|------|------|-------------|
| lessonId | INTEGER | Lesson identifier |
| accuracy | REAL | 0.0 to 1.0 |
| starsEarned | INTEGER | Stars from this lesson |
| completedAt | TEXT | ISO-8601 completion time |
