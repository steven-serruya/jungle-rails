describe('User Login and Signup', () => {
  const userEmail = 'testuser@example.com';
  const userPassword = 'testpassword';
  const userFirstName = 'John';
  const userLastName = 'Doe';

  beforeEach(() => {
    cy.visit('/login');
  });

  it('should sign up and then log in the user', () => {
    // Sign up
    cy.visit('/signup');
    cy.get('input[name="user[first_name]"]').type(userFirstName);
    cy.get('input[name="user[last_name]"]').type(userLastName);
    cy.get('input[name="user[email]"]').type(userEmail);
    cy.get('input[name="user[password]"]').type(userPassword);
    cy.get('input[name="user[password_confirmation]"]').type(userPassword);
    cy.get('form').submit();

    // Assuming redirection to login page after signup
    cy.visit('/login');

    // Login
    cy.get('input[name="session[email]"]').type(userEmail);
    cy.get('input[name="session[password]"]').type(userPassword);
    cy.get('form').submit();

    // Verify user login
    cy.get('.navbar .nav-link').contains(`Logged in as: ${userEmail}`).should('be.visible');
  });

  it('should log in the user with existing credentials', () => {
    cy.get('input[name="session[email]"]').type(userEmail);
    cy.get('input[name="session[password]"]').type(userPassword);
    cy.get('form').submit();

    // Verify user login
    cy.get('.navbar .nav-link').contains(`Logged in as: ${userEmail}`).should('be.visible');
  });
});
