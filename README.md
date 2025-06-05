# 🕒 Employee Time Report Module for DNN

A custom intranet module for **DotNetNuke (DNN)** built in **C# and ASP.NET WebForms**. Designed for internal use by HR and IT teams to track employee time-in logs.

---

## 🎯 Features

- 📤 IT uploads semi-structured employee login logs via `.txt` files.
- 📅 HR generates **daily, weekly, or monthly** reports.
- 🔎 Filters for:
  - Employee Name
  - Date Range
  - Report Type (Daily, Weekly, Monthly)
  - Branch/Controller
  - Time of Day (e.g., Morning, Afternoon)
- 📊 Visual chart:
  - Scatter plot of first login time per employee per day
  - Hover tooltip shows employee names
- 💾 Upload validation and real-time report rendering

---

## 🧰 Technologies Used

- **DNN 10+** (DotNetNuke CMS)
- **ASP.NET WebForms**
- **C# (.NET Framework 4.x)**
- **System.Web.UI**
- **Google Charts** (for visual report)
- **SQL Server** (DNN-integrated database)

---

## 📁 Folder Structure

- /DesktopModules/EmployeeTimeReport/
- │
- ├── View.ascx # Main UI markup
- ├── View.ascx.cs # Backend code-behind logic
- ├── View.ascx.designer.cs # Designer file for controls
- ├── EmployeeLogParser.cs # Logic to parse uploaded text files
- ├── Scripts/ # JavaScript + Google Chart integration
- ├── Styles/ # Custom CSS (optional)

---

## 🧑‍💻 IT Upload Instructions

1. Go to the **IT Upload Panel** in the module.
2. Upload a `.txt` file containing logs in the following format:

Date: 2025-06-05
Event ID: 4624
User: jdoe
Time: 08:45:12
Location: Toronto
Controller: BranchA

3. On success, logs are stored in the module database.

---

## 👩‍💼 HR Report Instructions

1. Go to the **Report Generation Panel**.
2. Fill in filters:

- Employee Name (optional)
- Start Date / End Date
- Report Type (Daily/Weekly/Monthly)
- Branch (optional)
- Time of Day filter (e.g., before/after 9 AM)

3. Click **Generate Report**.
4. Review results in:

- **Table View**: With columns for Date, Time In, Location, etc.
- **Graph View**: Scatter plot of first login times

---

## 📊 Chart Details

- **X-axis**: Dates within selected range
- **Y-axis**: Login time of day (formatted as time)
- **Dots**: One per employee's first login per day
- **Hover tooltip**: Displays employee name

---

## ⚙️ Setup & Deployment

1. Place module files in:

~/DesktopModules/EmployeeTimeReport/

2. Register the module via DNN Host → Extensions.
3. Add the module to a page via **Add Module**.
4. Ensure file upload permissions are granted to the app pool user (e.g., `IIS APPPOOL\DNN10`).

---

## 🔐 Security

- Uploads are validated for type and format.
- Only `.txt` files are accepted.
- No external file system operations beyond scoped folders.

---

## 🧪 Example Use Case

| Name       | Date       | Time In | Branch  | Location |
| ---------- | ---------- | ------- | ------- | -------- |
| John Doe   | 2025-06-03 | 08:45   | BranchA | Toronto  |
| Jane Smith | 2025-06-03 | 09:03   | BranchB | Calgary  |

---

## 📌 Notes

- DNN handles DB access via `DataProvider` and stored procedures.
- Use `gvLogs` GridView control for displaying data.
- Optional: Add export to CSV or PDF in future versions.

---

## 🧭 Future Enhancements

- [ ] Add export button for HR reports.
- [ ] Allow editing/deleting log entries.
- [ ] Role-based access control (IT vs HR).
- [ ] Switch to MVC or Blazor for modern architecture.
