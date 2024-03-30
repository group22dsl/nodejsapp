const app = require('../app');
const request = require('supertest');

describe('Sample test' , () => {
    it('Test / endpoint', async () => {
        const response = await request(app).get('/');
        expect(response.text).toBe('successfully connected to server');
    })
})