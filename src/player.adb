with Substances; use Substances;
package body Player is
   Inventory_List: array (Substance_Names) of Natural range 0 .. 100 := (others => 0);
   Tool_List: array (Tool_Names) of Natural range 0 .. 10 := (others => 0);
   Player_Debt: Natural := 0;
   Player_Balance: Natural := 0;

   function Inventory_Substance_Count (Drug: in Substance_Names) return Positive is
   begin
      return Inventory_List (Drug);
   end Inventory_Substance_Count;

   procedure Add_To_Inventory (Drug: in Substance_Names; Amount: in Positive) is
   begin
      Inventory_List (Drug) := Inventory_List (Drug) + Amount;
   end Add_To_Inventory;

   procedure Subtract_From_Inventory (Drug: in Substance_Names; Amount: in Positive) is
   begin
      Inventory_List (Drug) := Inventory_List (Drug) - Amount;
   end Subtract_From_Inventory;

   procedure Add_To_Tools (Tool: in Tool_Names; Amount: in Positive) is
   begin
      Tool_List (Tool) := Tool_List (Tool) + Amount;
   end Add_To_Tools;

   procedure Subtract_From_Tools (Tool: in Tool_Names; Amount: in Positive) is
   begin
      Tool_List (Tool) := Tool_List (Tool) - Amount;
   end Subtract_From_Tools;

   procedure Add_To_Debt (Debt_Amount: Positive) is
   begin
      Player_Debt := Player_Debt + Debt_Amount;
   end Add_To_Debt;

   procedure Subtract_From_Debt (Payment_Amount: Positive) is
   begin
      Player_Debt := Player_Debt - Payment_Amount;
   end Subtract_From_Debt;

   procedure Add_To_Balance (Income: Positive) is
   begin
      Player_Balance := Player_Balance + Income;
   end Add_To_Balance;

   procedure Subtract_From_Balance (Expense: Positive) is
   begin
      Player_Balance := Player_Balance - Expense;
   end Subtract_From_Balance;

end Player;
