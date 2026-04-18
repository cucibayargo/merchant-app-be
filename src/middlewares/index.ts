import { Request, Response, NextFunction } from 'express';
import jwt from 'jsonwebtoken';
import { getUserDetails } from '../modules/user/controller';

export interface AuthenticatedRequest extends Request {
  userId?: string;
  merchantId?: string;
  employeeId?: string;
  outletId?: string;
  userRole?: 'owner' | 'employee';
  permissions?: string[];
}

interface OwnerTokenPayload {
  id: string;
  subscription_end?: string;
  exp?: number;
  role?: 'owner';
}

interface EmployeeTokenPayload {
  id: string;
  role: 'employee';
  employee_id: string;
  outlet_id?: string;
  permissions?: string[];
  exp?: number;
}

// Handles both plain UUIDs and PostgreSQL array literals like {"uuid1","uuid2"}
export function parseSingleUuid(value: string | undefined): string | undefined {
  if (!value) return undefined;
  if (value.startsWith('{')) {
    const match = value.match(/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}/i);
    return match?.[0];
  }
  return value;
}

const authMiddleware = async (req: AuthenticatedRequest, res: Response, next: NextFunction) => {
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
    '/user/trigger-supabase-cloud',
    '/plan'
  ];
  
  const cronJobRoutes = [
    '/user/delete-temp-files',
    '/user/check-subscriptions',
    '/user/save-offline-user'
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
    const decoded = jwt.verify(token, secretKey) as OwnerTokenPayload | EmployeeTokenPayload;

    if (decoded.role === 'employee') {
      req.userId = decoded.id;
      req.merchantId = decoded.id;
      req.employeeId = decoded.employee_id;
      req.outletId = parseSingleUuid(decoded.outlet_id);
      req.userRole = 'employee';
      req.permissions = decoded.permissions || [];
      return next();
    }

    const { id, subscription_end, exp } = decoded as OwnerTokenPayload;
    req.userId = id;
    req.merchantId = id;
    req.userRole = 'owner';
    req.permissions = ['*'];

    const isExpiredSubscriptionException =
      (req.method === 'POST' && req.path === '/user/upload-logo') ||
      (req.method === 'PUT' && /^\/user\/[^/]+$/.test(req.path));
    const userDetail = await getUserDetails(id)
    if (userDetail?.subscription_end && new Date(userDetail?.subscription_end).getTime() <= Date.now()) {
      if (req.method !== 'GET' && !isExpiredSubscriptionException) {
        return res.status(403).json({
          message: "Langganan Anda telah kedaluwarsa. Silakan perbarui langganan Anda atau hubungi administrator."
        });
      }
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

export function requirePermission(permissionCode: string) {
  return (req: AuthenticatedRequest, res: Response, next: NextFunction) => {
    if (req.userRole !== 'employee') {
      return next();
    }

    const permissions = req.permissions || [];
    if (permissions.includes(permissionCode)) {
      return next();
    }

    return res.status(403).json({
      message: 'Akses ditolak. Anda tidak memiliki izin untuk aksi ini.',
      permission: permissionCode,
    });
  };
}

export function requireOwner(req: AuthenticatedRequest, res: Response, next: NextFunction) {
  if (req.userRole === 'owner') {
    return next();
  }

  return res.status(403).json({
    message: 'Akses ditolak. Fitur ini hanya untuk pemilik usaha.',
  });
}

export function resolveOutletId(req: AuthenticatedRequest, preferredOutletId?: string): string | null {
  if (preferredOutletId) {
    return preferredOutletId;
  }

  if (req.userRole === 'employee') {
    return req.outletId || null;
  }

  return req.outletId || null;
}

export default authMiddleware;
