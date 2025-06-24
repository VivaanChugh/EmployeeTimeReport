<%@ Control Language="C#" AutoEventWireup="true" Inherits="Vivaan.ModulesEmployeeTimeReport.View" %>

<div class="employee-time-report-container">
    <!-- Header Section -->
    <div class="report-header">
        <div class="header-content">
            <div class="header-icon">
                <i class="fas fa-business-time"></i>
            </div>
            <div class="header-text">
                <h1 class="report-title">Employee Time Report</h1>
                <p class="report-subtitle">Comprehensive time tracking and reporting system</p>
            </div>
        </div>
    </div>

    <!-- Main Content Grid -->
    <div class="content-grid">
        <!-- Upload Section -->
        <div class="card upload-card">
            <div class="card-header">
                <i class="fas fa-cloud-upload-alt"></i>
                <h3>Upload Time Logs</h3>
            </div>
            <div class="card-body">
                <div class="upload-area">
                    <asp:FileUpload ID="fuUpload" runat="server" CssClass="file-input" />
                    <div class="upload-info">
                        <i class="fas fa-info-circle"></i>
                        <span>Supported: Pipe-delimited text files (|)</span>
                    </div>
                </div>
                <asp:Button ID="btnUpload" runat="server" Text="Upload Files" 
                           OnClick="btnUpload_Click" CssClass="btn btn-primary btn-upload" />
            </div>
        </div>

        <!-- Filter Section -->
        <div class="card filter-card">
            <div class="card-header">
                <i class="fas fa-filter"></i>
                <h3>Report Filters</h3>
            </div>
            <div class="card-body">
                <div class="filter-grid">
                    <div class="input-group">
                        <label class="input-label">Employee Name</label>
                        <asp:TextBox ID="txtEmployeeName" runat="server" CssClass="form-input" 
                                   placeholder="Search by employee name..." />
                    </div>
                    
                    <div class="input-group">
                        <label class="input-label">Start Date</label>
                        <asp:TextBox ID="txtStartDate" runat="server" TextMode="Date" CssClass="form-input" />
                    </div>
                    
                    <div class="input-group">
                        <label class="input-label">End Date</label>
                        <asp:TextBox ID="txtEndDate" runat="server" TextMode="Date" CssClass="form-input" />
                    </div>

                    <div class="input-group">
                        <label class="input-label">Start Time</label>
                        <asp:TextBox ID="txtStartTime" runat="server" TextMode="Time" CssClass="form-input" />
                    </div>

                    <div class="input-group">
                        <label class="input-label">End Time</label>
                        <asp:TextBox ID="txtEndTime" runat="server" TextMode="Time" CssClass="form-input" />
                    </div>
                </div>

        

                <div class="input-group">
                    <label class="input-label">Location</label>
                    <asp:TextBox ID="txtLocation" runat="server" CssClass="form-input"
                 placeholder="Search by location..." />
                </div>


                
                <div class="action-bar">
                    <asp:Button ID="btnGenerateReport" runat="server" Text="Generate Report" 
                               OnClick="btnGenerateReport_Click" CssClass="btn btn-primary btn-upload" />
                    <asp:Button ID="btnDownloadReport" runat="server" Text="Export CSV" 
                               OnClick="btnDownloadReport_Click" CssClass="btn btn-primary btn-upload" />
                </div>
            </div>
        </div>
    </div>

    <!-- Message Section -->
    <asp:Label ID="lblMessage" runat="server" CssClass="alert-message"></asp:Label>

    <!-- Results Section -->
    <div class="card results-card">
        <div class="card-header">
            <i class="fas fa-table"></i>
            <h3>Time Log Results</h3>
        </div>
        <div class="card-body">
            <div class="table-container">
                <asp:GridView ID="gvLogs" runat="server" AutoGenerateColumns="false" 
                             CssClass="data-table" GridLines="None">
                    <HeaderStyle CssClass="table-header" />
                    <RowStyle CssClass="table-row" />
                    <AlternatingRowStyle CssClass="table-row table-row-alt" />
                    <Columns>
                        <asp:BoundField DataField="EmployeeName" HeaderText="Employee" 
                                       ItemStyle-CssClass="col-employee" />
                        <asp:BoundField DataField="ReportDate" HeaderText="Date" 
                                       ItemStyle-CssClass="col-date" />
                        <asp:BoundField DataField="TimeIn" HeaderText="Time In" 
                                       ItemStyle-CssClass="col-time" />
                        <asp:BoundField DataField="Location" HeaderText="Location" 
                                       ItemStyle-CssClass="col-location" HtmlEncode="true" />
                    </Columns>
                </asp:GridView>
                <canvas id="loginChart" width="100%" height="60"></canvas>
                <asp:Literal ID="ltChartData" runat="server" EnableViewState="false" />
                <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>


            </div>
        </div>

    </div>
</div>

<style>
    /* Reset and Base Styles */
    * {
        box-sizing: border-box;
    }

    .employee-time-report-container {
        max-width: 1400px;
        margin: 0 auto;
        padding: 24px;
        font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, sans-serif;
        background: #f7f9fc;
        min-height: 100vh;
        line-height: 1.6;
    }

    /* Header Styles */
    .report-header {
        background: linear-gradient(135deg, #2563eb 0%, #1d4ed8 100%);
        border-radius: 16px;
        padding: 32px;
        margin-bottom: 32px;
        box-shadow: 0 10px 25px rgba(37, 99, 235, 0.15);
        color: white;
    }

    .header-content {
        display: flex;
        align-items: center;
        gap: 20px;
    }

    .header-icon {
        font-size: 3rem;
        opacity: 0.9;
    }

    .header-text {
        flex: 1;
    }

    .report-title {
        margin: 0 0 8px 0;
        font-size: 2.5rem;
        font-weight: 700;
        letter-spacing: -0.025em;
    }

    .report-subtitle {
        margin: 0;
        font-size: 1.125rem;
        opacity: 0.9;
        font-weight: 400;
    }

    /* Content Grid */
    .content-grid {
        display: grid;
        grid-template-columns: 1fr 2fr;
        gap: 24px;
        margin-bottom: 24px;
    }

    /* Card Styles */
    .card {
        background: white;
        border-radius: 12px;
        box-shadow: 0 4px 6px rgba(0, 0, 0, 0.05);
        border: 1px solid #e5e7eb;
        overflow: hidden;
        transition: all 0.3s ease;
    }

    .card:hover {
        box-shadow: 0 8px 25px rgba(0, 0, 0, 0.1);
        transform: translateY(-2px);
    }

    .card-header {
        background: #f8fafc;
        border-bottom: 1px solid #e5e7eb;
        padding: 20px 24px;
        display: flex;
        align-items: center;
        gap: 12px;
    }

    .card-header i {
        color: #6b7280;
        font-size: 1.25rem;
    }

    .card-header h3 {
        margin: 0;
        font-size: 1.25rem;
        font-weight: 600;
        color: #1f2937;
    }

    .card-body {
        padding: 24px;
    }

    /* Upload Section */
    .upload-area {
        margin-bottom: 20px;
    }

    .file-input {
        width: 100%;
        padding: 16px;
        border: 2px dashed #d1d5db;
        border-radius: 8px;
        background: #f9fafb;
        font-size: 0.875rem;
        transition: all 0.3s ease;
        cursor: pointer;
    }

    .file-input:hover {
        border-color: #2563eb;
        background: #eff6ff;
    }

    .upload-info {
        margin-top: 12px;
        display: flex;
        align-items: center;
        gap: 8px;
        font-size: 0.875rem;
        color: #6b7280;
    }

    .upload-info i {
        color: #3b82f6;
    }

    /* Filter Section */
    .filter-grid {
        display: grid;
        grid-template-columns: repeat(auto-fit, minmax(200px, 1fr));
        gap: 20px;
        margin-bottom: 24px;
    }

    .input-group {
        display: flex;
        flex-direction: column;
        gap: 6px;
    }

    .input-label {
        font-size: 0.875rem;
        font-weight: 600;
        color: #374151;
        margin: 0;
    }

    .form-input {
        padding: 12px 16px;
        border: 1px solid #d1d5db;
        border-radius: 8px;
        font-size: 0.875rem;
        transition: all 0.2s ease;
        background: white;
    }

    .form-input:focus {
        outline: none;
        border-color: #2563eb;
        box-shadow: 0 0 0 3px rgba(37, 99, 235, 0.1);
    }

    .form-input::placeholder {
        color: #9ca3af;
    }

    /* Action Bar */
    .action-bar {
        display: flex;
        gap: 12px;
        justify-content: flex-end;
        padding-top: 20px;
        border-top: 1px solid #e5e7eb;
    }

    /* Button Styles */
    .btn {
        padding: 12px 24px;
        border: none;
        border-radius: 8px;
        font-size: 0.875rem;
        font-weight: 600;
        cursor: pointer;
        transition: all 0.2s ease;
        text-decoration: none;
        display: inline-flex;
        align-items: center;
        justify-content: center;
        min-width: 120px;
        white-space: nowrap;
    }

    .btn-primary {
        background: #2563eb;
        color: white;
    }

    .btn-primary:hover {
        background: #1d4ed8;
        transform: translateY(-1px);
        box-shadow: 0 4px 12px rgba(37, 99, 235, 0.4);
    }

    .btn-success {
        background: #059669;
        color: white;
    }

    .btn-success:hover {
        background: #047857;
        transform: translateY(-1px);
        box-shadow: 0 4px 12px rgba(5, 150, 105, 0.4);
    }

    .btn-outline {
        background: white;
        color: #374151;
        border: 1px solid #d1d5db;
    }

    .btn-outline:hover {
        background: #f9fafb;
        border-color: #9ca3af;
        transform: translateY(-1px);
    }

    .btn-upload {
        width: 100%;
        margin-top: 8px;
    }

    /* Message Styles */
    .alert-message {
        display: block;
        padding: 16px 20px;
        margin: 0 0 24px 0;
        border-radius: 8px;
        font-weight: 500;
        background: #fef2f2;
        color: #dc2626;
        border: 1px solid #fecaca;
        font-size: 0.875rem;
    }

    .alert-message:empty {
        display: none;
    }

    /* Results Section */
    .results-card {
        grid-column: 1 / -1;
    }

    .table-container {
        overflow-x: auto;
        border-radius: 8px;
        border: 1px solid #e5e7eb;
    }

    .data-table {
        width: 100%;
        border-collapse: collapse;
        background: white;
        margin: 0;
        font-size: 0.875rem;
    }

    .table-header {
        background: #f8fafc;
        border-bottom: 1px solid #e5e7eb;
    }

    .table-header th {
        padding: 16px 20px;
        text-align: left;
        font-weight: 600;
        color: #374151;
        font-size: 0.875rem;
        letter-spacing: 0.025em;
        border: none;
    }

    .table-row td {
        padding: 16px 20px;
        border-bottom: 1px solid #f3f4f6;
        vertical-align: middle;
        background: white;
    }

    .table-row-alt td {
        background: #f9fafb;
    }

    .data-table tr:hover td {
        background: #eff6ff !important;
    }

    /* Column Styles */
    .col-employee {
        font-weight: 600;
        color: #1f2937;
    }

    .col-date {
        color: #6b7280;
        font-family: 'SF Mono', Monaco, 'Cascadia Code', monospace;
        font-size: 0.8125rem;
    }

    .col-time {
        color: #059669;
        font-weight: 500;
        font-family: 'SF Mono', Monaco, 'Cascadia Code', monospace;
    }

    .col-location {
        color: #6b7280;
        max-width: 300px;
        word-wrap: break-word;
    }

    /* Responsive Design */
    @media (max-width: 1024px) {
        .content-grid {
            grid-template-columns: 1fr;
        }
        
        .header-content {
            flex-direction: column;
            text-align: center;
            gap: 16px;
        }
        
        .report-title {
            font-size: 2rem;
        }
    }

    @media (max-width: 768px) {
        .employee-time-report-container {
            padding: 16px;
        }
        
        .report-header {
            padding: 24px 20px;
        }
        
        .card-body {
            padding: 20px;
        }
        
        .filter-grid {
            grid-template-columns: 1fr;
        }
        
        .action-bar {
            flex-direction: column;
        }
        
        .btn {
            width: 100%;
        }
        
        .table-header th,
        .table-row td {
            padding: 12px 16px;
        }
    }

    @media (max-width: 480px) {
        .report-title {
            font-size: 1.75rem;
        }
        
        .report-subtitle {
            font-size: 1rem;
        }
        
        .header-icon {
            font-size: 2rem;
        }
    }

    /* Focus States for Accessibility */
    .btn:focus,
    .form-input:focus,
    .file-input:focus {
        outline: 2px solid #2563eb;
        outline-offset: 2px;
    }

    /* Loading States */
    .btn:disabled {
        opacity: 0.6;
        cursor: not-allowed;
        transform: none;
    }

    /* Smooth Animations */
    .card,
    .btn,
    .form-input {
        transition: all 0.2s cubic-bezier(0.4, 0, 0.2, 1);
    }
</style>

<!-- Font Awesome for Icons -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">