using DotNetNuke.Common;
using DotNetNuke.Common.Utilities;
using DotNetNuke.Data;
using DotNetNuke.Entities.Modules;
using DotNetNuke.Entities.Modules.Actions;
using DotNetNuke.Security;
using DotNetNuke.Services.Exceptions;
using DotNetNuke.Services.Localization;
using Microsoft.ApplicationBlocks.Data;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.IO;
using Vivaan.ModulesEmployeeTimeReport;

namespace Vivaan.ModulesEmployeeTimeReport
{
    public partial class View : EmployeeTimeReportModuleBase, IActionable
    {
        protected void Page_Load(object sender, EventArgs e)
        {
            try
            {
                if (!IsPostBack)
                {
                    gvLogs.DataSource = null;
                    gvLogs.DataBind();
                }
            }
            catch (Exception exc)
            {
                Exceptions.ProcessModuleLoadException(this, exc);
            }
        }

        protected void btnUpload_Click(object sender, EventArgs e)
        {
            if (!fuUpload.HasFile)
            {
                lblMessage.Text = "Please select a file to upload.";
                lblMessage.ForeColor = System.Drawing.Color.Red;
                return;
            }

            try
            {
                int inserted = 0, skipped = 0;

                using (var reader = new StreamReader(fuUpload.FileContent))
                {
                    while (!reader.EndOfStream)
                    {
                        var line = reader.ReadLine();
                        if (string.IsNullOrWhiteSpace(line) || !line.Contains("Granted Entry")) continue;
                        if (line.StartsWith("Event ID")) continue;

                        try
                        {
                            string[] segments = line.Split('|');

                            string fieldTimeStr = segments.Length > 3 ? segments[3].Trim() : null;
                            if (!DateTime.TryParse(fieldTimeStr, out DateTime logTime)) continue;

                            string location = segments.Length > 6 ? segments[6].Trim() : "";

                            string description = segments.Length > 2 ? segments[2] : "";
                            string name = ExtractBetween(description, "User ", "(").Trim();

                            string checkQuery = @"
                                    SELECT COUNT(*) FROM EmployeeTimeLog
                                    WHERE EmployeeName = @name AND LogTime = @logTime AND Location = @location";

                            int exists = (int)SqlHelper.ExecuteScalar(
                                Config.GetConnectionString(), 
                                CommandType.Text,
                                checkQuery,
                                new SqlParameter("@name", name),
                                new SqlParameter("@logTime", logTime),
                                new SqlParameter("@location", location)
                            );

                            if (exists == 0)
                            {
                                string insertQuery = @"
                                        INSERT INTO EmployeeTimeLog (EmployeeName, LogTime, Location)
                                        VALUES (@name, @logTime, @location)";
                                SqlHelper.ExecuteNonQuery(
                                    Config.GetConnectionString(), 
                                    CommandType.Text,
                                    insertQuery,
                                    new SqlParameter("@name", name),
                                    new SqlParameter("@logTime", logTime),
                                    new SqlParameter("@location", location)
                                );
                                inserted++;
                            }
                            else
                            {
                                skipped++;
                            }
                        }
                        catch
                        {
                            continue;
                        }
                    }
                }

                lblMessage.Text = $"{inserted} new record(s) uploaded. {skipped} duplicate(s) skipped.";
                lblMessage.ForeColor = System.Drawing.Color.Green;
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error uploading file: " + ex.Message;
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
        }

        protected void btnGenerateReport_Click(object sender, EventArgs e)
        {
            GenerateOrDownloadReport(download: false);
        }

        protected void btnDownloadReport_Click(object sender, EventArgs e)
        {
            GenerateOrDownloadReport(download: true);
        }

        private void GenerateOrDownloadReport(bool download)
        {
            try
            {
                if (!DateTime.TryParse(txtStartDate.Text, out DateTime startDate) ||
                    !DateTime.TryParse(txtEndDate.Text, out DateTime endDate))
                {
                    lblMessage.Text = "Please enter a valid date range.";
                    return;
                }

                string employeeName = txtEmployeeName.Text.Trim();
                string locationInput = txtLocation.Text.Trim();
                string startTimeStr = txtStartTime.Text.Trim();
                string endTimeStr = txtEndTime.Text.Trim();

                bool hasStartTime = TimeSpan.TryParse(startTimeStr, out TimeSpan startTime);
                bool hasEndTime = TimeSpan.TryParse(endTimeStr, out TimeSpan endTime);

                string whereClause = "WHERE CAST(LogTime AS DATE) BETWEEN @startDate AND @endDate";
                var parameters = new List<SqlParameter>
        {
            new SqlParameter("@startDate", startDate),
            new SqlParameter("@endDate", endDate)
        };

                if (!string.IsNullOrEmpty(employeeName))
                {
                    whereClause += " AND EmployeeName LIKE @employeeName";
                    parameters.Add(new SqlParameter("@employeeName", "%" + employeeName + "%"));
                }

                if (!string.IsNullOrEmpty(locationInput))
                {
                    whereClause += " AND Location LIKE @location";
                    parameters.Add(new SqlParameter("@location", "%" + locationInput + "%"));
                }

                string havingClause = "";

                if (hasStartTime && hasEndTime)
                {
                    havingClause = "HAVING CAST(MIN(LogTime) AS TIME) BETWEEN @startTime AND @endTime";
                    parameters.Add(new SqlParameter("@startTime", startTime));
                    parameters.Add(new SqlParameter("@endTime", endTime));
                }
                else if (hasStartTime)
                {
                    havingClause = "HAVING CAST(MIN(LogTime) AS TIME) >= @startTime";
                    parameters.Add(new SqlParameter("@startTime", startTime));
                }
                else if (hasEndTime)
                {
                    havingClause = "HAVING CAST(MIN(LogTime) AS TIME) <= @endTime";
                    parameters.Add(new SqlParameter("@endTime", endTime));
                }

                string query = $@"
            WITH RankedLogs AS (
                SELECT 
                    EmployeeName,
                    CONVERT(VARCHAR, CAST(LogTime AS DATE), 101) AS ReportDate,
                    MIN(LogTime) AS TimeIn
                FROM EmployeeTimeLog
                {whereClause}
                GROUP BY EmployeeName, CAST(LogTime AS DATE)
                {havingClause}
            )
            SELECT rl.EmployeeName, rl.ReportDate, 
                   CONVERT(VARCHAR, rl.TimeIn, 108) AS TimeIn,
                   etl.Location
            FROM RankedLogs rl
            JOIN EmployeeTimeLog etl
              ON etl.EmployeeName = rl.EmployeeName
             AND CAST(etl.LogTime AS DATE) = CAST(rl.TimeIn AS DATE)
             AND etl.LogTime = rl.TimeIn
            ORDER BY rl.ReportDate DESC, rl.EmployeeName";

                var dt = SqlHelper.ExecuteDataset(
                    Globals.GetDBConnectionString(),
                    CommandType.Text,
                    query,
                    parameters.ToArray()
                ).Tables[0];

                if (download)
                {
                    if (dt.Rows.Count == 0)
                    {
                        lblMessage.Text = "No records found to export.";
                        return;
                    }

                    System.Text.StringBuilder csv = new System.Text.StringBuilder();
                    foreach (DataColumn col in dt.Columns)
                    {
                        csv.Append(col.ColumnName + ",");
                    }
                    csv.Length--;
                    csv.AppendLine();

                    foreach (DataRow row in dt.Rows)
                    {
                        foreach (var item in row.ItemArray)
                        {
                            csv.Append("\"" + item.ToString().Replace("\"", "\"\"") + "\",");

                        }
                        csv.Length--;
                        csv.AppendLine();
                    }

                    string fileName = $"TimeReport_{DateTime.Now:yyyyMMdd_HHmmss}.csv";

                    Response.Clear();
                    Response.ContentType = "text/csv";
                    Response.AddHeader("Content-Disposition", "attachment; filename=" + fileName);
                    Response.Write(csv.ToString());
                    Response.End();
                }
                else
                {
                    gvLogs.DataSource = dt;
                    gvLogs.DataBind();

                    
                    var scatterPoints = new List<string>();
                    foreach (DataRow row in dt.Rows)
                    {
                        string date = row["ReportDate"].ToString();
                        string employee = row["EmployeeName"].ToString().Replace("'", "\\'");
                        if (TimeSpan.TryParse(row["TimeIn"].ToString(), out TimeSpan timeIn))
                        {
                            int minutes = (int)timeIn.TotalMinutes;
                            scatterPoints.Add($"{{ x: '{date}', y: {minutes}, employee: '{employee}' }}");
                        }
                    }

                    string chartScript = $@"
<script>
document.addEventListener('DOMContentLoaded', function () {{
    var ctx = document.getElementById('loginChart').getContext('2d');
    new Chart(ctx, {{
        type: 'scatter',
        data: {{
            datasets: [{{
                label: 'First Logins',
                data: [{string.Join(",", scatterPoints)}],
                backgroundColor: '#3b82f6'
            }}]
        }},
        options: {{
            responsive: true,
            plugins: {{
                tooltip: {{
                    callbacks: {{
                        label: function(context) {{
                            var point = context.raw;
                            let hours = Math.floor(point.y / 60);
                            let minutes = point.y % 60;
                            let time = hours.toString().padStart(2, '0') + ':' + minutes.toString().padStart(2, '0');
                            return point.employee + ' @ ' + time;
                        }}
                    }}
                }},
                legend: {{
                    display: false
                }}
            }},
            scales: {{
                x: {{
                    type: 'category',
                    title: {{
                        display: true,
                        text: 'Date'
                    }},
                    ticks: {{
                        autoSkip: false
                    }}
                }},
                y: {{
                    title: {{
                        display: true,
                        text: 'Time of Day'
                    }},
                    ticks: {{
                        callback: function(value) {{
                            let hours = Math.floor(value / 60);
                            let minutes = value % 60;
                            return hours.toString().padStart(2, '0') + ':' + minutes.toString().padStart(2, '0');
                        }},
                        stepSize: 60
                    }}
                }}
            }}
        }}
    }});
}});
</script>";

                    ltChartData.Text = chartScript;

                    lblMessage.Text = $"{dt.Rows.Count} record(s) found.";
                    lblMessage.ForeColor = System.Drawing.Color.Green;
                }
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error processing report: " + ex.Message;
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
        }


        private string ExtractBetween(string source, string start, string end)
        {
            int startIndex = source.IndexOf(start);
            if (startIndex == -1) return "";
            startIndex += start.Length;
            int endIndex = source.IndexOf(end, startIndex);
            if (endIndex == -1) return "";
            return source.Substring(startIndex, endIndex - startIndex);
        }

        public ModuleActionCollection ModuleActions
        {
            get
            {
                var actions = new ModuleActionCollection
                {
                    {
                        GetNextActionID(),
                        Localization.GetString("EditModule", LocalResourceFile),
                        "",
                        "",
                        "",
                        EditUrl(),
                        false,
                        SecurityAccessLevel.Edit,
                        true,
                        false
                    }
                };
                return actions;
            }
        }
    }
}