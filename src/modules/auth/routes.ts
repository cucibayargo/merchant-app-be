import express from 'express';

const router = express.Router();

/**
 * @swagger
 * tags:
 *   name: Auth
 *   description: Authentication APIs
 */

/**
 * @swagger
 * /auth/login:
 *   post:
 *     summary: Logs in a user
 *     description: Logs in a user with credentials
 *     responses:
 *       '200':
 *         description: Successful login
 */
router.post('/login', (req, res) => {
  res.send('Login route');
});

export default router;
