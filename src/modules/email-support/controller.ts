import axios from 'axios';
import { SheetData } from './types';
// Function to send data to Google Apps Script
export const sendToSheet = async (data: SheetData): Promise<void> => {
  const sheetUrl = 'https://script.google.com/macros/s/AKfycbzSt6SKFgvYZa7u8EosmpOxM7PXQvd1-M7DmF_zv1tLE9sKPpiWuHOl3LpjxLIqodG0/exec';
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
