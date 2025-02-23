import axios from 'axios';
import { SheetData } from './types';
import * as dotenv from 'dotenv';

dotenv.config();
// Function to send data to Google Apps Script
export const sendToSheet = async (data: SheetData): Promise<void> => {
  const sheetUrl = `${process.env.GOOGLE_SHEET_API}`;
  try {
    const response = await axios.post(sheetUrl, data, {
      headers: {
        'Content-Type': 'application/json',
      },
    });
    console.log('Response:', response.data);
  } catch (error: any) {
    console.error('Error:', error.response ? error.response.data : error.message);
  }
};
