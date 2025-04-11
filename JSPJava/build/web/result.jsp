<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>Your IQ Test Results</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary: #4F46E5;
            --success: #10B981;
            --danger: #EF4444;
            --gray-light: #E5E7EB;
        }
        body {
            font-family: 'Inter', sans-serif;
            background: #F9FAFB;
            margin: 0;
            padding: 0;
            min-height: 100vh;
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .result-card {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            width: 100%;
            max-width: 500px;
            padding: 2rem;
            margin: 1rem;
            text-align: center;
        }
        .result-title {
            font-size: 1.5rem;
            font-weight: 600;
            margin-bottom: 1rem;
            color: #111827;
        }
        .iq-score {
            font-size: 3.5rem;
            font-weight: 700;
            color: var(--primary);
            margin: 1rem 0;
        }
        .iq-category {
            font-size: 1.25rem;
            font-weight: 500;
            color: var(--success);
            margin-bottom: 2rem;
        }
        .stats {
            display: grid;
            grid-template-columns: repeat(2, 1fr);
            gap: 1rem;
            margin: 2rem 0;
        }
        .stat {
            background: #F3F4F6;
            padding: 1rem;
            border-radius: 8px;
        }
        .stat-value {
            font-size: 1.5rem;
            font-weight: 600;
            color: #111827;
        }
        .stat-label {
            font-size: 0.875rem;
            color: #6B7280;
        }
        .btn {
            padding: 0.75rem 1.5rem;
            border-radius: 8px;
            font-weight: 500;
            cursor: pointer;
            border: none;
            font-size: 1rem;
            display: inline-flex;
            align-items: center;
            gap: 0.5rem;
            text-decoration: none;
            margin-top: 1rem;
        }
        .btn-primary {
            background: var(--primary);
            color: white;
        }
        .btn-primary:hover {
            background: #4338CA;
        }
    </style>
</head>
<body>
    <div class="result-card">
        <h1 class="result-title">Your IQ Test Results</h1>
        <div class="iq-score">${testResult.score}</div>
        <div class="iq-category">${testResult.description}</div>
        
        <div class="stats">
            <div class="stat">
                <div class="stat-value">${testResult.percentile}%</div>
                <div class="stat-label">Percentile Rank</div>
            </div>
            <div class="stat">
                <div class="stat-value">${testResult.correctAnswers}/${testResult.totalQuestions}</div>
                <div class="stat-label">Correct Answers</div>
            </div>
        </div>
        
        <a href="welcome.jsp" class="btn btn-primary">
            <i class="fas fa-home"></i> Return Home
        </a>
    </div>

    <script>
        console.log('Test results:', {
            score: ${testResult.score},
            percentile: ${testResult.percentile},
            correctAnswers: ${testResult.correctAnswers},
            totalQuestions: ${testResult.totalQuestions}
        });
    </script>
</body>
</html>