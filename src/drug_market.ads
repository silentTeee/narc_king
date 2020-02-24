with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;

package Drug_Market is
   type Substance is (Cocaine, Heroin, Molly, Marijuana, Jenkem, Crystal_Meth,
                            Ketamine, LSD, Shrooms, Adderall, Vicodin, PCP);
   subtype Percent is Natural range 0..100;
   type Level is (Low, Medium, High);

   function Get_Name (Drug: in Substance) return Unbounded_String;

   function Get_Drug_Count (Drug: in Substance) return Natural;
   function Take_Drugs (Drug: in Substance; Withdraw_Amount: in Positive) return Natural;
   function Give_Drugs (Drug: in Substance; Deposit_Amount: in Positive) return Positive;

   function Get_Risk (Drug: in Substance) return Percent;
   procedure Set_Risk (Drug: in Substance; New_Val: Percent);

   function Get_Demand (Drug: in Substance) return Level;
   procedure Set_Demand (Drug: in Substance; New_Val: Level);

   function Get_Supply (Drug: in Substance) return Level;
   procedure Set_Supply (Drug: in Substance; New_Val: Level);

   function Get_Market_Rate (Drug: in Substance) return Positive;
end Drug_Market;
