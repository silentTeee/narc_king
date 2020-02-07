with Drug_Market; use type Drug_Market.Substance;
package Player is
   type Tool_Names is (Bullet, Bulletproof_Vest);

   function Inventory_Substance_Count (Drug: in Substance) return Natural;
   procedure Add_To_Inventory (Drug: in Substance; Amount: in Positive);
   procedure Subtract_From_Inventory (Drug: in Substance; Amount: in Positive);

   function Get_Tool_Count (Tool: in Tool_Names) return Natural;
   procedure Add_To_Tools (Tool: in Tool_Names; Amount: in Positive);
   procedure Subtract_From_Tools (Tool: in Tool_Names; Amount: in Positive);

   function Get_Debt_Amount return Positive;
   procedure Add_To_Debt (Debt_Amount: Positive);
   procedure Subtract_From_Debt (Payment_Amount: Positive);

   function Get_Balance return Natural;
   procedure Add_To_Balance (Income: Positive);
   procedure Subtract_From_Balance (Expense: Positive);
end Player;
