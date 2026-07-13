describe('Digital Library - Borrow Module Automated Tests', () => {

  beforeEach(() => {
    // Register a new reader in the background via POST request so it doesn't load the register page visually
    const uniqueEmail = `cypress_borrower_${Date.now()}@gmail.com`
    
    cy.request({
      method: 'POST',
      url: '/auth/register',
      form: true, // submits as application/x-www-form-urlencoded
      body: {
        fullName: 'Nguyễn Văn Mượn',
        email: uniqueEmail,
        phone: '0987654321',
        password: 'Password123',
        confirmPassword: 'Password123'
      }
    }).then(() => {
      // After background auto-login, visit the borrow request page directly
      cy.visit('/customer/borrow-request?bookId=1')
    })
  })

  // Helper function to click the form's submit button
  const submitForm = () => {
    cy.get('form.card').find('button[type="submit"]').click()
  }

  // Case 1: Date validation - Return Date before Start Date
  it('Should prevent submission when return date is before start date', () => {
    const today = new Date()
    const tomorrow = new Date(today)
    tomorrow.setDate(today.getDate() + 1)
    
    const startY = tomorrow.getFullYear()
    const startM = String(tomorrow.getMonth() + 1).padStart(2, '0')
    const startD = String(tomorrow.getDate()).padStart(2, '0')
    const formattedStart = `${startY}-${startM}-${startD}`

    const returnY = today.getFullYear()
    const returnM = String(today.getMonth() + 1).padStart(2, '0')
    const returnD = String(today.getDate()).padStart(2, '0')
    const formattedReturn = `${returnY}-${returnM}-${returnD}`

    cy.get('#expectedStartDate').type(formattedStart)
    cy.get('#expectedReturnDate').type(formattedReturn)
    submitForm()

    // Assert that we are still on the same page (submission prevented)
    cy.url().should('include', '/customer/borrow-request')
    
    // Check validation message (browser native validation with custom oninvalid message)
    cy.get('#expectedReturnDate').then(($input) => {
      expect($input[0].validationMessage).to.contain('Vui lòng chọn ngày trả hợp lệ')
    })
  })

  // Case 2: Duration validation - Exceeding 5 days
  it('Should prevent submission when borrowing duration exceeds 5 days', () => {
    const today = new Date()
    const inSixDays = new Date(today)
    inSixDays.setDate(today.getDate() + 6)
    
    const startY = today.getFullYear()
    const startM = String(today.getMonth() + 1).padStart(2, '0')
    const startD = String(today.getDate()).padStart(2, '0')
    const formattedStart = `${startY}-${startM}-${startD}`

    const returnY = inSixDays.getFullYear()
    const returnM = String(inSixDays.getMonth() + 1).padStart(2, '0')
    const returnD = String(inSixDays.getDate()).padStart(2, '0')
    const formattedReturn = `${returnY}-${returnM}-${returnD}`

    cy.get('#expectedStartDate').type(formattedStart)
    cy.get('#expectedReturnDate').type(formattedReturn)
    submitForm()

    cy.url().should('include', '/customer/borrow-request')
    
    cy.get('#expectedReturnDate').then(($input) => {
      expect($input[0].validationMessage).to.contain('Vui lòng chọn ngày trả hợp lệ')
    })
  })

  // Case 3: Empty fields validation
  it('Should show HTML5 validation message when required dates are empty', () => {
    // Clear date values (browser date inputs might require clear or backspace, but let's clear)
    cy.get('#expectedStartDate').clear()
    cy.get('#expectedReturnDate').clear()
    submitForm()

    // Assert that we remain on the same page because submission was blocked by HTML5 required attribute
    cy.url().should('include', '/customer/borrow-request')

    cy.get('#expectedStartDate').then(($input) => {
      expect($input[0].validity.valueMissing).to.be.true
    })
  })

  // Case 4: Invalid quantity limit validation
  it('Should prevent submission when quantity exceeds maximum limit of 5', () => {
    const today = new Date()
    const startY = today.getFullYear()
    const startM = String(today.getMonth() + 1).padStart(2, '0')
    const startD = String(today.getDate()).padStart(2, '0')
    const formattedStart = `${startY}-${startM}-${startD}`

    cy.get('#expectedStartDate').type(formattedStart)
    cy.get('#expectedReturnDate').type(formattedStart)
    
    cy.get('input[name="quantity"]').clear().type('6')
    submitForm()

    cy.get('input[name="quantity"]').then(($input) => {
      expect($input[0].validity.rangeOverflow).to.be.true
    })
  })

  // Case 5: Successful Borrow Request Submission
  it('Should successfully submit request when all inputs are valid', () => {
    const today = new Date()
    const inTwoDays = new Date(today)
    inTwoDays.setDate(today.getDate() + 2)
    
    const startY = today.getFullYear()
    const startM = String(today.getMonth() + 1).padStart(2, '0')
    const startD = String(today.getDate()).padStart(2, '0')
    const formattedStart = `${startY}-${startM}-${startD}`

    const returnY = inTwoDays.getFullYear()
    const returnM = String(inTwoDays.getMonth() + 1).padStart(2, '0')
    const returnD = String(inTwoDays.getDate()).padStart(2, '0')
    const formattedReturn = `${returnY}-${returnM}-${returnD}`

    cy.get('#expectedStartDate').type(formattedStart)
    cy.get('#expectedReturnDate').type(formattedReturn)
    cy.get('input[name="quantity"]').clear().type('1')
    cy.get('input[name="note"]').type('Cypress automated E2E borrow request test.')

    submitForm()

    cy.url().should('include', '/customer/borrow-request-status')
    cy.get('.alert-danger').should('not.exist')
  })

  // Case 6: Enforce minimum date attribute on expected start date to be today
  it('Should enforce minimum date attribute on expected start date to be today', () => {
    const today = new Date()
    const yyyy = today.getFullYear()
    const mm = String(today.getMonth() + 1).padStart(2, '0')
    const dd = String(today.getDate()).padStart(2, '0')
    const formattedToday = `${yyyy}-${mm}-${dd}`

    cy.get('#expectedStartDate').should('have.attr', 'min', formattedToday)
  })

  // Case 7: Quantity input attributes validation
  it('Should have correct min and max attributes on quantity input', () => {
    cy.get('input[name="quantity"]')
      .should('have.attr', 'min', '1')
      .and('have.attr', 'max', '5')
  })

  // Case 8: Verify book details navigation link
  it('Should navigate to book details page when clicking view details link', () => {
    cy.get('.card-body').find('a').contains('Xem chi tiết').click()
    cy.url().should('include', '/books/detail/1')
  })

  // Case 9: Verify cancel/select other book button redirection
  it('Should navigate back to books catalog when clicking choose other book', () => {
    cy.get('a.btn-outline-dark').contains('Chọn sách khác').click()
    cy.url().should('include', '/books')
  })

  // Case 10: Verify view status button redirection
  it('Should navigate to borrow request status page when clicking view status link', () => {
    cy.get('a.btn-outline-secondary').contains('Xem trạng thái yêu cầu').click()
    cy.url().should('include', '/customer/borrow-request-status')
  })
})
