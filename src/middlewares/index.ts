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
  
  const token = req.cookies.auth_token || req.headers['authorization'];
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

  try {
    const secretKey = process.env.JWT_SECRET || 'secret_key';
    const decoded = jwt.verify(token, secretKey) as { id: string; subscription_end?: string };
    req.userId = decoded.id;

    const subscriptionEnd = decoded.subscription_end ? new Date(decoded.subscription_end) : null;
    if (subscriptionEnd && subscriptionEnd.getTime() <= Date.now()) {
      return res.status(403).json({
        message: "Your subscription has expired. Please renew your subscription or contact the administrator."
      });
    }

    const newToken = jwt.sign({ id: decoded.id, subscription_end: decoded.subscription_end }, secretKey, {
      expiresIn: "2d",
    });

    res.cookie("auth_token", newToken, {
      httpOnly: true,
      secure: true,
      sameSite: 'none',
      maxAge: 172800000, // 2 days
    });

    next();
  } catch (error) {
    console.log(error);
    res.status(401).json({ message: 'Token tidak valid atau telah kedaluwarsa' });
  }
};

export default authMiddleware;
