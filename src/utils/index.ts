export const formatJoiError = (error: any) => {
  if (!error) return null;

  // Combine all messages into one readable string
  const message = error.details
    .map((err: any) => err.message.replace(/["]/g, '')) // remove quotes
    .join(', ');

  return message;
};
