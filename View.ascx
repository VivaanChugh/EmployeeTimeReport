<%@ Control Language="C#" AutoEventWireup="true" Inherits="Vivaan.ModEmployeeTimeReport.View" %>

<div class="employee-time-report-container">
    <!-- Header Section -->
    <div class="report-header">
        <h2 class="report-title">
            <i class="fas fa-clock"></i>
            Employee Time Report Management
        </h2>
        <p class="report-subtitle">Upload time logs and generate comprehensive reports</p>
    </div>

    <!-- Upload Section -->
    <div class="upload-section">
        <div class="section-header">
            <h4><i class="fas fa-upload"></i> Upload Time Logs</h4>
        </div>
        <div class="upload-controls">
            <div class="file-upload-wrapper">
                <asp:FileUpload ID="fuUpload" runat="server" CssClass="form-control file-input" />
                <div class="file-upload-hint">
                    <i class="fas fa-info-circle"></i>
                    Supported formats: Delimited txt files, Seperated by "|"
                </div>
            </div>
            <asp:Button ID="btnUpload" runat="server" Text="📤 Upload Time Logs" 
                       OnClick="btnUpload_Click" CssClass="btn btn-primary btn-upload" />
        </div>
    </div>

    <!-- Filter Section -->
    <div class="filter-section">
        <div class="section-header">
            <h4><i class="fas fa-filter"></i> Report Filters</h4>
        </div>
        <div class="filter-grid">
            <div class="filter-group">
                <asp:Label runat="server" Text="Employee Name" CssClass="filter-label" />
                <asp:TextBox ID="txtEmployeeName" runat="server" CssClass="form-control" 
                           placeholder="Enter employee name..." />
            </div>
            
            <div class="filter-group">
                <asp:Label runat="server" Text="Start Date" CssClass="filter-label" />
                <asp:TextBox ID="txtStartDate" runat="server" TextMode="Date" CssClass="form-control" />
            </div>
            
            <div class="filter-group">
                <asp:Label runat="server" Text="End Date" CssClass="filter-label" />
                <asp:TextBox ID="txtEndDate" runat="server" TextMode="Date" CssClass="form-control" />
            </div>
            
            <div class="filter-group">
                <asp:Label runat="server" Text="Report Type" CssClass="filter-label" />
                <asp:DropDownList ID="ddlReportType" runat="server" CssClass="form-select">
                    <asp:ListItem Text="Daily" Value="daily" />
                    <asp:ListItem Text="Weekly" Value="weekly" />
                    <asp:ListItem Text="Monthly" Value="monthly" />
                </asp:DropDownList>
            </div>
        </div>
        
        <div class="action-buttons">
            <asp:Button ID="btnGenerateReport" runat="server" Text="📊 Generate Report" 
                       OnClick="btnGenerateReport_Click" CssClass="btn btn-success btn-action" />
            <asp:Button ID="btnDownloadReport" runat="server" Text="💾 Download CSV" 
                       OnClick="btnDownloadReport_Click" CssClass="btn btn-secondary btn-action" />
        </div>
    </div>

    <!-- Message Section -->
    <div class="message-section">
        <asp:Label ID="lblMessage" runat="server" CssClass="alert-message"></asp:Label>
    </div>

    <!-- Results Section -->
    <div class="results-section">
        <div class="section-header">
            <h4><i class="fas fa-table"></i> Time Log Results</h4>
        </div>
        <div class="table-wrapper">
            <asp:GridView ID="gvLogs" runat="server" AutoGenerateColumns="false" 
                         CssClass="table table-modern" GridLines="None">
                <HeaderStyle CssClass="table-header" />
                <RowStyle CssClass="table-row" />
                <AlternatingRowStyle CssClass="table-row table-row-alt" />
                <Columns>
                    <asp:BoundField DataField="EmployeeName" HeaderText="Employee Name" 
                                   ItemStyle-CssClass="employee-name" />
                    <asp:BoundField DataField="ReportDate" HeaderText="Date" 
                                   ItemStyle-CssClass="report-date" />
                    <asp:BoundField DataField="TimeIn" HeaderText="Time In" 
                                   ItemStyle-CssClass="time-in" />
                    <asp:BoundField DataField="Location" HeaderText="Location" 
                                   ItemStyle-CssClass="location" HtmlEncode="true" />
                </Columns>
            </asp:GridView>
        </div>
    </div>
</div>

<style>
    /* Container Styles */
    .employee-time-report-container {
        max-width: 1200px;
        margin: 0 auto;
        padding: 20px;
        font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
        background: #f8f9fa;
        min-height: 100vh;
    }

    /* Header Styles */
    .report-header {
        text-align: center;
        margin-bottom: 30px;
        padding: 20px;
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
        border-radius: 12px;
        box-shadow: 0 4px 15px rgba(0,0,0,0.1);
    }

    .report-title {
        margin: 0 0 10px 0;
        font-size: 2.2rem;
        font-weight: 600;
    }

    .report-title i {
        margin-right: 10px;
        color: #ffd700;
    }

    .report-subtitle {
        margin: 0;
        font-size: 1.1rem;
        opacity: 0.9;
    }

    /* Section Styles */
    .upload-section, .filter-section, .results-section {
        background: white;
        border-radius: 12px;
        padding: 25px;
        margin-bottom: 25px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.08);
        border: 1px solid #e9ecef;
    }

    .section-header {
        margin-bottom: 20px;
        padding-bottom: 10px;
        border-bottom: 2px solid #e9ecef;
    }

    .section-header h4 {
        margin: 0;
        color: #495057;
        font-size: 1.3rem;
        font-weight: 600;
    }

    .section-header i {
        margin-right: 8px;
        color: #6c757d;
    }

    /* Upload Section */
    .upload-controls {
        display: flex;
        align-items: flex-end;
        gap: 15px;
        flex-wrap: wrap;
    }

    .file-upload-wrapper {
        flex: 1;
        min-width: 300px;
    }

    .file-upload-hint {
        font-size: 0.85rem;
        color: #6c757d;
        margin-top: 5px;
    }

    .file-upload-hint i {
        margin-right: 5px;
    }

    /* Filter Section */
    .filter-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(250px, 1fr));
        gap: 20px;
        margin-bottom: 25px;
    }

    .filter-group {
        display: flex;
        flex-direction: column;
    }

    .filter-label {
        font-weight: 600;
        color: #495057;
        margin-bottom: 5px;
        font-size: 0.95rem;
    }

    .action-buttons {
        display: flex;
        gap: 15px;
        justify-content: center;
        flex-wrap: wrap;
    }

    /* Form Controls */
    .form-control, .form-select {
        padding: 12px 15px;
        border: 2px solid #e9ecef;
        border-radius: 8px;
        font-size: 1rem;
        transition: all 0.3s ease;
        background: white;
    }

    .form-control:focus, .form-select:focus {
        border-color: #667eea;
        box-shadow: 0 0 0 3px rgba(102, 126, 234, 0.1);
        outline: none;
    }

    .form-control::placeholder {
        color: #adb5bd;
    }

    /* Button Styles */
    .btn {
        padding: 12px 24px;
        border: none;
        border-radius: 8px;
        font-size: 1rem;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.3s ease;
        text-decoration: none;
        display: inline-block;
        min-width: 160px;
        text-align: center;
    }

    .btn-primary {
        background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
        color: white;
    }

    .btn-primary:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 15px rgba(102, 126, 234, 0.4);
    }

    .btn-success {
        background: linear-gradient(135deg, #56ab2f 0%, #a8e6cf 100%);
        color: white;
    }

    .btn-success:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 15px rgba(86, 171, 47, 0.4);
    }

    .btn-secondary {
        background: linear-gradient(135deg, #6c757d 0%, #adb5bd 100%);
        color: white;
    }

    .btn-secondary:hover {
        transform: translateY(-2px);
        box-shadow: 0 4px 15px rgba(108, 117, 125, 0.4);
    }

    /* Message Styles */
    .message-section {
        margin: 20px 0;
    }

    .alert-message {
        display: block;
        padding: 12px 20px;
        border-radius: 8px;
        font-weight: 500;
        background: #f8d7da;
        color: #721c24;
        border: 1px solid #f5c6cb;
    }

    .alert-message:empty {
        display: none;
    }

    /* Table Styles - Fixed */
    .table-wrapper {
        overflow-x: auto;
        border-radius: 8px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.1);
    }

    .table-modern {
        width: 100%;
        border-collapse: collapse;
        background: white;
        margin: 0;
    }

    .table-header {
        background: linear-gradient(135deg, #495057 0%, #6c757d 100%);
        color: white;
        font-weight: 600;
        text-align: center;
    }

    .table-header th {
        padding: 15px 20px;
        border: none;
        font-size: 0.95rem;
        letter-spacing: 0.5px;
        text-align: center;
    }

    .table-row td {
        padding: 15px 20px;
        border-bottom: 1px solid #e9ecef;
        text-align: center;
        vertical-align: middle;
        background: white;
    }

    .table-row-alt td {
        background: #f8f9fa !important;
    }

    .table-modern tr:hover td {
        background: #e3f2fd !important;
        transition: background 0.3s ease;
    }

    /* Column-specific styles */
    .employee-name {
        font-weight: 600;
        color: #495057;
        text-align: center;
    }

    .report-date {
        color: #6c757d;
        font-family: 'Courier New', monospace;
        text-align: center;
    }

    .time-in {
        color: #28a745;
        font-weight: 500;
        text-align: center;
    }

    .location {
        color: #6c757d;
        max-width: 250px;
        word-wrap: break-word;
        text-align: center;
    }

    /* Responsive Design */
    @media (max-width: 768px) {
        .employee-time-report-container {
            padding: 15px;
        }

        .report-title {
            font-size: 1.8rem;
        }

        .upload-controls {
            flex-direction: column;
            align-items: stretch;
        }

        .action-buttons {
            flex-direction: column;
        }

        .btn {
            width: 100%;
        }

        .filter-grid {
            grid-template-columns: 1fr;
        }
    }

    /* Loading Animation */
    .btn:disabled {
        opacity: 0.6;
        cursor: not-allowed;
    }

    /* Focus Styles for Accessibility */
    .btn:focus, .form-control:focus, .form-select:focus {
        outline: 2px solid #667eea;
        outline-offset: 2px;
    }
</style>

<!-- Font Awesome for Icons (add this to your page head if not already included) -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">