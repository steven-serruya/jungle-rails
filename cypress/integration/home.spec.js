it("There is 2 products on the page", () => {
  cy.visit('http://localhost:3000/');
  
  cy.get(".products article").should("have.length.at.least", 2);
});