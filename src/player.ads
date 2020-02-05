with Substances; use Substances;
package Player is
   type Tool_Names is (Bullet, Bulletproof_Vest);

   function Inventory_Substance_Count (Drug: in Substance_Names) return Positive;

   procedure Add_To_Inventory (Drug: in Substance_Names; Amount: in Positive);
   procedure Subtract_From_Inventory (Drug: in Substance_Names; Amount: in Positive);

   procedure Add_To_Tools (Tool: in Tool_Names; Amount: in Positive);

   procedure Add_To_Debt (Debt_Amount: Positive);
   procedure Subtract_From_Debt (Payment_Amount: Positive);

   procedure Add_To_Balance (Income: Positive);
   procedure Subtract_From_Balance (Expense: Positive);
end Player;
