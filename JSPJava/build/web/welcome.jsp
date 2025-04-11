<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>IQ Test Dashboard</title>
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">
    
    <style>
        :root {
            --primary: #4F46E5;
            --primary-light: #6366F1;
            --secondary: #10B981;
            --danger: #EF4444;
            --warning: #F59E0B;
            --dark: #1F2937;
            --light: #F9FAFB;
            --gray: #6B7280;
            --card-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1), 0 2px 4px -1px rgba(0, 0, 0, 0.06);
        }
        
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
            font-family: 'Inter', -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, Oxygen, Ubuntu, Cantarell, 'Open Sans', 'Helvetica Neue', sans-serif;
        }
        
        body {
            background-color: #F3F4F6;
            color: var(--dark);
            line-height: 1.6;
        }
        
        .dashboard-container {
            display: grid;
            grid-template-columns: 280px 1fr;
            min-height: 100vh;
        }
        
        /* Sidebar Styles */
        .sidebar {
            background: white;
            padding: 2rem 1.5rem;
            box-shadow: var(--card-shadow);
            position: sticky;
            top: 0;
            height: 100vh;
        }
        
        .user-profile {
            display: flex;
            flex-direction: column;
            align-items: center;
            padding-bottom: 1.5rem;
            margin-bottom: 1.5rem;
            border-bottom: 1px solid #E5E7EB;
        }
        
        .profile-pic {
            width: 80px;
            height: 80px;
            border-radius: 50%;
            object-fit: cover;
            border: 3px solid #E5E7EB;
            margin-bottom: 1rem;
        }
        
        .user-name {
            font-weight: 600;
            font-size: 1.1rem;
            margin-bottom: 0.25rem;
        }
        
        .user-email {
            font-size: 0.85rem;
            color: var(--gray);
        }
        
        .nav-menu {
            margin-top: 1rem;
        }
        
        .nav-item {
            display: flex;
            align-items: center;
            padding: 0.75rem 1rem;
            border-radius: 8px;
            margin-bottom: 0.5rem;
            cursor: pointer;
            transition: all 0.2s ease;
            color: var(--gray);
            text-decoration: none;
        }
        
        .nav-item:hover {
            background-color: #F3F4F6;
            color: var(--primary);
        }
        
        .nav-item.active {
            background-color: #EEF2FF;
            color: var(--primary);
            font-weight: 500;
        }
        
        .nav-item i {
            margin-right: 0.75rem;
            font-size: 1.1rem;
        }
        
        /* Main Content Styles */
        .main-content {
            padding: 2rem;
        }
        
        .header {
            display: flex;
            justify-content: space-between;
            align-items: center;
            margin-bottom: 2rem;
        }
        
        .page-title {
            font-size: 1.75rem;
            font-weight: 700;
            color: var(--dark);
        }
        
        .btn {
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            font-weight: 500;
            cursor: pointer;
            transition: all 0.2s ease;
            border: none;
            display: inline-flex;
            align-items: center;
        }
        
        .btn-primary {
            background-color: var(--primary);
            color: white;
        }
        
        .btn-primary:hover {
            background-color: var(--primary-light);
        }
        
        .btn-danger {
            background-color: var(--danger);
            color: white;
        }
        
        .btn-danger:hover {
            background-color: #DC2626;
        }
        
        .btn i {
            margin-right: 0.5rem;
        }
        
        /* Stats Cards */
        .stats-grid {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(240px, 1fr));
            gap: 1.5rem;
            margin-bottom: 2rem;
        }
        
        .stat-card {
            background: white;
            border-radius: 12px;
            padding: 1.5rem;
            box-shadow: var(--card-shadow);
        }
        
        .stat-card .stat-title {
            font-size: 0.9rem;
            color: var(--gray);
            margin-bottom: 0.5rem;
        }
        
        .stat-card .stat-value {
            font-size: 1.75rem;
            font-weight: 700;
            margin-bottom: 0.5rem;
        }
        
        .stat-card .stat-change {
            font-size: 0.85rem;
            display: flex;
            align-items: center;
        }
        
        .stat-card .stat-change.positive {
            color: var(--secondary);
        }
        
        .stat-card .stat-change.negative {
            color: var(--danger);
        }
        
        /* Test Section */
        .test-section {
            background: white;
            border-radius: 12px;
            padding: 2rem;
            box-shadow: var(--card-shadow);
            margin-bottom: 2rem;
        }
        
        .section-title {
            font-size: 1.25rem;
            font-weight: 600;
            margin-bottom: 1.5rem;
            display: flex;
            align-items: center;
        }
        
        .section-title i {
            margin-right: 0.75rem;
            color: var(--primary);
        }
        
        .test-options {
            display: grid;
            grid-template-columns: repeat(auto-fill, minmax(300px, 1fr));
            gap: 1.5rem;
        }
        
        .test-card {
            border: 1px solid #E5E7EB;
            border-radius: 10px;
            padding: 1.5rem;
            transition: all 0.2s ease;
        }
        
        .test-card:hover {
            border-color: var(--primary);
            transform: translateY(-2px);
        }
        
        .test-card .test-name {
            font-weight: 600;
            margin-bottom: 0.75rem;
            font-size: 1.1rem;
        }
        
        .test-card .test-desc {
            color: var(--gray);
            font-size: 0.9rem;
            margin-bottom: 1.5rem;
        }
        
        /* History Section */
        .history-table {
            width: 100%;
            border-collapse: collapse;
            background: white;
            border-radius: 12px;
            overflow: hidden;
            box-shadow: var(--card-shadow);
        }
        
        .history-table th, .history-table td {
            padding: 1rem 1.5rem;
            text-align: left;
        }
        
        .history-table thead {
            background-color: #F9FAFB;
            border-bottom: 1px solid #E5E7EB;
        }
        
        .history-table th {
            font-weight: 600;
            color: var(--dark);
            font-size: 0.9rem;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }
        
        .history-table tbody tr:not(:last-child) {
            border-bottom: 1px solid #E5E7EB;
        }
        
        .history-table tbody tr:hover {
            background-color: #F9FAFB;
        }
        
        .badge {
            display: inline-block;
            padding: 0.35rem 0.75rem;
            border-radius: 50px;
            font-size: 0.75rem;
            font-weight: 600;
        }
        
        .badge-success {
            background-color: #D1FAE5;
            color: var(--secondary);
        }
        
        .badge-warning {
            background-color: #FEF3C7;
            color: var(--warning);
        }
        
        /* Responsive Design */
        @media (max-width: 1024px) {
            .dashboard-container {
                grid-template-columns: 1fr;
            }
            
            .sidebar {
                height: auto;
                position: relative;
            }
            
            .main-content {
                padding: 1.5rem;
            }
        }
        
        @media (max-width: 640px) {
            .header {
                flex-direction: column;
                align-items: flex-start;
                gap: 1rem;
            }
            
            .stats-grid {
                grid-template-columns: 1fr;
            }
            
            .test-options {
                grid-template-columns: 1fr;
            }
        }
    </style>
</head>
<body>
    <div class="dashboard-container">
        <!-- Sidebar -->
        <div class="sidebar">
            <div class="user-profile">
                <img src="${user.pictureUrl}" alt="Profile Picture" class="profile-pic">
                <div class="user-name">${user.name}</div>
                <div class="user-email">${user.email}</div>
            </div>
<!--            
            <div class="nav-menu">
                <a href="#" class="nav-item active">
                    <i class="fas fa-tachometer-alt"></i>
                    Dashboard
                </a>
                <a href="#" class="nav-item">
                    <i class="fas fa-brain"></i>
                    Take IQ Test
                </a>
                <a href="#" class="nav-item">
                    <i class="fas fa-history"></i>
                    Test History
                </a>
                <a href="#" class="nav-item">
                    <i class="fas fa-chart-line"></i>
                    Progress
                </a>
                <a href="#" class="nav-item">
                    <i class="fas fa-cog"></i>
                    Settings
                </a>
            </div>-->
            
            <div style="margin-top: auto; padding-top: 1.5rem;">
                <button class="btn btn-danger" style="width: 100%;" onclick="window.location.href='${pageContext.request.contextPath}/logout'">
                    <i class="fas fa-sign-out-alt"></i>
                    Logout
                </button>
            </div>
        </div>
        
        <!-- Main Content -->
        <div class="main-content">
<!--            <div class="header">
                <h1 class="page-title">IQ Test Dashboard</h1>
                <button class="btn btn-primary">
                    <i class="fas fa-plus"></i>
                    New Test
                </button>
            </div>
            -->
            <!-- Stats Cards -->
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-title">Current IQ Score</div>
                    <div class="stat-value">${sessionScope.ciq}</div>
                  
                </div>
                
                <div class="stat-card">
                    <div class="stat-title">Tests Completed</div>
                    <div class="stat-value">${sessionScope.tq}</div>
                </div>
                
                <div class="stat-card">
                    <div class="stat-title">Average Score</div>
                    <div class="stat-value">${sessionScope.caiq}</div>
                </div>
                
<!--                <div class="stat-card">
                    <div class="stat-title">Percentile Rank</div>
                    <div class="stat-value">92%</div>
                    <div class="stat-change positive">
                        <i class="fas fa-arrow-up"></i> 4% from last test
                    </div>
                </div>-->
            </div>
            
            <!-- Test Options -->
            <div class="test-section">
                <h2 class="section-title">
                    <i class="fas fa-brain"></i>
                    Available IQ Tests
                </h2>
                
                <div class="test-options">
                    <div class="test-card">
                        <div class="test-name">Standard IQ Test</div>
                        <div class="test-desc">Complete our standard 15-question IQ assessment</div>
                        <button class="btn btn-primary" style="width: 100%;"  onclick="startTest('1')">
                            <i class="fas fa-play"></i>
                            Start Test
                        </button>
                    </div>
                    
                    <div class="test-card">
                        <div class="test-name">Intermediate IQ Test</div>
                        <div class="test-desc">Complete our standard 25-question IQ assessment</div>
                        <button class="btn btn-primary" style="width: 100%;"   onclick="startTest('2')">
                            <i class="fas fa-play"></i>
                            Start Test
                        </button>
                    </div>
                    
                    <div class="test-card">
                        <div class="test-name">Advanced IQ Test</div>
                        <div class="test-desc">Complete our standard 40-question IQ assessment</div>
                        <button class="btn btn-primary" style="width: 100%;"  onclick="startTest('3')">
                            <i class="fas fa-play"></i>
                            Start Test
                        </button>
                    </div>
                </div>
            </div>
<!--            
             Test History 
            <div class="test-section">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
                    <h2 class="section-title">
                        <i class="fas fa-history"></i>
                        Recent Tests
                    </h2>
                    <button class="btn" style="background: #F3F4F6; color: var(--danger);">
                        <i class="fas fa-trash-alt"></i>
                        Clear History
                    </button>
                </div>
                
                <table class="history-table">
                    <thead>
                        <tr>
                            <th>Date</th>
                            <th>Test Type</th>
                            <th>Score</th>
                            <th>Percentile</th>
                            <th>Time</th>
                            <th>Status</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>May 15, 2023</td>
                            <td>Standard IQ Test</td>
                            <td>128</td>
                            <td>92%</td>
                            <td>28:45</td>
                            <td><span class="badge badge-success">Completed</span></td>
                        </tr>
                        <tr>
                            <td>May 10, 2023</td>
                            <td>Quick Assessment</td>
                            <td>125</td>
                            <td>89%</td>
                            <td>09:32</td>
                            <td><span class="badge badge-success">Completed</span></td>
                        </tr>
                        <tr>
                            <td>May 5, 2023</td>
                            <td>Advanced Challenge</td>
                            <td>121</td>
                            <td>87%</td>
                            <td>42:18</td>
                            <td><span class="badge badge-success">Completed</span></td>
                        </tr>
                        <tr>
                            <td>Apr 28, 2023</td>
                            <td>Standard IQ Test</td>
                            <td>120</td>
                            <td>84%</td>
                            <td>31:07</td>
                            <td><span class="badge badge-success">Completed</span></td>
                        </tr>
                    </tbody>
                </table>
            </div>-->
        </div>
    </div>
</body>


<script>
function startTest(testType) {
    window.location.href = 'iqtest?type=' + testType;
}
</script>
</html>