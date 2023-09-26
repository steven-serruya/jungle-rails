describe('Product details navigation', () => {
    
  it('should navigate to product details page when product is clicked', () => {
      // Step 1: Visit the home page
      cy.visit('http://localhost:3000/');

      // Step 2: Click on a product link. This will click on the first product's link. 
      cy.get('article > a').first().click();

      // Step 3: Assert that you are now on the product details page.
      cy.get('.product-detail').should('exist');
  });

});
