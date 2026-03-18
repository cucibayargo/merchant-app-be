import multer from 'multer';

declare global {
  namespace Express {
    interface Request {
      file?: multer.File;
      userId?: string;
      merchantId?: string;
      employeeId?: string;
      outletId?: string;
      userRole?: 'owner' | 'employee';
      permissions?: string[];
    }
  }
}
