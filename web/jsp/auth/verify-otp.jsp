<%@ page contentType="text/html;charset=UTF-8" pageEncoding="UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="vi">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Xác minh OTP - Digital Library</title>
        <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap"
              rel="stylesheet">
        <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">
        <style>
            *,
            *::before,
            *::after {
                box-sizing: border-box;
                margin: 0;
                padding: 0;
            }

            body {
                font-family: 'Inter', sans-serif;
                min-height: 100vh;
                background: linear-gradient(135deg, #0f172a 0%, #1e293b 50%, #334155 100%);
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 20px;
            }

            .card {
                background: rgba(255, 255, 255, 0.06);
                backdrop-filter: blur(20px);
                -webkit-backdrop-filter: blur(20px);
                border: 1px solid rgba(255, 255, 255, 0.12);
                border-radius: 20px;
                padding: 40px;
                width: 100%;
                max-width: 420px;
                box-shadow: 0 25px 50px rgba(0, 0, 0, 0.4);
                text-align: center;
            }

            .logo i {
                font-size: 2.5rem;
                color: #94a3b8;
                margin-bottom: 15px;
                display: block;
            }

            .logo h1 {
                font-size: 1.5rem;
                font-weight: 700;
                color: #fff;
                margin-bottom: 8px;
            }

            .logo p {
                color: rgba(255, 255, 255, 0.55);
                font-size: 0.9rem;
                margin-bottom: 30px;
                line-height: 1.5;
            }

            .alert-error {
                background: rgba(239, 68, 68, 0.15);
                border: 1px solid rgba(239, 68, 68, 0.3);
                color: #fca5a5;
                border-radius: 10px;
                padding: 12px;
                margin-bottom: 20px;
                font-size: 0.875rem;
                text-align: left;
            }

            .alert-success {
                background: rgba(34, 197, 94, 0.15);
                border: 1px solid rgba(34, 197, 94, 0.3);
                color: #86efac;
                border-radius: 10px;
                padding: 12px;
                margin-bottom: 20px;
                font-size: 0.875rem;
                text-align: left;
            }

            .otp-input-group {
                display: flex;
                justify-content: space-between;
                margin-bottom: 25px;
                gap: 10px;
            }

            .otp-input-group input {
                width: 50px;
                height: 60px;
                background: rgba(255, 255, 255, 0.08);
                border: 1px solid rgba(255, 255, 255, 0.15);
                border-radius: 12px;
                color: #fff;
                font-size: 1.5rem;
                font-weight: 600;
                text-align: center;
                transition: all 0.2s;
                outline: none;
            }

            .otp-input-group input:focus {
                border-color: #94a3b8;
                background: rgba(255, 255, 255, 0.12);
                box-shadow: 0 0 0 3px rgba(148, 163, 184, 0.2);
            }

            .btn-primary {
                width: 100%;
                padding: 14px;
                background: linear-gradient(135deg, #475569, #64748b);
                border: none;
                border-radius: 10px;
                color: #fff;
                font-size: 1rem;
                font-weight: 600;
                cursor: pointer;
                transition: all 0.2s;
                letter-spacing: 0.5px;
            }

            .btn-primary:hover {
                transform: translateY(-2px);
                box-shadow: 0 8px 25px rgba(71, 85, 105, 0.4);
            }

            .resend-link {
                display: inline-block;
                margin-top: 25px;
                color: #94a3b8;
                text-decoration: none;
                font-size: 0.85rem;
            }

            .resend-link:hover {
                text-decoration: underline;
                color: #fff;
            }

            .back-link {
                display: block;
                margin-top: 20px;
                color: rgba(255, 255, 255, 0.4);
                text-decoration: none;
                font-size: 0.85rem;
            }

            .back-link:hover {
                color: #fff;
            }
        </style>
    </head>

    <body>
        <div class="card">
            <div class="logo">
                <i class="fa-solid fa-shield-check"></i>
                <h1>Nhập mã xác thực</h1>
                <p>Chúng tôi đã gửi mã OTP 6 số đến email <strong>${sessionScope.resetEmail}</strong> của bạn.</p>
            </div>

            <c:if test="${not empty error}">
                <div class="alert-error"><i class="fa-solid fa-circle-exclamation"></i> ${error}</div>
                <% request.removeAttribute("error");%>
            </c:if>

            <form action="${pageContext.request.contextPath}/auth/verify-otp" method="POST" id="otpForm">
                <!-- Hidden input to store full OTP value -->
                <input type="hidden" name="otp" id="fullOtp">

                <div class="otp-input-group" id="otpInputs">
                    <input type="text" maxlength="1" autocomplete="off" autofocus required>
                    <input type="text" maxlength="1" autocomplete="off" required>
                    <input type="text" maxlength="1" autocomplete="off" required>
                    <input type="text" maxlength="1" autocomplete="off" required>
                    <input type="text" maxlength="1" autocomplete="off" required>
                    <input type="text" maxlength="1" autocomplete="off" required>
                </div>

                <button type="submit" class="btn-primary">XÁC NHẬN</button>
            </form>

            <a href="${pageContext.request.contextPath}/auth/forgot-password" class="back-link">Thay đổi email khác</a>
        </div>

        <script>
            // Logic auto-focus next input field for OTP UI
            const inputs = document.querySelectorAll('#otpInputs input');
            const form = document.getElementById('otpForm');
            const hiddenInput = document.getElementById('fullOtp');

            inputs.forEach((input, index) => {
                input.addEventListener('input', (e) => {
                    if (e.target.value.length === 1) {
                        if (index < inputs.length - 1)
                            inputs[index + 1].focus();
                    }
                });
                input.addEventListener('keydown', (e) => {
                    if (e.key === 'Backspace' && e.target.value.length === 0) {
                        if (index > 0)
                            inputs[index - 1].focus();
                    }
                });
                // Handle pasting OTP
                input.addEventListener('paste', (e) => {
                    const pastedData = e.clipboardData.getData('text').trim();
                    if (pastedData.length === 6 && /^\d+$/.test(pastedData)) {
                        e.preventDefault();
                        for (let i = 0; i < 6; i++) {
                            inputs[i].value = pastedData[i];
                        }
                        inputs[5].focus();
                    }
                });
            });

            form.addEventListener('submit', (e) => {
                let otpVal = '';
                inputs.forEach(input => otpVal += input.value);
                hiddenInput.value = otpVal;
            });
        </script>
    </body>

</html>
