import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';

export interface AuthenticatedRequest extends Request {
  userId?: string;
}

const authMiddleware = (req: AuthenticatedRequest, res: Response, next: NextFunction) => {
  // Skip authentication for specific routes if needed
  if (req.path.startsWith('/api/auth') || req.path.startsWith('/api/docs') || req.path.startsWith('/api/transaction/invoice') || req.path.startsWith('/api/auth/signup/token')) {
    return next();
  }

  const token = req.cookies.auth_token || req.headers['authorization'];
  const crToken = req.headers['cron-job-token'];
  const crPrivateToken = process.env.crToken;
  
  // Specific route check for cron-job-token
  if (req.path.startsWith('/api/user/delete-temp-files') || req.path.startsWith('/api/user/check-subscriptions')) {
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

    // Check if subscription_end exists and is valid
    const subscriptionEnd = decoded.subscription_end ? new Date(decoded.subscription_end) : null;
    if (subscriptionEnd && subscriptionEnd.getTime() <= Date.now()) {
      return res.status(403).json({
        message: "Your subscription has expired. Please renew your subscription or contact the administrator."
      });
    }

    // Reissue a new token with refreshed expiration
    const newToken = jwt.sign({ id: decoded.id, subscription_end: decoded.subscription_end }, secretKey, {
      expiresIn: "2d",
    });

    // Set the refreshed token in the cookie
    res.cookie("auth_token", newToken, {
      httpOnly: true,
      secure: true,
      sameSite: 'none',
    });

    next();
  } catch (error) {
    console.log(error);
    res.status(401).json({ message: 'Token tidak valid atau telah kedaluwarsa' });
  }
};

export default authMiddleware;
