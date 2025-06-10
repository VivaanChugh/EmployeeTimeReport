# EmployeeTimeReport – DNN Module

**EmployeeTimeReport** is a custom DotNetNuke (DNN) module that allows IT staff to upload employee login data and lets HR generate daily, weekly, or monthly reports showing the **first login (Time In)** per employee. The module also supports filtering by date, time of day, employee name, and location, and displays results both in tabular form and as a scatter plot chart.

---

## 🚀 Features

- Upload semi-structured text logs containing employee entry events.
- Extract and store:
  - Employee name
  - Log-in time
  - Location
- Prevent duplicate log entries (same name, time, and location).
- Generate tabular login reports filtered by:
  - Date range
  - Time of day (start/end)
  - Employee name (partial match)
  - Location (partial match)
- Scatter chart view of first login time per employee per day.
- Download report as CSV.

---

## 🗂 File Structure

DesktopModules/
- └── EmployeeTimeReport/
- ├── View.ascx / View.ascx.cs # UI & logic for upload/report
- ├── Settings.ascx / Settings.ascx.cs # Optional module settings
- ├── SqlDataProvider.cs # SQL data access
- ├── EmployeeTimeReportModuleBase.cs # Shared base class
- ├── FeatureController.cs # IPortable, ISearchable, etc.
- ├── Resources/
- └── App_LocalResources/


---

## ⚙️ Setup Instructions

### Prerequisites

- DotNetNuke v10.0.1 or later
- .NET Framework 4.8
- Visual Studio 2022
- A local DNN instance (e.g., `C:\inetpub\wwwroot\DNN`)

### Installation Steps

1. Place the module folder in:
C:\inetpub\wwwroot\DNN\DesktopModules\EmployeeTimeReport

2. Add the project to your DNN solution in Visual Studio.

3. Add references to DNN assemblies from:
C:\inetpub\wwwroot\DNN\bin\

4. Set `Copy Local = False` for all DNN references.

5. Build the module in `Debug | Any CPU`.

6. Register the module from the DNN Host > Extensions page (if not already done).

7. Add the module to a page and begin using.

---

## 📤 Upload Format

The module expects a plain text log file where relevant entries contain the string `"Granted Entry"`.

Each line should follow a format like:
123456 | 2023-12-01 08:34 | User John Doe (12345) Granted Entry | 12/01/2023 08:34:12 | Other | Fields | Location


> **Note:** Parsing logic is customizable in `btnUpload_Click` method.

---

## 📈 Report Filters

Users can filter report data using:

| Field           | Description                                  |
|----------------|----------------------------------------------|
| Start/End Date | Date range to include in report              |
| Start Time     | Only include first logins **after** this time |
| End Time       | Only include first logins **before** this time |
| Name           | Partial match on employee name               |
| Location       | Partial match on login location              |

---

## 📊 Chart View

- Shows a **scatter plot** with:
  - X-axis: Date
  - Y-axis: Time of day (in HH:mm format)
  - Tooltip: Shows employee name and time
- Powered by Chart.js

---

## 🧪 Validations

- Only lines with `"Granted Entry"` are processed.
- Duplicates (same name, time, location) are skipped.
- Invalid lines are safely ignored without crashing.

---

## 🧾 Sample Query Output

| Employee Name | Report Date | Time In | Location  |
|---------------|-------------|---------|-----------|
| John Doe      | 06/10/2025  | 08:45   | LocationA |
| Jane Smith    | 06/10/2025  | 09:12   | LocationB |

---

## 📄 License

This project is proprietary and intended for internal use.

---

## 👨‍💻 Author

**Vivaan Chugh**  
Computer Engineering, University of Waterloo  




