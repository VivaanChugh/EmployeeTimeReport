namespace Vivaan.ModulesEmployeeTimeReport
{
    public partial class View
    {
        protected global::System.Web.UI.WebControls.FileUpload fuUpload;
        protected global::System.Web.UI.WebControls.Button btnUpload;
        protected global::System.Web.UI.WebControls.Label lblMessage;

        protected global::System.Web.UI.WebControls.TextBox txtEmployeeName;
        protected global::System.Web.UI.WebControls.TextBox txtStartDate;
        protected global::System.Web.UI.WebControls.TextBox txtEndDate;
        protected global::System.Web.UI.WebControls.TextBox txtStartTime;
        protected global::System.Web.UI.WebControls.TextBox txtEndTime;
        protected global::System.Web.UI.WebControls.TextBox txtLocation;

        protected global::System.Web.UI.WebControls.Button btnGenerateReport;
        protected global::System.Web.UI.WebControls.Button btnDownloadReport;

        protected global::System.Web.UI.WebControls.GridView gvLogs;

        // ✅ ADD THIS:
        protected global::System.Web.UI.WebControls.Literal ltChartData;
    }
}