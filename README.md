#  Weekly System Report

A Bash script that automatically collects system metrics and generates a weekly report with warnings for critical resource usage.

---

##  Features

- Monitors **CPU usage** over 60 seconds and calculates average
- Tracks **RAM usage** (used / total)
- Checks **disk usage** on all mounted partitions
- Generates a **timestamped log file** per run
- Prints **[WARNING]** if disk usage exceeds 80%
- Automated weekly execution via **cron** (every Monday at 08:00)

---

##  Project Structure

weekly-report/
├── weekly_report.sh     # Main script
└── README.md

---

##  Requirements

- Linux (Ubuntu 20.04+ recommended)
- Bash 4+
- Standard utilities: top, free, df, bc, awk

---

##  Setup

### 1. Clone the repository

git clone https://github.com/suNWay475/auto_checkDisk.git
cd weekly-report

### 2. Make the script executable

chmod +x weekly_report.sh

### 3. Run manually to test

./weekly_report.sh

The report will be saved to:

~/var/log/weekly_raport_DD.MM.YYYY.txt

---

##  Automate with Cron

To run the script automatically every Monday at 08:00, add it to your crontab:

crontab -e

Add this line at the bottom:

0 8 * * 1 /full/path/to/weekly_report.sh

Tip: Use an absolute path to the script to avoid PATH issues inside cron.

### Cron syntax reference

┌─ minute        (0–59)
│ ┌─ hour          (0–23)
│ │ ┌─ day of month  (1–31)
│ │ │ ┌─ month         (1–12)
│ │ │ │ ┌─ day of week   (0=Sun, 1=Mon ... 6=Sat)
│ │ │ │ │
0 8 * * 1  /home/user/weekly-report/weekly_report.sh

### Verify cron is set

crontab -l

---

##  Sample Output

[08:00:01] [CPU:2.3] | [Mem:512/1994 MB] [AVG:1.8]
[08:00:02] [WARNING] DISK USAGE 85

---

##  Skills Practiced

- Bash scripting (set -euo pipefail, functions, loops)
- System monitoring (top, free, df)
- Text processing (awk, tr, bc)
- Cron job scheduling
- Logging to files with tee

---

## 👤 Author

**Vitaliy** — Junior DevOps learner building hands-on Linux skills.