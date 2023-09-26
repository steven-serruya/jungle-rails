describe('Add to cart functionality', () => {

  it('should add a product to the cart and increase cart count by one', () => {
      // Visit the home page
      cy.visit('http://localhost:3000/');

      // Capture the initial count of items in the cart
      let initialCartCount = 0;
      cy.get('.cart-count').invoke('text').then((text) => {
          initialCartCount = parseInt(text);
      });

      // Click the 'Add to Cart' button of the first product
      cy.get('article .action-buttons .btn').first().click();

      // Verify the cart count has increased by one
      cy.get('.cart-count').invoke('text').then((newCount) => {
          expect(parseInt(newCount)).to.eq(initialCartCount + 1);
      });
  });
});
