describe('Scenario 1 : ตรวจสอบฟังก์ชันการเพิ่มผู้ดูแลระบบ ', () => {
  beforeEach(() => {
    cy.visit('https://co-newsproject.com') 
  })

  it('TC-CP-001 : ตรวจสอบการกรอกข้อมูลครบถ้วนเมื่อทำการเพิ่มผู้ดูแลระบบ', () => {
    //กรอกข้อมูล Login (เอา Type id มากรอก)
    cy.get('#login').type('abcd')
    cy.get('#password').type('1234')

    //กดปุ่ม Login(ไม่มีทั้ง id และ data)
    cy.get('button[type="submit"]').click()

    //ตรวจสอบว่ามีการ Redirect ไปที่หน้า Dashboard
    cy.url().should('include', '/views/dashboard')

    //กดแถบ Admin Dropdown และรอให้ DOM โหลดเสร็จก่อน
    cy.get('#adminDropdown', { setTimeout: 1000 }).click()

    //กดเข้าไปใน Admin Dashboard
    cy.get('a[href="../views/admin/admin.html"]').click()

    //กดปุ่มเพิ่มผู้ดูแลระบบ
    cy.get('a[href="../admin/add-admin.html"]').click()

    //กรอกข้อมูลช่องต่างๆ ตาม Test Data
    cy.get('#fname').type('TestCypress1')
    cy.get('#lname').type('CypressTest1')
    cy.get('#username').type('TestCypress1')
    cy.get('#password').type('cp123456789')
    cy.get('#email').type('TestCyp1@gmail.com')
    cy.get('#phone').type('0984561234')

    //กดปุ่มเพิ่มข้อมูล
    cy.get('button[type="submit"]').click()

    //ตรวจสอบว่ามีการ Redirect กลับไปที่หน้า Admin Dashboard และ ข้อมูลถูกเพิ่มเรียบร้อย
    cy.url().should('include', '/views/admin/admin.html')
    cy.contains('TestCypress1').should('exist')
  })

  it('TC-CP-002 : ตรวจสอบการกรอกเบอร์โทรศัพท์ที่ไม่ถูกต้อง', () => {
    cy.get('#login').type('abcd')
    cy.get('#password').type('1234')
    cy.get('button[type="submit"]').click()
    cy.url().should('include', '/views/dashboard')
    cy.get('#adminDropdown', { setTimeout: 1000 }).click()
    cy.get('a[href="../views/admin/admin.html"]').click()
    cy.get('a[href="../admin/add-admin.html"]').click()
    cy.get('#fname').type('TestCypress2')
    cy.get('#lname').type('CypressTest2')
    cy.get('#username').type('TestCypress2')
    cy.get('#password').type('cp123456789')
    cy.get('#email').type('TestCyp2@gmail.com')
    cy.get('#phone').type('09845612344')
    cy.get('button[type="submit"]').click()
    cy.get('#phoneError').should('be.visible')
    .should('contain', 'Format of Phone Number is Incorrect')
    cy.url().should('include', '/views/admin/add-admin.html') 
})

  it('TC-CP-003 : ตรวจสอบการเพิ่มข้อมูลด้วยชื่อผู้ใช้งานที่ซ้ำกัน', () => {
    cy.get('#login').type('abcd')
    cy.get('#password').type('1234')
    cy.get('button[type="submit"]').click()
    cy.url().should('include', '/views/dashboard')
    cy.get('#adminDropdown', { setTimeout: 1000 }).click()
    cy.get('a[href="../views/admin/admin.html"]').click()
    cy.get('a[href="../admin/add-admin.html"]').click()
    cy.get('#fname').type('TestCypress3')
    cy.get('#lname').type('CypressTest3')
    cy.get('#username').type('TestCypress1')
    cy.get('#password').type('cp123456789')
    cy.get('#email').type('TestCyp3@gmail.com')
    cy.get('#phone').type('0987891234')
    cy.get('button[type="submit"]').click()
    cy.get('#usernameError').should('be.visible')
    .should('contain', 'มีชื่อผู้ใช้งานนี้ในระบบแล้ว')
    cy.url().should('include', '/views/admin/add-admin.html')
})
})

describe('Scenario 2 : ตรวจสอบฟังก์ชันการเข้าสู่ระบบ', () => {
beforeEach(() => {
    cy.visit('https://co-newsproject.com') 
  })

  it('TC-CP-004 : ตรวจสอบการเข้าสู่ระบบด้วยข้อมูลที่ถูกต้อง', () => {
    cy.get('#login').type('admin')
    cy.get('#password').type('123456')
    cy.get('button[type="submit"]').click()
    cy.on('window:alert', (str) => {
      expect(str).to.equal('เข้าสู่ระบบสำเร็จ')
    })
    cy.url().should('include', '/views/dashboard')
  })

  it('TC-CP-005 : ตรวจสอบการเข้าสู่ระบบด้วยรหัสผ่านที่ผิด', () => {
    cy.get('#login').type('admin')
    cy.get('#password').type('123456789')
    cy.get('button[type="submit"]').click()
    cy.on('window:alert', (str) => {
      expect(str).to.equal('ชื่อผู้ใช้หรืออีเมล์หรือรหัสผ่านไม่ถูกต้อง')
    })
    cy.url().should('equal', 'https://co-newsproject.com/')
  })

  it('TC-CP-006 : ตรวจสอบการเข้าสู่ระบบด้วยการเว้นว่างช่องกรอกข้อมูล', () => {
    cy.get('#login').type('admin')
    cy.get('button[type="submit"]').click()
    cy.on('window:alert', (str) => {
      expect(str).to.equal('Please fill out this field.')
    })
    cy.url().should('equal', 'https://co-newsproject.com/')
  })
})

describe('Scenario 3 : ตรวจสอบฟังก์ชันการค้นหาข่าว', () => {
beforeEach(() => {
    cy.visit('https://co-newsproject.com') 
    cy.get('#login').type('admin')
    cy.get('#password').type('123456')
    cy.get('button[type="submit"]').click()
  })

  it('TC-CP-007 : ตรวจสอบการค้นหาข่าวด้วยชื่อข่าวที่มีในระบบ', () => {
    cy.get('#newsDropdown', { setTimeout: 1000 }).click()
    cy.get('a[href="../views/news/news.html"]').click()
    cy.get('#searchType').select('ค้นหาตามชื่อข่าว')
    cy.get('#searchInput').type('เครื่องดื่ม')
    cy.contains('เครื่องดื่ม').should('be.visible')
  })

  it('TC-CP-008 : ตรวจสอบการค้นหาข่าวด้วยวันที่ลงข่าว', () => {
    cy.get('#newsDropdown', { setTimeout: 1000 }).click()
    cy.get('a[href="../views/news/news.html"]').click()
    cy.get('#searchType').select('ค้นหาตามวันที่')
    cy.get('#searchInput').type('25/08/2024')
    cy.contains('25/08/2024').should('be.visible')
  })

  it('TC-CP-009 : ตรวจสอบการค้นหาข่าวด้วยวันที่ๆไม่ได้ลงข่าวในระบบ', () => {
    cy.get('#newsDropdown', { setTimeout: 1000 }).click()
    cy.get('a[href="../views/news/news.html"]').click()
    cy.get('#searchType').select('ค้นหาตามวันที่')
    cy.get('#searchInput').type('30')
    cy.get('table').contains('td', '30').should('not.exist')
  })
})

