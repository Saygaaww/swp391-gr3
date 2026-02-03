document.addEventListener('DOMContentLoaded', function() {
    const loginForm = document.getElementById('loginForm');
    if (!loginForm) {
        console.error('Login form not found!');
        return;
    }
    
    const emailInput = document.getElementById('email');
    const passwordInput = document.getElementById('password');
    const togglePasswordBtn = document.getElementById('togglePassword');
    const emailError = document.getElementById('emailError');
    const passwordError = document.getElementById('passwordError');
    const submitBtn = loginForm.querySelector('button[type="submit"]');
    
    // Toggle password visibility
    if (togglePasswordBtn) {
        togglePasswordBtn.addEventListener('click', function() {
            const type = passwordInput.getAttribute('type') === 'password' ? 'text' : 'password';
            passwordInput.setAttribute('type', type);
            
            const icon = togglePasswordBtn.querySelector('i');
            if (type === 'password') {
                icon.classList.remove('fa-eye-slash');
                icon.classList.add('fa-eye');
            } else {
                icon.classList.remove('fa-eye');
                icon.classList.add('fa-eye-slash');
            }
        });
    }
    
    // Email validation
    function validateEmail(email) {
        const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
        return emailRegex.test(email);
    }
    
    // Real-time validation
    if (emailInput) {
        emailInput.addEventListener('blur', function() {
            const email = emailInput.value.trim();
            if (email === '') {
                if (emailError) emailError.textContent = 'Email không được để trống';
                emailInput.style.borderColor = '#ef4444';
            } else if (!validateEmail(email)) {
                if (emailError) emailError.textContent = 'Email không hợp lệ';
                emailInput.style.borderColor = '#ef4444';
            } else {
                if (emailError) emailError.textContent = '';
                emailInput.style.borderColor = '#e5e7eb';
            }
        });
        
        emailInput.addEventListener('input', function() {
            if (emailError && emailError.textContent) {
                const email = emailInput.value.trim();
                if (email !== '' && validateEmail(email)) {
                    emailError.textContent = '';
                    emailInput.style.borderColor = '#e5e7eb';
                }
            }
        });
    }
    
    if (passwordInput) {
        passwordInput.addEventListener('blur', function() {
            const password = passwordInput.value;
            if (password === '') {
                if (passwordError) passwordError.textContent = 'Mật khẩu không được để trống';
                passwordInput.style.borderColor = '#ef4444';
            } else if (password.length < 6) {
                if (passwordError) passwordError.textContent = 'Mật khẩu phải có ít nhất 6 ký tự';
                passwordInput.style.borderColor = '#ef4444';
            } else {
                if (passwordError) passwordError.textContent = '';
                passwordInput.style.borderColor = '#e5e7eb';
            }
        });
        
        passwordInput.addEventListener('input', function() {
            if (passwordError && passwordError.textContent) {
                const password = passwordInput.value;
                if (password !== '' && password.length >= 6) {
                    passwordError.textContent = '';
                    passwordInput.style.borderColor = '#e5e7eb';
                }
            }
        });
    }
    
    // Form submission
    if (loginForm) {
        loginForm.addEventListener('submit', function(e) {
            console.log('Form submit event triggered');
            let isValid = true;
            
            // Clear previous errors
            if (emailError) emailError.textContent = '';
            if (passwordError) passwordError.textContent = '';
            if (emailInput) emailInput.style.borderColor = '#e5e7eb';
            if (passwordInput) passwordInput.style.borderColor = '#e5e7eb';
            
            // Validate email
            if (emailInput) {
                const email = emailInput.value.trim();
                console.log('Email:', email);
                if (email === '') {
                    if (emailError) emailError.textContent = 'Email không được để trống';
                    emailInput.style.borderColor = '#ef4444';
                    isValid = false;
                } else if (!validateEmail(email)) {
                    if (emailError) emailError.textContent = 'Email không hợp lệ';
                    emailInput.style.borderColor = '#ef4444';
                    isValid = false;
                }
            }
            
            // Validate password
            if (passwordInput) {
                const password = passwordInput.value;
                console.log('Password length:', password.length);
                if (password === '') {
                    if (passwordError) passwordError.textContent = 'Mật khẩu không được để trống';
                    passwordInput.style.borderColor = '#ef4444';
                    isValid = false;
                } else if (password.length < 6) {
                    if (passwordError) passwordError.textContent = 'Mật khẩu phải có ít nhất 6 ký tự';
                    passwordInput.style.borderColor = '#ef4444';
                    isValid = false;
                }
            }
            
            console.log('Validation result:', isValid);
            
            if (!isValid) {
                console.log('Validation failed, preventing submit');
                e.preventDefault();
                return false;
            }
            
            console.log('Validation passed, submitting form');
            
            // Show loading state
            if (submitBtn) {
                submitBtn.disabled = true;
                submitBtn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Đang xử lý...';
            }
            
            // Form will submit normally if validation passes
            // Don't prevent default, let form submit
        });
    } else {
        console.error('Login form not found!');
    }
    
    // Google login button click handler
    const googleLoginBtn = document.getElementById('googleLoginBtn');
    if (googleLoginBtn) {
        googleLoginBtn.addEventListener('click', function(e) {
            // Add loading state
            this.style.opacity = '0.7';
            this.style.pointerEvents = 'none';
            
            // The link will navigate normally
        });
    }
    
    // Auto-focus on email input
    if (emailInput) {
        emailInput.focus();
    }
    
    // Enter key to submit (not needed, form will submit naturally on Enter)
    // Removed to avoid conflicts
});
