export interface Plan {
  id: string;
  name: string;
  code: string;
  price: number | null;
  duration: number | null;
  created_at: string;
}
