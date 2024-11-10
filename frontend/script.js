document.addEventListener('DOMContentLoaded', () => {
    const loginForm = document.getElementById('loginForm');
    const signupForm = document.getElementById('signupForm');
    
    if (loginForm) {
      loginForm.addEventListener('submit', async (e) => {
        e.preventDefault();
        const email = document.getElementById('email').value;
        const password = document.getElementById('password').value;
        
        const response = await fetch('http://localhost:5000/login', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ email, password })
        });
        
        const result = await response.json();
        
        if (response.ok) {
          // Store the username in localStorage and navigate to the welcome page
          localStorage.setItem('username', result.message.replace('Welcome, ', ''));
          window.location.href = 'welcome.html';
        } else {
          document.getElementById('login-message').textContent = result.message;
        }
      });
    }
    
    if (signupForm) {
      signupForm.addEventListener('submit', async (e) => {
        e.preventDefault();
        const username = document.getElementById('username').value;
        const email = document.getElementById('email').value;
        const password = document.getElementById('password').value;
        
        const response = await fetch('http://localhost:5000/signup', {
          method: 'POST',
          headers: { 'Content-Type': 'application/json' },
          body: JSON.stringify({ username, email, password })
        });
        
        const result = await response.json();
        document.getElementById('signup-message').textContent = result.message;
        if (response.ok) window.location.href = 'login.html';
      });
    }
    
    // Display username on welcome page
    if (window.location.pathname.endsWith('welcome.html')) {
      const username = localStorage.getItem('username');
      if (username) {
        document.getElementById('welcome-user').textContent = `Welcome, ${username}!`;
      }
    }
  });
  