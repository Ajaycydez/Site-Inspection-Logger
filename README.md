# Site Inspection Logger

A Flutter application designed to help construction site staff log safety issues and allow safety officers to review, track, and resolve them.

## Overview

The Site Inspection Logger app digitizes the process of reporting and resolving safety issues on-site.
It comes with two user roles:

### Staff

Logs new safety issues.

Views all previously logged issues.

### Safety Officer

Monitors all issues.

Filters issues (All, Pending, Resolved).

Marks issues as “Safe” after verification.

All issue data is stored locally using SharedPreferences.




## Login Credentials

### Staff Credentials
Staff   : 	staff@gmail.com  | Staff@123

### Officer Credentials
Officer	: officer@gmail.com	 | Officer@123



## App Modules & Working Flow

1️⃣ Login Flow

User enters email and password

App checks credentials

Redirects:

Staff → Staff Dashboard

Officer → Safety Officer Dashboard

2️⃣ Staff Workflow

Login

Click Log Issue

Fill out safety issue form

Issue saved locally (status = Pending)

Appears on Officer’s dashboard instantly

3️⃣ Safety Officer Workflow

Login

Dashboard displays statistics

Tap any card → View filtered issues

Swipe right on Pending issue → Mark Safe

Issue moves to Resolved list

## Local Data Storage

All data is stored locally using SharedPreferences, where each issue includes:

🆔 ID

📝 Description

🔥 Severity

⚠️ Status (Pending / Safe)

⏰ Timestamp

👤 Reported By











