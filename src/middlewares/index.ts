import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';

export interface AuthenticatedRequest extends Request {
  userId?: string;
}

const authMiddleware = (req: AuthenticatedRequest, res: Response, next: NextFunction) => {
  const skipAuthRoutes = [
    '/auth',
    '/docs',
    '/transaction/:id',
    '/user/delete/:id',
    '/auth/signup/token',
    '/user/verify-invoice',
    '/user/invoice-update',
    '/user/upload-subscriptions-invoice',
    '/user/invoice/:invoiceId',
    '/user/trigger-supabase-cloud'
  ];
  
  const cronJobRoutes = [
    '/user/delete-temp-files',
    '/user/check-subscriptions',
  ];
  
  if (
    skipAuthRoutes.some(route => {
      // Check if the route has a parameter (e.g., "/:id")
      if (route.includes('/:')) {
        const baseRoute = route.split('/:')[0]; // Extract the base path (e.g., "/transaction")
        const isExactMatch = req.path === baseRoute; // Ensure no unintended matching (e.g., "/transactions")
        const startsWithBase = req.path.startsWith(baseRoute + '/'); // Match only paths with parameters
        return startsWithBase && !isExactMatch;
      }
      // Exact match for routes without parameters
      return req.path.startsWith(route);
    })
  ) {
    return next();
  }
  
  const token = req.cookies.auth_token || req.headers['authorization'] || req.query.authorization;
  const crToken = req.headers['cron-job-token'];
  const crPrivateToken = process.env.crToken;

  if (cronJobRoutes.some(route => req.path.startsWith(route))) {
    if (crToken === crPrivateToken) {
      return next();
    } else {
      return res.status(401).json({ message: 'Akses ditolak. Token tidak sesuai' });
    }
  }

  if (!token) {
    return res.status(401).json({ message: 'Akses ditolak. Token tidak sesuai' });
  }

  const secretKey = process.env.JWT_SECRET || 'secret_key';

  try {
    const { id, subscription_end, exp } = jwt.verify(token, secretKey) as { id: string; subscription_end?: string; exp?: number };
    req.userId = id;
  
    if (subscription_end && new Date(subscription_end).getTime() <= Date.now()) {
      return res.status(403).json({
        message: "Langganan Anda telah kedaluwarsa. Silakan perbarui langganan Anda atau hubungi administrator."
      });
    }
  
    // Refresh token if it's about to expire (e.g., within 24 hours)
    const currentTime = Math.floor(Date.now() / 1000);
    if (exp && exp - currentTime <= 24 * 60 * 60) {
      const newToken = jwt.sign({ id, subscription_end }, secretKey, { expiresIn: "7d" });
      res.cookie("auth_token", newToken, { httpOnly: true, secure: true, sameSite: "none", maxAge: 7 * 24 * 60 * 60 * 1000 });
    }
    next()
  } catch (error) {
    return res.status(401).json({ message: "Token tidak valid atau telah kedaluwarsa." });
  }
  
};

export default authMiddleware;
