using DotNetNuke.Common.Utilities;
using DotNetNuke.Entities.Modules;
using DotNetNuke.Entities.Modules.Actions;
using DotNetNuke.Security;
using DotNetNuke.Services.Exceptions;
using DotNetNuke.Services.Localization;
using System;
using System.Collections.Generic;
using System.Data;
using DotNetNuke.Data;
using DotNetNuke.Common;
using System.Data.SqlClient;
using System.IO;
using Microsoft.ApplicationBlocks.Data;

namespace Vivaan.ModEmployeeTimeReport
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

                            // ✅ Check for duplicates
                            string checkQuery = @"
                                SELECT COUNT(*) FROM EmployeeTimeLog
                                WHERE EmployeeName = @name AND LogTime = @logTime AND Location = @location";

                            int exists = (int)SqlHelper.ExecuteScalar(
                                Globals.GetDBConnectionString(),
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
                                    Globals.GetDBConnectionString(),
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
            try
            {
                if (!DateTime.TryParse(txtStartDate.Text, out DateTime startDate) ||
                    !DateTime.TryParse(txtEndDate.Text, out DateTime endDate))
                {
                    lblMessage.Text = "Please enter a valid date range.";
                    return;
                }

                string employeeName = txtEmployeeName.Text.Trim();
                string whereClause = "WHERE LogTime BETWEEN @startDate AND @endDate";
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

                string query = $@"
                    WITH RankedLogs AS (
                        SELECT 
                            EmployeeName,
                            CONVERT(VARCHAR, CAST(LogTime AS DATE), 101) AS ReportDate,
                            MIN(LogTime) AS TimeIn,
                            Location
                        FROM EmployeeTimeLog
                        {whereClause}
                        GROUP BY EmployeeName, CAST(LogTime AS DATE), Location
                    )
                    SELECT EmployeeName, ReportDate, CONVERT(VARCHAR, TimeIn, 108) AS TimeIn, Location
                    FROM RankedLogs
                    ORDER BY ReportDate DESC, EmployeeName";

                var dt = SqlHelper.ExecuteDataset(
                    Globals.GetDBConnectionString(),
                    CommandType.Text,
                    query,
                    parameters.ToArray()
                ).Tables[0];

                gvLogs.DataSource = dt;
                gvLogs.DataBind();

                lblMessage.Text = $"{dt.Rows.Count} record(s) found.";
                lblMessage.ForeColor = System.Drawing.Color.Green;
            }
            catch (Exception ex)
            {
                lblMessage.Text = "Error generating report: " + ex.Message;
                lblMessage.ForeColor = System.Drawing.Color.Red;
            }
        }

        protected void btnDownloadReport_Click(object sender, EventArgs e)
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
                string whereClause = "WHERE LogTime BETWEEN @startDate AND @endDate";
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

                string query = $@"
                    WITH RankedLogs AS (
                        SELECT 
                            EmployeeName,
                            CONVERT(VARCHAR, CAST(LogTime AS DATE), 101) AS ReportDate,
                            MIN(LogTime) AS TimeIn,
                            Location
                        FROM EmployeeTimeLog
                        {whereClause}
                        GROUP BY EmployeeName, CAST(LogTime AS DATE), Location
                    )
                    SELECT EmployeeName, ReportDate, CONVERT(VARCHAR, TimeIn, 108) AS TimeIn, Location
                    FROM RankedLogs
                    ORDER BY ReportDate DESC, EmployeeName";

                var dt = SqlHelper.ExecuteDataset(
                    Globals.GetDBConnectionString(),
                    CommandType.Text,
                    query,
                    parameters.ToArray()
                ).Tables[0];

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
            catch (Exception ex)
            {
                lblMessage.Text = "Error generating download: " + ex.Message;
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
