document.addEventListener('DOMContentLoaded', () => {
  const loginForm = document.getElementById('loginForm');
  const signupForm = document.getElementById('signupForm');
  const showLogin = document.getElementById('show-login');
  const showSignup = document.getElementById('show-signup');
  const home = document.getElementById('home');
  const loginSection = document.getElementById('login');
  const signupSection = document.getElementById('signup');
  const welcomeSection = document.getElementById('welcome');

  // Show home page initially
  home.style.display = 'block';

  showLogin.addEventListener('click', () => {
    home.style.display = 'none';
    signupSection.style.display = 'none';
    welcomeSection.style.display = 'none';
    loginSection.style.display = 'block';
  });

  showSignup.addEventListener('click', () => {
    home.style.display = 'none';
    loginSection.style.display = 'none';
    welcomeSection.style.display = 'none';
    signupSection.style.display = 'block';
  });

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
      localStorage.setItem('username', result.message.replace('Welcome, ', ''));
      welcomeSection.style.display = 'block';
      loginSection.style.display = 'none';
      document.getElementById('welcome-user').textContent = `Welcome, ${localStorage.getItem('username')}!`;
    } else {
      document.getElementById('login-message').textContent = result.message;
    }
  });

  signupForm.addEventListener('submit', async (e) => {
    e.preventDefault();
    const username = document.getElementById('username').value;
    const email = document.getElementById('signup-email').value;
    const password = document.getElementById('signup-password').value;

    const response = await fetch('http://localhost:5000/signup', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ username, email, password })
    });

    const result = await response.json();
    document.getElementById('signup-message').textContent = result.message;
    if (response.ok) {
      showLogin.click();
    }
  });
});
