export interface Plan {
  id: string;
  name: string;
  code: string;
  price: number | null;
  features: string[] | null;
  created_at: string;
}
