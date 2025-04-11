<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
<head>
    <title>IQ Test | Question ${questionNumber}/${totalQuestions}</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600&display=swap" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css" rel="stylesheet">
    <style>
        :root {
            --primary: #4F46E5;
            --success: #10B981;
            --danger: #EF4444;
            --gray-light: #E5E7EB;
            --gray-dark: #6B7280;
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
        .test-container {
            background: white;
            border-radius: 12px;
            box-shadow: 0 4px 6px rgba(0,0,0,0.05);
            width: 100%;
            max-width: 600px;
            padding: 2rem;
            margin: 1rem;
        }
        .progress-container {
            margin-bottom: 1.5rem;
        }
        .progress-bar {
            height: 6px;
            background: var(--gray-light);
            border-radius: 3px;
            overflow: hidden;
        }
        .progress {
            height: 100%;
            background: var(--primary);
            width: ${(questionNumber/totalQuestions)*100}%;
            transition: width 0.3s ease;
        }
        .question-header {
            display: flex;
            justify-content: space-between;
            margin-bottom: 1rem;
        }
        .question-number {
            color: var(--gray-dark);
            font-size: 0.875rem;
            font-weight: 500;
        }
        .question-text {
            font-size: 1.25rem;
            font-weight: 500;
            margin-bottom: 1.5rem;
            color: #111827;
        }
        .options {
            display: grid;
            gap: 0.75rem;
            margin-bottom: 1.5rem;
        }
        .option {
            padding: 1rem 1.25rem;
            border: 2px solid var(--gray-light);
            border-radius: 8px;
            cursor: pointer;
            transition: all 0.2s;
            position: relative;
        }
        .option:hover {
            border-color: var(--primary);
            background: rgba(79, 70, 229, 0.03);
        }
        .option.selected {
            border-color: var(--primary);
            background: rgba(79, 70, 229, 0.05);
        }
        .option.correct {
            border-color: var(--success);
            background: rgba(16, 185, 129, 0.05);
        }
        .option.incorrect {
            border-color: var(--danger);
            background: rgba(239, 68, 68, 0.05);
        }
        .feedback {
            padding: 1rem;
            border-radius: 8px;
            margin-bottom: 1.5rem;
            display: none;
        }
        .feedback.correct {
            display: block;
            background: rgba(16, 185, 129, 0.1);
            color: var(--success);
        }
        .feedback.incorrect {
            display: block;
            background: rgba(239, 68, 68, 0.1);
            color: var(--danger);
        }
        .navigation {
            display: flex;
            justify-content: space-between;
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
        }
        .btn-outline {
            background: transparent;
            border: 1px solid var(--gray-light);
            color: var(--gray-dark);
        }
        .btn-outline:hover {
            background: #F3F4F6;
        }
        .btn-primary {
            background: var(--primary);
            color: white;
        }
        .btn-primary:hover {
            background: #4338CA;
        }
        .btn:disabled {
            opacity: 0.5;
            cursor: not-allowed;
        }
    </style>
</head>
<body>
    <div class="test-container">
        <div class="progress-container">
            <div class="progress-bar">
                <div class="progress"></div>
            </div>
            <div class="question-header">
                <span class="question-number">Question ${questionNumber} of ${totalQuestions}</span>
            </div>
        </div>
        
        <div class="question-text">${question.text}</div>
        
        <div class="options" id="options">
            <c:forEach var="option" items="${question.options}">
                <div class="option ${selectedAnswer eq option.key ? 'selected' : ''}" 
                     data-value="${option.key}">
                    ${option.value}
                </div>
            </c:forEach>
        </div>
        
        <div id="feedback" class="feedback"></div>
        
        <div class="navigation">
            <button class="btn btn-outline" id="prevBtn" 
                <c:if test="${questionNumber <= 1}">disabled</c:if>>
                <i class="fas fa-arrow-left"></i> Previous
            </button>
            
            <button class="btn btn-primary" id="nextBtn" 
                <c:if test="${empty selectedAnswer and questionNumber ne totalQuestions}">disabled</c:if>>
                <c:choose>
                    <c:when test="${questionNumber < totalQuestions}">
                        Next <i class="fas fa-arrow-right"></i>
                    </c:when>
                    <c:otherwise>
                        Submit Test <i class="fas fa-paper-plane"></i>
                    </c:otherwise>
                </c:choose>
            </button>
        </div>
    </div>

                
                <script>
document.addEventListener('DOMContentLoaded', function() {
    const options = document.querySelectorAll('.option');
    const feedback = document.getElementById('feedback');
    const nextBtn = document.getElementById('nextBtn');
    const prevBtn = document.getElementById('prevBtn');
    let selectedOption = null;

    console.log('Test page initialized');
    console.log('Current question ID:', ${question.id});
    console.log('Existing selected answer:', '${selectedAnswer}');

    // Initialize selected option if exists
    if ('${selectedAnswer}' && '${selectedAnswer}' !== '') {
        selectedOption = '${selectedAnswer}';
        const selectedElement = document.querySelector(`.option[data-value="${selectedOption}"]`);
        if (selectedElement) {
            selectedElement.classList.add('selected');
            nextBtn.disabled = false;
            console.log('Restored previous selection');
        }
    }
    
    // Option selection
    options.forEach(option => {
        option.addEventListener('click', function() {
            console.log('Option clicked:', this.getAttribute('data-value'));
            
            // Remove previous selection and feedback
            options.forEach(opt => {
                opt.classList.remove('selected', 'correct', 'incorrect');
            });
            feedback.className = 'feedback';
            feedback.textContent = '';
            
            // Select current option
            this.classList.add('selected');
            selectedOption = this.getAttribute('data-value');
            
            // Enable next button
            nextBtn.disabled = false;
            
            // Validate answer
            validateAnswer();
        });
    });
    
    // Validate answer via AJAX
    function validateAnswer() {
        const questionId = ${question.id};
        console.log('Validating answer for question', questionId, 'Answer:', selectedOption);
        
        // Show loading state
        feedback.textContent = 'Checking answer...';
        feedback.className = 'feedback';
        
        // Prepare form data
        const formData = new URLSearchParams();
        formData.append('action', 'check');
        formData.append('questionId', questionId);
        formData.append('answer', selectedOption);
        
        // Make AJAX request
        fetch('iqtest', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/x-www-form-urlencoded',
            },
            body: formData
        })
        .then(response => {
            console.log('Received response, status:', response.status);
            if (!response.ok) {
                throw new Error(`HTTP error! status: ${response.status}`);
            }
            return response.json();
        })
        .then(data => {
            console.log('Validation result:', data);
            
            if (data.correct) {
                feedback.textContent = '✓ Correct answer!';
                feedback.className = 'feedback correct';
                document.querySelector('.option.selected').classList.add('correct');
            } else {
                feedback.textContent = `✗ Incorrect. Correct answer: ${data.correctAnswer}`;
                feedback.className = 'feedback incorrect';
                document.querySelector('.option.selected').classList.add('incorrect');
            }
        })
        .catch(error => {
            console.error('Validation error:', error);
            feedback.textContent = 'Error checking answer. Please try again.';
            feedback.className = 'feedback incorrect';
            
            // Additional error details for debugging
            console.error('Full error:', error);
            if (confirm('An error occurred. See console for details. Continue anyway?')) {
                nextBtn.disabled = false;
            }
        });
    }
    
    // Navigation
    prevBtn.addEventListener('click', function() {
        console.log('Navigating to previous question');
        window.location.href = 'iqtest?action=prev';
    });
    
    nextBtn.addEventListener('click', function() {
        if (!selectedOption) {
            feedback.textContent = 'Please select an answer first';
            feedback.className = 'feedback incorrect';
            return;
        }
        
        if (${questionNumber} < ${totalQuestions}) {
            console.log('Navigating to next question');
            window.location.href = 'iqtest?action=next';
        } else {
            submitTest();
        }
    });
    
    function submitTest() {
        console.log('Submitting test with final answer:', selectedOption);
        
        const form = document.createElement('form');
        form.method = 'POST';
        form.action = 'iqtest';
        
        const inputAction = document.createElement('input');
        inputAction.type = 'hidden';
        inputAction.name = 'action';
        inputAction.value = 'submit';
        form.appendChild(inputAction);
        
        const inputAnswer = document.createElement('input');
        inputAnswer.type = 'hidden';
        inputAnswer.name = 'q_${question.id}';
        inputAnswer.value = selectedOption;
        form.appendChild(inputAnswer);
        
        document.body.appendChild(form);
        form.submit();
    }
});
</script>
</body>
</html>